// In CPython:
// Objects -> dict-common.h
// Objects -> dictobject.c
// https://morepypy.blogspot.com/2015/01/faster-more-memory-efficient-and-more.html
// https://www.youtube.com/watch?v=p33CVV29OG8

// swiftlint:disable file_length

/// To ensure the lookup algorithm terminates, there must be at least one Unused
/// slot (NULL key) in the table.
private let perturbShift: Int64 = 5

/// PyDict_MINSIZE is the starting size for any new dict.
private let pydictMinsize = 8

/// USABLE_FRACTION is the maximum dictionary load.
/// Increasing this ratio makes dictionaries more dense resulting in more
/// collisions.
/// Decreasing it improves sparseness at the expense of spreading
/// indices over more cache lines and at the cost of total memory consumed.
private func usableFraction(size: Int) -> Int {
  return (size << 1) / 3
}

/// ESTIMATE_SIZE is reverse function of USABLE_FRACTION.
/// This can be used to reserve enough size to insert n entries without
/// resizing.
private func estimateSize(entryCount: Int) -> Int {
  return  (entryCount * 3 + 1) >> 1
}

/// GROWTH_RATE. Growth rate upon hitting maximum load.
private func growthRate(entryCount: Int) -> Int {
  return 3 * entryCount
}

/// Bitmask for acceptable index.
///
/// Mask takes a form of `0001 1111` where the number of `1` depends on the
/// `self.size` (it is easy because `self.size` is a power of 2!).
private func getIndexMask(size: Int) -> Int {
  return size - 1
}

private func isPowerOf2(_ value: Int) -> Bool {
  return value.isMultiple(of: 2)
}

internal struct OrderedDictionary {

  private class Entry {
    fileprivate var hash: PyHash
    fileprivate var key:  PyObject
    fileprivate var value: PyObject

    fileprivate init(hash: PyHash, key: PyObject, value: PyObject) {
      self.hash = hash
      self.key = key
      self.value = value
    }
  }

  private enum Index: Equatable {
    /// Slot is free to use.
    case notAssigned
    /// There was an index here, but it got deleted, so now it is not,
    /// but we can't reuse it because we need to remember insertion order.
    case deletedPlaceholder
    /// Slot contains an entry. Use `self.entries[entryIndex]` to get its value.
    case entryIndex(Int)
  }

  /// Data held in dictinary.
  /// `nil` means that there was an entry here but it was deleted.
  private var entries: [Entry?]
  /// Actual hash table of `self.size` entries. Holds indices to `self.entries`.
  /// Indices must be: `0 <= indice < usableFraction(self.size)`.
  private var indices: [Index]

  /// Number of used entries in `self.indices`.
  /// Basically number of valid entry indices in `self.indices`.
  private var used: Int
  /// Number of usable entries in `self.indices`.
  /// Basically: `usableFraction(self.size) `- number of valid entry indices
  /// in `self.indices`.
  private var usable: Int
  /// Size of the hash table. It must be a power of 2.
  ///
  ///- Warning:
  /// This is not a number of items in dictionary! Use `self.used` for that.
  private var size: Int {
    return self.indices.count
  }

  // MARK: - Init

  init() {
    self.init(size: pydictMinsize)
  }

  /// static PyDictKeysObject *new_keys_object(Py_ssize_t size)
  internal init(size: Int) {
    assert(size >= pydictMinsize)
    assert(isPowerOf2(size))

    self.entries = [Entry]()
    self.indices = [Index](repeating: .notAssigned, count: size)
    self.used = 0
    self.usable = usableFraction(size: size)

    // Avoid `self.entries` resize during lifetime (unless is it really needed)
    self.entries.reserveCapacity(self.usable)

    self.checkConsistency()
  }

  // MARK: - Get item

  internal enum GetResult {
    case notFound
    case value(PyObject)
    case error(PyErrorEnum)
  }

  internal func get(key: PyObject) -> GetResult {
    let hash = self.hash(key)
    return self.get(key: key, hash: hash)
  }

  internal func get(key: PyObject, hash: PyHash) -> GetResult {
    switch self.lookup(key: key, hash: hash) {
    case let .entry(index: _, entryIndex: _, entry: entry):
      return .value(entry.value)
    case .notFound:
      return .notFound
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Insert

  /// Internal routine to insert a new item into the table.
  /// Used both by the internal resize routine and by the public insert routine.
  internal mutating func insert(key: PyObject, value: PyObject) -> PyResult<()> {
    let hash = self.hash(key)
    return self.insert(key: key, hash: hash, value: value)
  }

  /// Internal routine to insert a new item into the table.
  /// Used both by the internal resize routine and by the public insert routine.
  ///
  /// insertdict(PyDictObject *mp, PyObject *key, Py_hash_t hash, PyObject *value)
  internal mutating func insert(key: PyObject,
                                hash: PyHash,
                                value: PyObject) -> PyResult<()> {
    switch self.lookup(key: key, hash: hash) {
    case .notFound:
      // Insert into new slot.
      if self.usable <= 0 {
        self.insertionResize()
      }

      let hashPos = self.findEmptySlot(hash: hash)

      let endIndex = self.entries.endIndex
      self.entries.append(Entry(hash: hash, key: key, value: value))
      self.indices[hashPos] = Index.entryIndex(endIndex)

      self.used += 1
      self.usable -= 1
      self.checkConsistency()
      return .value()

    case let .entry(index: _, entryIndex: _, entry: entry):
      entry.value = value
      return .value()

    case let .error(e):
      return .error(e)
    }
  }

  /// Internal function to find slot for an item from its hash
  /// when it is known that the key is not present in the dict.
  ///
  /// static Py_ssize_t
  /// find_empty_slot(PyDictKeysObject *keys, Py_hash_t hash)
  private func findEmptySlot(hash: PyHash) -> Int {
    let mask = getIndexMask(size: self.size)
    var i = hash & mask
    var ix = self.getIndexValue(i)

    var pertub = hash
    while case Index.entryIndex = ix {
      // Try next entry
      pertub >>= perturbShift
      i = (5 * i + pertub + 1) & mask
      ix = self.getIndexValue(i)
    }

    return i
  }

  // MARK: - Delete

  internal enum DeleteResult {
    case ok
    case keyError(key: PyObject)
    case error(PyErrorEnum)
  }

  /// int
  /// PyDict_DelItem(PyObject *op, PyObject *key)
  internal mutating func delete(key: PyObject) -> DeleteResult {
    let hash = self.hash(key)
    return self.delete(key: key, hash: hash)
  }

  /// int
  /// _PyDict_DelItem_KnownHash(PyObject *op, PyObject *key, Py_hash_t hash)
  internal mutating func delete(key: PyObject, hash: PyHash) -> DeleteResult {
    switch self.lookup(key: key, hash: hash) {
    case .notFound:
      return .keyError(key: key)
    case let .entry(index: index, entryIndex: entryIndex, entry: _):
      self.used -= 1
      self.indices[index] = .deletedPlaceholder
      self.entries[entryIndex] = nil
      self.checkConsistency()
      return .ok
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Clear

  internal mutating func clear() {
    self = OrderedDictionary()
  }

  // MARK: - Indices

  /// Lookup indices.
  ///
  /// static inline Py_ssize_t
  /// dk_get_index(PyDictKeysObject *keys, Py_ssize_t i)
  private func getIndexValue(_ i: Int) -> Index {
    return self.indices[i]
  }

  // MARK: - Lookup

  private enum LookupResult {
    case notFound
    case entry(index: Int, entryIndex: Int, entry: Entry)
    case error(PyErrorEnum)
  }

  /// The basic lookup function used by all operations.
  private func lookup(key: PyObject) -> LookupResult {
    let hash = self.hash(key)
    return self.lookup(key: key, hash: hash)
  }

  /// The basic lookup function used by all operations.
  ///
  /// static Py_ssize_t _Py_HOT_FUNCTION
  /// lookdict(PyDictObject *mp, PyObject *key, Py_hash_t hash, PyObject ...)
  private func lookup(key: PyObject, hash: PyHash) -> LookupResult {
    assert(self.size > 0)

    let mask = getIndexMask(size: self.size)
    var pertub = hash
    var index = hash & mask

    while true {
      switch self.getIndexValue(index) {
      case .notAssigned:
        return .notFound

      case .deletedPlaceholder:
        break

      case let .entryIndex(entryIndex):
        guard let entry = self.entries[entryIndex] else {
          break
        }

        // Fast path, when it is the same object
        if entry.key === key {
          return .entry(index: index, entryIndex: entryIndex, entry: entry)
        }

        // Check if `entry.key` is `__eq__` to key
        if entry.hash == hash {
          switch self.isEqual(left: entry.key, right: key) {
          case .value(let isKeyEqual):
            if isKeyEqual {
              return .entry(index: index, entryIndex: entryIndex, entry: entry)
            }
            // If key is different then hash collision -> search more
          case .notImplemented:
            return .error(.typeError("unhashable type: '\(key.typeName)'"))
          case .error(let e):
            return .error(e)
          }
        }
      }

      // Try next entry
      pertub >>= perturbShift
      index = (5 * index + pertub + 1) & mask
    }
  }

  // MARK: - Resize

  /// static int
  /// insertion_resize(PyDictObject *mp)
  private mutating func insertionResize() {
    let newSize = growthRate(entryCount: self.entries.count)
    self.dictResize(minSize: newSize)
  }

  /// Restructure the table by allocating a new table and reinserting all
  /// items again.
  ///
  /// When entries have been deleted, the new table may
  /// actually be smaller than the old one.
  ///
  /// static int
  /// dictresize(PyDictObject *mp, Py_ssize_t minsize)
  private mutating func dictResize(minSize: Int) {
    guard minSize > self.size else {
      return
    }

    var newSize = minSize
    while newSize < minSize && newSize > 0 {
      newSize <<= 1
    }

    // Take not-deleted entries entries
    let newEntries = self.entries.compactMap { $0 }

    // Insert entries to newIndices
    var newIndices = [Index](repeating: .notAssigned, count: newSize)

    let mask = getIndexMask(size: newSize)
    for (n, entry) in newEntries.enumerated() {
      var perturb = entry.hash
      var index = entry.hash & mask
      while newIndices[index] != Index.notAssigned {
        perturb >>= perturbShift
        index = (5 * index + perturb + 1) & mask
      }

      newIndices[index] = .entryIndex(n)
    }

    // Update self
    self.entries = newEntries
    self.indices = newIndices
    self.used = newEntries.count
    self.usable = usableFraction(size: newSize) - newEntries.count
  }

  // MARK: - Consistency

  /// static int
  /// _PyDict_CheckConsistency(PyDictObject *mp)
  private func checkConsistency() {
    #if DEBUG
    assert(isPowerOf2(self.size))
    let usableBySize = usableFraction(size: self.size)

    assert(0 <= self.used && self.used <= usableBySize)
    assert(0 <= self.usable && self.usable <= usableBySize)
    assert(0 <= self.entries.count && self.entries.count <= usableBySize)
    assert(self.used + self.usable <= usableBySize)

    var indexEntryCount = 0
    for case let Index.entryIndex(entryIndex) in self.indices {
      assert(entryIndex <= self.entries.count)
      indexEntryCount += 1
    }

    let entryCount = self.entries.count { $0 != nil }
    assert(indexEntryCount == entryCount)
    #endif
  }

  // MARK: - Helpers

  private func hash(_ object: PyObject) -> PyHash {
    return object.context.hash(value: object)
  }

  private func isEqual(left: PyObject, right: PyObject) -> PyResultOrNot<Bool> {
    return left.context.isEqual(left: left, right: right)
  }
}

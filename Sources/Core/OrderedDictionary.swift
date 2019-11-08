// In CPython:
// Objects -> dict-common.h
// Objects -> dictobject.c
// https://morepypy.blogspot.com/2015/01/faster-more-memory-efficient-and-more.html
// https://www.youtube.com/watch?v=p33CVV29OG8

// swiftlint:disable file_length

/// PyDict_MINSIZE is the starting size for any new dict.
private let minsize = 8

/// GROWTH_RATE. Growth rate upon hitting maximum load.
private let growthRate = 3

/// To ensure the lookup algorithm terminates, there must be at least one Unused
/// slot (NULL key) in the table.
private let perturbShift: Int = 5

// MARK: - Hashable

public protocol VioletHashable {

  /// The hash value.
  ///
  /// - Warning:
  /// Value should be either immutable or mutation should not change hash.
  var hash: Int { get }

  /// Returns a Boolean value indicating whether two values are equal.
  func isEqual(to other: Self) -> Bool
}

// MARK: - OrderedDictionary

/// A generic collection to store key-value pairs in the order they were
/// inserted in.
///
/// - Warning:
/// Memory footprint of this sctructure is sub-optimal, but it's internal
/// implementation type-safe because of that.
public struct OrderedDictionary<Key: VioletHashable, Value> {

  public struct Entry {
    fileprivate let hash: Int
    fileprivate let key:  Key
    fileprivate let value: Value

    fileprivate init(key: Key, value: Value) {
      self.hash = key.hash
      self.key = key
      self.value = value
    }
  }

  private enum EntryOrDeleted {
    /// Proper value in dictionary.
    case entry(Entry)
    /// There was an index here, but it was deleted.
    /// We can't this index because we need to remember insertion order.
    case deleted
  }

  private enum Index: Equatable {
    /// Slot is free to use.
    case notAssigned
    /// There was an index here, but it was deleted.
    /// We can't reuse this slot because we need to remember insertion order.
    case deleted
    /// Slot contains an entry. Use `self.entries[entryIndex]` to get its value.
    case entryIndex(Int)
  }

  // MARK: - Properties

  /// Data held in dictinary.
  /// `nil` means that there was an entry here but it was deleted.
  private var _entries: [EntryOrDeleted]
  /// Actual hash table of `self.size` entries. Holds indices to `self.entries`.
  /// Indices must be: `0 <= indice < usableFraction(self.size)`.
  private var _indices: [Index]

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
    return self._indices.count
  }

  /// The number of keys in the dictionary.
  ///
  /// - Complexity: O(1).
  public var count: Int {
    return self.used
  }

  /// The total number of key-value pairs that the dictionary can contain without
  /// allocating new storage.
  public var capacity: Int {
    return self.size
  }

  /// A Boolean value indicating whether the collection is empty.
  public var isEmpty: Bool {
    return self.used == 0
  }

  // MARK: - Init

  public init() {
    self.init(size: minsize)
  }

  /// static PyDictKeysObject *new_keys_object(Py_ssize_t size)
  public init(size: Int) {
    let size = max(nextPowerOf2(size), minsize)
    assert(isPowerOf2(size))

    self._entries = [EntryOrDeleted]()
    self._indices = [Index](repeating: .notAssigned, count: size)
    self.used = 0
    self.usable = usableFraction(size: size)

    // Avoid `self.entries` resize.
    // We may still resize when we resize the whole dictionary.
    self._entries.reserveCapacity(self.usable)

    self.checkConsistency()
  }

  // MARK: - Subscript

  /// Accesses the value associated with the given key for reading and writing.
  ///
  /// This *key-based* subscript returns the value for the given key if the key
  /// is found in the dictionary, or `nil` if the key is not found.
  public subscript(key: Key) -> Value? {
    get { return self.get(key: key) }
    set {
      if let newValue = newValue {
        self.insert(key: key, value: newValue)
      } else {
        _ = self.remove(key: key)
      }
    }
  }

  // MARK: - Get

  /// Accesses the value associated with the given key for reading.
  ///
  /// This *key-based* function returns the value for the given key if the key
  /// is found in the dictionary, or `nil` if the key is not found.
  public func get(key: Key) -> Value? {
    switch self.lookup(key: key) {
    case let .entry(index: _, entryIndex: _, entry: entry):
      return entry.value
    case .notFound:
      return nil
    }
  }

  // MARK: - Insert

  /// Updates the value stored in the dictionary for the given key, or adds a
  /// new key-value pair if the key does not exist.
  ///
  /// insertdict(PyDictObject *mp, PyObject *key, Py_hash_t hash, PyObject *value)
  public mutating func insert(key: Key, value: Value) {
    switch self.lookup(key: key) {
    case let .entry(index: _, entryIndex: entryIndex, entry: _):
      // Update existing entry.
      self._entries[entryIndex] = .entry(Entry(key: key, value: value))

    case .notFound:
      // Try to insert into new slot.
      if self.usable <= 0 {
        self.insertionResize()
      }

      let hashPos = self.findEmptySlot(hash: key.hash)

      let endIndex = self._entries.endIndex
      self._entries.append(.entry(Entry(key: key, value: value)))
      self._indices[hashPos] = Index.entryIndex(endIndex)

      self.used += 1
      self.usable -= 1
      self.checkConsistency()
    }
  }

  /// Internal function to find slot for an item from its hash
  /// when it is known that the key is not present in the dict.
  ///
  /// static Py_ssize_t
  /// find_empty_slot(PyDictKeysObject *keys, Py_hash_t hash)
  private func findEmptySlot(hash: Int) -> Int {
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

  // MARK: - Remove

  /// Removes the given key and its associated value from the dictionary.
  ///
  /// If the key is found in the dictionary, this method returns the key's
  /// associated value.
  /// int
  /// _PyDict_DelItem_KnownHash(PyObject *op, PyObject *key, Py_hash_t hash)
  public mutating func remove(key: Key) -> Value? {
    switch self.lookup(key: key) {
    case .notFound:
      return nil

    case let .entry(index: index, entryIndex: entryIndex, entry: entry):
      self.used -= 1
      self._indices[index] = .deleted
      self._entries[entryIndex] = .deleted

      self.checkConsistency()
      return entry.value
    }
  }

  // MARK: - Lookup

  private enum LookupResult {
    case notFound
    case entry(index: Int, entryIndex: Int, entry: Entry)
  }

  /// The basic lookup function used by all operations.
  ///
  /// static Py_ssize_t _Py_HOT_FUNCTION
  /// lookdict(PyDictObject *mp, PyObject *key, Py_hash_t hash, PyObject ...)
  private func lookup(key: Key) -> LookupResult {
    let hash = key.hash
    let mask = getIndexMask(size: self.size)
    var pertub = hash
    var index = hash & mask

    while true {
      // Search unil we find entry with equal key or we hit 'notAssigned'.
      switch self.getIndexValue(index) {
      case .notAssigned:
        return .notFound

      case .deleted:
        break

      case let .entryIndex(entryIndex):
        guard case let .entry(old) = self._entries[entryIndex] else {
          assert(false, "Index was deleted, but entry was not.")
          break
        }

        if hash == old.hash && key.isEqual(to: old.key) {
          return .entry(index: index, entryIndex: entryIndex, entry: old)
        }
      }

      // Try next entry
      pertub >>= perturbShift
      index = (5 * index + pertub + 1) & mask
    }
  }

  // MARK: - Indices

  /// Lookup indices.
  ///
  /// static inline Py_ssize_t
  /// dk_get_index(PyDictKeysObject *keys, Py_ssize_t i)
  private func getIndexValue(_ i: Int) -> Index {
    return self._indices[i]
  }

  // MARK: - Clear

  public mutating func clear() {
    self = OrderedDictionary()
  }

  // MARK: - Resize

  /// static int
  /// insertion_resize(PyDictObject *mp)
  private mutating func insertionResize() {
    let newSize = self._entries.count * growthRate
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

    let newSize = nextPowerOf2(minSize)

    // Take not-deleted entries entries
    var newEntries = [Entry]()
    for case let EntryOrDeleted.entry(entry) in self._entries {
      newEntries.append(entry)
    }

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
    self._entries = newEntries.map { EntryOrDeleted.entry($0) }
    self._indices = newIndices
    self.used = newEntries.count
    self.usable = usableFraction(size: newSize) - newEntries.count

    self.checkConsistency()
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
    assert(0 <= self._entries.count && self._entries.count <= usableBySize)
    assert(self.used + self.usable <= usableBySize)

    var indexEntryCount = 0
    for case let Index.entryIndex(entryIndex) in self._indices {
      assert(entryIndex <= self._entries.count)
      indexEntryCount += 1
    }

    var entryCount = 0
    for case EntryOrDeleted.entry in self._entries {
      entryCount += 1
    }

    assert(indexEntryCount == entryCount)
    #endif
  }
}

// MARK: - Extensions

extension OrderedDictionary: ExpressibleByDictionaryLiteral {
  public init(dictionaryLiteral elements: (Key, Value)...) {
    self.init()
    for element in elements {
      self.insert(key: element.0, value: element.1)
    }
  }
}

extension OrderedDictionary: CustomStringConvertible {
  public var description: String {
    var result = ""
    for entry in self._entries {
      switch entry {
      case .entry(let e):
        result += "\(e.key): \(e.value), "
      case .deleted:
        break
      }
    }

    // remove trailing ', '
    _ = result.popLast()
    _ = result.popLast()

    return "[" + result + "]"
  }
}

// MARK: - Helpers

private func isPowerOf2(_ value: Int) -> Bool {
  return value.isMultiple(of: 2)
}

private func nextPowerOf2(_ value: Int) -> Int {
  var result = 1
  while result < value && result > 0 {
    result <<= 1
  }
  return result
}

/// USABLE_FRACTION is the maximum dictionary load.
/// Increasing this ratio makes dictionaries more dense resulting in more
/// collisions.
/// Decreasing it improves sparseness at the expense of spreading
/// indices over more cache lines and at the cost of total memory consumed.
private func usableFraction(size: Int) -> Int {
  assert(size > 0)
  return (size << 1) / 3
}

/// Bitmask for acceptable index.
///
/// Mask takes a form of `0001 1111` where the number of `1` depends on the
/// `self.size` (it is easy because `self.size` is a power of 2!).
private func getIndexMask(size: Int) -> Int {
  assert(size > 0)
  return size - 1
}

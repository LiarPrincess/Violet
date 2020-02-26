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
private let perturbShift = 5

// MARK: - Hashable

public protocol PyHashable {

  /// The hash value.
  ///
  /// - Warning:
  /// Value should be either immutable or mutation should not change hash.
  var hash: Int { get }

  /// Returns a Boolean value indicating whether two values are equal.
  func isEqual(to other: Self) -> PyResult<Bool>
}

// MARK: - OrderedDictionary

/// A generic collection to store key-value pairs in the order they were
/// inserted in.
public struct OrderedDictionary<Key: PyHashable, Value> {

  public struct Entry {
    public let hash: Int
    public let key:  Key
    public let value: Value

    fileprivate init(key: Key, value: Value) {
      self.hash = key.hash
      self.key = key
      self.value = value
    }
  }

  internal enum EntryOrDeleted {
    /// Proper value in dictionary.
    case entry(Entry)
    /// There was an entry here, but it was deleted.
    /// We can't reuse this index because we need to remember insertion order.
    case deleted
  }

  /// Custom index with special reserved 'notAssigned' and 'deleted' values
  ///
  /// We could use enum but that would cost us 2x more memory.
  /// (It would be also more type-safe, but nobody cares about that...)
  /// If we want to optimize memory footprint further then we could use
  /// 2 different kind of indices: Int8 and Int with 'enum trick'
  /// from Foundation.Data.
  fileprivate struct EntryIndex: Equatable {

    /// Slot is free to use.
    fileprivate static var notAssigned: EntryIndex {
      return EntryIndex(unchecked: -1)
    }

    /// There was an index here, but it was deleted.
    fileprivate static var deleted: EntryIndex {
      return EntryIndex(unchecked: -2)
    }

    private let value: Int

    /// Slot contains an entry. Use `self.entries[arrayIndex]` to get its value.
    fileprivate var asArrayIndex: Int {
      assert(self.isArrayIndex, "Can't index array with 'notAssigned' or 'deleted'")
      return self.value
    }

    /// Does the slot contain an entry?
    fileprivate var isArrayIndex: Bool {
      return self.value >= 0
    }

    fileprivate init(_ value: Int) {
      assert(value >= 0)
      self.value = value
    }

    /// Init used to create 'notAssigned' and 'deleted' values.
    private init(unchecked value: Int) {
      self.value = value
    }
  }

  // MARK: - Properties

  /// Data held in dictinary.
  internal fileprivate(set) var entries: [EntryOrDeleted]
  /// Actual hash table of `self.size` entries. Holds indices to `self.entries`.
  /// Indices must be: `0 <= indice < usableFraction(self.size)`.
  fileprivate var indices: [EntryIndex]

  /// Number of used entries in `self.indices`.
  /// Basically number of valid entry indices in `self.indices`.
  fileprivate var used: Int
  /// Number of usable entries in `self.indices`.
  /// Basically: `usableFraction(self.size) `- number of valid entry indices
  /// in `self.indices`.
  fileprivate var usable: Int
  /// Size of the hash table. It must be a power of 2.
  ///
  ///- Warning:
  /// This is not a number of items in dictionary! Use `self.used` for that.
  fileprivate var size: Int {
    return self.indices.count
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

  /// A Boolean value indicating whether the collection has any elements.
  public var any: Bool {
    return !self.isEmpty
  }

  /// The last inserted element.
  /// If the dictionary is empty, the value of this property is `nil`.
  public var last: Entry? {
    if self.isEmpty {
      return nil
    }

    for entry in self.entries.reversed() {
      switch entry {
      case .entry(let e):
        return e
      case .deleted:
        break // iterate more
      }
    }

    return nil
  }

  // MARK: - Init

  public init() {
    self.init(size: minsize)
  }

  /// static PyDictKeysObject *new_keys_object(Py_ssize_t size)
  public init(size: Int) {
    let size = Swift.max(nextPowerOf2(size), minsize)
    assert(isPowerOf2(size))

    self.entries = [EntryOrDeleted]()
    self.indices = [EntryIndex](repeating: .notAssigned, count: size)
    self.used = 0
    self.usable = usableFraction(size: size)

    // Avoid `self.entries` resize.
    // We may still resize when we resize the whole dictionary.
    self.entries.reserveCapacity(self.usable)

    self.checkConsistency()
  }

  public init(copy: OrderedDictionary<Key, Value>) {
    self.entries = copy.entries
    self.indices = copy.indices
    self.used = copy.used
    self.usable = copy.usable
  }

  // MARK: - Get

  public enum GetResult {
    case value(Value)
    case notFound
    case error(PyBaseException)
  }

  /// Accesses the value associated with the given key for reading.
  ///
  /// This *key-based* function returns the value for the given key if the key
  /// is found in the dictionary, or `nil` if the key is not found.
  public func get(key: Key) -> GetResult {
    switch self.lookup(key: key) {
    case let .entry(index: _, entryIndex: _, entry: entry):
      return .value(entry.value)
    case .notFound:
      return .notFound
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Contains

  public func contains(key: Key) -> PyResult<Bool> {
    switch self.get(key: key) {
    case .value:
      return .value(true)
    case .notFound:
      return .value(false)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Insert

  public enum InsertResult {
    case inserted
    case updated
    case error(PyBaseException)
  }

  /// Updates the value stored in the dictionary for the given key, or adds a
  /// new key-value pair if the key does not exist.
  ///
  /// insertdict(PyDictObject *mp, PyObject *key, Py_hash_t hash, PyObject *value)
  public mutating func insert(key: Key, value: Value) -> InsertResult {
    switch self.lookup(key: key) {
    case let .entry(index: _, entryIndex: entryIndex, entry: oldEntry):
      // Update existing entry.
      // We have to use old 'key':
      // >>> d = { }
      // >>> d[True] = True # -> {True: True}
      // >>> d[1] = 1       # -> {True: 1} <- key is still 'True' not '1'
      self.entries[entryIndex] = .entry(Entry(key: oldEntry.key, value: value))
      return .updated

    case .notFound:
      // Try to insert into new slot.
      if self.usable <= 0 {
        self.insertionResize()
      }

      let hashPos = self.findEmptySlot(hash: key.hash)

      let endIndex = self.entries.endIndex
      self.entries.append(.entry(Entry(key: key, value: value)))
      self.indices[hashPos] = EntryIndex(endIndex)

      self.used += 1
      self.usable -= 1
      self.checkConsistency()
      return .inserted

    case let .error(e):
      return .error(e)
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
    while ix.isArrayIndex {
      pertub >>= perturbShift
      i = (5 * i + pertub + 1) & mask
      ix = self.getIndexValue(i)
    }

    return i
  }

  // MARK: - Remove

  public enum RemoveResult {
    case value(Value)
    case notFound
    case error(PyBaseException)
  }

  /// Removes the given key and its associated value from the dictionary.
  ///
  /// If the key is found in the dictionary, this method returns the key's
  /// associated value.
  /// int
  /// _PyDict_DelItem_KnownHash(PyObject *op, PyObject *key, Py_hash_t hash)
  public mutating func remove(key: Key) -> RemoveResult {
    switch self.lookup(key: key) {
    case .notFound:
      return .notFound

    case let .entry(index: index, entryIndex: entryIndex, entry: entry):
      self.used -= 1
      self.indices[index] = .deleted
      self.entries[entryIndex] = .deleted

      self.checkConsistency()
      return .value(entry.value)

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Lookup

  private enum LookupResult {
    case notFound
    case entry(index: Int, entryIndex: Int, entry: Entry)
    case error(PyBaseException)
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

      case let entryIndex:
        assert(entryIndex.isArrayIndex)
        let arrayIndex = entryIndex.asArrayIndex

        guard case let .entry(old) = self.entries[arrayIndex] else {
          assert(false, "Index was deleted, but entry was not.")
          break
        }

        if hash == old.hash {
          switch key.isEqual(to: old.key) {
          case .value(true):
            return .entry(index: index, entryIndex: arrayIndex, entry: old)
          case .value(false):
            break // Try next entry
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

  // MARK: - Indices

  /// Lookup indices.
  ///
  /// static inline Py_ssize_t
  /// dk_get_index(PyDictKeysObject *keys, Py_ssize_t i)
  private func getIndexValue(_ i: Int) -> EntryIndex {
    return self.indices[i]
  }

  // MARK: - Copy

  public func copy() -> OrderedDictionary<Key, Value> {
    return OrderedDictionary<Key, Value>(copy: self)
  }

  // MARK: - Clear

  public mutating func clear() {
    self = OrderedDictionary()
  }

  // MARK: - Resize

  /// static int
  /// insertion_resize(PyDictObject *mp)
  private mutating func insertionResize() {
    let newSize = self.entries.count * growthRate
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
    for case let EntryOrDeleted.entry(entry) in self.entries {
      newEntries.append(entry)
    }

    // Insert entries to newIndices
    var newIndices = [EntryIndex](repeating: .notAssigned, count: newSize)

    let mask = getIndexMask(size: newSize)
    for (n, entry) in newEntries.enumerated() {
      var perturb = entry.hash
      var index = entry.hash & mask
      while newIndices[index] != EntryIndex.notAssigned {
        perturb >>= perturbShift
        index = (5 * index + perturb + 1) & mask
      }

      newIndices[index] = EntryIndex(n)
    }

    // Update self
    self.entries = newEntries.map { EntryOrDeleted.entry($0) }
    self.indices = newIndices
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
    assert(0 <= self.entries.count && self.entries.count <= usableBySize)
    assert(self.used + self.usable <= usableBySize)

    var indexEntryCount = 0
    for entryIndex in self.indices where entryIndex.isArrayIndex {
      assert(entryIndex.asArrayIndex <= self.entries.count)
      indexEntryCount += 1
    }

    var entryCount = 0
    for case EntryOrDeleted.entry in self.entries {
      entryCount += 1
    }

    assert(indexEntryCount == entryCount)
    #endif
  }
}

// MARK: - Iterator

/// Iterator for `OrderedDictionary` that will skip deleted entries.
public struct OrderedDictionaryIterator<Key: PyHashable, Value>: IteratorProtocol {

  public typealias OrderedDictionaryType = OrderedDictionary<Key, Value>
  public typealias Element = OrderedDictionaryType.Entry

  private var inner: IndexingIterator<[OrderedDictionaryType.EntryOrDeleted]>

  public init(_ dictionary: OrderedDictionaryType) {
    self.inner = dictionary.entries.makeIterator()
  }

  public mutating func next() -> Self.Element? {
    while let entryOrDeleted = self.inner.next() {
      switch entryOrDeleted {
      case let .entry(entry):
        return entry
      case .deleted:
        break // Skip deleted
      }
    }

    // We reached end, no more entries to return
    return nil
  }
}

// MARK: - Extensions

extension OrderedDictionary: CustomStringConvertible {
  public var description: String {
    if self.isEmpty {
      return "OrderedDictionary()"
    }

    var result = "OrderedDictionary("

    for entry in self {
      result += "\(entry.key): \(entry.value), "
    }

    // remove trailing ', '
    _ = result.popLast()
    _ = result.popLast()

    result += ")"
    return result
  }
}

extension OrderedDictionary: Sequence {
  public typealias Element = Array<Entry>.Element

  public func makeIterator() -> OrderedDictionaryIterator<Key, Value> {
    return OrderedDictionaryIterator(self)
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

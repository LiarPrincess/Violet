import VioletCore

// cSpell:ignore dictobject pertub insertdict lookdict dictresize

// In CPython:
// Objects -> dict-common.h
// Objects -> dictobject.c
// https://morepypy.blogspot.com/2015/01/faster-more-memory-efficient-and-more.html
// https://www.youtube.com/watch?v=p33CVV29OG8

/// PyDict_MINSIZE is the starting size for any new dict.
private let minsize = 8

/// GROWTH_RATE. Growth rate upon hitting maximum load.
private let growthRate = 3

/// To ensure the lookup algorithm terminates, there must be at least one Unused
/// slot (NULL key) in the table.
private let perturbShift = 5

/// A generic collection to store key-value pairs in exactly the same order
/// as they were inserted.
public struct OrderedDictionary<Value> {

  // MARK: - Helper data types

  public struct Key: CustomStringConvertible {

    /// The hash value.
    ///
    /// - Warning:
    /// Value should be either immutable or mutation should not change hash.
    public let hash: PyHash
    public let object: PyObject

    public var description: String {
      return "Key(\(self.object))"
    }

    internal init(_ py: Py, id: IdString) {
      let string = py.resolve(id: id)
      self.hash = string.getHash(py)
      self.object = string.asObject
    }

    internal init(hash: PyHash, object: PyObject) {
      self.hash = hash
      self.object = object
    }
  }

  public struct Entry {
    public let key: Key
    public let value: Value

    fileprivate init(key: Key, value: Value) {
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
  /// We could use enum, but that would cost us 2x more memory.
  /// (It would be also more type-safe, but nobody cares about that…)
  ///
  /// HOT!
  /// If we want to optimize cache access (and by that performance) we can use
  /// 2 different kind of indices: `Int8` and `Int` with `IndexKind` enum
  /// (similar to Foundation.Data._Representation).
  ///
  /// In such case we would use `Int8` for dictionaries with \<127 slots
  /// (which means 90% of them), then if we need more we would move to `Int`.
  fileprivate struct EntryIndex: Equatable {

    /// Slot is free to use.
    fileprivate static var notAssigned: EntryIndex { EntryIndex(unchecked: -1) }
    /// There was an index here, but it was deleted.
    fileprivate static var deleted: EntryIndex { EntryIndex(unchecked: -2) }

    private let value: Int

    /// Slot contains an entry. Use `self.entries[entryIndex]` to get its value.
    fileprivate var asEntryIndex: Int {
      assert(self.isEntryIndex, "Can't index array with 'notAssigned' or 'deleted'")
      return self.value
    }

    /// Does the slot contain an entry?
    fileprivate var isEntryIndex: Bool {
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

  /// Minor helper used for calculating next index.
  ///
  /// Read the giant comment in `CPython/Objects/dictobject.c' for reasoning.
  /// Also, we will ignore overflows.
  internal struct IndexCalculation {

    /// Modulo by dictionary size.
    ///
    /// When we have dictionary with 32 slots and we get index 60,
    /// we have to clamp it to be <=32.
    private let mask: Int
    /// Include hash in the index calculation (this way it is more 'random')
    private var pertub: Int
    /// Index at which we will try to get/set/delete.
    internal private(set) var value: Int

    internal init(hash: Int, dictionarySize: Int) {
      let mask = getIndexMask(size: dictionarySize)
      self.init(hash: hash, mask: mask)
    }

    internal init(hash: Int, mask: Int) {
      assert(mask >= 0, "Dict size <0? Hmm… interesting.")

      self.mask = mask
      self.pertub = Swift.abs(Swift.max(hash, Int.min + 1)) // abs(Int.min) -> trap
      self.value = self.pertub & self.mask // Initial index value
    }

    /// Go to next index.
    internal mutating func calculateNext() {
      self.pertub >>= perturbShift
      self.value = (5 * self.value + self.pertub + 1) & self.mask
    }
  }

  // MARK: - Properties

  /// Data held in dictionary.
  internal private(set) var entries: [EntryOrDeleted]
  /// Actual hash table of `self.size` entries. Holds indices from `self.entries`.
  /// Indices must be: `0 <= index < usableFraction(self.size)`.
  ///
  /// Having separate `indices` and `entries` is good for cache.
  private var indices: [EntryIndex]

  /// Number of used entries in `self.indices`.
  /// Basically number of valid entry indices in `self.indices`.
  private var used: Int
  /// Number of usable entries in `self.indices`.
  /// Basically: `usableFraction(self.size) `- number of valid entry indices
  /// in `self.indices`.
  private var usable: Int
  /// Size of the hash table. It must be a power of 2.
  ///
  /// - Warning:
  /// This is not a number of items in dictionary! Use `self.used` for that.
  private var size: Int {
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
    self.init(count: minsize)
  }

  /// static PyDictKeysObject *new_keys_object(Py_ssize_t size)
  public init(count: Int) {
    let size = Swift.max(nextPowerOf2(count), minsize)
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

  public init(copy: OrderedDictionary<Value>) {
    self.entries = copy.entries
    self.indices = copy.indices
    self.used = copy.used
    self.usable = copy.usable

    self.checkConsistency()
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
  public func get(_ py: Py, key: Key) -> GetResult {
    switch self.lookup(py, key: key) {
    case let .entry(indicesIndex: _, entriesIndex: _, entry: entry):
      return .value(entry.value)
    case .notFound:
      return .notFound
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Contains

  public func contains(_ py: Py, key: Key) -> PyResultGen<Bool> {
    switch self.get(py, key: key) {
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
  public mutating func insert(_ py: Py, key: Key, value: Value) -> InsertResult {
    switch self.lookup(py, key: key) {
    case let .entry(indicesIndex: _, entriesIndex: entryIndex, entry: oldEntry):
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
    var index = IndexCalculation(hash: hash, dictionarySize: self.size)
    var entryIndex = self.getEntryIndex(at: index)

    while entryIndex.isEntryIndex {
      index.calculateNext()
      entryIndex = self.getEntryIndex(at: index)
    }

    return index.value
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
  public mutating func remove(_ py: Py, key: Key) -> RemoveResult {
    switch self.lookup(py, key: key) {
    case .notFound:
      return .notFound

    case let .entry(indicesIndex: index, entriesIndex: entryIndex, entry: entry):
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
    case entry(indicesIndex: Int, entriesIndex: Int, entry: Entry)
    case error(PyBaseException)
  }

  /// The basic lookup function used by all operations.
  ///
  /// static Py_ssize_t _Py_HOT_FUNCTION
  /// lookdict(PyDictObject *mp, PyObject *key, Py_hash_t hash, PyObject ...)
  private func lookup(_ py: Py, key: Key) -> LookupResult {
    let hash = key.hash
    var index = IndexCalculation(hash: hash, dictionarySize: self.size)

    while true {
      // Search until we find entry with equal key or we hit 'notAssigned'.
      switch self.getEntryIndex(at: index) {
      case .notAssigned:
        return .notFound

      case .deleted:
        break

      case let i:
        assert(i.isEntryIndex)
        let entryIndex = i.asEntryIndex

        guard case let .entry(old) = self.entries[entryIndex] else {
          trap("Ordered dictionary - index was deleted, but entry was not.")
        }

        if hash == old.key.hash {
          switch self.areEqual(py, lhs: key, rhs: old.key) {
          case .value(true):
            return .entry(indicesIndex: index.value, entriesIndex: entryIndex, entry: old)
          case .value(false):
            break // Hash collision -> iterate more
          case .error(let e):
            return .error(e)
          }
        }
        // else: it is a totally different object -> iterate more
      }

      // Try next entry
      index.calculateNext()
    }
  }

  private func areEqual(_ py: Py, lhs: Key, rhs: Key) -> PyResultGen<Bool> {
    // >>> class HashCollisionWith1:
    // ...     def __hash__(self): return 1
    // ...     def __eq__(self, other): raise NotImplementedError('Ooo!')
    //
    // >>> d = {}
    // >>> d[1] = 'a'
    // >>> c = HashCollisionWith1()
    // >>> d[c] = 'b'
    // NotImplementedError: Ooo!

    guard lhs.hash == rhs.hash else {
      return .value(false)
    }

    return py.isEqualBool(left: lhs.object, right: rhs.object)
  }

  // MARK: - Indices

  /// Lookup indices.
  ///
  /// static inline Py_ssize_t
  /// dk_get_index(PyDictKeysObject *keys, Py_ssize_t i)
  private func getEntryIndex(at index: IndexCalculation) -> EntryIndex {
    return self.indices[index.value]
  }

  // MARK: - Copy

  public func copy() -> OrderedDictionary<Value> {
    return OrderedDictionary(copy: self)
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

    var newEntries = [EntryOrDeleted]()
    newEntries.reserveCapacity(newSize)
    var newIndices = [EntryIndex](repeating: .notAssigned, count: newSize)

    let mask = getIndexMask(size: newSize)
    for (n, entry) in self.enumerated() {
      let entryOrDeleted = EntryOrDeleted.entry(entry)
      newEntries.append(entryOrDeleted)

      var index = IndexCalculation(hash: entry.key.hash, mask: mask)
      while newIndices[index.value] != EntryIndex.notAssigned {
        index.calculateNext()
      }

      newIndices[index.value] = EntryIndex(n)
    }

    self.entries = newEntries
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
    for entryIndex in self.indices where entryIndex.isEntryIndex {
      assert(entryIndex.asEntryIndex <= self.entries.count)
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

// MARK: - CustomStringConvertible

extension OrderedDictionary.EntryIndex: CustomStringConvertible {
  fileprivate var description: String {
    switch self.value {
    case Self.notAssigned.value:
      return "-"
    case Self.deleted.value:
      return "deleted"
    default:
      return "Index(value: \(self.value))"
    }
  }
}

extension OrderedDictionary.EntryOrDeleted: CustomStringConvertible {
  internal var description: String {
    switch self {
    case .entry(let e):
      return "Entry(key: \(e.key), value: \(e.value))"
    case .deleted:
      return "deleted"
    }
  }
}

extension OrderedDictionary: CustomStringConvertible {
  public var description: String {
    if self.isEmpty {
      return "OrderedDictionary()"
    }

    var result = "OrderedDictionary("

    for (index, entry) in self.enumerated() {
      if index > 0 {
        result += ", " // so that we don't have ', )'.
      }

      result += "\(entry.key): \(entry.value)"
    }

    result += ")"
    return result
  }
}

// MARK: - CustomReflectable

extension OrderedDictionary.EntryIndex: CustomReflectable {
  public var customMirror: Mirror {
    // This will print only description (1 index = 1 line)
    return Mirror(self, children: [])
  }
}

extension OrderedDictionary.EntryOrDeleted: CustomReflectable {
  public var customMirror: Mirror {
    // This will print only description (1 entry = 1 line)
    return Mirror(self, children: [])
  }
}

extension OrderedDictionary: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(
      self,
      children: [
        "Indices": self.indices,
        "Entries": self.entries
      ]
    )
  }
}

// MARK: - Sequence

extension OrderedDictionary: Sequence {

  /// Iterator for `OrderedDictionary` that will skip deleted entries.
  public struct Iterator: IteratorProtocol {

    // swiftlint:disable nesting
    public typealias OrderedDictionaryType = OrderedDictionary<Value>
    public typealias Element = OrderedDictionaryType.Entry
    // swiftlint:enable nesting

    private var inner: IndexingIterator<[OrderedDictionaryType.EntryOrDeleted]>

    public init(_ dictionary: OrderedDictionaryType) {
      self.inner = dictionary.entries.makeIterator()
    }

    public mutating func next() -> Element? {
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

  public typealias Element = Iterator.Element

  public func makeIterator() -> Iterator {
    return Iterator(self)
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

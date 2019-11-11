import Core

// In CPython:
// Objects -> setobject.c
// https://docs.python.org/3.7/c-api/set.html

// TODO: Frozen set
// swiftlint:disable file_length

internal struct PySetElement: VioletHashable {

  internal var hash: PyHash
  internal var object: PyObject

  internal init(hash: PyHash, object: PyObject) {
    self.hash = hash
    self.object = object
  }

  internal func isEqual(to other: PySetElement) -> Bool {
    return self.hash == other.hash &&
      self.object.builtins.isEqualBool(left: self.object, right: other.object)
  }
}

extension OrderedDictionary where Value == Void {
  public mutating func insert(key: Key) {
    self.insert(key: key, value: ())
  }
}

// sourcery: pytype = set
/// This subtype of PyObject is used to hold the internal data for both set
/// and frozenset objects.
internal final class PySet: PyObject {

  internal static let doc: String = """
    set() -> new empty set object
    set(iterable) -> new set object

    Build an unordered collection of unique elements.
    """

  /// Small trick: when we use `Void` (which is the same as `()`) as value
  /// then it would not take any space in dictionary!
  /// For example `struct { Int, Void }` has the same storage as `struct { Int }`.
  /// This trick is sponsored by 'go lang': `map[T]struct{}`.
  private typealias OrderedSetType = OrderedDictionary<PySetElement, ()>

  private var elements: OrderedSetType

  // MARK: - Init

  internal init(_ context: PyContext) {
    self.elements = OrderedSetType()
    super.init(type: context.builtins.types.set)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySet else {
      return .notImplemented
    }

    return .value(self.isEqual(other))
  }

  internal func isEqual(_ other: PySet) -> Bool {
    guard self.elements.count == other.elements.count else {
      return false
    }

    // Equal count + isSubset -> equal
    return self.isSubset(of: other)
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    // CPython has different implementation here,
    // but in the end it all comes down to:
    return NotEqualHelper.fromIsEqual(self.isEqual(other))
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySet else {
      return .notImplemented
    }

    return .value(
      self.elements.count < other.elements.count
      && self.isSubset(of: other)
    )
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySet else {
      return .notImplemented
    }

    return .value(self.isSubset(of: other))
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySet else {
      return .notImplemented
    }

    return .value(
      self.elements.count > other.elements.count
      && self.isSuperset(of: other)
    )
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySet else {
      return .notImplemented
    }

    return .value(self.isSuperset(of: other))
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> PyResultOrNot<PyHash> {
    return .error(self.builtins.hashNotImplemented(self))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    if self.elements.isEmpty {
      return .value("()")
    }

    if self.hasReprLock {
      return .value("(...)")
    }

    return self.withReprLock {
      var result = "set("
      for (index, element) in self.elements.enumerated() {
        if index > 0 {
          result += ", " // so that we don't have ', )'.
        }

        result += self.context._repr(value: element.key.object)
      }

      result += self.elements.count > 1 ? ")" : ",)"
      return .value(result)
    }
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(zelf: self, name: name)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Length

  // sourcery: pymethod = __len__
  internal func getLength() -> BigInt {
    return BigInt(self.elements.count)
  }

  // MARK: - Contaions

  // sourcery: pymethod = __contains__
  internal func contains(_ element: PyObject) -> PyResult<Bool> {
    let key: PySetElement
    switch self.createKey(from: element) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    return .value(self.elements.contains(key: key))
  }

  // MARK: - Sub

  // sourcery: pymethod = __sub__
  internal func sub(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let otherSet = other as? PySet else {
      return .notImplemented
    }

    return .value(self.difference(with: otherSet))
  }

  // sourcery: pymethod = __rsub__
  internal func rsub(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let otherSet = other as? PySet else {
      return .notImplemented
    }

    return .value(otherSet.difference(with: self))
  }

  // MARK: - And

  // sourcery: pymethod = __and__
  internal func and(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let otherSet = other as? PySet else {
      return .notImplemented
    }

    return .value(self.intersection(with: otherSet))
  }

  // sourcery: pymethod = __rand__
  internal func rand(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.and(other)
  }

  // MARK: - Or

  // sourcery: pymethod = __or__
  internal func or(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let otherSet = other as? PySet else {
      return .notImplemented
    }

    return .value(self.union(with: otherSet))
  }

  // sourcery: pymethod = __ror__
  internal func ror(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.or(other)
  }

  // MARK: - Xor

  // sourcery: pymethod = __xor__
  internal func xor(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let otherSet = other as? PySet else {
      return .notImplemented
    }

    return .value(self.symmetricDifference(with: otherSet))
  }

  // sourcery: pymethod = __rxor__
  internal func rxor(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.xor(other)
  }

  // MARK: - Subset
  // TODO: All of the set methods should work for any iterable
  // TODO: All of the set methods should have tuple as an arg

  internal static let isSubsetDoc = """
    Report whether another set contains this set.
    """

  // sourcery: pymethod = issubset, doc = isSubsetDoc
  internal func isSubset(of other: PyObject) -> PyResult<Bool> {
    guard let otherSet = other as? PySet else {
      return .typeError("'\(other.typeName)' object is not iterable")
    }

    return .value(self.isSubset(of: otherSet))
  }

  internal func isSubset(of other: PySet) -> Bool {
    guard self.elements.count <= other.elements.count else {
      return false
    }

    for entry in self.elements {
      guard other.elements.contains(key: entry.key) else {
        return false
      }
    }

    return true
  }

  // MARK: - Superset

  internal static let isSupersetDoc = """
    Report whether this set contains another set.
    """

  // sourcery: pymethod = issuperset, doc = isSupersetDoc
  internal func isSuperset(of other: PyObject) -> PyResult<Bool> {
    guard let otherSet = other as? PySet else {
      return .typeError("'\(other.typeName)' object is not iterable")
    }

    return otherSet.isSubset(of: self)
  }

  internal func isSuperset(of other: PySet) -> Bool {
    return other.isSubset(of: self)
  }

  // MARK: - Intersection

  internal static let intersectionDoc = """
    Return the intersection of two sets as a new set.

    (i.e. all elements that are in both sets.)
    """

  // sourcery: pymethod = intersection, doc = intersectionDoc
  internal func intersection(with other: PyObject) -> PyResult<PySet> {
    guard let otherSet = other as? PySet else {
      return .typeError("'\(other.typeName)' object is not iterable")
    }

    return .value(self.intersection(with: otherSet))
  }

  internal func intersection(with other: PySet) -> PySet {
    let isSelfSmaller = self.elements.count < other.elements.count
    let smallerSet = isSelfSmaller ? self : other
    let largerSet = isSelfSmaller ? other : self

    let result = PySet(self.context)
    for entry in smallerSet.elements {
      if largerSet.elements.contains(key: entry.key) {
        result.elements.insert(key: entry.key)
      }
    }

    return result
  }

  // MARK: - Union

  internal static let unionDoc = """
    Return the union of sets as a new set.

    (i.e. all elements that are in either set.)
    """

  // sourcery: pymethod = union, doc = unionDoc
  internal func union(with other: PyObject) -> PyResult<PySet> {
    guard let otherSet = other as? PySet else {
      return .typeError("'\(other.typeName)' object is not iterable")
    }

    return .value(self.union(with: otherSet))
  }

  internal func union(with other: PySet) -> PySet {
    let isSelfSmaller = self.elements.count < other.elements.count
    let smallerSet = isSelfSmaller ? self : other
    let largerSet = isSelfSmaller ? other : self

    let result = PySet(self.context)
    result.elements = largerSet.elements

    for entry in smallerSet.elements {
      result.elements.insert(key: entry.key)
    }

    return result
  }

  // MARK: - Difference

  internal static let differenceDoc = """
    Return the difference of two or more sets as a new set.

    (i.e. all elements that are in this set but not the others.)
    """

  // sourcery: pymethod = difference, doc = differenceDoc
  internal func difference(with other: PyObject) -> PyResult<PySet> {
    guard let otherSet = other as? PySet else {
      return .typeError("'\(other.typeName)' object is not iterable")
    }

    return .value(self.difference(with: otherSet))
  }

  internal func difference(with other: PySet) -> PySet {
    let result = PySet(self.context)
    for entry in self.elements {
      if !other.elements.contains(key: entry.key) {
        result.elements.insert(key: entry.key)
      }
    }

    return result
  }

  // MARK: - Symmetric difference

  internal static let symmetricDifferenceDoc = """
    Return the symmetric difference of two sets as a new set.

    (i.e. all elements that are in exactly one of the sets.
    """

  // sourcery: pymethod = symmetric_difference, doc = symmetricDifferenceDoc
  internal func symmetricDifference(with other: PyObject) -> PyResult<PySet> {
    guard let otherSet = other as? PySet else {
      return .typeError("'\(other.typeName)' object is not iterable")
    }

    return .value(self.symmetricDifference(with: otherSet))
  }

  internal func symmetricDifference(with other: PySet) -> PySet {
    let result = PySet(self.context)
    for entry in self.elements {
      if !other.elements.contains(key: entry.key) {
        result.elements.insert(key: entry.key)
      }
    }

    for entry in other.elements {
      if !self.elements.contains(key: entry.key) {
        result.elements.insert(key: entry.key)
      }
    }

    return result
  }

  // MARK: - Is disjoint

  internal static let isDisjointDoc = """
    Return True if two sets have a null intersection.
    """

  // sourcery: pymethod = isdisjoint, doc = isDisjointDoc
  internal func isDisjoint(with other: PyObject) -> PyResult<Bool> {
    guard let otherSet = other as? PySet else {
      return .typeError("'\(other.typeName)' object is not iterable")
    }

    let isSelfSmaller = self.elements.count < otherSet.elements.count
    let smallerSet = isSelfSmaller ? self : otherSet
    let largerSet = isSelfSmaller ? otherSet : self

    for entry in smallerSet.elements {
      if largerSet.elements.contains(key: entry.key) {
        return .value(false)
      }
    }

    return .value(true)
  }

  // MARK: - Add

  internal static let addDoc = """
    Add an element to a set.

    This has no effect if the element is already present.
    """

  // sourcery: pymethod = add, doc = addDoc
  internal func add(_ value: PyObject) -> PyResult<PyNone> {
    let key: PySetElement
    switch self.createKey(from: value) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    self.elements.insert(key: key)
    return .value(self.builtins.none)
  }

  // MARK: - Remove

  internal static let removeDoc = """
    Remove an element from a set; it must be a member.

    If the element is not a member, raise a KeyError.
    """

  // sourcery: pymethod = remove, doc = removeDoc
  internal func remove(_ value: PyObject) -> PyResult<PyNone> {
    let key: PySetElement
    switch self.createKey(from: value) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    let wasInSet = self.elements.remove(key: key) != nil
    if wasInSet {
      return .value(self.builtins.none)
    }

    return .keyErrorForKey(value)
  }

  // MARK: - Discard

  internal static let discardDoc = """
    Remove an element from a set if it is a member.

    If the element is not a member, do nothing.
    """

  // sourcery: pymethod = discard, doc = discardDoc
  internal func discard(_ value: PyObject) -> PyResult<PyNone> {
    let key: PySetElement
    switch self.createKey(from: value) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    _ = self.elements.remove(key: key) != nil
    return .value(self.builtins.none)
  }

  // MARK: - Clear

  internal static let clearDoc = """
    Remove all elements from this set.
    """

  // sourcery: pymethod = clear, doc = clearDoc
  internal func clear() -> PyResult<PyNone> {
    self.elements.clear()
    return .value(self.builtins.none)
  }

  // MARK: - Copy

  internal static let copyDoc = "Return a shallow copy of a set."

  // sourcery: pymethod = copy, doc = copyDoc
  internal func copy() -> PyObject {
    let result = PySet(self.context)
    result.elements = self.elements
    return result
  }

  // MARK: - Pop

  internal static let popDoc = """
    Remove and return an arbitrary set element.
    Raises KeyError if the set is empty.
    """

  // sourcery: pymethod = pop, doc = popDoc
  internal func pop() -> PyResult<PyObject> {
    guard let last = self.elements.last else {
      return .keyError("pop from an empty set")
    }

    _ = self.elements.remove(key: last.key)
    return .value(last.key.object)
  }

  // MARK: - Helpers

  private func createKey(from object: PyObject) -> PyResult<PySetElement> {
    switch self.builtins.hash(object) {
    case let .value(hash):
      return .value(PySetElement(hash: hash, object: object))
    case let .error(e):
      return .error(e)
    }
  }
}

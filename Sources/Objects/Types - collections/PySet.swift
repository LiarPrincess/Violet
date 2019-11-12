import Core

// In CPython:
// Objects -> setobject.c
// https://docs.python.org/3.7/c-api/set.html

// swiftlint:disable file_length

// sourcery: pytype = set
/// This subtype of PyObject is used to hold the internal data for both set
/// and frozenset objects.
public final class PySet: PyObject {

  internal static let doc: String = """
    set() -> new empty set object
    set(iterable) -> new set object

    Build an unordered collection of unique elements.
    """

  internal var elements: PySetData

  // MARK: - Init

  internal init(_ context: PyContext) {
    self.elements = PySetData()
    super.init(type: context.builtins.types.set)
  }

  internal init(_ context: PyContext, elements: PySetData) {
    self.elements = elements
    super.init(type: context.builtins.types.set)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return .value(SetHelper.isEqual(left: self, right: other))
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
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return .value(SetHelper.isLess(left: self, right: other))
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return .value(SetHelper.isLessEqual(left: self, right: other))
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return .value(SetHelper.isGreater(left: self, right: other))
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return .value(SetHelper.isGreaterEqual(left: self, right: other))
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> PyResultOrNot<PyHash> {
    return .error(self.builtins.hashNotImplemented(self))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    return .value(SetHelper.repr(self))
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
    return SetHelper.getLength(self)
  }

  // MARK: - Contaions

  // sourcery: pymethod = __contains__
  internal func contains(_ element: PyObject) -> PyResult<Bool> {
    return SetHelper.contains(set: self, element: element)
  }

  // MARK: - And

  // sourcery: pymethod = __and__
  internal func and(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .notImplemented
    }

    let elements = SetHelper.and(left: self, right: otherSet)
    return .value(self.createSet(elements: elements))
  }

  // sourcery: pymethod = __rand__
  internal func rand(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.and(other)
  }

  // MARK: - Or

  // sourcery: pymethod = __or__
  internal func or(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .notImplemented
    }

    let elements = SetHelper.union(left: self, right: otherSet)
    return .value(self.createSet(elements: elements))
  }

  // sourcery: pymethod = __ror__
  internal func ror(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.or(other)
  }

  // MARK: - Xor

  // sourcery: pymethod = __xor__
  internal func xor(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .notImplemented
    }

    let elements = SetHelper.symmetricDifference(left: self, right: otherSet)
    return .value(self.createSet(elements: elements))
  }

  // sourcery: pymethod = __rxor__
  internal func rxor(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.xor(other)
  }

  // MARK: - Sub

  // sourcery: pymethod = __sub__
  internal func sub(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .notImplemented
    }

    let elements = SetHelper.difference(left: self, right: otherSet)
    return .value(self.createSet(elements: elements))
  }

  // sourcery: pymethod = __rsub__
  internal func rsub(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .notImplemented
    }

    let elements = SetHelper.difference(left: otherSet, right: self)
    return .value(self.createSet(elements: elements))
  }

  // MARK: - Subset

  internal static let isSubsetDoc = """
    Report whether another set contains this set.
    """

  // sourcery: pymethod = issubset, doc = isSubsetDoc
  internal func isSubset(of other: PyObject) -> PyResult<Bool> {
    guard let otherSet = other as? PySetType else {
      return .typeError("'\(other.typeName)' object is not iterable")
    }

    return .value(SetHelper.isSubset(self, of: otherSet))
  }

  // MARK: - Superset

  internal static let isSupersetDoc = """
    Report whether this set contains another set.
    """

  // sourcery: pymethod = issuperset, doc = isSupersetDoc
  internal func isSuperset(of other: PyObject) -> PyResult<Bool> {
    guard let otherSet = other as? PySetType else {
      return .typeError("'\(other.typeName)' object is not iterable")
    }

    return .value(SetHelper.isSuperset(self, of: otherSet))
  }

  // MARK: - Intersection

  internal static let intersectionDoc = """
    Return the intersection of two sets as a new set.

    (i.e. all elements that are in both sets.)
    """

  // sourcery: pymethod = intersection, doc = intersectionDoc
  internal func intersection(with other: PyObject) -> PyResult<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .typeError("'\(other.typeName)' object is not iterable")
    }

    let elements = SetHelper.intersection(left: self, right: otherSet)
    return .value(self.createSet(elements: elements))
  }

  // MARK: - Union

  internal static let unionDoc = """
    Return the union of sets as a new set.

    (i.e. all elements that are in either set.)
    """

  // sourcery: pymethod = union, doc = unionDoc
  internal func union(with other: PyObject) -> PyResult<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .typeError("'\(other.typeName)' object is not iterable")
    }

    let elements = SetHelper.union(left: self, right: otherSet)
    return .value(self.createSet(elements: elements))
  }

  // MARK: - Difference

  internal static let differenceDoc = """
    Return the difference of two or more sets as a new set.

    (i.e. all elements that are in this set but not the others.)
    """

  // sourcery: pymethod = difference, doc = differenceDoc
  internal func difference(with other: PyObject) -> PyResult<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .typeError("'\(other.typeName)' object is not iterable")
    }

    let elements = SetHelper.difference(left: self, right: otherSet)
    return .value(self.createSet(elements: elements))
  }

  // MARK: - Symmetric difference

  internal static let symmetricDifferenceDoc = """
    Return the symmetric difference of two sets as a new set.

    (i.e. all elements that are in exactly one of the sets.
    """

  // sourcery: pymethod = symmetric_difference, doc = symmetricDifferenceDoc
  internal func symmetricDifference(with other: PyObject) -> PyResult<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .typeError("'\(other.typeName)' object is not iterable")
    }

    let elements = SetHelper.symmetricDifference(left: self, right: otherSet)
    return .value(self.createSet(elements: elements))
  }

  // MARK: - Is disjoint

  internal static let isDisjointDoc = """
    Return True if two sets have a null intersection.
    """

  // sourcery: pymethod = isdisjoint, doc = isDisjointDoc
  internal func isDisjoint(with other: PyObject) -> PyResult<Bool> {
    guard let otherSet = other as? PySetType else {
      return .typeError("'\(other.typeName)' object is not iterable")
    }

    return .value(SetHelper.isDisjoint(left: self, right: otherSet))
  }

  // MARK: - Add

  internal static let addDoc = """
    Add an element to a set.

    This has no effect if the element is already present.
    """

  // sourcery: pymethod = add, doc = addDoc
  internal func add(_ value: PyObject) -> PyResult<PyNone> {
    switch SetHelper.add(self, value: value) {
    case .none:
      return .value(self.builtins.none)
    case .some(let e):
      return .error(e)
    }
  }

  // MARK: - Remove

  internal static let removeDoc = """
    Remove an element from a set; it must be a member.

    If the element is not a member, raise a KeyError.
    """

  // sourcery: pymethod = remove, doc = removeDoc
  internal func remove(_ value: PyObject) -> PyResult<PyNone> {
    switch SetHelper.remove(self, value: value) {
    case .none:
      return .value(self.builtins.none)
    case .some(let e):
      return .error(e)
    }
  }

  // MARK: - Discard

  internal static let discardDoc = """
    Remove an element from a set if it is a member.

    If the element is not a member, do nothing.
    """

  // sourcery: pymethod = discard, doc = discardDoc
  internal func discard(_ value: PyObject) -> PyResult<PyNone> {
    switch SetHelper.discard(self, value: value) {
    case .none:
      return .value(self.builtins.none)
    case .some(let e):
      return .error(e)
    }
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
    return self.createSet(elements: self.elements)
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

  private func createSet(elements: PySetData) -> PySet {
    return PySet(self.context, elements: elements)
  }

  private func createKey(from object: PyObject) -> PyResult<PySetElement> {
    switch self.builtins.hash(object) {
    case let .value(hash):
      return .value(PySetElement(hash: hash, object: object))
    case let .error(e):
      return .error(e)
    }
  }
}

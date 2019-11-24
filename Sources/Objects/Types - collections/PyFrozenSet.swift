import Core

// In CPython:
// Objects -> setobject.c
// https://docs.python.org/3.7/c-api/set.html

// swiftlint:disable file_length

// sourcery: pytype = frozenset
/// This is an instance of PyTypeObject representing the Python frozenset type.
public final class PyFrozenSet: PyObject {

  internal static let doc: String = """
    frozenset() -> empty frozenset object
    frozenset(iterable) -> frozenset object

    Build an immutable unordered collection of unique elements.
    """

  internal var elements: PySetData

  // MARK: - Init

  internal init(_ context: PyContext) {
    self.elements = PySetData()
    super.init(type: context.builtins.types.frozenset)
  }

  internal init(_ context: PyContext, elements: PySetData) {
    self.elements = elements
    super.init(type: context.builtins.types.frozenset)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return SetHelper.isEqual(left: self, right: other).asResultOrNot
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

    return SetHelper.isLess(left: self, right: other).asResultOrNot
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return SetHelper.isLessEqual(left: self, right: other).asResultOrNot
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return SetHelper.isGreater(left: self, right: other).asResultOrNot
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return SetHelper.isGreaterEqual(left: self, right: other).asResultOrNot
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> PyResultOrNot<PyHash> {
    // This is hash function from 'tuple', which means that 'frozenset'
    // and 'tuple' with the same elements (in the same order) will have
    // the same hash.
    var x: PyHash = 0x345678
    var mult = PyHasher.multiplier

    for entry in self.elements {
      switch self.builtins.hash(entry.key.object) {
      case let .value(y):
        x = (x ^ y) * mult
        mult += 82_520 + PyHash(2 * self.elements.count)
      case let .error(e):
        return .error(e)
      }
    }

    return .value(x + 97_531)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    return SetHelper.repr(self)
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
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
    return SetHelper.contains(self, element: element)
  }

  // MARK: - And

  // sourcery: pymethod = __and__
  internal func and(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .notImplemented
    }

    switch SetHelper.and(left: self, right: otherSet) {
    case let .value(data):
      return .value(self.createSet(elements: data))
    case let .error(e):
      return .error(e)
    }
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

    switch SetHelper.union(left: self, right: otherSet) {
    case let .value(data):
      return .value(self.createSet(elements: data))
    case let .error(e):
      return .error(e)
    }
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

    switch SetHelper.symmetricDifference(left: self, right: otherSet) {
    case let .value(data):
      return .value(self.createSet(elements: data))
    case let .error(e):
      return .error(e)
    }
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

    switch SetHelper.difference(left: self, right: otherSet) {
    case let .value(data):
      return .value(self.createSet(elements: data))
    case let .error(e):
      return .error(e)
    }
  }

  // sourcery: pymethod = __rsub__
  internal func rsub(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let otherSet = other as? PySetType else {
      return .notImplemented
    }

    switch SetHelper.difference(left: otherSet, right: self) {
    case let .value(data):
      return .value(self.createSet(elements: data))
    case let .error(e):
      return .error(e)
    }
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

    return SetHelper.isSubset(self, of: otherSet)
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

    return SetHelper.isSuperset(self, of: otherSet)
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

    switch SetHelper.intersection(left: self, right: otherSet) {
    case let .value(data):
      return .value(self.createSet(elements: data))
    case let .error(e):
      return .error(e)
    }
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

    switch SetHelper.union(left: self, right: otherSet) {
    case let .value(data):
      return .value(self.createSet(elements: data))
    case let .error(e):
      return .error(e)
    }
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

    switch SetHelper.difference(left: self, right: otherSet) {
    case let .value(data):
      return .value(self.createSet(elements: data))
    case let .error(e):
      return .error(e)
    }
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

    switch SetHelper.symmetricDifference(left: self, right: otherSet) {
    case let .value(data):
      return .value(self.createSet(elements: data))
    case let .error(e):
      return .error(e)
    }
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

    return SetHelper.isDisjoint(left: self, right: otherSet)
  }

  // MARK: - Copy

  internal static let copyDoc = "Return a shallow copy of a set."

  // sourcery: pymethod = copy, doc = copyDoc
  internal func copy() -> PyObject {
    return self.createSet(elements: self.elements)
  }

  // MARK: - Helpers

  private func createSet(elements: PySetData) -> PyFrozenSet {
    return PyFrozenSet(self.context, elements: elements)
  }
}

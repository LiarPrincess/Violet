import BigInt
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore setobject

// In CPython:
// Objects -> setobject.c
// https://docs.python.org/3.7/c-api/set.html

// sourcery: pytype = frozenset, isDefault, hasGC, isBaseType
// sourcery: subclassInstancesHave__dict__
public final class PyFrozenSet: PyObject, AbstractSet {

  // MARK: - Element, OrderedSet

  internal typealias Element = AbstractSet_Element
  internal typealias OrderedSet = VioletObjects.OrderedSet<Element>

  // MARK: - Properties

  // sourcery: pytypedoc
  internal static let doc = """
    frozenset() -> empty frozenset object
    frozenset(iterable) -> frozenset object

    Build an immutable unordered collection of unique elements.
    """

  internal let elements: OrderedSet

  override public var description: String {
    return "PyFrozenSet(count: \(self.elements.count))"
  }

  // MARK: - Init

  internal convenience init(elements: PyFrozenSet.OrderedSet) {
    let type = Py.types.frozenset
    self.init(type: type, elements: elements)
  }

  internal init(type: PyType, elements: PyFrozenSet.OrderedSet) {
    self.elements = elements
    super.init(type: type)
  }

  // MARK: - AbstractSet

  internal static func _toSelf(elements: OrderedSet) -> PyFrozenSet {
    return Py.newFrozenSet(elements: elements)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    return self._isEqual(other: other)
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self._isNotEqual(other: other)
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    return self._isLess(other: other)
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    return self._isLessEqual(other: other)
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    return self._isGreater(other: other)
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return self._isGreaterEqual(other: other)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> PyHash {
    // This is hash function from 'tuple', which means that 'frozenset'
    // and 'tuple' with the same elements (in the same order) will have
    // the same hash.
    var x: PyHash = 0x34_5678
    var multiplier = Hasher.multiplier

    for element in self.elements {
      let y = element.hash
      x = (x ^ y) * multiplier
      multiplier += 82_520 + PyHash(2 * self.elements.count)
    }

    return x + 97_531
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    if self.elements.isEmpty {
      return .value(self.typeName + "()")
    }

    if self.hasReprLock {
      return .value(self.typeName + "(...)")
    }

    return self.withReprLock {
      let elements = self._joinElementsForRepr()
      return elements.map { "\(typeName)({" + $0 + "})" }
    }
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
    return BigInt(self._count)
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(object: PyObject) -> PyResult<Bool> {
    return self._contains(object: object)
  }

  // MARK: - And

  // sourcery: pymethod = __and__
  internal func and(_ other: PyObject) -> PyResult<PyObject> {
    return self._and(other: other)
  }

  // sourcery: pymethod = __rand__
  internal func rand(_ other: PyObject) -> PyResult<PyObject> {
    return self._rand(other: other)
  }

  // MARK: - Or

  // sourcery: pymethod = __or__
  internal func or(_ other: PyObject) -> PyResult<PyObject> {
    return self._or(other: other)
  }

  // sourcery: pymethod = __ror__
  internal func ror(_ other: PyObject) -> PyResult<PyObject> {
    return self._ror(other: other)
  }

  // MARK: - Xor

  // sourcery: pymethod = __xor__
  internal func xor(_ other: PyObject) -> PyResult<PyObject> {
    return self._xor(other: other)
  }

  // sourcery: pymethod = __rxor__
  internal func rxor(_ other: PyObject) -> PyResult<PyObject> {
    return self._rxor(other: other)
  }

  // MARK: - Sub

  // sourcery: pymethod = __sub__
  internal func sub(_ other: PyObject) -> PyResult<PyObject> {
    return self._sub(other: other)
  }

  // sourcery: pymethod = __rsub__
  internal func rsub(_ other: PyObject) -> PyResult<PyObject> {
    return self._rsub(other: other)
  }

  // MARK: - Is subset

  internal static let isSubsetDoc = """
    Report whether another set contains this set.
    """

  // sourcery: pymethod = issubset, doc = isSubsetDoc
  internal func isSubset(of other: PyObject) -> PyResult<Bool> {
    return self._isSubset(of: other)
  }

  // MARK: - Is superset

  internal static let isSupersetDoc = """
    Report whether this set contains another set.
    """

  // sourcery: pymethod = issuperset, doc = isSupersetDoc
  internal func isSuperset(of other: PyObject) -> PyResult<Bool> {
    return self._isSuperset(of: other)
  }

  // MARK: - Is disjoint

  internal static let isDisjointDoc = """
    Return True if two sets have a null intersection.
    """

  // sourcery: pymethod = isdisjoint, doc = isDisjointDoc
  internal func isDisjoint(with other: PyObject) -> PyResult<Bool> {
    return self._isDisjoint(with: other)
  }

  // MARK: - Intersection

  internal static let intersectionDoc = """
    Return the intersection of two sets as a new set.

    (i.e. all elements that are in both sets.)
    """

  // sourcery: pymethod = intersection, doc = intersectionDoc
  internal func intersection(with other: PyObject) -> PyResult<PyObject> {
    return self._intersection(with: other)
  }

  // MARK: - Union

  internal static let unionDoc = """
    Return the union of sets as a new set.

    (i.e. all elements that are in either set.)
    """

  // sourcery: pymethod = union, doc = unionDoc
  internal func union(with other: PyObject) -> PyResult<PyObject> {
    return self._union(with: other)
  }

  // MARK: - Difference

  internal static let differenceDoc = """
    Return the difference of two or more sets as a new set.

    (i.e. all elements that are in this set but not the others.)
    """

  // sourcery: pymethod = difference, doc = differenceDoc
  internal func difference(with other: PyObject) -> PyResult<PyObject> {
    return self._difference(with: other)
  }

  // MARK: - Symmetric difference

  internal static let symmetricDifferenceDoc = """
    Return the symmetric difference of two sets as a new set.

    (i.e. all elements that are in exactly one of the sets.
    """

  // sourcery: pymethod = symmetric_difference, doc = symmetricDifferenceDoc
  internal func symmetricDifference(with other: PyObject) -> PyResult<PyObject> {
    return self._symmetricDifference(with: other)
  }

  // MARK: - Copy

  internal static let copyDoc = "Return a shallow copy of a set."

  // sourcery: pymethod = copy, doc = copyDoc
  internal func copy() -> PyObject {
    return Py.newFrozenSet(elements: self.elements)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return PyMemory.newSetIterator(frozenSet: self)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyFrozenSet> {
    let isBuiltin = type === Py.types.frozenset
    if isBuiltin {
      if let e = ArgumentParser.noKwargsOrError(fnName: "frozenset",
                                                kwargs: kwargs) {
        return .error(e)
      }
    }

    // Guarantee 0 or 1 args
    if let e = ArgumentParser.guaranteeArgsCountOrError(fnName: "frozenset",
                                                        args: args,
                                                        min: 0,
                                                        max: 1) {
      return .error(e)
    }

    let elements: OrderedSet
    if let iterable = args.first {
      switch Self._getElements(iterable: iterable) {
      case let .value(e): elements = e
      case let .error(e): return .error(e)
      }
    } else {
      elements = OrderedSet()
    }

    let result: PyFrozenSet = isBuiltin ?
      Py.newFrozenSet(elements: elements) :
      PyMemory.newFrozenSet(type: type, elements: elements)

    return .value(result)
  }
}

/* MARKER
import BigInt
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore setobject

// In CPython:
// Objects -> setobject.c
// https://docs.python.org/3.7/c-api/set.html

// sourcery: pytype = set, isDefault, hasGC, isBaseType
// sourcery: subclassInstancesHave__dict__
public final class PySet: PyObject, AbstractSet {

  // MARK: - Element, OrderedSet

  internal typealias Element = AbstractSet_Element
  internal typealias OrderedSet = VioletObjects.OrderedSet<Element>

  // MARK: - Properties

  // sourcery: pytypedoc
  internal static let doc = """
    set() -> new empty set object
    set(iterable) -> new set object

    Build an unordered collection of unique elements.
    """

  internal var elements: OrderedSet

  // MARK: - Init

  internal convenience init(elements: PySet.OrderedSet) {
    let type = Py.types.set
    self.init(type: type, elements: elements)
  }

  internal init(type: PyType, elements: PySet.OrderedSet) {
    self.elements = elements
    super.init(type: type)
  }

  // MARK: - AbstractSet

  internal static func _toSelf(elements: OrderedSet) -> PySet {
    return Py.newSet(elements: elements)
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
  internal func hash() -> HashResult {
    return .unhashable(self)
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
      return elements.map { "{" + $0 + "}" } // no 'self.typeName'!
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

  // MARK: - Add

  internal static let addDoc = """
    Add an element to a set.

    This has no effect if the element is already present.
    """

  // sourcery: pymethod = add, doc = addDoc
  internal func add(object: PyObject) -> PyResult<PyNone> {
    switch Self._createElement(from: object) {
    case let .value(element):
      switch self.elements.insert(element: element) {
      case .inserted,
           .updated:
        return .value(Py.none)
      case .error(let e):
        return .error(e)
      }

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Update

  internal static let updateDoc = """
    Update a set with the union of itself and others.
    """

  // sourcery: pymethod = update, doc = updateDoc
  internal func update(from other: PyObject) -> PyResult<PyNone> {
    switch Self._getElements(iterable: other) {
    case let .value(set):
      return self.update(from: set)
    case let .error(e):
      return .error(e)
    }
  }

  private func update(from other: OrderedSet) -> PyResult<PyNone> {
    for element in other {
      switch self.elements.insert(element: element) {
      case .inserted,
           .updated:
        break
      case .error(let e):
        return .error(e)
      }
    }

    return .value(Py.none)
  }

  // MARK: - Remove

  internal static let removeDoc = """
    Remove an element from a set; it must be a member.

    If the element is not a member, raise a KeyError.
    """

  // sourcery: pymethod = remove, doc = removeDoc
  internal func remove(object: PyObject) -> PyResult<PyNone> {
    switch Self._createElement(from: object) {
    case let .value(element):
      return self.remove(element: element)
    case let .error(e):
      return .error(e)
    }
  }

  private func remove(element: Element) -> PyResult<PyNone> {
    switch self.elements.remove(element: element) {
    case .ok:
      return .value(Py.none)
    case .notFound:
      let e = Py.newKeyError(key: element.object)
      return .error(e)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Discard

  internal static let discardDoc = """
    Remove an element from a set if it is a member.

    If the element is not a member, do nothing.
    """

  // sourcery: pymethod = discard, doc = discardDoc
  internal func discard(object: PyObject) -> PyResult<PyNone> {
    switch Self._createElement(from: object) {
    case let .value(element):
      return self.discard(element: element)
    case let .error(e):
      return .error(e)
    }
  }

  private func discard(element: Element) -> PyResult<PyNone> {
    switch self.elements.remove(element: element) {
    case .ok,
         .notFound:
      return .value(Py.none)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Clear

  internal static let clearDoc = """
    Remove all elements from this set.
    """

  // sourcery: pymethod = clear, doc = clearDoc
  internal func clear() -> PyNone {
    self.elements.clear()
    return Py.none
  }

  // MARK: - Copy

  internal static let copyDoc = "Return a shallow copy of a set."

  // sourcery: pymethod = copy, doc = copyDoc
  internal func copy() -> PyObject {
    return Py.newSet(elements: self.elements)
  }

  // MARK: - Pop

  internal static let popDoc = """
    Remove and return an arbitrary set element.
    Raises KeyError if the set is empty.
    """

  // sourcery: pymethod = pop, doc = popDoc
  internal func pop() -> PyResult<PyObject> {
    guard let lastElement = self.elements.last else {
      return .keyError("pop from an empty set")
    }

    _ = self.remove(element: lastElement)
    return .value(lastElement.object)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return PyMemory.newSetIterator(set: self)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PySet> {
    let elements = OrderedSet()
    let isBuiltin = type === Py.types.set

    let result: PySet = isBuiltin ?
      Py.newSet(elements: elements) :
      PyMemory.newSet(type: type, elements: elements)

    return .value(result)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    if let e = ArgumentParser.noKwargsOrError(fnName: self.typeName,
                                              kwargs: kwargs) {
      return .error(e)
    }

    if let e = ArgumentParser.guaranteeArgsCountOrError(fnName: self.typeName,
                                                        args: args,
                                                        min: 0,
                                                        max: 1) {
      return .error(e)
    }

    if let iterable = args.first {
      switch self.update(from: iterable) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    return .value(Py.none)
  }
}

*/
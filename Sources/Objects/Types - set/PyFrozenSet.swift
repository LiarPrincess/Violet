import BigInt
import VioletCore

// cSpell:ignore setobject

// In CPython:
// Objects -> setobject.c
// https://docs.python.org/3.7/c-api/set.html

// sourcery: pytype = frozenset, isDefault, hasGC, isBaseType
// sourcery: subclassInstancesHave__dict__
public struct PyFrozenSet: PyObjectMixin, AbstractSet {

  // sourcery: pytypedoc
  internal static let doc = """
    frozenset() -> empty frozenset object
    frozenset(iterable) -> frozenset object

    Build an immutable unordered collection of unique elements.
    """

  internal typealias Element = OrderedSet.Element

  // sourcery: storedProperty
  internal var elements: OrderedSet { self.elementsPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, elements: OrderedSet) {
    self.initializeBase(py, type: type)
    self.elementsPtr.initialize(to: elements)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyFrozenSet(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "count", value: zelf.count, includeInDescription: true)
    result.append(name: "elements", value: zelf.elements)
    return result
  }

  // MARK: - AbstractSet

  internal static func newObject(_ py: Py, elements: OrderedSet) -> PyFrozenSet {
    return py.newFrozenSet(elements: elements)
  }

  // MARK: - Equatable, comparable

  // sourcery: pymethod = __eq__
  internal static func __eq__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__eq__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __ne__
  internal static func __ne__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__ne__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __lt__
  internal static func __lt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__lt__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __le__
  internal static func __le__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__le__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __gt__
  internal static func __gt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__gt__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __ge__
  internal static func __ge__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__ge__(py, zelf: zelf, other: other)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal static func __hash__(_ py: Py, zelf _zelf: PyObject) -> HashResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName)
    }

    // This is hash function from 'tuple', which means that 'frozenset'
    // and 'tuple' with the same elements (in the same order) will have
    // the same hash.
    var x: PyHash = 0x34_5678
    var multiplier = Hasher.multiplier

    for element in zelf.elements {
      let y = element.hash
      x = (x ^ y) * multiplier
      multiplier += 82_520 + PyHash(2 * zelf.elements.count)
    }

    let result = x + 97_531
    return .value(result)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__repr__")
    }

    if zelf.elements.isEmpty {
      return PyResult(py, interned: "frozenset()")
    }

    if zelf.hasReprLock {
      return PyResult(py, interned: "frozenset(...)")
    }

    return zelf.withReprLock {
      switch Self.abstractJoinElementsForRepr(py, zelf: zelf) {
      case let .value(elements):
        let result = "frozenset({" + elements + "})"
        return PyResult(py, result)
      case let .error(e):
        return .error(e)
      }
    }
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf _zelf: PyObject,
                                        name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Length

  // sourcery: pymethod = __len__
  internal static func __len__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__len__")
    }

    let result = zelf.count
    return PyResult(py, result)
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal static func __contains__(_ py: Py, zelf: PyObject, object: PyObject) -> PyResult {
    return Self.abstract__contains__(py, zelf: zelf, object: object)
  }

  // MARK: - And, or, xor

  // sourcery: pymethod = __and__
  internal static func __and__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.abstract__and__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __rand__
  internal static func __rand__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.abstract__rand__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __or__
  internal static func __or__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.abstract__or__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __ror__
  internal static func __ror__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.abstract__ror__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __xor__
  internal static func __xor__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.abstract__xor__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __rxor__
  internal static func __rxor__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.abstract__rxor__(py, zelf: zelf, other: other)
  }

  // MARK: - Sub

  // sourcery: pymethod = __sub__
  internal static func __sub__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.abstract__sub__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __rsub__
  internal static func __rsub__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.abstract__rsub__(py, zelf: zelf, other: other)
  }

  // MARK: - Is subset, superset, disjoint

  internal static let isSubsetDoc = """
    Report whether another set contains this set.
    """

  // sourcery: pymethod = issubset, doc = isSubsetDoc
  internal static func issubset(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return self.abstractIsSubset(py, zelf: zelf, other: other)
  }

  internal static let isSupersetDoc = """
    Report whether this set contains another set.
    """

  // sourcery: pymethod = issuperset, doc = isSupersetDoc
  internal static func issuperset(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return self.abstractIsSuperset(py, zelf: zelf, other: other)
  }

  internal static let isDisjointDoc = """
    Return True if two sets have a null intersection.
    """

  // sourcery: pymethod = isdisjoint, doc = isDisjointDoc
  internal static func isdisjoint(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return self.abstractIsDisjoint(py, zelf: zelf, other: other)
  }

  // MARK: - Intersection, union, difference

  internal static let intersectionDoc = """
    Return the intersection of two sets as a new set.

    (i.e. all elements that are in both sets.)
    """

  // sourcery: pymethod = intersection, doc = intersectionDoc
  internal static func intersection(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return self.abstractIntersection(py, zelf: zelf, other: other)
  }

  internal static let unionDoc = """
    Return the union of sets as a new set.

    (i.e. all elements that are in either set.)
    """

  // sourcery: pymethod = union, doc = unionDoc
  internal static func union(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return self.abstractUnion(py, zelf: zelf, other: other)
  }

  internal static let differenceDoc = """
    Return the difference of two or more sets as a new set.

    (i.e. all elements that are in this set but not the others.)
    """

  // sourcery: pymethod = difference, doc = differenceDoc
  internal static func difference(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return self.abstractDifference(py, zelf: zelf, other: other)
  }

  internal static let symmetricDifferenceDoc = """
    Return the symmetric difference of two sets as a new set.

    (i.e. all elements that are in exactly one of the sets.
    """

  // sourcery: pymethod = symmetric_difference, doc = symmetricDifferenceDoc
  internal static func symmetric_difference(_ py: Py,
                                            zelf: PyObject,
                                            other: PyObject) -> PyResult {
    return self.abstractSymmetricDifference(py, zelf: zelf, other: other)
  }

  // MARK: - Copy

  internal static let copyDoc = "Return a shallow copy of a set."

  // sourcery: pymethod = copy, doc = copyDoc
  internal static func copy(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "copy")
    }

    let result = py.newFrozenSet(elements: zelf.elements)
    return PyResult(result)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal static func __iter__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__iter__")
    }

    let result = py.newIterator(set: zelf)
    return PyResult(result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    let isBuiltin = type === py.types.frozenset
    if isBuiltin {
      if let e = ArgumentParser.noKwargsOrError(py,
                                                fnName: Self.pythonTypeName,
                                                kwargs: kwargs) {
        return .error(e.asBaseException)
      }
    }

    // Guarantee 0 or 1 args
    if let e = ArgumentParser.guaranteeArgsCountOrError(py,
                                                        fnName: Self.pythonTypeName,
                                                        args: args,
                                                        min: 0,
                                                        max: 1) {
      return .error(e.asBaseException)
    }

    let elements: OrderedSet
    if let iterable = args.first {
      switch Self.getElements(py, iterable: iterable) {
      case let .value(e): elements = e
      case let .error(e): return .error(e)
      }
    } else {
      elements = OrderedSet()
    }

    let result: PyFrozenSet = isBuiltin ?
      py.newFrozenSet(elements: elements) :
      py.memory.newFrozenSet(type: type, elements: elements)

    return PyResult(result)
  }
}

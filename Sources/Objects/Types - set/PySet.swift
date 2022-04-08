import BigInt
import VioletCore

// cSpell:ignore setobject

// In CPython:
// Objects -> setobject.c
// https://docs.python.org/3.7/c-api/set.html

// sourcery: pytype = set, isDefault, hasGC, isBaseType
// sourcery: subclassInstancesHave__dict__
public struct PySet: PyObjectMixin, AbstractSet {

  // sourcery: pytypedoc
  internal static let doc = """
    set() -> new empty set object
    set(iterable) -> new set object

    Build an unordered collection of unique elements.
    """

  internal typealias Element = OrderedSet.Element

  // sourcery: storedProperty
  internal var elements: OrderedSet {
    // Do not add 'nonmutating set/_modify' - the compiler could get confused
    // sometimes. Use 'self.elementsPtr.pointee' for modification.
    self.elementsPtr.pointee
  }

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
    let zelf = PySet(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "count", value: zelf.count, includeInDescription: true)
    result.append(name: "elements", value: zelf.elements)
    return result
  }

  // MARK: - AbstractSet

  internal static func newObject(_ py: Py, elements: OrderedSet) -> PySet {
    return py.newSet(elements: elements)
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
  internal static func __hash__(_ py: Py, zelf: PyObject) -> HashResult {
    guard Self.downcast(py, zelf) != nil else {
      return .invalidSelfArgument(zelf, Self.pythonTypeName)
    }

    return .unhashable(zelf)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__repr__")
    }

    if zelf.elements.isEmpty {
      return PyResult(py, interned: "set()")
    }

    if zelf.hasReprLock {
      return PyResult(py, interned: "set(...)")
    }

    return zelf.withReprLock {
      switch Self.abstractJoinElementsForRepr(py, zelf: zelf) {
      case let .value(elements):
        let result = "{" + elements + "}" // no 'set'!
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
  internal static func __contains__(_ py: Py,
                                    zelf: PyObject,
                                    object: PyObject) -> PyResult {
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

  // MARK: - Union

  internal static let unionDoc = """
    Return the union of sets as a new set.

    (i.e. all elements that are in either set.)
    """

  // sourcery: pymethod = union, doc = unionDoc
  internal static func union(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return self.abstractUnion(py, zelf: zelf, other: other)
  }

  // MARK: - Difference

  internal static let differenceDoc = """
    Return the difference of two or more sets as a new set.

    (i.e. all elements that are in this set but not the others.)
    """

  // sourcery: pymethod = difference, doc = differenceDoc
  internal static func difference(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return self.abstractDifference(py, zelf: zelf, other: other)
  }

  // MARK: - Symmetric difference

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

  // MARK: - Add

  internal static let addDoc = """
    Add an element to a set.

    This has no effect if the element is already present.
    """

  // sourcery: pymethod = add, doc = addDoc
  internal static func add(_ py: Py,
                           zelf _zelf: PyObject,
                           other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "add")
    }

    if let error = zelf.add(py, object: other) {
      return .error(error)
    }

    return .none(py)
  }

  internal func add(_ py: Py, object: PyObject) -> PyBaseException? {
    switch Self.createElement(py, object: object) {
    case let .value(element):
      switch self.elementsPtr.pointee.insert(py, element: element) {
      case .inserted,
           .updated:
        return nil
      case .error(let e):
        return e
      }

    case let .error(e):
      return e
    }
  }

  // MARK: - Update

  internal static let updateDoc = """
    Update a set with the union of itself and others.
    """

  // sourcery: pymethod = update, doc = updateDoc
  internal static func update(_ py: Py,
                              zelf _zelf: PyObject,
                              other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "update")
    }

    if let e = zelf.update(py, fromIterable: other) {
      return .error(e)
    }

    return .none(py)
  }

  internal func update(_ py: Py, fromIterable iterable: PyObject) -> PyBaseException? {
    switch Self.getElements(py, iterable: iterable) {
    case let .value(set):
      for element in set {
        switch self.elementsPtr.pointee.insert(py, element: element) {
        case .inserted,
             .updated:
          break
        case .error(let e):
          return e
        }
      }

    case let .error(e):
      return e
    }

    return nil
  }

  // MARK: - Remove

  internal static let removeDoc = """
    Remove an element from a set; it must be a member.

    If the element is not a member, raise a KeyError.
    """

  // sourcery: pymethod = remove, doc = removeDoc
  internal static func remove(_ py: Py,
                              zelf _zelf: PyObject,
                              object: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "remove")
    }

    switch Self.createElement(py, object: object) {
    case let .value(element):
      return self.remove(py, zelf: zelf, element: element)
    case let .error(e):
      return .error(e)
    }
  }

  private static func remove(_ py: Py, zelf: PySet, element: Element) -> PyResult {
    switch zelf.elementsPtr.pointee.remove(py, element: element) {
    case .ok:
      return .none(py)
    case .notFound:
      let e = py.newKeyError(key: element.object)
      return .error(e.asBaseException)
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
  internal static func discard(_ py: Py,
                               zelf _zelf: PyObject,
                               object: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "discard")
    }

    switch Self.createElement(py, object: object) {
    case let .value(element):
      switch zelf.elementsPtr.pointee.remove(py, element: element) {
      case .ok,
           .notFound:
        return .none(py)
      case .error(let e):
        return .error(e)
      }

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Clear

  internal static let clearDoc = """
    Remove all elements from this set.
    """

  // sourcery: pymethod = clear, doc = clearDoc
  internal static func clear(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "clear")
    }

    zelf.elementsPtr.pointee.clear()
    return .none(py)
  }

  // MARK: - Copy

  internal static let copyDoc = "Return a shallow copy of a set."

  // sourcery: pymethod = copy, doc = copyDoc
  internal static func copy(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "copy")
    }

    let result = py.newSet(elements: zelf.elements)
    return PyResult(result)
  }

  // MARK: - Pop

  internal static let popDoc = """
    Remove and return an arbitrary set element.
    Raises KeyError if the set is empty.
    """

  // sourcery: pymethod = pop, doc = popDoc
  internal static func pop(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "pop")
    }

    guard let lastElement = zelf.elements.last else {
      return .keyError(py, message: "pop from an empty set")
    }

    switch Self.remove(py, zelf: zelf, element: lastElement) {
    case .value:
      return PyResult(lastElement.object)
    case .error(let e):
      return .error(e)
    }
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
    let elements = OrderedSet()
    let isBuiltin = type === py.types.set

    let result: PySet = isBuiltin ?
      py.newSet(elements: elements) :
      py.memory.newSet(type: type, elements: elements)

    return PyResult(result)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf _zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__init__")
    }

    if let e = ArgumentParser.noKwargsOrError(py,
                                              fnName: Self.pythonTypeName,
                                              kwargs: kwargs) {
      return .error(e.asBaseException)
    }

    if let e = ArgumentParser.guaranteeArgsCountOrError(py,
                                                        fnName: Self.pythonTypeName,
                                                        args: args,
                                                        min: 0,
                                                        max: 1) {
      return .error(e.asBaseException)
    }

    if let iterable = args.first {
      if let e = zelf.update(py, fromIterable: iterable) {
        return .error(e)
      }
    }

    return .none(py)
  }
}

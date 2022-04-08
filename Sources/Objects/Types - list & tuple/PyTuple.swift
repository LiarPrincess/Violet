import BigInt
import VioletCore

// cSpell:ignore tupleobject

// In CPython:
// Objects -> tupleobject.c
// https://docs.python.org/3.7/c-api/tuple.html

// sourcery: pytype = tuple, isDefault, hasGC, isBaseType, isTupleSubclass
// sourcery: subclassInstancesHave__dict__
public struct PyTuple: PyObjectMixin, AbstractSequence {

  // sourcery: pytypedoc
  internal static let doc = """
    tuple() -> an empty tuple
    tuple(sequence) -> tuple initialized from sequence's items

    If the argument is a tuple, the return value is the same object.
    """

  // sourcery: storedProperty
  internal var elements: [PyObject] { self.elementsPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, elements: [PyObject]) {
    self.initializeBase(py, type: type)
    self.elementsPtr.initialize(to: elements)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyTuple(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "count", value: zelf.count, includeInDescription: true)
    result.append(name: "elements", value: zelf.elements, includeInDescription: true)
    return result
  }

  // MARK: - AbstractSequence

  internal static func newObject(_ py: Py, elements: [PyObject]) -> PyTuple {
    return py.newTuple(elements: elements)
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

    return Self.calculateHash(py, elements: zelf.elements)
  }

  internal static func calculateHash(_ py: Py, elements: [PyObject]) -> HashResult {
    var x: PyHash = 0x34_5678
    var multiplier = Hasher.multiplier

    for e in elements {
      switch py.hash(object: e) {
      case let .value(y):
        x = (x ^ y) &* multiplier
        multiplier &+= 82_520 + PyHash(2 * elements.count)
      case let .error(e):
        return .error(e)
      }
    }

    return .value(x &+ 97_531)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__repr__")
    }

    switch zelf.repr(py) {
    case let .empty(s),
         let .reprLock(s):
      return PyResult(py, interned: s)
    case let .value(s):
      return PyResult(py, s)
    case let .error(e):
      return .error(e)
    }
  }

  internal enum Repr {
    case empty(String)
    case reprLock(String)
    case value(String)
    case error(PyBaseException)
  }

  internal func repr(_ py: Py) -> Repr {
    if self.isEmpty {
      return .empty("()")
    }

    // While not mutable, it is still possible to end up with a cycle in a tuple
    // through an object that stores itself within a tuple (and thus infinitely
    // asks for the repr of itself).
    if self.hasReprLock {
      return .reprLock("(...)")
    }

    return self.withReprLock {
      let hasSingleElement = self.count == 1
      let suffix = hasSingleElement ? ",)" : ")"

      switch Self.abstractJoinElementsForRepr(py, zelf: self, prefix: "(", suffix: suffix) {
      case let .value(result):
        return .value(result)
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

  // MARK: - Contains, count, index of

  // sourcery: pymethod = __contains__
  internal static func __contains__(_ py: Py,
                                    zelf: PyObject,
                                    object: PyObject) -> PyResult {
    return Self.abstract__contains__(py, zelf: zelf, object: object)
  }

  // sourcery: pymethod = count
  internal static func count(_ py: Py,
                             zelf: PyObject,
                             object: PyObject) -> PyResult {
    return Self.abstractCount(py, zelf: zelf, object: object)
  }

  // Special overload for `index` static method
  internal static func index(_ py: Py,
                             zelf: PyObject,
                             object: PyObject) -> PyResult {
    return Self.index(py, zelf: zelf, object: object, start: nil, end: nil)
  }

  // sourcery: pymethod = index
  internal static func index(_ py: Py,
                             zelf: PyObject,
                             object: PyObject,
                             start: PyObject?,
                             end: PyObject?) -> PyResult {
    return Self.abstractIndex(py, zelf: zelf, object: object, start: start, end: end)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal static func __iter__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__iter__")
    }

    let result = py.newIterator(tuple: zelf)
    return PyResult(result)
  }

  // MARK: - Get item

  // sourcery: pymethod = __getitem__
  internal static func __getitem__(_ py: Py,
                                   zelf: PyObject,
                                   index: PyObject) -> PyResult {
    return Self.abstract__getitem__(py, zelf: zelf, index: index)
  }

  // MARK: - Add, mul

  // sourcery: pymethod = __add__
  internal static func __add__(_ py: Py,
                               zelf: PyObject,
                               other: PyObject) -> PyResult {
    return Self.abstract__add__(py, zelf: zelf, other: other, isTuple: true)
  }

  // sourcery: pymethod = __mul__
  internal static func __mul__(_ py: Py,
                               zelf: PyObject,
                               other: PyObject) -> PyResult {
    return Self.abstract__mul__(py, zelf: zelf, other: other, isTuple: true)
  }

  // sourcery: pymethod = __rmul__
  internal static func __rmul__(_ py: Py,
                                zelf: PyObject,
                                other: PyObject) -> PyResult {
    return Self.abstract__rmul__(py, zelf: zelf, other: other, isTuple: true)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
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

    let elements: [PyObject]
    switch args.count {
    case 0:
      elements = []
    case 1:
      let iterable = args[0]
      switch py.toArray(iterable: iterable) {
      case let .value(e): elements = e
      case let .error(e): return .error(e)
      }
    default:
      trap("We already checked max count = 1")
    }

    // If this is a builtin then try to re-use interned values
    let isBuiltin = type === py.types.tuple
    let result: PyTuple = isBuiltin ?
      py.newTuple(elements: elements) :
      py.memory.newTuple(type: type, elements: elements)

    return PyResult(result)
  }
}

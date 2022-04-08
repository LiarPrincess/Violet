import VioletCore

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html
// https://www.python.org/dev/peps/pep-0415/#proposal

// sourcery: pyerrortype = StopIteration, pybase = Exception, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyStopIteration: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let stopIterationDoc = "Signal the end from iterator.__next__()."

  // sourcery: storedProperty
  internal var value: PyObject {
    get { self.valuePtr.pointee }
    nonmutating set { self.valuePtr.pointee = newValue }
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(
    _ py: Py,
    type: PyType,
    value: PyObject,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyBaseException.defaultSuppressContext
  ) {
    let args = py.newTuple(elements: value)
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)

    self.valuePtr.initialize(to: value)
  }

  internal func initialize(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyBaseException.defaultSuppressContext
  ) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)

    let none = py.none.asObject
    self.valuePtr.initialize(to: none)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyStopIteration(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    PyBaseException.fillDebug(zelf: zelf.asBaseException, debug: &result)
    result.append(name: "value", value: zelf.value)
    return result
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // MARK: - Value

  // sourcery: pyproperty = value, setter
  internal static func value(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "value")
    }

    return PyResult(zelf.value)
  }

  internal static func value(_ py: Py,
                             zelf _zelf: PyObject,
                             value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "value")
    }

    zelf.value = value?.asObject ?? py.none.asObject
    return .none(py)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newStopIteration(type: type, args: argsTuple)
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

    if let first = args.first {
      zelf.value = first
    }

    let zelfAsObject = zelf.asObject
    return PyException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

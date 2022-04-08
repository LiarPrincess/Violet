import VioletCore

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html
// https://www.python.org/dev/peps/pep-0415/#proposal

// sourcery: pyerrortype = SystemExit, pybase = BaseException, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PySystemExit: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let systemExitDoc = "Request to exit from the interpreter."

  // sourcery: storedProperty
  internal var code: PyObject? {
    get { self.codePtr.pointee }
    nonmutating set { self.codePtr.pointee = newValue }
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(
    _ py: Py,
    type: PyType,
    code: PyObject?,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyBaseException.defaultSuppressContext
  ) {
    var argsElements = [PyObject]()
    if let code = code {
      argsElements.append(code)
    }

    let args = py.newTuple(elements: argsElements)
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)

    self.codePtr.initialize(to: code)
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

    self.codePtr.initialize(to: nil)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PySystemExit(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    PyBaseException.fillDebug(zelf: zelf.asBaseException, debug: &result)
    result.append(name: "code", value: zelf.code as Any)
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

  // MARK: - Code

  // sourcery: pyproperty = code, setter
  internal static func code(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "code")
    }

    return PyResult(py, zelf.code)
  }

  internal static func code(_ py: Py,
                            zelf _zelf: PyObject,
                            value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "code")
    }

    zelf.code = value
    return .none(py)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newSystemExit(type: type, args: argsTuple)
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

    switch args.count {
    case 0:
      zelf.code = nil
    case 1:
      zelf.code = args[0]
    default:
      let code = py.newTuple(elements: args)
      zelf.code = code.asObject
    }

    let zelfAsObject = zelf.asObject
    return PyBaseException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}

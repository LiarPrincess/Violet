import VioletCore

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html
// https://www.python.org/dev/peps/pep-0415/#proposal

// sourcery: pyerrortype = ImportError, pybase = Exception, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyImportError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let importErrorDoc =
    "Import can't find module, or can't find name in module."

  // sourcery: storedProperty
  internal var msg: PyObject? {
    get { self.msgPtr.pointee }
    nonmutating set { self.msgPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var moduleName: PyObject? {
    get { self.moduleNamePtr.pointee }
    nonmutating set { self.moduleNamePtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var modulePath: PyObject? {
    get { self.modulePathPtr.pointee }
    nonmutating set { self.modulePathPtr.pointee = newValue }
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(
    _ py: Py,
    type: PyType,
    msg: PyObject?,
    moduleName: PyObject?,
    modulePath: PyObject?,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyBaseException.defaultSuppressContext
  ) {
    // Only 'msg' goes to args
    var argsElements = [PyObject]()
    if let msg = msg {
      argsElements.append(msg)
    }

    let args = py.newTuple(elements: argsElements)
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)

    self.msgPtr.initialize(to: msg)
    self.moduleNamePtr.initialize(to: moduleName)
    self.modulePathPtr.initialize(to: modulePath)
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
    self.msgPtr.initialize(to: nil)
    self.moduleNamePtr.initialize(to: nil)
    self.modulePathPtr.initialize(to: nil)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyImportError(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    PyBaseException.fillDebug(zelf: zelf.asBaseException, debug: &result)
    result.append(name: "msg", value: zelf.msg as Any)
    result.append(name: "moduleName", value: zelf.moduleName as Any)
    result.append(name: "modulePath", value: zelf.modulePath as Any)
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

  // MARK: - String

  // sourcery: pymethod = __str__
  internal static func __str__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__str__")
    }

    // If we have 'msg' then use it.
    if let msgObject = zelf.msg,
       let msg = py.cast.asString(msgObject) {
      return PyResult(msg)
    }

    // Otherwise just use standard path.
    let zelfAsBase = zelf.asBaseException
    return PyBaseException.str(py, zelf: zelfAsBase)
  }

  // MARK: - Msg

  // sourcery: pyproperty = msg, setter
  internal static func msg(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "msg")
    }

    return PyResult(py, zelf.msg)
  }

  internal static func msg(_ py: Py,
                           zelf _zelf: PyObject,
                           value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "msg")
    }

    zelf.msg = value
    return .none(py)
  }

  // MARK: - Name

  // sourcery: pyproperty = name, setter
  internal static func name(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "name")
    }

    return PyResult(py, zelf.moduleName)
  }

  internal static func name(_ py: Py,
                            zelf _zelf: PyObject,
                            value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "name")
    }

    zelf.moduleName = value
    return .none(py)
  }

  // MARK: - Path

  // sourcery: pyproperty = path, setter
  internal static func path(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "path")
    }

    return PyResult(py, zelf.modulePath)
  }

  internal static func path(_ py: Py,
                            zelf _zelf: PyObject,
                            value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "path")
    }

    zelf.modulePath = value
    return .none(py)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newImportError(type: type, args: argsTuple)
    return PyResult(result)
  }

  // MARK: - Python init

  private static let initArguments = ArgumentParser.createOrTrap(
    arguments: ["name", "path"],
    format: "|$OO:ImportError"
  )

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf _zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__init__")
    }

    // Run 'super.pyInit' before our custom code, to avoid situation where
    // 'super.pyInit' errors but we already mutated entity.
    let zelfAsObject = zelf.asObject
    switch PyBaseException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs) {
    case .value:
      break
    case .error(let e):
      return .error(e)
    }

    if args.count == 1 {
      zelf.msg = args[0]
    }

    switch Self.initArguments.bind(py, args: [], kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      zelf.moduleName = binding.optional(at: 0)
      zelf.modulePath = binding.optional(at: 1)
    case let .error(e):
      return .error(e)
    }

    return .none(py)
  }
}

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

  // sourcery: includeInLayout
  internal var msg: PyObject? {
    get { self.msgPtr.pointee }
    nonmutating set { self.msgPtr.pointee = newValue }
  }

  // sourcery: includeInLayout
  internal var moduleName: PyObject? {
    get { self.moduleNamePtr.pointee }
    nonmutating set { self.moduleNamePtr.pointee = newValue }
  }

  // sourcery: includeInLayout
  internal var modulePath: PyObject? {
    get { self.modulePathPtr.pointee }
    nonmutating set { self.modulePathPtr.pointee = newValue }
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // swiftlint:disable:next function_parameter_count
  internal func initialize(_ py: Py,
                           type: PyType,
                           msg: PyObject?,
                           moduleName: PyObject?,
                           modulePath: PyObject?,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    // Only 'msg' goes to args
    var argsElements = [PyObject]()
    if let msg = msg {
      argsElements.append(msg)
    }

    let args = py.newTuple(elements: argsElements)
    self.errorHeader.initialize(py,
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

  // swiftlint:disable:next function_parameter_count
  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           moduleName: PyObject?,
                           modulePath: PyObject?,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.errorHeader.initialize(py,
                                type: type,
                                args: args,
                                traceback: traceback,
                                cause: cause,
                                context: context,
                                suppressContext: suppressContext)

    let msg = Self.getMsg(args: args.elements)
    self.msgPtr.initialize(to: msg)
    self.moduleNamePtr.initialize(to: moduleName)
    self.modulePathPtr.initialize(to: modulePath)
  }

  private static func getMsg(args: [PyObject]) -> PyObject? {
    return args.count == 1 ? args[0] : nil
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyImportError(ptr: ptr)
    return "PyImportError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    return PyResult(zelf.__dict__)
  }

  // MARK: - String

  // sourcery: pymethod = __str__
  internal static func __str__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__str__")
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
  internal static func msg(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "msg")
    }

    return PyResult(py, zelf.msg)
  }

  internal static func msg(_ py: Py,
                           zelf: PyObject,
                           value: PyObject?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "msg")
    }

    zelf.msg = value
    return .none(py)
  }

  // MARK: - Name

  // sourcery: pyproperty = name, setter
  internal static func name(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "name")
    }

    return PyResult(py, zelf.moduleName)
  }

  internal static func name(_ py: Py,
                            zelf: PyObject,
                            value: PyObject?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "name")
    }

    zelf.moduleName = value
    return .none(py)
  }

  // MARK: - Path

  // sourcery: pyproperty = path, setter
  internal static func path(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "path")
    }

    return PyResult(py, zelf.modulePath)
  }

  internal static func path(_ py: Py,
                            zelf: PyObject,
                            value: PyObject?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "path")
    }

    zelf.modulePath = value
    return .none(py)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newImportError(
      py,
      type: type,
      args: argsTuple,
      moduleName: nil,
      modulePath: nil,
      traceback: nil,
      cause: nil,
      context: nil,
      suppressContext: PyErrorHeader.defaultSuppressContext
    )

    return PyResult(result)
  }

  // MARK: - Python init

  private static let initArguments = ArgumentParser(
    arguments: ["name", "path"],
    format: "|$OO:ImportError"
  )

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    // Run 'super.pyInit' before our custom code, to avoid situation where
    // 'super.pyInit' errors but we already mutated entity.
    switch PyBaseException.__init__(py,
                                    zelf: zelf.asObject,
                                    args: args,
                                    kwargs: kwargs) {
    case .value:
      break
    case .error(let e):
      return .error(e)
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

    zelf.msg = Self.getMsg(args: args)
    return .none(py)
  }
}

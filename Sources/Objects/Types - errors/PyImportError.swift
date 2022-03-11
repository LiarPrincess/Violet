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
  internal var msg: PyObject? { self.msgPtr.pointee }
  // sourcery: includeInLayout
  internal var moduleName: PyObject? { self.moduleNamePtr.pointee }
  // sourcery: includeInLayout
  internal var modulePath: PyObject? { self.modulePathPtr.pointee }

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
                           args: PyTuple,
                           traceback: PyTraceback?,
                           cause: PyBaseException?,
                           context: PyBaseException?,
                           suppressContext: Bool) {
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

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyImportError(ptr: ptr)
    return "PyImportError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }
}

/* MARKER

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func getClass(importError: PyImportError) -> PyType {
    return importError.type
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal static func getDict(importError: PyImportError) -> PyDict {
    return importError.__dict__
  }

  // MARK: - String

  // sourcery: pymethod = __str__
  internal static func str(importError: PyImportError) -> PyResult<String> {
    // Why this is static? See comment in 'PyBaseException.str'.

    // If we have 'msg' then use it.
    let msgPyString = importError.msg.flatMap(PyCast.asString(_:))
    if let msg = msgPyString {
      return .value(msg.value)
    }

    // Otherwise just use standard path.
    return Self.str(baseException: importError)
  }

  // MARK: - Msg

  // sourcery: pyproperty = msg, setter
  internal func getMsg() -> PyObject? {
    return self.msg
  }

  internal func setMsg(_ value: PyObject?) -> PyResult<Void> {
    self.msg = value
    return .value()
  }

  // MARK: - Name

  // sourcery: pyproperty = name, setter
  internal func getName() -> PyObject? {
    return self.moduleName
  }

  internal func setName(_ value: PyObject?) -> PyResult<Void> {
    self.moduleName = value
    return .value()
  }

  // MARK: - Path

  // sourcery: pyproperty = path, setter
  internal func getPath() -> PyObject? {
    return self.modulePath
  }

  internal func setPath(_ value: PyObject?) -> PyResult<Void> {
    self.modulePath = value
    return .value()
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyImportErrorNew(type: PyType,
                                        args: [PyObject],
                                        kwargs: PyDict?) -> PyResult<PyImportError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyMemory.newImportError(type: type, args: argsTuple)
    return .value(result)
  }

  // MARK: - Python init

  private static let initArguments = ArgumentParser.createOrTrap(
    arguments: ["name", "path"],
    format: "|$OO:ImportError"
  )

  // sourcery: pymethod = __init__
  internal func pyImportErrorInit(args: [PyObject],
                                  kwargs: PyDict?) -> PyResult<PyNone> {
    // Run 'super.pyInit' before our custom code, to avoid situation where
    // 'super.pyInit' errors but we already mutated entity.
    switch self.pyExceptionInit(args: args, kwargs: kwargs) {
    case .value:
      break
    case .error(let e):
      return .error(e)
    }

    switch Self.initArguments.bind(args: [], kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      self.moduleName = binding.optional(at: 0)
      self.modulePath = binding.optional(at: 1)
    case let .error(e):
      return .error(e)
    }

    self.fillMsgFromArgs(args: args)
    return .value(Py.none)
  }
}

*/

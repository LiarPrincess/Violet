import VioletCore

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html
// https://www.python.org/dev/peps/pep-0415/#proposal

// sourcery: pyerrortype = ImportError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public class PyImportError: PyException {

  // sourcery: pytypedoc
  internal static let importErrorDoc =
    "Import can't find module, or can't find name in module."

  // MARK: - Properties

  private var msg: PyObject?
  private var moduleName: PyObject?
  private var modulePath: PyObject?

  // MARK: - Init

  /// Type to set in `init`.
  override internal class var pythonTypeToSetInInit: PyType {
    return Py.errorTypes.importError
  }

  internal convenience init(msg: String?,
                            moduleName: String?,
                            modulePath: String?,
                            traceback: PyTraceback? = nil,
                            cause: PyBaseException? = nil,
                            context: PyBaseException? = nil,
                            suppressContext: Bool = false) {
    // Only 'msg' goes to args
    var argsElements = [PyObject]()
    if let m = msg {
      argsElements.append(Py.newString(m))
    }

    let args = Py.newTuple(elements: argsElements)
    let type = Self.pythonTypeToSetInInit
    self.init(type: type,
              args: args,
              traceback: traceback,
              cause: cause,
              context: context,
              suppressContext: suppressContext)

    // 'self.msg' should be filled from args
    if msg != nil {
      assert(self.msg != nil)
    }

    self.moduleName = moduleName.map(Py.newString(_:))
    self.modulePath = modulePath.map(Py.newString(_:))
  }

  /// Important: You have to manually fill `moduleName` and `modulePath` later!
  override internal init(type: PyType,
                         args: PyTuple,
                         traceback: PyTraceback? = nil,
                         cause: PyBaseException? = nil,
                         context: PyBaseException? = nil,
                         suppressContext: Bool = false) {
    super.init(type: type,
               args: args,
               traceback: traceback,
               cause: cause,
               context: context,
               suppressContext: suppressContext)

    self.fillMsgFromArgs(args: args.elements)
  }

  private func fillMsgFromArgs(args: [PyObject]) {
    if args.count == 1 {
      self.msg = args[0]
    }
  }

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

  // sourcery: pyproperty = msg, setter = setMsg
  internal func getMsg() -> PyObject? {
    return self.msg
  }

  internal func setMsg(_ value: PyObject?) -> PyResult<Void> {
    self.msg = value
    return .value()
  }

  // MARK: - Name

  // sourcery: pyproperty = name, setter = setName
  internal func getName() -> PyObject? {
    return self.moduleName
  }

  internal func setName(_ value: PyObject?) -> PyResult<Void> {
    self.moduleName = value
    return .value()
  }

  // MARK: - Path

  // sourcery: pyproperty = path, setter = setPath
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

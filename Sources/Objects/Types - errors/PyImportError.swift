import VioletCore

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html
// https://www.python.org/dev/peps/pep-0415/#proposal

// sourcery: pyerrortype = ImportError, default, baseType, hasGC, baseExceptionSubclass
public class PyImportError: PyException {

  override internal class var doc: String {
    return "Import can't find module, or can't find name in module."
  }

  override public var description: String {
    return self.createDescription(typeName: "PyImportError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.importError
  }

  // MARK: - Properties

  private var msg: PyObject?
  private var moduleName: PyObject?
  private var modulePath: PyObject?

  // MARK: - Init

  internal convenience init(msg: String?,
                            moduleName: String?,
                            modulePath: String?,
                            traceback: PyTraceback? = nil,
                            cause: PyBaseException? = nil,
                            context: PyBaseException? = nil,
                            suppressContext: Bool = false,
                            type: PyType? = nil) {
    // Only 'msg' goes to args
    var argsElements = [PyObject]()
    if let m = msg {
      argsElements.append(Py.newString(m))
    }

    self.init(args: Py.newTuple(argsElements),
              traceback: traceback,
              cause: cause,
              context: context,
              suppressContext: suppressContext,
              type: type)

    // 'self.msg' should be filled from args
    if msg != nil {
      assert(self.msg != nil)
    }

    self.moduleName = moduleName.map(Py.newString(_:))
    self.modulePath = modulePath.map(Py.newString(_:))
  }

  /// Important: You have to manually fill `name` and `path` later!
  override internal init(args: PyTuple,
                         traceback: PyTraceback? = nil,
                         cause: PyBaseException? = nil,
                         context: PyBaseException? = nil,
                         suppressContext: Bool = false,
                         type: PyType? = nil) {
    super.init(args: args,
               traceback: traceback,
               cause: cause,
               context: context,
               suppressContext: suppressContext,
               type: type)

    self.fillMsgFromArgs(args: args.elements)
  }

  private func fillMsgFromArgs(args: [PyObject]) {
    if args.count == 1 {
      self.msg = args[0]
    }
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  override public func getClass() -> PyType {
    return self.type
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  override public func getDict() -> PyDict {
    return self.__dict__
  }

  // MARK: - String

  override public func str() -> PyResult<String> {
    return Self.str(importError: self)
  }

  // sourcery: pymethod = __str__
  internal static func str(importError zelf: PyImportError) -> PyResult<String> {
    // Why this is static? See comment in 'PyBaseException.str'.

    let msgPyString = zelf.msg.flatMap(PyCast.asString(_:))
    if let msg = msgPyString {
      return .value(msg.value)
    }

    return Self.str(baseException: zelf)
  }

  // MARK: - Msg

  // sourcery: pyproperty = msg, setter = setMsg
  public func getMsg() -> PyObject? {
    return self.msg
  }

  public func setMsg(_ value: PyObject?) -> PyResult<Void> {
    self.msg = value
    return .value()
  }

  // MARK: - Name

  // sourcery: pyproperty = name, setter = setName
  public func getName() -> PyObject? {
    return self.moduleName
  }

  public func setName(_ value: PyObject?) -> PyResult<Void> {
    self.moduleName = value
    return .value()
  }

  // MARK: - Path

  // sourcery: pyproperty = path, setter = setPath
  public func getPath() -> PyObject? {
    return self.modulePath
  }

  public func setPath(_ value: PyObject?) -> PyResult<Void> {
    self.modulePath = value
    return .value()
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal class func pyImportErrorNew(type: PyType,
                                       args: [PyObject],
                                       kwargs: PyDict?) -> PyResult<PyImportError> {
    let argsTuple = Py.newTuple(args)
    return .value(PyImportError(args: argsTuple, type: type))
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
    switch super.pyExceptionInit(args: args, kwargs: kwargs) {
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

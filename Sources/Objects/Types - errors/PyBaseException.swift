import Core

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html
// https://www.python.org/dev/peps/pep-0415/#proposal

// swiftlint:disable file_length

// sourcery: pyerrortype = BaseException, default, baseType, hasGC, baseExceptionSubclass
public class PyBaseException: PyObject {

  internal class var doc: String {
    return "Common base class for all exceptions"
  }

  internal var args: PyTuple
  internal var traceback: PyObject?
  internal var cause: PyObject?
  internal lazy var __dict__ = Py.newDict()

  /// Another exception during whose handling this exception was raised.
  internal var context: PyBaseException?
  internal var suppressContext: Bool

  override public var description: String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "PyBaseException(\(msg))"
  }

  // MARK: - Init

  internal convenience init(msg: String,
                            traceback: PyObject? = nil,
                            cause: PyObject? = nil,
                            exceptionContext: PyBaseException? = nil,
                            suppressExceptionContext: Bool = false) {
    self.init(args: Py.newTuple(Py.newString(msg)),
              traceback: traceback,
              cause: cause,
              exceptionContext: exceptionContext,
              suppressExceptionContext: suppressExceptionContext)
  }

  internal init(args: PyTuple,
                traceback: PyObject? = nil,
                cause: PyObject? = nil,
                exceptionContext: PyBaseException? = nil,
                suppressExceptionContext: Bool = false) {
    self.args = args
    self.traceback = traceback
    self.cause = cause
    self.context = exceptionContext
    self.suppressContext = suppressExceptionContext

    super.init()
    self.setType()
  }

  /// Override this function in every exception class!
  ///
  /// This is a terrible HACK!.
  /// Our goal is to set proper `type` in each PyObject and to do this we can:
  /// 1. Have 2 inits in each exception:
  ///    - convenience, so it can be used in 'normal' code
  ///    - with `type: PyType` arg, so it can be used in derieved classes to set type
  ///    But this is a lot of boilerplate.
  /// 2. Have `type` as a computed property.
  ///    This simplifies some stuff, but complicates other, for example
  ///    it is totally different than other types.
  ///    It also forces us to drop 'final' in 'PyObject.type'.
  /// 3. Use the same `init` in every exception and inject proper type to assign.
  ///
  /// We went with 3 using dynamic dyspatch.
  internal func setType() {
    self.setType(to: Py.errorTypes.baseException)
  }

  // MARK: - Msg

  /// Try to get message from first `self.args`.
  ///
  /// If it fails then...
  /// Well whatever.
  public var message: String? {
    guard let firstArg = self.args.elements.first else {
      return nil
    }

    // Even when we start with 'string', it may not be a message if we have other.
    guard self.args.elements.count == 1 else {
      return nil
    }

    guard let string = firstArg as? PyString else {
      return nil
    }

    return string.value
  }

  // MARK: - Subclass checks

  public var isAttributeError: Bool {
    return self is PyAttributeError
  }

  public var isStopIteration: Bool {
    return self is PyStopIteration
  }

  public var isIndexError: Bool {
    return self is PyIndexError
  }

  public var isTypeError: Bool {
    return self is PyTypeError
  }

  public var isKeyError: Bool {
    return self is PyKeyError
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  public func repr() -> PyResult<String> {
    let name = self.typeName
    let args = self.args

    switch args.getLength() {
    case 1:
      // BaseException('Elsa')
      let first = args.elements[0]
      return Py.repr(first).map { name + "(" + $0 + ")" }
    default:
      // BaseException('Elsa', 'Anna')
      let argsRepr = args.repr()
      return argsRepr.map { name + $0 }
    }
  }

  // sourcery: pymethod = __str__
  public func str() -> PyResult<String> {
    let args = self.args

    switch args.getLength() {
    case 0:
      return .value("")
    case 1:
      let first = args.elements[0]
      return Py.repr(first)
    default:
      return Py.repr(args)
    }
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  public func getDict() -> PyDict {
    return self.__dict__
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  public func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  public func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // sourcery: pymethod = __setattr__
  public func setAttribute(name: PyObject, value: PyObject?) -> PyResult<PyNone> {
    return AttributeHelper.setAttribute(on: self, name: name, to: value)
  }

  // sourcery: pymethod = __delattr__
  public func delAttribute(name: PyObject) -> PyResult<PyNone> {
    return AttributeHelper.delAttribute(on: self, name: name)
  }

  // MARK: - Args

  // sourcery: pyproperty = args, setter = setArgs
  public func getArgs() -> PyTuple {
    return self.args
  }

  public func setArgs(_ value: PyObject?) -> PyResult<()> {
    guard let value = value else {
      return .typeError("args may not be deleted")
    }

    if let tuple = value as? PyTuple {
      return self.setArgs(tuple)
    }

    switch Py.toArray(iterable: value) {
    case let .value(elements):
      return self.setArgs(Py.newTuple(elements))
    case let .error(e):
      return .error(e)
    }
  }

  public func setArgs(_ value: PyTuple) -> PyResult<()> {
    self.args = value
    return .value()
  }

  // MARK: - Traceback

  // sourcery: pyproperty = __traceback__, setter = setTraceback
  public func getTraceback() -> PyObject {
    return self.traceback ?? Py.none
  }

  public func setTraceback(_ value: PyObject?) -> PyResult<()> {
//    guard let value = value else {
//      return .typeError("__traceback__ may not be deleted")
//    }

    // TODO: This (but we need PyTraceback first)
//    else if (!(tb == Py_None || PyTraceBack_Check(tb))) {
//        PyErr_SetString(PyExc_TypeError, "__traceback__ must be a traceback or None");
//        return -1;
//    }

//    guard let tuple = value as? PyObject else {
//      return .typeError("__traceback__ must be a traceback")
//    }
//
//    self._traceback = tuple
    return .value()
  }

  // MARK: - Cause

  internal static let getCauseDoc = "exception cause"

  // sourcery: pyproperty = __cause__, setter = setCause, doc = getCauseDoc
  public func getCause() -> PyObject? {
    return self.cause
  }

  public func setCause(_ value: PyObject?) -> PyResult<()> {
    guard let value = value else {
      return .typeError("__cause__ may not be deleted")
    }

    if value is PyNone {
      self.delCause()
      return .value()
    }

    if let e = value as? PyBaseException {
      self.setCause(e)
      return .value()
    }

    let msg = "exception cause must be None or derive from BaseException"
    return .typeError(msg)
  }

  public func setCause(_ value: PyBaseException) {
    // https://www.python.org/dev/peps/pep-0415/#proposal
    self.suppressContext = true
    self.cause = value
  }

  public func delCause() {
    self.cause = nil
  }

  // MARK: - Context

  internal static let getContextDoc = "exception context"

  // sourcery: pyproperty = __context__, setter = setContext, doc = getContextDoc
  public func getContext() -> PyBaseException? {
    return self.context
  }

  public func setContext(_ value: PyObject?) -> PyResult<()> {
    guard let value = value else {
      return .typeError("__context__ may not be deleted")
    }

    if value is PyNone {
      self.delContext()
      return .value()
    }

    if let context = value as? PyBaseException {
      self.setContext(context)
      return .value()
    }

    let msg = "exception context must be None or derive from BaseException"
    return .typeError(msg)
  }

  public func setContext(_ value: PyBaseException) {
    self.avoidCycleInContexts(with: value)
    self.context = value
  }

  // When we want to set exception as 'context',
  // we have to check if this exception is already in exception stack.
  // Otherwise we would create cycle.
  private func avoidCycleInContexts(with other: PyBaseException) {
    var current = other

    // Traverse context down looking for 'self'.
    while let context = current.getContext() {
      if context === self {
        // Clear context
        // We can return, because when setting 'context' exception
        // we also ran 'avoidCycleInContext'.
        current.delContext()
        return
      }

      current = context
    }
  }

  public func delContext() {
    self.context = nil
  }

  // MARK: - Suppress context

  // sourcery: pyproperty = __suppress_context__, setter = setSuppressContext
  public func getSuppressContext() -> PyBool {
    return Py.newBool(self.suppressContext)
  }

  public func setSuppressContext(_ value: PyObject?) -> PyResult<()> {
    guard let value = value else {
      self.suppressContext = false
      return .value()
    }

    switch Py.isTrueBool(value) {
    case let .value(b):
      self.suppressContext = b
      return .value()
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = Py.newTuple(args)
    return .value(PyBaseException(args: argsTuple))
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal class func pyInit(zelf: PyBaseException,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyNone> {
    return PyBaseException.pyInitShared(zelf: zelf, args: args, kwargs: kwargs)
  }

  /// `pyInit` in all of the exception classes will call this shared method.
  internal static func pyInitShared(zelf: PyBaseException,
                                    args: [PyObject],
                                    kwargs: PyDict?) -> PyResult<PyNone> {
    // Copy args if needed
    let zelfArgs = zelf.args.elements
    let hasAssignedArgsIn__new__ = zelfArgs.count == args.count
        && zip(zelfArgs, args).allSatisfy { $0.0 === $0.1 }

    if !hasAssignedArgsIn__new__ {
      let argsTuple = Py.newTuple(args)
      switch zelf.setArgs(argsTuple) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    // Copy kwargs
    if let kwargs = kwargs {
      let zelfDict = zelf.__dict__
      switch zelfDict.update(from: kwargs.data) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    return .value(Py.none)
  }
}

import VioletCore

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html
// https://www.python.org/dev/peps/pep-0415/#proposal

// swiftlint:disable file_length

// sourcery: pyerrortype = BaseException, default, baseType, hasGC, baseExceptionSubclass
public class PyBaseException: PyObject {

  private static let suppressContextFlag = PyObject.Flags.custom0

  // sourcery: pytypedoc
  internal static let baseExceptionDoc = "Common base class for all exceptions"

  private var args: PyTuple
  private var traceback: PyTraceback?
  /// `raise from xxx`.
  private var cause: PyBaseException?
  /// Another exception during whose handling this exception was raised.
  private var context: PyBaseException?
  /// Should we use `self.cause` or `self.context`?
  ///
  /// If we have `cause` then probably `cause`, otherwise `context`.
  internal var suppressContext: Bool {
    get { self.flags.isSet(Self.suppressContextFlag) }
    set { self.flags.set(Self.suppressContextFlag, to: newValue) }
  }

  internal lazy var __dict__ = Py.newDict()

  override public var description: String {
    return self.createDescription(typeName: "PyBaseException")
  }

  internal func createDescription(typeName: String) -> String {
    let msg = self.message.map { "msg: \($0)" } ?? ""
    return "\(typeName)(\(msg))"
  }

  /// Type to set in `init`.
  /// Override this property in every exception class!
  ///
  /// This is a terrible HACK!.
  /// Our goal is to set proper `type` in each PyObject and to do this we can:
  /// 1. Have 2 inits in each exception:
  ///    - convenience, so it can be used in 'normal' code
  ///    - with `type: PyType` arg, so it can be used in derived classes to set type
  ///    But this is a lot of boilerplate.
  /// 2. Have `type` as a computed property.
  ///    This simplifies some stuff, but complicates other, for example
  ///    it is totally different than other types.
  ///    It also forces us to drop 'final' in 'PyObject.type'.
  /// 3. Use the same `init` in every exception and inject proper type to assign.
  ///
  /// We went with 3 using `class` property.
  internal class var pythonType: PyType {
    return Py.errorTypes.baseException
  }

  // MARK: - Init

  internal convenience init(msg: String,
                            traceback: PyTraceback? = nil,
                            cause: PyBaseException? = nil,
                            context: PyBaseException? = nil,
                            suppressContext: Bool = false,
                            type: PyType? = nil) {
    let args = Py.newTuple(Py.newString(msg))
    self.init(args: args,
              traceback: traceback,
              cause: cause,
              context: context,
              suppressContext: suppressContext,
              type: type)
  }

  internal init(args: PyTuple,
                traceback: PyTraceback? = nil,
                cause: PyBaseException? = nil,
                context: PyBaseException? = nil,
                suppressContext: Bool = false,
                type: PyType? = nil) {
    self.args = args
    self.traceback = traceback
    self.cause = cause
    self.context = context
    super.init(type: type ?? Self.pythonType)
    self.suppressContext = suppressContext
  }

  // MARK: - Msg

  /// Try to get message from first `self.args`.
  ///
  /// If it fails then…
  /// Well whatever.
  internal var message: String? {
    guard let firstArg = self.args.elements.first else {
      return nil
    }

    // Even when we start with 'string', it may not be a message if we have other.
    guard self.args.elements.count == 1 else {
      return nil
    }

    guard let string = PyCast.asString(firstArg) else {
      return nil
    }

    return string.value
  }

  // MARK: - Subclass checks

  public var isAttributeError: Bool {
    let type = Py.errorTypes.attributeError
    return self.isSubtype(of: type)
  }

  public var isStopIteration: Bool {
    let type = Py.errorTypes.stopIteration
    return self.isSubtype(of: type)
  }

  public var isIndexError: Bool {
    let type = Py.errorTypes.indexError
    return self.isSubtype(of: type)
  }

  public var isTypeError: Bool {
    let type = Py.errorTypes.typeError
    return self.isSubtype(of: type)
  }

  public var isKeyError: Bool {
    let type = Py.errorTypes.keyError
    return self.isSubtype(of: type)
  }

  public var isSystemExit: Bool {
    let type = Py.errorTypes.systemExit
    return self.isSubtype(of: type)
  }

  public var isKeyboardInterrupt: Bool {
    let type = Py.errorTypes.keyboardInterrupt
    return self.isSubtype(of: type)
  }

  private func isSubtype(of type: PyType) -> Bool {
    return self.type.isSubtype(of: type)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    let name = self.typeName
    let args = self.args

    switch args.getLength() {
    case 1:
      // BaseException('Elsa')
      let first = args.elements[0]
      switch Py.reprString(object: first) {
      case let .value(s): return .value(name + "(" + s + ")")
      case let .error(e): return .error(e)
      }
    default:
      // BaseException('Elsa', 'Anna')
      switch args.repr() {
      case let .value(s): return .value(name + s)
      case let .error(e): return .error(e)
      }
    }
  }

  internal func str() -> PyResult<String> {
    let result = Self.str(baseException: self)
    return result.flatMap(Py.strString(object:))
  }

  // sourcery: pymethod = __str__
  internal static func str(baseException zelf: PyBaseException) -> PyResult<PyObject> {
    // This is a special (and unusual) place where normally we would override
    // 'pymethod'. But we can't do that because Swift would always call the
    // overridden function (even if we did 'BaseClass.fn(childInstance)').
    // So, we have to introduce separate selectors for each override.

    let args = zelf.args

    switch args.getLength() {
    case 0:
      return .value(Py.emptyString)
    case 1:
      let first = args.elements[0]
      return Py.str(object: first).map { $0 as PyObject }
    default:
      return Py.str(object: args).map { $0 as PyObject }
    }
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal func getDict() -> PyDict {
    return self.__dict__
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // sourcery: pymethod = __setattr__
  internal func setAttribute(name: PyObject, value: PyObject?) -> PyResult<PyNone> {
    return AttributeHelper.setAttribute(on: self, name: name, to: value)
  }

  // sourcery: pymethod = __delattr__
  internal func delAttribute(name: PyObject) -> PyResult<PyNone> {
    return AttributeHelper.delAttribute(on: self, name: name)
  }

  // MARK: - Args

  // sourcery: pyproperty = args, setter = setArgs
  internal func getArgs() -> PyTuple {
    return self.args
  }

  internal func setArgs(_ value: PyObject?) -> PyResult<Void> {
    guard let value = value else {
      return .typeError("args may not be deleted")
    }

    if let tuple = PyCast.asTuple(value) {
      return self.setArgs(tuple)
    }

    switch Py.toArray(iterable: value) {
    case let .value(elements):
      return self.setArgs(Py.newTuple(elements: elements))
    case let .error(e):
      return .error(e)
    }
  }

  internal func setArgs(_ value: PyTuple) {
    self.args = value
  }

  // MARK: - Traceback

  // sourcery: pyproperty = __traceback__, setter = setTraceback
  internal func getTraceback() -> PyTraceback? {
    return self.traceback
  }

  internal func setTraceback(_ value: PyObject?) -> PyResult<Void> {
    guard let value = value else {
      return .typeError("__traceback__ may not be deleted")
    }

    if value.isNone {
      self.traceback = nil
      return .value()
    }

    if let tb = PyCast.asTraceback(value) {
      self.setTraceback(traceback: tb)
      return .value()
    }

    return .typeError("__traceback__ must be a traceback or None")
  }

  internal func setTraceback(traceback: PyTraceback) {
    self.traceback = traceback
  }

  // MARK: - With traceback

  internal static let withTracebackDoc = """
    Exception.with_traceback(tb) --
    set self.__traceback__ to tb and return self.
    """

  // sourcery: pymethod = with_traceback, doc = withTracebackDoc
  internal func withTraceback(traceback: PyObject) -> PyResult<PyBaseException> {
    let result = self.setTraceback(traceback)
    return result.map { _ in self }
  }

  // MARK: - Cause

  internal static let getCauseDoc = "exception cause"

  // sourcery: pyproperty = __cause__, setter = setCause, doc = getCauseDoc
  internal func getCause() -> PyBaseException? {
    return self.cause
  }

  internal func setCause(_ value: PyObject?) -> PyResult<Void> {
    guard let value = value else {
      return .typeError("__cause__ may not be deleted") // set to 'None' instead
    }

    if PyCast.isNone(value) {
      self.delCause()
      return .value()
    }

    if let e = PyCast.asBaseException(value) {
      self.setCause(e)
      return .value()
    }

    let msg = "exception cause must be None or derive from BaseException"
    return .typeError(msg)
  }

  internal func setCause(_ value: PyBaseException) {
    // https://www.python.org/dev/peps/pep-0415/#proposal
    self.suppressContext = true
    self.cause = value
  }

  internal func delCause() {
    self.cause = nil
  }

  // MARK: - Context

  internal static let getContextDoc = "exception context"

  // sourcery: pyproperty = __context__, setter = setContext, doc = getContextDoc
  internal func getContext() -> PyBaseException? {
    return self.context
  }

  internal func setContext(_ value: PyObject?) -> PyResult<Void> {
    guard let value = value else {
      return .typeError("__context__ may not be deleted") // use 'None'
    }

    if PyCast.isNone(value) {
      self.delContext()
      return .value()
    }

    if let context = PyCast.asBaseException(value) {
      self.setContext(context)
      return .value()
    }

    let msg = "exception context must be None or derive from BaseException"
    return .typeError(msg)
  }

  internal func setContext(_ value: PyBaseException) {
    // When we are just setting the '__context__' property we are allowed
    // to have cycles:
    //
    //  elsa = NotImplementedError('elsa')
    //  anna = NotImplementedError('anna')
    //
    //  elsa.__context__ = anna # Just setting the property, nothing fancy
    //  anna.__context__ = elsa
    //
    //  assert elsa.__context__ == anna
    //  assert anna.__context__ == elsa

    self.setContext(value, checkAndPossiblyBreakCycle: false)
  }

  /// What are those `cycles` and where can I (not) get one?
  ///
  /// So, when we want to set exception as `__context__`, it is possible
  /// that this exception is already in an exception stack.
  /// For example: `e1.__context__` is `e2` and we try to set
  /// `e2.__context__` to `e1`.
  ///
  /// Note that for just an ordinary assignment (`elsa.__context__ = anna`)
  /// cycles are allowed, so here we are just talking about `raise/except`.
  ///
  /// Run this:
  /// ``` py
  /// elsa = NotImplementedError('elsa')
  /// anna = NotImplementedError('anna')
  ///
  /// try:
  ///   try:
  ///     try:
  ///       raise elsa
  ///     except:
  ///       # this will set: anna.__context__ = elsa
  ///       raise anna
  ///   except:
  ///     # this will set: elsa.__context__ = anna
  ///     # but we can't do that because: anna.__context__ = elsa
  ///     # we have to clear: anna.__context__ = None
  ///     raise elsa
  /// except:
  ///   assert elsa.__context__ == anna
  ///   assert anna.__context__ == None # Yep, it is 'None'!
  /// ```
  ///
  /// Also, setting itself as a `__context__` should not work:
  ///
  /// ```py
  /// try:
  ///   try:
  ///     raise elsa
  ///   except:
  ///     raise elsa
  /// except:
  ///   assert elsa.__context__ == None
  /// ```
  internal func setContext(
    _ value: PyBaseException,
    checkAndPossiblyBreakCycle: Bool
  ) {
    if checkAndPossiblyBreakCycle {
      if value === self {
        // Setting itself as a '__context__' should not change existing context.
        // try:
        //   try:
        //     elsa.__context__ = anna # Change 'anna' -> 'elsa' to get infinite loop
        //     raise elsa
        //   except:
        //     # Normally this should set 'elsa.__context__ = elsa'
        //     # But it will not do this, because that would be a cycle.
        //     raise elsa
        // except:
        //   assert elsa.__context__ == anna # Context is still 'anna'
        return
      }

      self.avoidCycleInContexts(with: value)
    }

    self.context = value // quite boring, compared to all of the fanciness above
  }

  private func avoidCycleInContexts(with other: PyBaseException) {
    var current = other

    // Traverse contexts down/up (however you want to call it) looking for 'self'.
    while let context = current.getContext() {
      if context === self {
        // Clear context
        // We can return, because when setting 'context' exception
        // we also ran 'avoidCycleInContext'
        // (or the user tempered with context manually, so all bets are off).
        current.delContext()
        return
      }

      current = context
    }
  }

  internal func delContext() {
    self.context = nil
  }

  // MARK: - Suppress context

  // sourcery: pyproperty = __suppress_context__, setter = setSuppressContext
  internal func getSuppressContext() -> Bool {
    return self.suppressContext
  }

  internal func setSuppressContext(_ value: PyObject?) -> PyResult<Void> {
    guard let value = value else {
      self.suppressContext = false
      return .value()
    }

    switch Py.isTrueBool(object: value) {
    case let .value(b):
      self.suppressContext = b
      return .value()
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal class func pyBaseExceptionNew(
    type: PyType,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyBaseException(args: argsTuple, type: type))
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal func pyBaseExceptionInit(args: [PyObject],
                                    kwargs: PyDict?) -> PyResult<PyNone> {
    // Copy args if needed
    if !self.areArgsEqual(to: args) {
      let argsTuple = Py.newTuple(elements: args)
      self.setArgs(argsTuple)
    }

    // Copy kwargs
    if let kwargs = kwargs {
      switch self.__dict__.update(from: kwargs.elements, onKeyDuplicate: .continue) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    return .value(Py.none)
  }

  internal func areArgsEqual(to objects: [PyObject]) -> Bool {
    let selfArgs = self.args.elements
    return selfArgs.count == objects.count &&
      zip(selfArgs, objects).allSatisfy { $0.0 === $0.1 }
  }
}

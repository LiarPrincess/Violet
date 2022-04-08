import VioletCore

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html
// https://www.python.org/dev/peps/pep-0415/#proposal

// swiftlint:disable static_operator

public func === (lhs: PyBaseException, rhs: PyBaseException) -> Bool { lhs.ptr === rhs.ptr }
public func !== (lhs: PyBaseException, rhs: PyBaseException) -> Bool { lhs.ptr !== rhs.ptr }

// sourcery: pyerrortype = BaseException, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyBaseException: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let doc = "Common base class for all exceptions"

  // MARK: - Properties

  public static let defaultSuppressContext = false
  private static let suppressContextFlag = PyObject.Flags.custom0

  // sourcery: storedProperty
  internal var args: PyTuple {
    get { self.argsPtr.pointee }
    nonmutating set { self.argsPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var traceback: PyTraceback? {
    get { self.tracebackPtr.pointee }
    nonmutating set { self.tracebackPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  /// `raise from xxx`.
  internal var cause: PyBaseException? {
    get { self.causePtr.pointee }
    nonmutating set { self.causePtr.pointee = newValue }
  }

  // sourcery: storedProperty
  /// Another exception during whose handling this exception was raised.
  internal var context: PyBaseException? {
    get { self.contextPtr.pointee }
    nonmutating set { self.contextPtr.pointee = newValue }
  }

  /// Should we use `self.cause` or `self.context`?
  ///
  /// If we have `cause` then probably `cause`, otherwise `context`.
  internal var suppressContext: Bool {
    get {
      let object = PyObject(ptr: self.ptr)
      return object.flags.isSet(Self.suppressContextFlag)
    }
    nonmutating set {
      let object = PyObject(ptr: self.ptr)
      object.flags.set(Self.suppressContextFlag, value: newValue)
    }
  }

  // MARK: - Initialize/deinitialize

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
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
    self.initializeBase(py, type: type)

    self.argsPtr.initialize(to: args)
    self.tracebackPtr.initialize(to: traceback)
    self.causePtr.initialize(to: cause)
    self.contextPtr.initialize(to: context)
    self.suppressContext = suppressContext
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  // MARK: - Debug

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyBaseException(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    Self.fillDebug(zelf: zelf, debug: &result)
    return result
  }

  internal static func fillDebug(zelf: PyBaseException, debug: inout PyObject.DebugMirror) {
    debug.append(name: "args", value: zelf.args, includeInDescription: true)
    debug.append(name: "traceback", value: zelf.traceback as Any)
    debug.append(name: "cause", value: zelf.cause as Any)
    debug.append(name: "context", value: zelf.context as Any)
    debug.append(name: "suppressContext", value: zelf.suppressContext)
  }

  // MARK: - Message

  /// Try to get message from first `self.args`.
  ///
  /// If it fails then…
  /// Well whatever.
  internal func getMessage(_ py: Py) -> PyString? {
    guard let firstArg = self.args.elements.first else {
      return nil
    }

    // Even when we start with 'string', it may not be a message if we have other.
    guard self.args.elements.count == 1 else {
      return nil
    }

    guard let string = py.cast.asString(firstArg) else {
      return nil
    }

    return string
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__repr__")
    }

    let name = zelf.typeName
    let args = zelf.args

    if args.count == 1 {
      // BaseException('Elsa')
      let first = args.elements[0]
      switch py.reprString(first) {
      case let .value(s):
        let result = name + "(" + s + ")"
        return PyResult(py, result)
      case let .error(e):
        return .error(e)
      }
    }

    // BaseException('Elsa', 'Anna')
    switch args.repr(py) {
    case let .empty(s),
         let .reprLock(s),
         let .value(s):
      let result = name + s
      return PyResult(py, result)

    case let .error(e):
      return .error(e)
    }
  }

  // sourcery: pymethod = __str__
  internal static func __str__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__str__")
    }

    return Self.str(py, zelf: zelf)
  }

  internal static func str(_ py: Py, zelf: PyBaseException) -> PyResult {
    let args = zelf.args

    switch args.count {
    case 0:
      return PyResult(py.emptyString)
    case 1:
      let first = args.elements[0]
      let result = py.str(first)
      return PyResult(result)
    default:
      let result = py.str(args.asObject)
      return PyResult(result)
    }
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__dict__")
    }

    let result = zelf.getDict(py)
    return PyResult(result)
  }

  internal func getDict(_ py: Py) -> PyDict {
    let object = PyObject(ptr: self.ptr)

    guard let result = object.get__dict__(py) else {
      py.trapMissing__dict__(object: self)
    }

    return result
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
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

  // sourcery: pymethod = __setattr__
  internal static func __setattr__(_ py: Py,
                                   zelf _zelf: PyObject,
                                   name: PyObject,
                                   value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__setattr__")
    }

    return AttributeHelper.setAttribute(py, object: zelf.asObject, name: name, value: value)
  }

  // sourcery: pymethod = __delattr__
  internal static func __delattr__(_ py: Py,
                                   zelf _zelf: PyObject,
                                   name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__delattr__")
    }

    return AttributeHelper.delAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Args

  // sourcery: pyproperty = args, setter
  internal static func args(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "args")
    }

    let result = zelf.getArgs()
    return PyResult(result)
  }

  internal func getArgs() -> PyTuple {
    return self.args
  }

  internal static func args(_ py: Py,
                            zelf _zelf: PyObject,
                            value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "args")
    }

    if let error = zelf.setArgs(py, value: value) {
      return .error(error)
    }

    return .none(py)
  }

  internal func setArgs(_ py: Py, value: PyObject?) -> PyBaseException? {
    guard let value = value else {
      let error = py.newTypeError(message: "args may not be deleted")
      return error.asBaseException
    }

    if let tuple = py.cast.asTuple(value) {
      self.setArgs(tuple)
      return nil
    }

    switch py.newTuple(iterable: value) {
    case let .value(tuple):
      self.args = tuple
      return nil
    case let .error(e):
      return e
    }
  }

  internal func setArgs(_ value: PyTuple) {
    self.args = value
  }

  // MARK: - Traceback

  // sourcery: pyproperty = __traceback__, setter
  internal static func __traceback__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__traceback__")
    }

    let result = zelf.getTraceback()
    return PyResult(py, result)
  }

  internal func getTraceback() -> PyTraceback? {
    return self.traceback
  }

  internal static func __traceback__(_ py: Py,
                                     zelf _zelf: PyObject,
                                     value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__traceback__")
    }

    if let error = zelf.setTraceback(py, value: value) {
      return .error(error)
    }

    return .none(py)
  }

  private func setTraceback(_ py: Py, value: PyObject?) -> PyBaseException? {
    guard let value = value else {
      let error = py.newTypeError(message: "__traceback__ may not be deleted")
      return error.asBaseException
    }

    if py.cast.isNone(value) {
      self.traceback = nil
      return nil
    }

    if let traceback = py.cast.asTraceback(value) {
      self.setTraceback(traceback)
      return nil
    }

    let error = py.newTypeError(message: "__traceback__ must be a traceback or None")
    return error.asBaseException
  }

  internal func setTraceback(_ value: PyTraceback) {
    self.traceback = value
  }

  // MARK: - With traceback

  internal static let withTracebackDoc = """
    Exception.with_traceback(tb) --
    set zelf.__traceback__ to tb and return zelf.
    """

  // sourcery: pymethod = with_traceback, doc = withTracebackDoc
  internal static func with_traceback(_ py: Py,
                                      zelf _zelf: PyObject,
                                      traceback: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "with_traceback")
    }

    if let error = zelf.setTraceback(py, value: traceback) {
      return .error(error)
    }

    return PyResult(zelf)
  }

  // MARK: - Cause

  internal static let getCauseDoc = "exception cause"

  // sourcery: pyproperty = __cause__, setter, doc = getCauseDoc
  internal static func __cause__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__cause__")
    }

    return PyResult(py, zelf.cause)
  }

  internal func getCause() -> PyBaseException? {
    return self.cause
  }

  internal static func __cause__(_ py: Py,
                                 zelf _zelf: PyObject,
                                 value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__cause__")
    }

    guard let value = value else {
      // set to 'None' instead
      return .typeError(py, message: "__cause__ may not be deleted")
    }

    if py.cast.isNone(value) {
      zelf.delCause()
      return .none(py)
    }

    if let e = py.cast.asBaseException(value) {
      zelf.setCause(e)
      return .none(py)
    }

    let message = "exception cause must be None or derive from BaseException"
    return .typeError(py, message: message)
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

  // sourcery: pyproperty = __context__, setter, doc = getContextDoc
  internal static func __context__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__context__")
    }

    let result = zelf.getContext()
    return PyResult(py, result)
  }

  internal func getContext() -> PyBaseException? {
    return self.context
  }

  internal static func __context__(_ py: Py,
                                   zelf _zelf: PyObject,
                                   value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__context__")
    }

    guard let value = value else {
      return .typeError(py, message: "__context__ may not be deleted") // use 'None'
    }

    if py.cast.isNone(value) {
      zelf.delContext()
      return .none(py)
    }

    if let context = py.cast.asBaseException(value) {
      zelf.setContext(context)
      return .none(py)
    }

    let message = "exception context must be None or derive from BaseException"
    return .typeError(py, message: message)
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
  internal func setContext(_ value: PyBaseException, checkAndPossiblyBreakCycle: Bool) {
    if checkAndPossiblyBreakCycle {
      if value.ptr === self.ptr {
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

    // quite boring, compared to all of the fanciness above
    self.context = value
  }

  private func avoidCycleInContexts(with other: PyBaseException) {
    var current = other

    // Traverse contexts down/up (however you want to call it) looking for 'self'.
    while let context = current.context {
      if context.ptr === self.ptr {
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

  private func delContext() {
    self.context = nil
  }

  // MARK: - Suppress context

  // sourcery: pyproperty = __suppress_context__, setter
  internal static func __suppress_context__(_ py: Py,
                                            zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__suppress_context__")
    }

    let result = zelf.getSuppressContext()
    return PyResult(py, result)
  }

  internal func getSuppressContext() -> Bool {
    return self.suppressContext
  }

  internal static func __suppress_context__(_ py: Py,
                                            zelf _zelf: PyObject,
                                            value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__suppress_context__")
    }

    guard let value = value else {
      zelf.suppressContext = false
      return .none(py)
    }

    switch py.isTrueBool(object: value) {
    case let .value(b):
      zelf.suppressContext = b
      return .none(py)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newBaseException(type: type, args: argsTuple)
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

    // Copy args if needed
    if !zelf.areArgsEqual(to: args) {
      let argsTuple = py.newTuple(elements: args)
      zelf.setArgs(argsTuple)
    }

    // Copy kwargs
    if let kwargs = kwargs {
      let dict = py.get__dict__(error: zelf)
      if let e = dict.update(py, from: kwargs.elements, onKeyDuplicate: .continue) {
        return .error(e)
      }
    }

    return .none(py)
  }

  private func areArgsEqual(to objects: [PyObject]) -> Bool {
    let selfArgs = self.args.elements
    return selfArgs.count == objects.count &&
      zip(selfArgs, objects).allSatisfy { $0.0.ptr === $0.1.ptr }
  }
}

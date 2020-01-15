import Core

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html

// swiftlint:disable file_length

// sourcery: pyerrortype = BaseException, default, baseType, hasGC, baseExceptionSubclass
public class PyBaseException: PyObject {

  internal class var doc: String {
    return "Common base class for all exceptions"
  }

  internal var args: PyTuple
  internal var traceback: PyObject?
  internal var cause: PyObject?
  internal var attributes: Attributes

  /// Another exception during whose handling ex was raised.
  internal var exceptionContext: PyObject?
  internal var suppressExceptionContext: Bool

  // MARK: - Init

  convenience init(_ context: PyContext,
                   msg: String,
                   traceback: PyObject? = nil,
                   cause: PyObject? = nil,
                   exceptionContext: PyObject? = nil,
                   suppressExceptionContext: Bool = false) {
    let builtins = context.builtins
    let msgPy = builtins.newString(msg)
    let args = builtins.newTuple(msgPy)
    self.init(context,
              args: args,
              traceback: traceback,
              cause: cause,
              exceptionContext: exceptionContext,
              suppressExceptionContext: suppressExceptionContext)
  }

  internal init(_ context: PyContext,
                args: PyTuple,
                traceback: PyObject? = nil,
                cause: PyObject? = nil,
                exceptionContext: PyObject? = nil,
                suppressExceptionContext: Bool = false) {
    self.args = args
    self.traceback = traceback
    self.cause = cause
    self.attributes = Attributes()
    self.exceptionContext = exceptionContext
    self.suppressExceptionContext = suppressExceptionContext

    super.init()
    self.initType(from: context)
  }

  /// Override this function in every exception class!
  ///
  /// This is a terrible HACK!.
  /// Our goal is to set proper `type` in each PyObject and to do this we can:
  /// 1. Have 2 inits in each exception:
  ///    - convenience (similar to this one), so it can be used in 'normal' code
  ///    - with `type: PyType` arg, so it can be used in derieved classes to set type
  ///    But this is a lot of boilerplate.
  /// 2. Store `context` in each PyObject and have `type` as computed property.
  ///    This simplifies some stuff, but complicates other
  ///    (mostly by having different mental model than other VMs).
  /// 3. Use the same `init` in every exception and inject proper type to assign.
  ///
  /// We went with 3 using dynamic dyspatch.
  internal func initType(from context: PyContext) {
    self.setType(to: context.builtins.errorTypes.baseException)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    let name = self.typeName
    let args = self.args

    switch args.getLength() {
    case 1:
      let first = args.elements[0]
      return self.builtins.repr(first).map { name + "(" + $0 + ")" }
    default:
      let argsRepr = args.repr()
      return argsRepr.map { name + $0 }
    }
  }

  // sourcery: pymethod = __str__
  internal func str() -> PyResult<String> {
    let args = self.args

    switch args.getLength() {
    case 0:
      return .value("")
    case 1:
      let first = args.elements[0]
      return self.builtins.repr(first)
    default:
      return self.builtins.repr(args)
    }
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal func getDict() -> Attributes {
    return self.attributes
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
  internal func getArgs() -> PyObject {
    return self.args
  }

  internal func setArgs(_ value: PyObject?) -> PyResult<()> {
    guard let value = value else {
      return .typeError("args may not be deleted")
    }

    switch self.builtins.newTuple(iterable: value) {
    case let .value(tuple):
      self.args = tuple
      return .value()
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Traceback

  // sourcery: pyproperty = __traceback__, setter = setTraceback
  internal func getTraceback() -> PyObject {
    return self.traceback ?? self.builtins.none
  }

  internal func setTraceback(_ value: PyObject?) -> PyResult<()> {
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
  internal func getCause() -> PyObject {
    return self.cause ?? self.builtins.none
  }

  internal func setCause(_ value: PyObject?) -> PyResult<()> {
    guard let value = value else {
      return .typeError("__cause__ may not be deleted")
    }

    if value is PyNone {
      self.cause = nil
      return .value()
    }

    guard value.type.isException else {
      let msg = "exception cause must be None or derive from BaseException"
      return .typeError(msg)
    }

    self.cause = value
    return .value()
  }

  // MARK: - Context

  internal static let getContetDoc = "exception context"

  // sourcery: pyproperty = __context__, setter = setContext, doc = getContetDoc
  internal func getContext() -> PyObject {
    return self.exceptionContext ?? self.builtins.none
  }

  internal func setContext(_ value: PyObject?) -> PyResult<()> {
    guard let value = value else {
      return .typeError("__context__ may not be deleted")
    }

    if value is PyNone {
      self.exceptionContext = nil
      return .value()
    }

    guard value.type.isException else {
      let msg = "exception context must be None or derive from BaseException"
      return .typeError(msg)
    }

    self.exceptionContext = value
    return .value()
  }

  // MARK: - Suppress context

  // sourcery: pyproperty = __suppress_context__, setter = setSuppressContext
  internal func getSuppressContext() -> PyObject {
    return self.builtins.newBool(self.suppressExceptionContext)
  }

  internal func setSuppressContext(_ value: PyObject?) -> PyResult<()> {
    if let value = value {
      switch self.builtins.isTrueBool(value) {
      case let .value(v): self.suppressExceptionContext = v
      case let .error(e): return .error(e)
      }
    } else {
      self.suppressExceptionContext = false
    }

    return .value()
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDictData?) -> PyResult<PyObject> {
    let argsTuple = type.builtins.newTuple(args)
    return .value(PyBaseException(type.context, args: argsTuple))
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal class func pyInit(zelf: PyBaseException,
                             args: [PyObject],
                             kwargs: PyDictData?) -> PyResult<PyNone> {
    return PyBaseException.pyInitShared(zelf: zelf, args: args, kwargs: kwargs)
  }

  internal static func pyInitShared(zelf: PyBaseException,
                                    args: [PyObject],
                                    kwargs: PyDictData?) -> PyResult<PyNone> {
    if let e = ArgumentParser.noKwargsOrError(fnName: zelf.typeName,
                                              kwargs: kwargs) {
      return .error(e)
    }

    let zelfArgs = zelf.args.elements
    let argsAreEqual = zelfArgs.count == args.count
        && zip(zelfArgs, args).allSatisfy { $0.0 === $0.1 }

    if !argsAreEqual {
      let argsTuple = zelf.builtins.newTuple(args)
      switch zelf.setArgs(argsTuple) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    return .value(zelf.builtins.none)
  }
}

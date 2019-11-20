import Core

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html

// sourcery: pyerrortype = BaseException
internal class PyBaseException: PyObject, AttributesOwner {

  internal class var doc: String {
    return "Common base class for all exceptions"
  }

  internal var _args: PyTuple
  internal var _traceback: PyObject
  internal var _cause: PyObject?
  internal var _attributes: Attributes

  /// Another exception during whose handling ex was raised.
  internal var _exceptionContext: PyObject?
  internal var _suppressExceptionContext: Bool

  // MARK: - Init

  internal init(_ context: PyContext,
                args: PyTuple,
                traceback: PyObject,
                cause: PyObject?,
                exceptionContext: PyObject?,
                suppressExceptionContext: Bool) {
    self._args = args
    self._traceback = traceback
    self._cause = cause
    self._attributes = Attributes()
    self._exceptionContext = exceptionContext
    self._suppressExceptionContext = suppressExceptionContext

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
    let args = self._args

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
    let args = self._args

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
  internal func dict() -> Attributes {
    return self._attributes
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
    return self._args
  }

  internal func setArgs(_ value: PyObject?) -> PyResult<()> {
    //    guard let value = value else {
    //      return .typeError("args may not be deleted")
    //    }

    // TODO: seq = PySequence_Tuple(val);
    //    guard let tuple = value as? PyTuple else {
    //      return .typeError("__args__ must be a tuple")
    //    }
    //
    //    self._args = tuple
    return .value()
  }

  // MARK: - Traceback

  // sourcery: pyproperty = __traceback__, setter = setTraceback
  internal func getTraceback() -> PyObject {
    return self._traceback
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
    return self._cause ?? self.builtins.none
  }

  internal func setCause(_ value: PyObject?) -> PyResult<()> {
    guard let value = value else {
      return .typeError("__cause__ may not be deleted")
    }

    if value is PyNone {
      self._cause = nil
      return .value()
    }

    guard value.type.isException else {
      let msg = "exception cause must be None or derive from BaseException"
      return .typeError(msg)
    }

    self._cause = value
    return .value()
  }

  // MARK: - Context

  internal static let getContetDoc = "exception context"

  // sourcery: pyproperty = __context__, setter = setContext, doc = getContetDoc
  internal func getContext() -> PyObject {
    return self._exceptionContext ?? self.builtins.none
  }

  internal func setContext(_ value: PyObject?) -> PyResult<()> {
    guard let value = value else {
      return .typeError("__context__ may not be deleted")
    }

    if value is PyNone {
      self._exceptionContext = nil
      return .value()
    }

    guard value.type.isException else {
      let msg = "exception context must be None or derive from BaseException"
      return .typeError(msg)
    }

    self._exceptionContext = value
    return .value()
  }

  // MARK: - Suppress context

  // sourcery: pyproperty = __suppress_context__, setter = setSuppressContext
  internal func getSuppressContext() -> PyObject {
    return self.builtins.newBool(self._suppressExceptionContext)
  }

  internal func setSuppressContext(_ value: PyObject?) -> PyResult<()> {
    if let value = value {
      switch self.builtins.isTrueBool(value) {
      case let .value(v): self._suppressExceptionContext = v
      case let .error(e): return .error(e)
      }
    } else {
      self._suppressExceptionContext = false
    }

    return .value()
  }
}

import VioletCore

// cSpell:ignore ceval pythonrun

// In CPython:
// Python -> sysmodule.c
// Python -> pythonrun.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  // MARK: - Function

  internal static var excepthookDoc: String {
    return """
    excepthook(exctype, value, traceback) -> None

    Handle an exception by displaying it with a traceback on sys.stderr.
    """
  }

  /// sys.excepthook(type, value, traceback)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.excepthook).
  ///
  /// static PyObject *
  /// sys_excepthook(PyObject* self, PyObject* args)
  ///
  /// With parts of this inlined:
  /// void
  /// PyErr_Display(PyObject *exception, PyObject *value, PyObject *tb)
  public func excepthook(type: PyObject,
                         value: PyObject,
                         traceback: PyObject) -> PyResult<PyObject> {
    let fn = "sys.excepthook():"

    guard let error = PyCast.asBaseException(value) else {
      let t = value.typeName
      return .typeError("\(fn) Exception expected for value, \(t) found")
    }

    if error.getTraceback() == nil {
      if PyCast.isNone(traceback) {
        // nothing
      } else if let tb = PyCast.asTraceback(traceback) {
        error.setTraceback(traceback: tb)
      } else {
        let t = traceback.typeName
        return .typeError("\(fn) Traceback expected for traceback, \(t) found")
      }
    }

    switch self.getStderrOrNone() {
    case .none:
      // User does not want any printing
      return .value(Py.none)
    case .value(let file):
      // 'printRecursive' swallows any errors
      Py.printRecursive(error: error, file: file)
      return .value(Py.none)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Get

  public func getExcepthook() -> PyResult<PyObject> {
    return self.get(.excepthook)
  }
}

// MARK: - Call

extension Sys {

  public enum CallExcepthookResult {
    case value(PyObject)
    /// `sys.excepthook` is missing
    case missing(PyBaseException)
    /// `sys.excepthook` is not callable
    case notCallable(PyBaseException)
    case error(PyBaseException)
  }

  /// void
  /// PyErr_PrintEx(int set_sys_last_vars)
  public func callExcepthook(error: PyBaseException) -> CallExcepthookResult {
    // We removed all of the 'SystemExit' code.
    // This function will only call excepthook, nothing else.
    let hook: PyObject
    switch self.getExcepthook() {
    case let .value(h): hook = h
    case let .error(e): return .missing(e)
    }

    let type = error.type
    let traceback = error.getTraceback() ?? Py.none
    let args = [type, error, traceback]

    switch Py.call(callable: hook, args: args, kwargs: nil) {
    case let .value(o): return .value(o)
    case let .notCallable(e): return .notCallable(e)
    case let .error(e): return .error(e)
    }
  }
}

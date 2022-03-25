import VioletCore

// cSpell:ignore ceval pythonrun

// In CPython:
// Python -> sysmodule.c
// Python -> pythonrun.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  // MARK: - Displayhook

  internal static let displayhookDoc = """
    displayhook(object) -> None

    Print an object to sys.stdout and also save it in builtins._
    """

  /// sys.displayhook(value)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.displayhook).
  ///
  /// static PyObject *
  /// sys_displayhook(PyObject *self, PyObject *o)
  internal static func displayhook(_ py: Py, object: PyObject) -> PyResult {
    // Print value except if None.
    // Before, set '_' to None to avoid recursion.
    // After printing, also assign to '_'
    if py.cast.isNone(object) {
      return .none(py)
    }

    let builtins = py.builtinsModule
    let underscore = py.intern(string: "_")

    let none = py.none.asObject
    switch builtins.setAttribute(py, name: underscore, value: none) {
    case .value: break
    case .error(let e): return .error(e)
    }

    let stdout: PyObject
    switch py.sys.getStdout() {
    case let .value(s): stdout = s.asObject
    case let .error(e): return .error(e)
    }

    // We are using 'print', so '\n' will be added automatically.
    if let e = py.print(file: stdout, arg: object) {
      return .error(e)
    }

    switch builtins.setAttribute(py, name: underscore, value: object) {
    case .value: break
    case .error(let e): return .error(e)
    }

    return .none(py)
  }

  public func getDisplayhook() -> PyResult {
    return self.get(.displayhook)
  }

  public func callDisplayhook(object: PyObject) -> PyResult {
    switch self.getDisplayhook() {
    case let .value(hook):
      let callResult = self.py.call(callable: hook, arg: object)
      return callResult.asResult
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Excepthook

  internal static let excepthookDoc = """
    excepthook(exctype, value, traceback) -> None

    Handle an exception by displaying it with a traceback on sys.stderr.
    """

  /// sys.excepthook(type, value, traceback)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.excepthook).
  ///
  /// static PyObject *
  /// sys_excepthook(PyObject* self, PyObject* args)
  ///
  /// With parts of this inlined:
  /// void
  /// PyErr_Display(PyObject *exception, PyObject *value, PyObject *tb)
  internal static func excepthook(_ py: Py,
                                  type: PyObject,
                                  value: PyObject,
                                  traceback: PyObject) -> PyResult {
    guard let error = py.cast.asBaseException(value) else {
      let message = "sys.excepthook(): Exception expected for value, \(value.typeName) found"
      return .typeError(py, message: message)
    }

    if error.getTraceback() == nil {
      if py.cast.isNone(traceback) {
        // nothing
      } else if let tb = py.cast.asTraceback(traceback) {
        error.setTraceback(tb)
      } else {
        let t = traceback.typeName
        let message = "sys.excepthook(): Traceback expected for traceback, \(t) found"
        return .typeError(py, message: message)
      }
    }

    switch py.sys.getStderrOrNone() {
    case .none:
      // User does not want any printing
      return .none(py)
    case .value(let file):
      py.printRecursiveIgnoringErrors(file: file, error: error)
      return .none(py)
    case .error(let e):
      return .error(e)
    }
  }

  public func getExcepthook() -> PyResult {
    return self.get(.excepthook)
  }

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

    let argError = error.asObject
    let argType = error.type.asObject

    let argTraceback: PyObject
    if let traceback = error.getTraceback() {
      argTraceback = traceback.asObject
    } else {
      argTraceback = self.py.none.asObject
    }

    let args = [argType, argError, argTraceback]
    switch self.py.call(callable: hook, args: args, kwargs: nil) {
    case let .value(o): return .value(o)
    case let .notCallable(e): return .notCallable(e)
    case let .error(e): return .error(e)
    }
  }
}

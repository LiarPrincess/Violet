import Core

// In CPython:
// Python -> sysmodule.c
// Python -> pythonrun.c
// https://docs.python.org/3.7/library/sys.html

private enum GetStderrOrNoneResult {
  case none
  case file(PyTextFile)
  case error(PyBaseException)
}

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
    let fn = "sys.excepthook(): "

    guard let error = value as? PyBaseException else {
      let t = value.typeName
      return .typeError("\(fn) Exception expected for value, \(t) found")
    }

    if error.getTraceback() == nil {
      guard let tb = traceback as? PyTraceback else {
        let t = traceback.typeName
        return .typeError("\(fn) Traceback expected for traceback, \(t) found")
      }

      error.setTraceback(traceback: tb)
    }

    switch self.getStderrOrNone() {
    case .none:
      // User does not want any printing
      return .value(Py.none)
    case .file(let file):
      // 'printRecursive' swallows any errors
      Py.printRecursive(error: error, file: file)
      return .value(Py.none)
    case .error(let e):
      return .error(e)
    }
  }

  private func getStderrOrNone() -> GetStderrOrNoneResult {
    switch self.get(.stderr) {
    case .value(let object):
      if object.isNone {
        return .none
      }

      if let file = object as? PyTextFile {
        return .file(file)
      }

      let msg = self.createPropertyTypeError(.stderr,
                                             got: object,
                                             expectedType: "textFile")
      return .error(Py.newTypeError(msg: msg))

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Get

  public func getExcepthook() -> PyResult<PyObject> {
    return self.get(.excepthook)
  }
}

// MARK: - Call

public enum CallExcepthookResult {
  case value(PyObject)
  /// `sys.excepthook` is missing
  case missing(PyBaseException)
  /// `sys.excepthook` is not callable
  case notCallable(PyBaseException)
  case error(PyBaseException)
}

extension Sys {

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

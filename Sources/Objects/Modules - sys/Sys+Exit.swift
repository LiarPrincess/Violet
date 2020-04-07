import Core

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  internal var exitDoc: String {
    return """
    exit([status])

    Exit the interpreter by raising SystemExit(status).
    If the status is omitted or None, it defaults to zero (i.e., success).
    If the status is an integer, it will be used as the system exit status.
    If it is another kind of object, it will be printed and the system
    exit status will be one (i.e., failure).
    """
  }

  // sourcery: pymethod = exit, doc = exitDoc
  /// sys.exit([arg])
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.exit).
  public func exit(status: PyObject? = nil) -> PyResult<PyNone> {
    let e = Py.newSystemExit(status: status)
    return .error(e)
  }
}

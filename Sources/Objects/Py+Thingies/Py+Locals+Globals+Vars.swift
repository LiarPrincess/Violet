import Core

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension PyInstance {

  /// globals()
  /// See [this](https://docs.python.org/3/library/functions.html#globals)
  public func getGlobals() -> PyResult<PyDict> {
    guard let frame = Py.delegate.frame else {
      return .runtimeError("globals(): no current frame")
    }

    let dict = frame.globals
    return .value(dict)
  }

  /// locals()
  /// See [this](https://docs.python.org/3/library/functions.html#locals)
  public func getLocals() -> PyResult<PyDict> {
    guard let frame = Py.delegate.frame else {
      return .runtimeError("locals(): no current frame")
    }

    let dict = frame.locals
    return .value(dict)
  }
}

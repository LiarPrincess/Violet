import VioletCore

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  // MARK: - Get recursion limit

  internal static var getRecursionLimitDoc: String {
    return """
    getrecursionlimit()

    Return the current value of the recursion limit, the maximum depth
    of the Python interpreter stack.  This limit prevents infinite
    recursion from causing an overflow of the C stack and crashing Python.
    """
  }

  /// sys.getrecursionlimit()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getrecursionlimit).
  public func getRecursionLimit() -> PyInt {
    return self.recursionLimit
  }

  // MARK: - Set recursion limit

  internal static var setRecursionLimitDoc: String {
    return """
    setrecursionlimit(n)

    Set the maximum depth of the Python interpreter stack to n.  This
    limit prevents infinite recursion from causing an overflow of the C
    stack and crashing Python.  The highest possible limit is platform-
    dependent."
    """
  }

  /// sys.setrecursionlimit(limit)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.setrecursionlimit).
  ///
  /// static PyObject *
  /// sys_setrecursionlimit(PyObject *self, PyObject *args)
  public func setRecursionLimit(limit: PyObject) -> PyResult<PyNone> {
    guard let int = limit as? PyInt else {
      let t = limit.typeName
      return .typeError("recursion limit must be an int, not \(t)")
    }

    guard int.value >= 1 else {
      return .valueError("recursion limit must be greater or equal than 1")
    }

    self.recursionLimit = int
    return .value(Py.none)
  }

  // MARK: - Traceback

  /// sys.tracebacklimit
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.tracebacklimit).
  public func getTracebackLimit() -> PyResult<PyInt> {
    return self.getInt(.tracebacklimit)
  }
}

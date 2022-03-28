import BigInt
import VioletCore

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  // MARK: - Intern

  internal static let internDoc = """
    intern(string) -> string

    ``Intern'' the given string.  This enters the string in the (global)
    table of interned strings whose purpose is to speed up dictionary lookups.
    Return the string itself or the previously interned string object with the
    same value."
    """

  internal static func intern(_ py: Py, string: PyObject) -> PyResult {
    let result = py.sys.intern(string)
    return PyResult(result)
  }

  /// sys.intern(string)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.intern).
  public func intern(_ value: PyObject) -> PyResultGen<PyString> {
    guard let str = self.py.cast.asString(value) else {
      let message = "intern() argument 1 must be str, not \(value.typeName)"
      return .typeError(self.py, message: message)
    }

    let result = self.intern(str)
    return .value(result)
  }

  public func intern(_ value: PyString) -> PyString {
    return self.py.intern(string: value.value)
  }

  public func intern(_ value: String) -> PyString {
    return self.py.intern(string: value)
  }

  // MARK: - Exit

  internal static let exitDoc = """
    exit([status])

    Exit the interpreter by raising SystemExit(status).
    If the status is omitted or None, it defaults to zero (i.e., success).
    If the status is an integer, it will be used as the system exit status.
    If it is another kind of object, it will be printed and the system
    exit status will be one (i.e., failure).
    """

  internal static func exit(_ py: Py, status: PyObject?) -> PyResult {
    let error = py.sys.exit(status: status)
    return .error(error)
  }

  /// sys.exit([arg])
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.exit).
  public func exit(status: PyObject?) -> PyBaseException {
    let error = self.py.newSystemExit(code: status)
    return error.asBaseException
  }

  public func getExit() -> PyResult {
    return self.get(.exit)
  }

  // MARK: - Default encoding

  internal static let getDefaultEncodingDoc = """
    getdefaultencoding() -> string

    Return the current default string encoding used by the Unicode
    implementation.
    """

  internal static func getdefaultencoding(_ py: Py) -> PyResult {
    let result = py.sys.defaultEncodingString
    return PyResult(result)
  }

  // MARK: - Recursion limit

  internal static let getRecursionLimitDoc = """
    getrecursionlimit()

    Return the current value of the recursion limit, the maximum depth
    of the Python interpreter stack.  This limit prevents infinite
    recursion from causing an overflow of the C stack and crashing Python.
    """

  internal static func getrecursionlimit(_ py: Py) -> PyResult {
    let result = py.sys.recursionLimit
    return PyResult(result)
  }

  internal static let setRecursionLimitDoc = """
    setrecursionlimit(n)

    Set the maximum depth of the Python interpreter stack to n.  This
    limit prevents infinite recursion from causing an overflow of the C
    stack and crashing Python.  The highest possible limit is platform-
    dependent."
    """

  internal static func setrecursionlimit(_ py: Py, limit: PyObject) -> PyResult {
    if let error = py.sys.setRecursionLimit(limit) {
      return .error(error)
    }

    return .none(py)
  }

  /// sys.setrecursionlimit(limit)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.setrecursionlimit).
  ///
  /// static PyObject *
  /// sys_setrecursionlimit(PyObject *self, PyObject *args)
  public func setRecursionLimit(_ limit: PyObject) -> PyBaseException? {
    guard let int = self.py.cast.asInt(limit) else {
      let message = "recursion limit must be an int, not \(limit.typeName)"
      let error = self.py.newTypeError(message: message)
      return error.asBaseException
    }

    guard int.value >= 1 else {
      let message = "recursion limit must be greater or equal than 1"
      let error = self.py.newValueError(message: message)
      return error.asBaseException
    }

    self.recursionLimit = int
    return nil
  }

  // MARK: - Traceback limit

  internal static func tracebacklimit(_ py: Py) -> PyResult {
    let result = py.sys.getTracebackLimit()
    return PyResult(result)
  }

  /// sys.tracebacklimit
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.tracebacklimit).
  public func getTracebackLimit() -> PyResultGen<PyInt> {
    return self.getInt(.tracebacklimit)
  }

  // MARK: - Get frame

  internal static let getFrameDoc = """
    _getframe([depth]) -> frameobject

    Return a frame object from the call stack.  If optional integer depth is
    given, return the frame object that many calls below the top of the stack.
    If that is deeper than the call stack, ValueError is raised.  The default
    for depth is zero, returning the frame at the top of the call stack.

    This function should be used for internal and specialized
    purposes only."
    """

  internal static func _getframe(_ py: Py, depth: PyObject?) -> PyResult {
    let result = py.sys.getFrame(depth: depth)
    return PyResult(result)
  }

  /// sys._getframe([depth])
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys._getframe).
  internal func getFrame(depth: PyObject?) -> PyResultGen<PyFrame> {
    switch self.parseFrameDepth(object: depth) {
    case let .value(d): return self.getFrame(depth: d)
    case let .error(e): return .error(e)
    }
  }

  internal func getFrame(depth: BigInt) -> PyResultGen<PyFrame> {
    guard let initialFrame = self.py.delegate.getCurrentlyExecutedFrame(self.py) else {
      return .runtimeError(self.py, message: "_getFrame(): no current frame")
    }

    var depth = depth
    var frame: PyFrame? = initialFrame
    while let f = frame, depth > 0 {
      frame = f.parent
      depth -= 1
    }

    guard let result = frame else {
      return .valueError(self.py, message: "call stack is not deep enough")
    }

    return .value(result)
  }

  private func parseFrameDepth(object: PyObject?) -> PyResultGen<BigInt> {
    guard let object = object else {
      return .value(-1)
    }

    guard let depth = self.py.cast.asInt(object) else {
      let message = "an integer is required (got type \(object.typeName))"
      return .typeError(self.py, message: message)
    }

    return .value(depth.value)
  }
}

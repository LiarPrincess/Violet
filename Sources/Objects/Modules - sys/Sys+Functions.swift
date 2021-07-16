import BigInt
import VioletCore

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  // MARK: - Intern

  internal static var internDoc: String {
    return """
    intern(string) -> string

    ``Intern'' the given string.  This enters the string in the (global)
    table of interned strings whose purpose is to speed up dictionary lookups.
    Return the string itself or the previously interned string object with the
    same value."
    """
  }

  /// sys.intern(string)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.intern).
  public func intern(value: PyObject) -> PyResult<PyString> {
    guard let str = PyCast.asString(value) else {
      let t = value.typeName
      return .typeError("intern() argument 1 must be str, not \(t)")
    }

    let result = self.intern(value: str)
    return .value(result)
  }

  public func intern(value: PyString) -> PyString {
    return Py.intern(string: value.value)
  }

  public func intern(value: String) -> PyString {
    return Py.intern(string: value)
  }

  // MARK: - Displayhook

  internal static var displayhookDoc: String {
    return """
    displayhook(object) -> None

    Print an object to sys.stdout and also save it in builtins._
    """
  }

  public func getDisplayhook() -> PyResult<PyObject> {
    return self.get(.displayhook)
  }

  /// sys.displayhook(value)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.displayhook).
  ///
  /// static PyObject *
  /// sys_displayhook(PyObject *self, PyObject *o)
  public func displayhook(value: PyObject) -> PyResult<PyNone> {
    // Print value except if None
    // After printing, also assign to '_'
    // Before, set '_' to None to avoid recursion
    if PyCast.isNone(value) {
      return .value(Py.none)
    }

    let builtins = Py.builtinsModule
    let underscore = Py.intern(string: "_")

    switch builtins.setAttribute(name: underscore, value: Py.none) {
    case .value: break
    case .error(let e): return .error(e)
    }

    let stdout: PyTextFile
    switch self.getStdout() {
    case let .value(s): stdout = s
    case let .error(e): return .error(e)
    }

    // We are using 'print', so '\n' will be added automatically.
    switch Py.print(args: [value], file: stdout) {
    case .value: break
    case .error(let e): return .error(e)
    }

    switch builtins.setAttribute(name: underscore, value: value) {
    case .value: break
    case .error(let e): return .error(e)
    }

    return .value(Py.none)
  }

  public func callDisplayhook(value: PyObject) -> PyResult<PyObject> {
    switch self.getDisplayhook() {
    case let .value(hook):
      let callResult = Py.call(callable: hook, arg: value)
      return callResult.asResult
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Exit

  internal static var exitDoc: String {
    return """
    exit([status])

    Exit the interpreter by raising SystemExit(status).
    If the status is omitted or None, it defaults to zero (i.e., success).
    If the status is an integer, it will be used as the system exit status.
    If it is another kind of object, it will be printed and the system
    exit status will be one (i.e., failure).
    """
  }

  /// sys.exit([arg])
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.exit).
  public static func exit(status: PyObject? = nil) -> PyResult<PyNone> {
    let e = Py.newSystemExit(code: status)
    return .error(e)
  }

  public func getExit() -> PyResult<PyObject> {
    return self.get(.exit)
  }

  // MARK: - Get default encoding

  internal static var getDefaultEncodingDoc: String {
    return """
    getdefaultencoding() -> string

    Return the current default string encoding used by the Unicode
    implementation.
    """
  }

  /// sys.getdefaultencoding()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getdefaultencoding).
  public func getDefaultEncoding() -> PyObject {
    return Py.newString(self.defaultEncoding)
  }

  // MARK: - Get frame

  internal static var getFrameDoc: String {
    return """
    _getframe([depth]) -> frameobject

    Return a frame object from the call stack.  If optional integer depth is
    given, return the frame object that many calls below the top of the stack.
    If that is deeper than the call stack, ValueError is raised.  The default
    for depth is zero, returning the frame at the top of the call stack.

    This function should be used for internal and specialized
    purposes only."
    """
  }

  /// sys._getframe([depth])
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys._getframe).
  internal func _getFrame(depth depthObject: PyObject?) -> PyResult<PyFrame> {
    var depth: BigInt
    switch self.parseFrameDepth(object: depthObject) {
    case let .value(d): depth = d
    case let .error(e): return .error(e)
    }

    guard let initialFrame = Py.delegate.frame else {
      return .runtimeError("_getFrame(): no current frame")
    }

    var frame: PyFrame? = initialFrame
    while let f = frame, depth > 0 {
      frame = f.parent
      depth -= 1
    }

    guard let result = frame else {
      return .valueError("call stack is not deep enough")
    }

    return .value(result)
  }

  private func parseFrameDepth(object: PyObject?) -> PyResult<BigInt> {
    guard let object = object else {
      return .value(-1)
    }

    guard let depth = PyCast.asInt(object) else {
      return .typeError("an integer is required (got type \(object.typeName))")
    }

    return .value(depth.value)
  }
}

import Core

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
    guard let str = value as? PyString else {
      let t = value.typeName
      return .typeError("intern() argument 1 must be str, not \(t)")
    }

    let result = self.intern(value: str)
    return .value(result)
  }

  public func intern(value: PyString) -> PyString {
    return Py.intern(value.value)
  }

  public func intern(value: String) -> PyString {
    return Py.intern(value)
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
  public func exit(status: PyObject? = nil) -> PyResult<PyNone> {
    let e = Py.newSystemExit(status: status)
    return .error(e)
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
}

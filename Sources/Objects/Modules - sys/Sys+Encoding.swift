import Core

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  public var defaultEncoding: String {
    return "utf-8"
  }

  internal var getDefaultEncodingDoc: String {
    return """
    getdefaultencoding() -> string

    Return the current default string encoding used by the Unicode
    implementation.
    """
  }

  // sourcery: pymethod = getdefaultencoding, doc = getDefaultEncodingDoc
  /// sys.getdefaultencoding()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getdefaultencoding).
  internal func getDefaultEncoding() -> PyObject {
    if let value = self.get(key: .getdefaultencoding) {
      return value
    }

    let value = Py.newString(self.defaultEncoding)
    return value
  }
}

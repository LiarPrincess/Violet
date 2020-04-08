import Core

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  public var defaultEncoding: PyStringEncoding {
    return .utf8
  }

  internal static var getDefaultEncodingDoc: String {
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

    return Py.newString(self.defaultEncoding)
  }
}

import Core

// In CPython:
// Python -> sysmodule.c
// https://docs.python.org/3.7/library/sys.html

extension Sys {

  internal var internDoc: String {
    return """
    intern(string) -> string

    ``Intern'' the given string.  This enters the string in the (global)
    table of interned strings whose purpose is to speed up dictionary lookups.
    Return the string itself or the previously interned string object with the
    same value."
    """
  }

  // sourcery: pymethod = intern
  /// sys.intern(string)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.intern).
  internal func intern(value: PyObject) -> PyResult<PyString> {
    guard let str = value as? PyString else {
      let t = value.typeName
      return .typeError("intern() argument 1 must be str, not \(t)")
    }

    let result = Py.intern(str.value)
    return .value(result)
  }
}

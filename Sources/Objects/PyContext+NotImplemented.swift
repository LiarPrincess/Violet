public enum CompareMode {
  case equal
  case notEqual
  case less
  case lessEqual
  case greater
  case greaterEqual
}

extension PyContext {
  public var unicode: PyUnicodeType { return PyUnicodeType() }

  public func pyObject_IsTrue(_ value: PyObject) -> Bool {
    return false
  }

  public func cmp_outcome(mode: CompareMode,
                          left:  PyObject,
                          right: PyObject) -> PyObject {
    // remember to fix enum in caller
    return left
  }

  internal func hash(value: PyObject) throws -> PyHash {
    return 0
  }

  public func PyObject_RichCompareBool(left:  PyObject,
                                       right: PyObject,
                                       mode:  CompareMode) -> Bool {
    return false
  }

  public func PyObject_RichCompare(left:  PyObject,
                                   right: PyObject,
                                   mode:  CompareMode) -> PyObject {
    return left
  }

  internal func _PyType_Name(value: PyType) -> String {
    return ""
  }

  internal func PyType_IsSubtype(parent: PyType, subtype: PyType) -> Bool {
    return false
  }

  internal func PyUnicode_FromFormat(format: String, args: Any...) -> String {
    return ""
  }

  public func Py_CLEAR(value: PyObject) throws { }

  public func PyObject_Repr(value: PyObject) throws -> String {
    return ""
  }

  public func PyObject_Str(value: PyObject) throws -> String {
    return ""
  }

  public func pySlice_New(start: PyObject, stop: PyObject, step: PyObject?) -> PyObject {
    return start
  }
}

public final class PyUnicodeType {

  internal init() { }

  public func checkExact(_ value: PyObject) -> Bool {
    return false
  }

  public func check(_ value: PyObject) -> Bool {
    return false
  }

  public func format(dividend: PyObject, divisor: PyObject) -> PyObject {
    return dividend
  }

  public func extract(value: PyObject) -> String? {
    return ""
  }

  public func unicode_concatenate(left: PyObject, right: PyObject) -> PyObject {
    return left
  }
}

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

  public func PyObject_RichCompareBool(left:  PyObject,
                                       right: PyObject,
                                       mode:  CompareMode) -> Bool {
    return false
  }

  public func repr(value: PyObject) throws -> String {
    return ""
  }

  public func pySlice_New(start: PyObject, stop: PyObject, step: PyObject?) -> PyObject {
    return start
  }
}

public final class PyUnicodeType {

  fileprivate init() { }

  public func checkExact(_ value: PyObject) -> Bool {
    return false
  }

  public func check(_ value: PyObject) -> Bool {
    return false
  }

  public func format(dividend: PyObject, divisor: PyObject) -> PyObject {
    return dividend
  }

  public func unicode_concatenate(left: PyObject, right: PyObject) -> PyObject {
    return left
  }
}

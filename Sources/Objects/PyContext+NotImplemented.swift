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

  public func isTrue(_ value: PyObject) -> Bool {
    return false
  }

  public func cmp_outcome(mode: CompareMode,
                          left:  PyObject,
                          right: PyObject) -> PyObject {
    // remember to fix enum in caller
    return left
  }

  public func repr(value: PyObject) throws -> String {
    return ""
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

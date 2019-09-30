public enum CompareMode {
  case equal
  case notEqual
  case less
  case lessEqual
  case greater
  case greaterEqual
}

extension PyContext {

  /// Test a value used as condition, e.g., in a for or if statement.
  public func isTrue(value: PyObject) throws -> Bool {
    // PyObject_IsTrue(PyObject *v)

    if let bool = value as? PyBool {
      return bool.value.isTrue
    }

    if let boolType = value as? PyBoolConvertibleTypeClass {
      let result = try boolType.bool(value: value)
      return result.value.isTrue
    }

    if let subscriptType = value as? SubscriptLengthTypeClass {
      let length = try subscriptType.subscriptLength(value: value)
      return length.value.isTrue
    }

    if let lengthType = value as? LengthTypeClass {
      let length = try lengthType.length(value: value)
      return length.value.isTrue
    }

    return true
  }

  // MARK: - TODO

  public var unicode: PyUnicodeType { return PyUnicodeType() }

  public func cmp_outcome(mode: CompareMode,
                          left:  PyObject,
                          right: PyObject) -> PyObject {
    // remember to fix enum in caller
    return left
  }

  internal func hash(value: PyObject) throws -> PyHash {
    return 0
  }

  internal func _PyType_Name(value: PyType) -> String {
    return value.name
  }

  internal func PyType_IsSubtype(parent: PyType, subtype: PyType) -> Bool {
    return false
  }

  internal func PyUnicode_FromFormat(format: String, args: Any...) -> String {
    return ""
  }

  public func Py_CLEAR(value: PyObject) throws { }

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

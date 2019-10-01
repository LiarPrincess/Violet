extension PyContext {

  public func not(value: PyObject) throws -> PyObject {
    return self.unimplemented()
  }

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

  /// `is` will return `True` if two variables point to the same object.
  public func `is`(left: PyObject, right: PyObject) -> PyObject {
    return self.types.bool.new(left === right)
  }
}

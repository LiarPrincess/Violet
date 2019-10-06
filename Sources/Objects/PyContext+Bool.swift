extension PyContext {

  /// int PyObject_Not(PyObject *v)
  ///
  /// Equivalent of 'not v'.
  public func not(value: PyObject) throws -> PyObject {
    let isTrue = try self.isTrue(value: value)
    return self.types.bool.new(!isTrue)
  }

  /// PyObject_IsTrue(PyObject *v)
  ///
  /// Test a value used as condition, e.g., in a for or if statement.
  public func isTrue(value: PyObject) throws -> Bool {
    if let bool = value as? PyBool {
      return bool.value.isTrue
    }

    if let boolType = value as? PyBoolConvertibleTypeClass {
      let result = try boolType.asBool()
      return result.value.isTrue
    }

    if let lengthType = value as? LengthTypeClass {
      let length = try lengthType.getLength()
      return length.value.isTrue
    }

    return true
  }

  /// `is` will return `True` if two variables point to the same object.
  public func `is`(left: PyObject, right: PyObject) -> PyObject {
    return self.types.bool.new(left === right)
  }
}

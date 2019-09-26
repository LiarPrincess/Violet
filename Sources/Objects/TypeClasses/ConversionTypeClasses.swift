internal protocol PyBoolConvertibleTypeClass: TypeClass {
  func bool(value: PyObject) throws -> PyBool
}

internal protocol PyIntConvertibleTypeClass: TypeClass {
  /// Returns the o converted to an integer object on success.
  /// This is the equivalent of the Python expression int(o).
  func int(value: PyObject) throws -> PyInt
}

internal protocol PyFloatConvertibleTypeClass: TypeClass {
  /// Returns the o converted to a float object on success.
  /// This is the equivalent of the Python expression float(o).
  func float(value: PyObject) throws -> PyFloat
}

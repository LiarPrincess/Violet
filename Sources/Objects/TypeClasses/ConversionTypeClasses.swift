internal protocol PyBoolConvertibleTypeClass: TypeClass {
  func asBool() throws -> PyBool
}

internal protocol PyIntConvertibleTypeClass: TypeClass {
  /// Returns the o converted to an integer object on success.
  /// This is the equivalent of the Python expression int(o).
  func asInt() throws -> PyInt
}

internal protocol PyFloatConvertibleTypeClass: TypeClass {
  /// Returns the o converted to a float object on success.
  /// This is the equivalent of the Python expression float(o).
  func asFloat() throws -> PyFloat
}

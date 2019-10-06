internal protocol BoolConvertibleTypeClass: TypeClass {
  var asBool: PyBool { get }
}

internal protocol IntConvertibleTypeClass: TypeClass {
  /// Returns the o converted to an integer object on success.
  /// This is the equivalent of the Python expression int(o).
  var asInt: PyInt { get }
}

internal protocol FloatConvertibleTypeClass: TypeClass {
  /// Returns the o converted to a float object on success.
  /// This is the equivalent of the Python expression float(o).
  var asFloat: PyFloat { get }
}

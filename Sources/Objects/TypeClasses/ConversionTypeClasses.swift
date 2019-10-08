internal protocol BoolConvertibleTypeClass: TypeClass {
  var asBool: PyResult<Bool> { get }
}

internal protocol IntConvertibleTypeClass: TypeClass {
  /// Returns the o converted to an integer object on success.
  /// This is the equivalent of the Python expression int(o).
  var asInt: PyResult<PyInt> { get }
}

internal protocol FloatConvertibleTypeClass: TypeClass {
  /// Returns the o converted to a float object on success.
  /// This is the equivalent of the Python expression float(o).
  var asFloat: PyResult<PyFloat> { get }
}

internal protocol ComplexConvertibleTypeClass: TypeClass {
  /// Returns the o converted to a complex object on success.
  /// This is the equivalent of the Python expression complex(o).
  var asComplex: PyResult<PyComplex> { get }
}

internal protocol IndexConvertibleTypeClass: TypeClass {
  /// Returns the o converted to a Python int on success
  /// or TypeError exception raised on failure.
  var asIndex: PyInt { get }
}

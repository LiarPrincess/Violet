internal protocol PyBoolConvertibleTypeClass: TypeClass {
  func bool(value: PyObject) throws -> PyBool
}

internal protocol PyIntConvertibleTypeClass: TypeClass {
  func int(value: PyObject) throws -> PyInt
}

internal protocol PyFloatConvertibleTypeClass: TypeClass {
  func float(value: PyObject) throws -> PyFloat
}

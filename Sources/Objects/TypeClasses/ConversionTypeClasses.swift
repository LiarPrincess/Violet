import Core

internal protocol BoolConvertibleTypeClass: TypeClass {
  // sourcery: pymethod = __bool__
  func asBool() -> PyResult<Bool>
}

internal protocol IntConvertibleTypeClass: TypeClass {
  // sourcery: pymethod = __int__
  func asInt() -> PyResult<PyInt>
}

internal protocol FloatConvertibleTypeClass: TypeClass {
  // sourcery: pymethod = __float__
  func asFloat() -> PyResult<PyFloat>
}

internal protocol ComplexConvertibleTypeClass: TypeClass {
  // sourcery: pymethod = __complex__
  func asComplex() -> PyResult<PyComplex>
}

internal protocol RealConvertibleTypeClass: TypeClass {
  // sourcery: pymethod = real
  func asReal() -> PyObject
}

internal protocol ImagConvertibleTypeClass: TypeClass {
  // sourcery: pymethod = imag
  func asImag() -> PyObject
}

internal protocol IndexConvertibleTypeClass: TypeClass {
  // sourcery: pymethod = __index__
  func asIndex() -> BigInt
}

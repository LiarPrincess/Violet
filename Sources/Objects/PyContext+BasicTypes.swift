import Core

extension PyContext {

  public func int(value: BigInt) -> PyObject {
//    return self.types.int.new(value)
    return self.unimplemented()
  }

  public func float(value: Double) -> PyObject {
//    return self.types.float.new(value)
    return self.unimplemented()
  }

  public func complex(real: Double, imag: Double) -> PyObject {
//    return self.types.complex.new(real: real, imag: imag)
    return self.unimplemented()
  }

  public func string(value: String) -> PyObject {
//    return self.types.string.new(value)
    return self.unimplemented()
  }
}

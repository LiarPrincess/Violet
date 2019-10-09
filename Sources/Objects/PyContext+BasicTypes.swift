import Core

extension PyContext {

  // MARK: - Int

  public func int(_ value: Int) -> PyObject {
    return self.types.int.new(value)
  }

  public func int(_ value: BigInt) -> PyObject {
    return self.types.int.new(value)
  }

  // MARK: - Float

  public func float(_ value: Double) -> PyObject {
    return self.types.float.new(value)
  }

  // MARK: - Complex

  public func complex(real: Double, imag: Double) -> PyObject {
    return self.types.complex.new(real: real, imag: imag)
  }

  // MARK: - String

  public func string(_ value: String) -> PyObject {
    return self.types.string.new(value)
  }
}

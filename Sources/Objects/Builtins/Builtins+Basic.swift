import Core

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// TODO: Cache <-10, 255> values

extension Builtins {

  // MARK: - Int

  public func newInt(_ value: Int) -> PyInt {
    return PyInt(self.context, value: BigInt(value))
  }

  public func newInt(_ value: BigInt) -> PyInt {
    return PyInt(self.context, value: value)
  }

  // MARK: - Bool

  public func newBool(_ value: Bool) -> PyBool {
    return value ? self.true : self.false
  }

  public func newBool(_ value: BigInt) -> PyBool {
    return self.newBool(value.isTrue)
  }

  // MARK: - Float

  public func newFloat(_ value: Double) -> PyFloat {
    return PyFloat(self.context, value: value)
  }

  // MARK: - Complex

  public func newComplex(real: Double, imag: Double) -> PyComplex {
    return PyComplex(self.context, real: real, imag: imag)
  }

  // MARK: - String

  public func newString(_ value: String) -> PyString {
    return PyString(self.context, value: value)
  }
}

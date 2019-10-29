import Core

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Builtins {

  // MARK: - Int

  public func newInt(_ value: Int) -> PyInt {
    return PyInt(self.context, value: BigInt(value))
  }

  public func newInt(_ value: BigInt) -> PyInt {
    if let cached = self.cachedInts[value] {
      return cached
    }
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

  // MARK: - Module

  public func newModule(name: String, doc: String? = nil) -> PyModule {
    let n = self.newString(name)
    let d = doc.map(self.newString)
    return self.newModule(name: n, doc: d)
  }

  public func newModule(name: PyObject, doc: PyObject? = nil) -> PyModule {
    return PyModule(self.context, name: name, doc: doc)
  }
}

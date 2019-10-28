import Core

extension PyContext {

  // MARK: - Int

  public func int(_ value: Int) -> PyObject {
    return self._int(value)
  }

  internal func _int(_ value: Int) -> PyInt {
    return PyInt(self, value: BigInt(value))
  }

  public func int(_ value: BigInt) -> PyObject {
    return self._int(value)
  }

  internal func _int(_ value: BigInt) -> PyInt {
    return PyInt(self, value: value)
  }

  // MARK: - Float

  public func float(_ value: Double) -> PyObject {
    return self._float(value)
  }

  internal func _float(_ value: Double) -> PyFloat {
    return PyFloat(self, value: value)
  }

  // MARK: - Complex

  public func complex(real: Double, imag: Double) -> PyObject {
    return self._complex(real: real, imag: imag)
  }

  internal func _complex(real: Double, imag: Double) -> PyComplex {
    return PyComplex(self, real: real, imag: imag)
  }

  // MARK: - String

  public func string(_ value: String) -> PyObject {
    return self._string(value)
  }

  internal func _string(_ value: String) -> PyString {
    return PyString(self, value: value)
  }

  // MARK: - Bool

  public func not(value: PyObject) -> Bool {
    return false
  }

  public func isTrue(value: PyObject) -> Bool {
    return true
  }

  public func `is`(left: PyObject, right: PyObject) -> Bool {
    return false
  }
}

import Core

extension Builtins {

  // sourcery: pymethod: bin
  /// bin(x)
  /// See [this](https://docs.python.org/3/library/functions.html#bin)
  public func bin(_ object: PyObject) -> PyResult<PyObject> {
    return self.toNumberString(object, radix: 2, prefix: "0b")
  }

  // sourcery: pymethod: oct
  /// oct(x)
  /// See [this](https://docs.python.org/3/library/functions.html#oct)
  public func oct(_ object: PyObject) -> PyResult<PyObject> {
    return self.toNumberString(object, radix: 8, prefix: "0o")
  }

  // sourcery: pymethod: hex
  /// hex(x)
  /// See [this](https://docs.python.org/3/library/functions.html#hex)
  public func hex(_ object: PyObject) -> PyResult<PyObject> {
    return self.toNumberString(object, radix: 16, prefix: "0x")
  }

  private func toNumberString(_ object: PyObject,
                              radix: Int,
                              prefix: String) -> PyResult<PyObject> {
    switch IndexHelper.bigInt(object) {
    case let .value(bigInt):
      let result = prefix + String(bigInt, radix: radix, uppercase: false)
      return .value(self.newString(result))
    case let .error(e):
      return .error(e)
    }
  }
}

extension PyInstance {

  /// bin(x)
  /// See [this](https://docs.python.org/3/library/functions.html#bin)
  public func bin(object: PyObject) -> PyResult<PyObject> {
    return self.toNumberString(object: object, radix: 2, prefix: "0b")
  }

  /// oct(x)
  /// See [this](https://docs.python.org/3/library/functions.html#oct)
  public func oct(object: PyObject) -> PyResult<PyObject> {
    return self.toNumberString(object: object, radix: 8, prefix: "0o")
  }

  /// hex(x)
  /// See [this](https://docs.python.org/3/library/functions.html#hex)
  public func hex(object: PyObject) -> PyResult<PyObject> {
    return self.toNumberString(object: object, radix: 16, prefix: "0x")
  }

  private func toNumberString(object: PyObject,
                              radix: Int,
                              prefix: String) -> PyResult<PyObject> {
    switch IndexHelper.bigInt(object) {
    case let .value(bigInt):
      let sign = bigInt < 0 ? "-" : ""

      let bigIntAbs = Swift.abs(bigInt)
      let number = String(bigIntAbs, radix: radix, uppercase: false)

      let result = sign + prefix + number
      return .value(self.newString(result))

    case let .notIndex(lazyError):
      let e = lazyError.create()
      return .error(e)

    case let .error(e):
      return .error(e)
    }
  }
}

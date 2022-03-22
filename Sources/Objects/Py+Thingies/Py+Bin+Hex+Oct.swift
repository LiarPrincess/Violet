extension Py {

  /// bin(x)
  /// See [this](https://docs.python.org/3/library/functions.html#bin)
  public func bin(object: PyObject) -> PyResultGen<PyString> {
    return self.toNumberString(object: object, radix: 2, prefix: "0b")
  }

  /// oct(x)
  /// See [this](https://docs.python.org/3/library/functions.html#oct)
  public func oct(object: PyObject) -> PyResultGen<PyString> {
    return self.toNumberString(object: object, radix: 8, prefix: "0o")
  }

  /// hex(x)
  /// See [this](https://docs.python.org/3/library/functions.html#hex)
  public func hex(object: PyObject) -> PyResultGen<PyString> {
    return self.toNumberString(object: object, radix: 16, prefix: "0x")
  }

  private func toNumberString(object: PyObject,
                              radix: Int,
                              prefix: String) -> PyResultGen<PyString> {
    switch IndexHelper.pyInt(self, object: object) {
    case let .value(pyInt):
      let bigInt = pyInt.value
      let sign = bigInt < 0 ? "-" : ""

      let bigIntAbs = Swift.abs(bigInt)
      let number = String(bigIntAbs, radix: radix, uppercase: false)

      let result = sign + prefix + number
      let resultObject = self.newString(result)
      return .value(resultObject)

    case let .notIndex(lazyError):
      let e = lazyError.create(self)
      return .error(e)

    case let .error(e):
      return .error(e)
    }
  }
}

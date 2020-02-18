import Core

// We will group all those functions in a single file just because
// they all have 3-letter names.
extension BuiltinFunctions {

  // MARK: - Bin, Hex, Oct

  // sourcery: pymethod = bin
  /// bin(x)
  /// See [this](https://docs.python.org/3/library/functions.html#bin)
  public func bin(_ object: PyObject) -> PyResult<PyObject> {
    return self.toNumberString(object, radix: 2, prefix: "0b")
  }

  // sourcery: pymethod = oct
  /// oct(x)
  /// See [this](https://docs.python.org/3/library/functions.html#oct)
  public func oct(_ object: PyObject) -> PyResult<PyObject> {
    return self.toNumberString(object, radix: 8, prefix: "0o")
  }

  // sourcery: pymethod = hex
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
      let sign = bigInt < 0 ? "-" : ""

      let bigIntAbs = Swift.abs(bigInt)
      let number = String(bigIntAbs, radix: radix, uppercase: false)

      let result = sign + prefix + number
      return .value(self.newString(result))
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Chr, Ord

  // sourcery: pymethod = chr
  /// chr(i)
  /// See [this](https://docs.python.org/3/library/functions.html#chr)
  public func chr(_ object: PyObject) -> PyResult<PyString> {
    // Integer Unicode code point -> string representing a character

    let bigInt: BigInt
    switch IndexHelper.bigIntMaybe(object) {
    case .value(let i):
      bigInt = i
    case .notIndex:
      return .typeError("an integer is required (got type \(object.typeName))")
    case .error(let e):
      return .error(e)
    }

    guard let int = Int(exactly: bigInt),
          let scalar = UnicodeScalar(int), int < 0x110000 else {
      return .valueError("chr() arg not in range(0x110000)")
    }

    let result = self.newString(String(scalar))
    return .value(result)
  }

  // sourcery: pymethod = ord
  /// ord(c)
  /// See [this](https://docs.python.org/3/library/functions.html#ord)
  public func ord(_ object: PyObject) -> PyResult<PyInt> {
    // Unicode character -> integer representing the Unicode code point

    if let string = object as? PyString {
      let scalars = string.scalars

      guard let first = scalars.first, scalars.count == 1 else {
        let l = scalars.count
        return .typeError("ord() expected a character, but string of length \(l) found")
      }

      let int = BigInt(first.value)
      return .value(self.newInt(int))
    }

    if let bytes = object as? PyBytesType {
      let scalars = bytes.data.values

      guard let first = scalars.first, scalars.count == 1 else {
        let l = scalars.count
        return .typeError("ord() expected a character, but string of length \(l) found")
      }

      let scalar = UnicodeScalar(first) // Does this even make sense?
      let int = BigInt(scalar.value)
      return .value(self.newInt(int))
    }

    let msg = "ord() expected string of length 1, but \(object.typeName) found"
    return .typeError(msg)
  }
}

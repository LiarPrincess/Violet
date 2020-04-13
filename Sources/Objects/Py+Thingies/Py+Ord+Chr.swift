import Core

extension PyInstance {

  // MARK: - Chr

  /// chr(i)
  /// See [this](https://docs.python.org/3/library/functions.html#chr)
  public func chr(object: PyObject) -> PyResult<PyString> {
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

  // MARK: - Ord

  /// ord(c)
  /// See [this](https://docs.python.org/3/library/functions.html#ord)
  public func ord(object: PyObject) -> PyResult<PyInt> {
    // Unicode character -> integer representing the Unicode code point

    if let string = object as? PyString {
      let scalars = string.scalars

      guard let first = scalars.first, scalars.count == 1 else {
        let l = scalars.count
        let msg = "ord() expected a character, but string of length \(l) found"
        return .typeError(msg)
      }

      let int = BigInt(first.value)
      return .value(self.newInt(int))
    }

    if let bytes = object as? PyBytesType {
      let scalars = bytes.data.values

      guard let first = scalars.first, scalars.count == 1 else {
        let l = scalars.count
        let msg = "ord() expected a character, but string of length \(l) found"
        return .typeError(msg)
      }

      let scalar = UnicodeScalar(first) // Does this even make sense?
      let int = BigInt(scalar.value)
      return .value(self.newInt(int))
    }

    let msg = "ord() expected string of length 1, but \(object.typeName) found"
    return .typeError(msg)
  }
}

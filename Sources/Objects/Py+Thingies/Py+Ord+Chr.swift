import BigInt
import VioletCore

extension Py {

  // MARK: - Chr

  /// chr(i)
  /// See [this](https://docs.python.org/3/library/functions.html#chr)
  public func chr(object: PyObject) -> PyResultGen<PyString> {
    // Integer Unicode code point -> string representing a character

    let pyInt: PyInt
    switch IndexHelper.pyInt(self, object: object) {
    case .value(let i):
      pyInt = i
    case .notIndex:
      return .typeError(self, message: "an integer is required (got type \(object.typeName))")
    case .error(let e):
      return .error(e)
    }

    guard let int = Int(exactly: pyInt.value),
          let scalar = UnicodeScalar(int), int < 0x11_0000 else {
      return .valueError(self, message: "chr() arg not in range(0x110000)")
    }

    let result = self.newString(scalar: scalar)
    return .value(result)
  }

  // MARK: - Ord

  /// ord(c)
  /// See [this](https://docs.python.org/3/library/functions.html#ord)
  public func ord(object: PyObject) -> PyResultGen<PyInt> {
    // Unicode character -> integer representing the Unicode code point

    if let string = self.cast.asString(object) {
      let elements = string.elements

      guard let first = elements.first, elements.count == 1 else {
        let msg = "ord() expected a character, but string of length \(elements.count) found"
        return .typeError(self, message: msg)
      }

      let int = BigInt(first.value)
      return .value(self.newInt(int))
    }

    if let bytes = self.cast.asAnyBytes(object) {
      let elements = bytes.elements

      guard let first = elements.first, elements.count == 1 else {
        let msg = "ord() expected a character, but string of length \(elements.count) found"
        return .typeError(self, message: msg)
      }

      return .value(self.newInt(first))
    }

    let msg = "ord() expected string of length 1, but \(object.typeName) found"
    return .typeError(self, message: msg)
  }
}

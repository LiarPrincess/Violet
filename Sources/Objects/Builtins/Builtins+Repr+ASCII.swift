// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Builtins {

  // MARK: - Repr

  // sourcery: pymethod: repr
  /// repr(object)
  /// See [this](https://docs.python.org/3/library/functions.html#repr)
  public func repr(_ object: PyObject) -> PyResult<String> {
    if object.hasReprLock {
      return .value("")
    }

    // Fast path
    if let reprOwner = object as? __repr__Owner {
      return .value(reprOwner.repr())
    }

    guard let repr = self.lookup(object, name: "__repr__") else {
      return .value(self.genericRepr(object))
    }

    switch self.call(repr, args: [object]) {
    case let .value(result):
      guard let resultStr = result as? PyString else {
        return .error(
          .typeError("__repr__ returned non-string (\(result.typeName))")
        )
      }

      return .value(resultStr.value)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - ASCII

  // sourcery: pymethod: ascii
  /// ascii(object)
  /// See [this](https://docs.python.org/3/library/functions.html#ascii)
  public func ascii(_ object: PyObject) -> String {
    guard case let PyResult.value(repr) = self.repr(object) else {
      return ""
    }

    let scalars = repr.unicodeScalars

    let allASCII = scalars.allSatisfy { $0.isASCII }
    if allASCII {
      return repr
    }

    var result = ""
    for scalar in scalars {
      if scalar.isASCII {
        result.append(String(scalar))
      } else if scalar.value < 0x10000 {
        // \uxxxx Character with 16-bit hex value xxxx
        result.append("\\u\(self.hex(scalar.value, padTo: 4))")
      } else {
        // \Uxxxxxxxx Character with 32-bit hex value xxxxxxxx
        result.append("\\U\(self.hex(scalar.value, padTo: 8))")
      }
    }

    return result
  }

  private func hex(_ value: UInt32, padTo: Int) -> String {
    let raw = String(value, radix: 16, uppercase: false)
    return raw.padding(toLength: padTo, withPad: "0", startingAt: 0)
  }

  // MARK: - Helpers

  private func genericRepr(_ object: PyObject) -> String {
    return "<\(object.typeName) object at \(object.ptrString)>"
  }
}

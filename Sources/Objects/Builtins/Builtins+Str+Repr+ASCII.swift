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

    if let owner = object as? __repr__Owner {
      return owner.repr()
    }

    switch self.callMethod(on: object, selector: "__repr__") {
    case .value(let result):
      guard let resultStr = result as? PyString else {
        return .typeError("__repr__ returned non-string (\(result.typeName))")
      }

      return .value(resultStr.value)

    case .noSuchMethod,
         .notImplemented:
      return .value(self.genericRepr(object))

    case .methodIsNotCallable(let e),
         .error(let e):
      return .error(e)
    }
  }

  // MARK: - Str

  /// class str(object='')
  /// class str(object=b'', encoding='utf-8', errors='strict')
  public func strValue(_ object: PyObject) -> PyResult<String> {
    if object.hasReprLock {
      return .value("")
    }

    if let owner = object as? __str__Owner {
      return owner.str()
    }

    switch self.callMethod(on: object, selector: "__str__") {
    case .value(let result):
      guard let resultStr = result as? PyString else {
        return .typeError("__str__ returned non-string (\(result.typeName))")
      }

      return .value(resultStr.value)

    case .noSuchMethod,
         .notImplemented:
      return self.repr(object)

    case .methodIsNotCallable(let e),
         .error(let e):
      return .error(e)
    }
  }

  // MARK: - ASCII

  // sourcery: pymethod: ascii
  /// ascii(object)
  /// See [this](https://docs.python.org/3/library/functions.html#ascii)
  public func ascii(_ object: PyObject) -> PyResult<String> {
    let repr: String
    switch self.repr(object) {
    case let .value(s): repr = s
    case let .error(e): return .error(e)
    }

    let scalars = repr.unicodeScalars

    let allASCII = scalars.allSatisfy { $0.isASCII }
    if allASCII {
      return .value(repr)
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

    return .value(result)
  }

  // MARK: - Helpers

  private func hex(_ value: UInt32, padTo: Int) -> String {
    let raw = String(value, radix: 16, uppercase: false)
    return raw.padding(toLength: padTo, withPad: "0", startingAt: 0)
  }

  private func genericRepr(_ object: PyObject) -> String {
    return "<\(object.typeName) object at \(object.ptrString)>"
  }
}

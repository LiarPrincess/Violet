// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Builtins {

  // MARK: - Repr

  // sourcery: pymethod = repr
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

    case .missingMethod, .notImplemented:
      return .value(self.genericRepr(object))

    case .notCallable(let e), .error(let e):
      return .error(e)
    }
  }

  internal func reprOrGeneric(_ object: PyObject) -> String {
    switch self.repr(object) {
    case .value(let s): return s
    case .error: return self.genericRepr(object)
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

    case .missingMethod, .notImplemented:
      return self.repr(object)

    case .notCallable(let e), .error(let e):
      return .error(e)
    }
  }

  // MARK: - ASCII

  // sourcery: pymethod = ascii
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

  // MARK: - Join

  /// _PyUnicode_JoinArray
  public func join(strings elements: [PyObject],
                   separator: PyObject) -> PyResult<PyString> {
    if elements.isEmpty {
      return .value(self.emptyString)
    }

    if elements.count == 1 {
      if let s = elements[0] as? PyString {
        return .value(s)
      }
    }

    guard let sep = separator as? PyString else {
      return .typeError("separator: expected str instance, \(separator.typeName) found")
    }

    let strings: [PyString]
    switch self.asStringArray(elements: elements) {
    case let .value(r): strings = r
    case let .error(e): return .error(e)
    }

    var result = ""
    for (index, string) in strings.enumerated() {
      result.append(string.value)

      let isLast = index == strings.count - 1
      if !isLast {
        result.append(sep.value)
      }
    }

    return .value(self.newString(result))
  }

  private func asStringArray(elements: [PyObject]) -> PyResult<[PyString]> {
    var result = [PyString]()

    for (index, object) in elements.enumerated() {
      switch object as? PyString {
      case .some(let s):
        result.append(s)
      case .none:
        let msg = "sequence item \(index): expected str instance, \(object.typeName) found"
        return .typeError(msg)
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

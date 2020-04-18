import Core

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// MARK: - Repr

extension PyInstance {

  /// repr(object)
  /// See [this](https://docs.python.org/3/library/functions.html#repr)
  public func repr(object: PyObject) -> PyResult<String> {
    if let result = Fast.__repr__(object) {
      return result
    }

    switch self.callMethod(object: object, selector: .__repr__) {
    case .value(let result):
      guard let resultStr = result as? PyString else {
        return .typeError("__repr__ returned non-string (\(result.typeName))")
      }

      return .value(resultStr.value)

    case .missingMethod:
      return .value(self.genericRepr(object: object))

    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  /// Get object `__repr__` if that fail then use generic representation.
  public func reprOrGeneric(object: PyObject) -> String {
    switch self.repr(object: object) {
    case .value(let s): return s
    case .error: return self.genericRepr(object: object)
    }
  }
}

// MARK: - Str

extension PyInstance {

  /// class str(object='')
  /// class str(object=b'', encoding='utf-8', errors='strict')
  public func strValue(object: PyObject) -> PyResult<String> {
    if object.hasReprLock {
      return .value("")
    }

    // If we do not override '__str__' then we have to use '__repr__'.
    guard self.hasCustom__str__(object: object) else {
      return self.repr(object: object)
    }

    if let result = Fast.__str__(object) {
      return result
    }

    switch self.callMethod(object: object, selector: .__str__) {
    case .value(let result):
      guard let resultStr = result as? PyString else {
        return .typeError("__str__ returned non-string (\(result.typeName))")
      }

      return .value(resultStr.value)

    case .missingMethod:
      return self.repr(object: object)

    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  private func hasCustom__str__(object: PyObject) -> Bool {
    let type = object.type

    guard let lookup = type.lookupWithType(name: .__str__) else {
      // 'object' has default implementation for '__str__',
      // if we did not find it then something went really wrong.
      trap("'\(type.getName())' is not a subclass of 'object'")
    }

    let isFromObject = lookup.type === Py.types.object
    return !isFromObject
  }

  // MARK: - ASCII

  /// ascii(object)
  /// See [this](https://docs.python.org/3/library/functions.html#ascii)
  public func ascii(object: PyObject) -> PyResult<String> {
    let repr: String
    switch self.repr(object: object) {
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
        let hex = self.hex(value: scalar.value, padTo: 4)
        result.append("\\u\(hex)")
      } else {
        // \Uxxxxxxxx Character with 32-bit hex value xxxxxxxx
        let hex = self.hex(value: scalar.value, padTo: 8)
        result.append("\\U\(hex)")
      }
    }

    return .value(result)
  }

  // MARK: - Join

  /// _PyUnicode_JoinArray
  public func join(strings elements: [PyObject],
                   separator: PyObject) -> PyResult<PyString> {
    if elements.isEmpty {
      return .value(Py.emptyString)
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
}
  // MARK: - Decode string

internal enum ExtractStringResult {
  case string(PyString, String)
  case bytes(PyBytesType, String)
  case byteDecodingError(PyBytesType)
  case notStringOrBytes
}

extension PyInstance {

  /// Extract `String` from this object (if possible).
  ///
  /// Mostly targeted torwards 'str', `bytes` and `bytearray`.
  internal func extractString(object: PyObject) -> ExtractStringResult {
    if let str = object as? PyString {
      return .string(str, str.value)
    }

    if let bytes = object as? PyBytesType {
      if let string = bytes.data.string {
        return .bytes(bytes, string)
      }

      return .byteDecodingError(bytes)
    }

    return .notStringOrBytes
  }

  // MARK: - Helpers

  private func hex(value: UInt32, padTo: Int) -> String {
    let string = String(value, radix: 16, uppercase: false)
    if string.count >= padTo {
      return string
    }

    let paddingCount = padTo - string.count
    assert(paddingCount > 0)
    let padding = String(repeating: "0", count: paddingCount)

    return padding + string
  }

  private func genericRepr(object: PyObject) -> String {
    return "<\(object.typeName) object at \(object.ptr)>"
  }
}

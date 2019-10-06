extension PyContext {

  // MARK: - Repr

  /// PyObject * PyObject_Repr(PyObject *v)
  public func repr(value: PyObject) throws -> PyObject {
    let raw = try self.reprString(value: value)
    return self.types.string.new(raw)
  }

  internal func reprString(value: PyObject) throws -> String {
    if let reprType = value as? ReprTypeClass {
      return reprType.repr
    }

    return self.genericRepr(value: value)
  }

  // MARK: - Str

  /// PyObject * PyObject_Str(PyObject *v)
  public func str(value: PyObject) -> PyObject {
    let raw = self.strString(value: value)
    return self.types.string.new(raw)
  }

  internal func strString(value: PyObject) -> String {
    if let str = value as? PyString {
      return str.value
    }

    if let strType = value as? StrTypeClass {
      return strType.str
    }

    if let reprType = value as? ReprTypeClass {
      return reprType.repr
    }

    return self.genericRepr(value: value)
  }

  // MARK: - ASCII

  /// PyObject * PyObject_ASCII(PyObject *v)
  public func ascii(value: PyObject) throws -> PyObject {
    let raw = try self.asciiStr(value: value)
    return self.types.string.new(raw)
  }

  internal func asciiStr(value: PyObject) throws -> String {
    let repr = try self.reprString(value: value)
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

  private func genericRepr(value: PyObject) -> String {
    return "<\(value.type.name) object>"
  }
}

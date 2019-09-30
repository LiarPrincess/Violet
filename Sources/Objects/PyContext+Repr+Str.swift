internal class PyString: PyObject {

  internal var value: String

  internal init(type: PyIntType, value: String) {
    fatalError()
  }
}

extension PyContext {

  public func repr(value: PyObject) throws -> PyObject {
    let raw = try self.reprString(value: value)
    return self.createString(raw)
  }

  internal func reprString(value: PyObject) throws -> String {
    if let reprType = value as? ReprTypeClass {
      return try reprType.repr(value: value)
    }

    return self.genericRepr(value: value)
  }

  public func str(value: PyObject) throws -> PyObject {
    let raw = try self.strString(value: value)
    return self.createString(raw)
  }

  internal func strString(value: PyObject) throws -> String {
    // TODO: if let str = value as? PyUnicodeType { }

    if let strType = value as? StrTypeClass {
      return try strType.str(value: value)
    }

    if let reprType = value as? ReprTypeClass {
      return try reprType.repr(value: value)
    }

    return self.genericRepr(value: value)
  }

  private func genericRepr(value: PyObject) -> String {
    return "<\(value.type.name) object>"
  }

  internal func createString(_ value: String) -> PyString {
    return PyString(type: self.types.int, value: value)
  }
}

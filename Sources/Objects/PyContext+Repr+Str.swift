extension PyContext {

  public func repr(value: PyObject) throws -> String {
    if let reprType = value as? ReprTypeClass {
      return try reprType.repr(value: value)
    }

    return self.genericRepr(value: value)
  }

  public func str(value: PyObject) throws -> String {
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
}

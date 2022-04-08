extension AbstractString {

  // MARK: - Strip

  internal static func abstractStrip(_ py: Py,
                                     zelf: PyObject,
                                     chars: PyObject?) -> PyResult {
    return Self.template(py,
                         zelf: zelf,
                         chars: chars,
                         fnName: "strip",
                         onStripWhitespace: Self.stripWhitespace(zelf:),
                         onStripChars: Self.strip(zelf:chars:))
  }

  private static func stripWhitespace(zelf: Self) -> Elements.SubSequence {
    let tmp = zelf.elements.drop(while: Self.isWhitespace(element:))
    return tmp.dropLast(while: Self.isWhitespace(element:))
  }

  private static func strip(zelf: Self, chars: Set<Element>) -> Elements.SubSequence {
    let tmp = zelf.elements.drop { chars.contains($0) }
    return tmp.dropLast { chars.contains($0) }
  }

  // MARK: - Left strip

  internal static func abstractLStrip(_ py: Py,
                                      zelf: PyObject,
                                      chars: PyObject?) -> PyResult {
    return Self.template(py,
                         zelf: zelf,
                         chars: chars,
                         fnName: "lstrip",
                         onStripWhitespace: Self.lstripWhitespace(zelf:),
                         onStripChars: Self.lstrip(zelf:chars:))
  }

  private static func lstripWhitespace(zelf: Self) -> Elements.SubSequence {
    return zelf.elements.drop(while: Self.isWhitespace(element:))
  }

  private static func lstrip(zelf: Self, chars: Set<Element>) -> Elements.SubSequence {
    return zelf.elements.drop { chars.contains($0) }
  }

  // MARK: - Right strip

  internal static func abstractRStrip(_ py: Py,
                                      zelf: PyObject,
                                      chars: PyObject?) -> PyResult {
    return Self.template(py,
                         zelf: zelf,
                         chars: chars,
                         fnName: "rstrip",
                         onStripWhitespace: Self.rstripWhitespace(zelf:),
                         onStripChars: Self.rstrip(zelf:chars:))
  }

  private static func rstripWhitespace(zelf: Self) -> Elements.SubSequence {
    return zelf.elements.dropLast(while: Self.isWhitespace(element:))
  }

  private static func rstrip(zelf: Self, chars: Set<Element>) -> Elements.SubSequence {
    return zelf.elements.dropLast { chars.contains($0) }
  }

  // MARK: - Template

  // swiftlint:disable:next function_parameter_count
  private static func template(
    _ py: Py,
    zelf _zelf: PyObject,
    chars: PyObject?,
    fnName: String,
    onStripWhitespace: (Self) -> Elements.SubSequence,
    onStripChars: (Self, Set<Element>) -> Elements.SubSequence
  ) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    // No chars (or 'None') -> whitespace mode
    guard let chars = chars, !py.cast.isNone(chars) else {
      let result = onStripWhitespace(zelf)
      let resultObject = Self.newObject(py, elements: result)
      return PyResult(resultObject)
    }

    if let charsElements = Self.getElements(py, object: chars) {
      let charsSet = Set(charsElements)
      let result = onStripChars(zelf, charsSet)
      let resultObject = Self.newObject(py, elements: result)
      return PyResult(resultObject)
    }

    let selfType = Self.pythonTypeName
    let charsType = chars.typeName
    let message = "\(fnName) arg must be \(selfType) or None, not \(charsType)"
    return .typeError(py, message: message)
  }
}

extension AbstractString {

  // MARK: - Strip

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _strip(chars: PyObject?) -> PyResult<SwiftType> {
    return self._template(fnName: "strip",
                          chars: chars,
                          onStripWhitespace: self._stripWhitespace,
                          onStripChars: self._strip(chars:))
  }

  private func _stripWhitespace() -> Elements.SubSequence {
    let tmp = self.elements.drop(while: Self._isWhitespace(element:))
    return tmp.dropLast(while: Self._isWhitespace(element:))
  }

  private func _strip(chars: Set<Element>) -> Elements.SubSequence {
    let tmp = self.elements.drop { chars.contains($0) }
    return tmp.dropLast { chars.contains($0) }
  }

  // MARK: - Left strip

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _lstrip(chars: PyObject?) -> PyResult<SwiftType> {
    return self._template(fnName: "lstrip",
                          chars: chars,
                          onStripWhitespace: self._lstripWhitespace,
                          onStripChars: self._lstrip(chars:))
  }

  private func _lstripWhitespace() -> Elements.SubSequence {
    return self.elements.drop(while: Self._isWhitespace(element:))
  }

  private func _lstrip(chars: Set<Element>) -> Elements.SubSequence {
    return self.elements.drop { chars.contains($0) }
  }

  // MARK: - Right strip

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _rstrip(chars: PyObject?) -> PyResult<SwiftType> {
    return self._template(fnName: "rstrip",
                          chars: chars,
                          onStripWhitespace: self._rstripWhitespace,
                          onStripChars: self._rstrip(chars:))
  }

  private func _rstripWhitespace() -> Elements.SubSequence {
    return self.elements.dropLast(while: Self._isWhitespace(element:))
  }

  private func _rstrip(chars: Set<Element>) -> Elements.SubSequence {
    return self.elements.dropLast { chars.contains($0) }
  }

  // MARK: - Template

  private func _template(
    fnName: String,
    chars: PyObject?,
    onStripWhitespace: () -> Elements.SubSequence,
    onStripChars: (Set<Element>) -> Elements.SubSequence
  ) -> PyResult<SwiftType> {
    // No chars (or 'None') -> whitespace mode
    guard let chars = chars, !PyCast.isNone(chars) else {
      let result = onStripWhitespace()
      let resultObject = Self._toObject(elements: result)
      return .value(resultObject)
    }

    if let charsElements = Self._getElements(object: chars) {
      let charsSet = Set(charsElements)
      let result = onStripChars(charsSet)
      let resultObject = Self._toObject(elements: result)
      return .value(resultObject)
    }

    let selfType = Self._pythonTypeName
    let charsType = chars.typeName
    let msg = "\(fnName) arg must be \(selfType) or None, not \(charsType)"
    return .error(Py.newTypeError(msg: msg))
  }
}

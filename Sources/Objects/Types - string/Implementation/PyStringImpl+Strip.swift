// MARK: - Strip

private enum StripChars<Element: Hashable> {
  case whitespace
  case chars(Set<Element>)
  case error(PyBaseException)
}

extension PyStringImpl {

  internal func strip(_ chars: PyObject?) -> PyResult<Self.SubSequence> {
    switch self.parseStripChars(chars, fnName: "strip") {
    case .whitespace:
      return .value(self.stripWhitespace())
    case let .chars(set):
      let tmp = self.lstrip(self.scalars, chars: set)
      let result = self.rstrip(tmp, chars: set)
      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }

  internal func lstrip(_ chars: PyObject?) -> PyResult<Self.SubSequence> {
    switch self.parseStripChars(chars, fnName: "lstrip") {
    case .whitespace:
      return .value(self.lstripWhitespace())
    case let .chars(set):
      return .value(self.lstrip(self.scalars, chars: set))
    case let .error(e):
      return .error(e)
    }
  }

  internal func rstrip(_ chars: PyObject?) -> PyResult<Self.SubSequence> {
    switch self.parseStripChars(chars, fnName: "rstrip") {
    case .whitespace:
      return .value(self.rstripWhitespace())
    case let .chars(set):
      return .value(self.rstrip(self.scalars, chars: set))
    case let .error(e):
      return .error(e)
    }
  }

  private func parseStripChars(_ chars: PyObject?,
                               fnName: String) -> StripChars<Element> {
    guard let chars = chars else {
      return .whitespace
    }

    if chars is PyNone {
      return .whitespace
    }

    switch Self.extractSelf(from: chars) {
    case .value(let charsString):
      return .chars(Set(charsString.scalars))
    case .notSelf:
      break // Try other
    case .error(let e):
      return .error(e)
    }

    let msg = "\(fnName) arg must be \(Self.typeName) or None, not \(chars.typeName)"
    return .error(Py.newTypeError(msg: msg))
  }

  private func lstrip<C: BidirectionalCollection>(
    _ scalars: C,
    chars: Set<C.Element>) -> C.SubSequence where C.Element == Self.Element {

    var index = scalars.startIndex

    while index != scalars.endIndex {
      if !chars.contains(scalars[index]) {
        break
      }

      scalars.formIndex(after: &index)
    }

    return scalars[index...]
  }

  private func rstrip<C: BidirectionalCollection>(
    _ scalars: C,
    chars: Set<C.Element>) -> C.SubSequence where C.Element == Self.Element {

    var index = scalars.endIndex

    // `endIndex` is AFTER the collection
    scalars.formIndex(before: &index)

    while index != scalars.startIndex {
      if !chars.contains(scalars[index]) {
        break
      }

      scalars.formIndex(before: &index)
    }

    return scalars[...index]
  }
}

// MARK: - Strip whitespace

extension PyStringImpl {

  internal func stripWhitespace() -> Self.SubSequence {
    let tmp = self.lstripWhitespace(in: self.scalars)
    return self.rstripWhitespace(in: tmp)
  }

  internal func lstripWhitespace() -> Self.SubSequence {
    return self.lstripWhitespace(in: self.scalars)
  }

  internal func rstripWhitespace() -> Self.SubSequence {
    return self.rstripWhitespace(in: self.scalars)
  }

  private func lstripWhitespace<C: Collection>(
    in value: C
  ) -> C.SubSequence where C.Element == Self.Element {
    return value.drop(while: Self.isWhitespace)
  }

  private func rstripWhitespace<C: BidirectionalCollection>(
    in value: C
  ) -> C.SubSequence where C.Element == Self.Element {
    return value.dropLast(while: Self.isWhitespace)
  }
}

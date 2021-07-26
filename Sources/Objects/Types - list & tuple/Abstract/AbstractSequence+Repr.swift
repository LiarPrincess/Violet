extension AbstractSequence {

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  internal func _repr(openBracket: String,
                      closeBracket: String,
                      appendCommaIfSingleElement: Bool) -> PyResult<String> {
    if self._isEmpty {
      return .value(openBracket + closeBracket)
    }

    // While not mutable, it is still possible to end up with a cycle in a tuple
    // through an object that stores itself within a tuple (and thus infinitely
    // asks for the repr of itself).
    if self.hasReprLock {
      return .value(openBracket + "..." + closeBracket)
    }

    return self.withReprLock {
      self._inner(openBracket: openBracket,
                  closeBracket: closeBracket,
                  appendCommaIfSingleElement: appendCommaIfSingleElement)
    }
  }

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  private func _inner(openBracket: String,
                      closeBracket: String,
                      appendCommaIfSingleElement: Bool) -> PyResult<String> {
    var result = openBracket
    for (index, element) in self.elements.enumerated() {
      if index > 0 {
        result += ", " // so that we don't have ', )'.
      }

      switch Py.reprString(object: element) {
      case let .value(s): result += s
      case let .error(e): return .error(e)
      }
    }

    if appendCommaIfSingleElement && self._length == 1 {
      result += ","
    }

    result += closeBracket
    return .value(result)
  }
}

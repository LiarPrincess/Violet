private let splitLinesArguments = ArgumentParser.createOrTrap(
  arguments: ["keepends"],
  format: "|O:splitlines"
)

extension AbstractString {

  /// DO NOT USE! This is a part of `AbstractString` implementation
  internal func _splitLines(args: [PyObject], kwargs: PyDict?) -> PyResult<PyList> {
    switch splitLinesArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 1, "Invalid optional argument count.")

      let keepEnds = binding.optional(at: 0)
      return self._splitLines(keepEnds: keepEnds)
    case let .error(e):
      return .error(e)
    }
  }

  private func _splitLines(keepEnds: PyObject?) -> PyResult<PyList> {
    guard let keepEnds = keepEnds else {
      let result = self._splitLines(keepEnds: false)
      return .value(result)
    }

    // `bool` is also `int`
    if let int = PyCast.asInt(keepEnds) {
      let keepEnds = int.value.isTrue
      let result = self._splitLines(keepEnds: keepEnds)
      return .value(result)
    }

    return .typeError("keepends must be integer or bool, not \(keepEnds.typeName)")
  }

  private func _splitLines(keepEnds: Bool) -> PyList {
    var result = [SwiftType]()
    var index = self.elements.startIndex

    self._wouldBeBetterWithRandomAccessCollection()
    while index != self.elements.endIndex {
      let groupStart = index

      self._advanceUntilNewLineOrEnd(index: &index)

      // 'index' is either 'new line' or 'endIndex'
      let rangeExcludingNewLine = groupStart..<index

      self._consumeNewLineHandlingCRLFAsOne(index: &index)

      // 'index' is either 1st character of the next group or 'endIndex'
      let rangeIncludingNewLine = groupStart..<index

      let range = keepEnds ? rangeIncludingNewLine : rangeExcludingNewLine
      let line = self.elements[range]
      let lineObject = Self._toObject(elements: line)
      result.append(lineObject)
    }

    return Py.newList(elements: result)
  }

  private func _advanceUntilNewLineOrEnd(index: inout Elements.Index) {
    while index != self.elements.endIndex {
      if Self._isLineBreak(element: self.elements[index]) {
        return
      }

      self.elements.formIndex(after: &index)
    }
  }

  private func _consumeNewLineHandlingCRLFAsOne(index: inout Elements.Index) {
    // 'index' is either 'new line' or 'endIndex'
    if index == self.elements.endIndex {
      return
    }

    // Now only 'new line' is possible,
    // but we still have to deal with possible 'CRLF'
    let newLine = self.elements[index]
    self.elements.formIndex(after: &index)

    // If we are at the end -> 'CRLF' is not possible
    if index == self.elements.endIndex {
      return
    }

    let newLineAfter = self.elements[index]

    let newLineScalar = Self._asUnicodeScalar(element: newLine)
    let newLineAfterScalar = Self._asUnicodeScalar(element: newLineAfter)

    let isCRLF = newLineScalar == "\r" && newLineAfterScalar == "\n"
    if isCRLF {
      self.elements.formIndex(after: &index)
    }
  }
}

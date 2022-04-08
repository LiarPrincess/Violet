private let splitLinesArguments = ArgumentParser.createOrTrap(
  arguments: ["keepends"],
  format: "|O:splitlines"
)

extension AbstractString {

  internal static func abstractSplitLines(_ py: Py,
                                          zelf _zelf: PyObject,
                                          args: [PyObject],
                                          kwargs: PyDict?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "splitlines")
    }

    switch splitLinesArguments.bind(py, args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 1, "Invalid optional argument count.")

      let keepEnds = binding.optional(at: 0)
      return Self.splitLines(py, zelf: zelf, keepEnds: keepEnds)
    case let .error(e):
      return .error(e)
    }
  }

  private static func splitLines(_ py: Py, zelf: Self, keepEnds: PyObject?) -> PyResult {
    guard let keepEnds = keepEnds else {
      let result = Self.splitLines(py, zelf: zelf, keepEnds: false)
      return PyResult(result)
    }

    // `bool` is also `int`
    if let int = py.cast.asInt(keepEnds) {
      let keepEnds = int.value.isTrue
      let result = Self.splitLines(py, zelf: zelf, keepEnds: keepEnds)
      return PyResult(result)
    }

    let message = "keepends must be integer or bool, not \(keepEnds.typeName)"
    return .typeError(py, message: message)
  }

  private static func splitLines(_ py: Py, zelf: Self, keepEnds: Bool) -> PyList {
    var result = [PyObject]()
    var index = zelf.elements.startIndex

    Self.wouldBeBetterWithRandomAccessCollection()
    while index != zelf.elements.endIndex {
      let groupStart = index

      Self.advanceUntilNewLineOrEnd(zelf: zelf, index: &index)

      // 'index' is either 'new line' or 'endIndex'
      let rangeExcludingNewLine = groupStart..<index

      Self.consumeNewLineHandlingCRLFAsOne(zelf: zelf, index: &index)

      // 'index' is either 1st character of the next group or 'endIndex'
      let rangeIncludingNewLine = groupStart..<index

      let range = keepEnds ? rangeIncludingNewLine : rangeExcludingNewLine
      let line = zelf.elements[range]
      let lineObject = Self.newObject(py, elements: line)
      result.append(lineObject.asObject)
    }

    return py.newList(elements: result)
  }

  private static func advanceUntilNewLineOrEnd(zelf: Self,
                                               index: inout Elements.Index) {
    while index != zelf.elements.endIndex {
      if Self.isLineBreak(element: zelf.elements[index]) {
        return
      }

      zelf.elements.formIndex(after: &index)
    }
  }

  private static func consumeNewLineHandlingCRLFAsOne(zelf: Self,
                                                      index: inout Elements.Index) {
    // 'index' is either 'new line' or 'endIndex'
    if index == zelf.elements.endIndex {
      return
    }

    // Now only the 'new line' is possible,
    // but we still have to deal with possible 'CRLF'
    let newLine = zelf.elements[index]
    zelf.elements.formIndex(after: &index)

    // If we are at the end -> 'CRLF' is not possible
    if index == zelf.elements.endIndex {
      return
    }

    let afterNewLine = zelf.elements[index]

    if Self.isCarriageReturn(element: newLine) && Self.isLineFeed(element: afterNewLine) {
      zelf.elements.formIndex(after: &index)
    }
  }
}

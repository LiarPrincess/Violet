extension AbstractString {

  internal static func abstractExpandTabs(_ py: Py,
                                          zelf _zelf: PyObject,
                                          tabSize: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "expandtabs")
    }

    switch Self.parseTabSize(py, tabSize: tabSize) {
    case let .value(tabSize):
      let builder = Self.expandTabs(zelf: zelf, tabSize: tabSize)
      let result = builder.finalize()
      let resultObject = Self.newObject(py, result: result)
      return PyResult(resultObject)
    case let .error(e):
      return .error(e)
    }
  }

  private static func expandTabs(zelf: Self, tabSize: Int) -> Builder {
    var builder = Builder(capacity: zelf.count + tabSize)
    var linePos = 0

    for element in zelf.elements {
      let isTab = Self.isHorizontalTab(element: element)
      if isTab {
        if tabSize > 0 {
          let incr = tabSize - (linePos % tabSize)
          linePos += incr
          builder.append(element: Self.defaultFill, repeated: incr)
        }
      } else {
        linePos += 1
        builder.append(element: element)

        let isNewLineStart = Self.isCarriageReturn(element: element)
          || Self.isLineFeed(element: element)

        if isNewLineStart {
          linePos = 0
        }
      }
    }

    return builder
  }

  private static func parseTabSize(_ py: Py, tabSize: PyObject?) -> PyResultGen<Int> {
    guard let tabSize = tabSize else {
      return .value(8)
    }

    guard let pyInt = py.cast.asInt(tabSize) else {
      return .typeError(py, message: "tabsize must be int, not \(tabSize.typeName)")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError(py, message: "tabsize is too big")
    }

    return .value(int)
  }
}

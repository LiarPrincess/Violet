extension AbstractString {

  /// DO NOT USE! This is a part of `AbstractString` implementation
  internal func _expandTabs(tabSize tabSizeObject: PyObject?) -> PyResult<SwiftType> {
    switch self._parseTabSize(tabSize: tabSizeObject) {
    case let .value(tabSize):
      let builder = self._expandTabs(tabSize: tabSize)
      let result = builder.finalize()
      let resultObject = Self._toObject(result: result)
      return .value(resultObject)
    case let .error(e):
      return .error(e)
    }
  }

  private func _expandTabs(tabSize: Int) -> Builder {
    var builder = Builder(capacity: self.elements.count + tabSize)
    var linePos = 0

    for element in self.elements {
      let scalar = Self._asUnicodeScalar(element: element)

      switch scalar {
      case "\t":
        if tabSize > 0 {
          let incr = tabSize - (linePos % tabSize)
          linePos += incr
          builder.append(element: Self._defaultFill, repeated: incr)
        }

      default:
        linePos += 1
        builder.append(element: element)

        if scalar == "\n" || scalar == "\r" {
          linePos = 0
        }
      }
    }

    return builder
  }

  private func _parseTabSize(tabSize: PyObject?) -> PyResult<Int> {
    guard let tabSize = tabSize else {
      return .value(8)
    }

    guard let pyInt = PyCast.asInt(tabSize) else {
      return .typeError("tabsize must be int, not \(tabSize.typeName)")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError("tabsize is too big")
    }

    return .value(int)
  }
}

import BigInt

private enum ExtractIndexResult<Elements: Collection> {
  case none
  case index(Elements.Index)
  case error(PyBaseException)
}

extension AbstractSequence {

  // MARK: - Contains

  internal static func abstract__contains__(_ py: Py,
                                            zelf _zelf: PyObject,
                                            object: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__contains__")
    }

    for element in zelf.elements {
      switch py.isEqualBool(left: element, right: object) {
      case .value(true):
        let result = true
        return PyResult(py, result)
      case .value(false):
        break // go to next element
      case .error(let e):
        return .error(e)
      }
    }

    let result = false
    return PyResult(py, result)
  }

  // MARK: - Count

  internal static func abstractCount(_ py: Py,
                                     zelf _zelf: PyObject,
                                     object: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "count")
    }

    var result = BigInt()

    for element in zelf.elements {
      switch py.isEqualBool(left: element, right: object) {
      case .value(true):
        result += 1
      case .value(false):
        break // go to next element
      case .error(let e):
        return .error(e)
      }
    }

    return PyResult(py, result)
  }

  // MARK: - Index of

  internal static func abstractIndex(_ py: Py,
                                     zelf _zelf: PyObject,
                                     object: PyObject,
                                     start: PyObject?,
                                     end: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "index")
    }

    let subsequence: SubSequence
    switch zelf.getSubsequence(py, start: start, end: end) {
    case let .value(s): subsequence = s
    case let .error(e): return .error(e)
    }

    for (index, element) in subsequence.enumerated() {
      switch py.isEqualBool(left: element, right: object) {
      case .value(true):
        let result = BigInt(index)
        return PyResult(py, result)
      case .value(false):
        break // go to next element
      case .error(let e):
        return .error(e)
      }
    }

    let typeName = Self.pythonTypeName
    return .valueError(py, message: "\(typeName).index(x): x not in \(typeName)")
  }

  private func getSubsequence(_ py: Py,
                              start: PyObject?,
                              end: PyObject?) -> PyResultGen<SubSequence> {
    let startIndex: Index
    switch self.extractIndex(py, object: start) {
    case .none: startIndex = self.elements.startIndex
    case .index(let index): startIndex = index
    case .error(let e): return .error(e)
    }

    var endIndex: Index
    switch self.extractIndex(py, object: end) {
    case .none: endIndex = self.elements.endIndex
    case .index(let index): endIndex = index
    case .error(let e): return .error(e)
    }

    let result = self.elements[startIndex..<endIndex]
    return .value(result)
  }

  private func extractIndex(_ py: Py,
                            object: PyObject?) -> ExtractIndexResult<Elements> {
    guard let object = object else {
      return .none
    }

    if py.cast.isNone(object) {
      return .none
    }

    let elements = self.elements

    switch IndexHelper.int(py, object: object, onOverflow: .overflowError) {
    case var .value(index):
      if index < 0 {
        index += elements.count
        if index < 0 {
          index = 0
        }
      }

      let start = elements.startIndex
      let end = elements.endIndex
      let result = elements.index(start, offsetBy: index, limitedBy: end)
      return .index(result ?? end)

    case let .notIndex(lazyError):
      let e = lazyError.create(py)
      return .error(e)

    case let .overflow(_, lazyError):
      let e = lazyError.create(py)
      return .error(e)

    case let .error(e):
      return .error(e)
    }
  }
}

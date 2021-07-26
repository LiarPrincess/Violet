import BigInt

extension AbstractSequence {

  // MARK: - Contains

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  internal func _contains(object: PyObject) -> PyResult<Bool> {
    for element in self.elements {
      switch Py.isEqualBool(left: element, right: object) {
      case .value(true):
        return .value(true)
      case .value(false):
        break // go to next element
      case .error(let e):
        return .error(e)
      }
    }

    return .value(false)
  }

  // MARK: - Count

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  internal func _count(object: PyObject) -> PyResult<BigInt> {
    var result = BigInt()

    for e in self.elements {
      switch Py.isEqualBool(left: e, right: object) {
      case .value(true): result += 1
      case .value(false): break // go to next element
      case .error(let e): return .error(e)
      }
    }

    return .value(result)
  }

  // MARK: - Find

  // MARK: - Index of

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  internal func _indexOf(object: PyObject,
                         start: PyObject?,
                         end: PyObject?) -> PyResult<BigInt> {
    let subsequence: SubSequence
    switch self._getSubsequence(start: start, end: end) {
    case let .value(s): subsequence = s
    case let .error(e): return .error(e)
    }

    for (index, e) in subsequence.enumerated() {
      switch Py.isEqualBool(left: e, right: object) {
      case .value(true):
        return .value(BigInt(index))
      case .value(false):
        break // go to next element
      case .error(let e):
        return .error(e)
      }
    }

    let typeName = Self._pythonTypeName
    return .valueError("\(typeName).index(x): x not in \(typeName)")
  }

  // MARK: - Subsequence

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  private func _getSubsequence(start: PyObject?,
                               end: PyObject?) -> PyResult<SubSequence> {

    let startIndex: Index
    switch self._extractIndex(start) {
    case .none: startIndex = self.elements.startIndex
    case .index(let index): startIndex = index
    case .error(let e): return .error(e)
    }

    var endIndex: Index
    switch self._extractIndex(end) {
    case .none: endIndex = self.elements.endIndex
    case .index(let index): endIndex = index
    case .error(let e): return .error(e)
    }

    return .value(self.elements[startIndex..<endIndex])
  }
}

// MARK: - Index

private enum ExtractIndexResult<Elements: Collection> {
  case none
  case index(Elements.Index)
  case error(PyBaseException)
}

extension AbstractSequence {

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  private func _extractIndex(_ value: PyObject?) -> ExtractIndexResult<Elements> {
    guard let value = value else {
      return .none
    }

    if PyCast.isNone(value) {
      return .none
    }

    switch IndexHelper.int(value, onOverflow: .default) {
    case var .value(index):
      if index < 0 {
        index += self.elements.count
        if index < 0 {
          index = 0
        }
      }

      let start = self.elements.startIndex
      let end = self.elements.endIndex
      let result = self.elements.index(start, offsetBy: index, limitedBy: end)
      return .index(result ?? end)

    case let .error(e),
         let .notIndex(e),
         let .overflow(_, e):
      return .error(e)
    }
  }
}

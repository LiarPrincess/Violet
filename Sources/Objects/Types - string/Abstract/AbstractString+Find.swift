import BigInt

// swiftlint:disable type_name

internal enum AbstractString_FindResult<C: Collection> {
  case index(index: C.Index, position: BigInt)
  case notFound
}

extension AbstractString {

  // MARK: - Find

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _find(object: PyObject,
                      start: PyObject?,
                      end: PyObject?) -> PyResult<BigInt> {
    return self._template(object: object,
                          start: start,
                          end: end,
                          findFn: self._findImpl(in:value:))
  }

  /// Use this method to find a `value` in `self`.
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _findImpl(value: Elements) -> AbstractString_FindResult<Elements> {
    let elementsAsSubstring = self.elements[...] // O(1)
    return self._findImpl(in: elementsAsSubstring, value: value)
  }

  /// Use this method to find a `value` in a given `substring`.
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _findImpl(
    in string: Elements.SubSequence,
    value: Elements
  ) -> AbstractString_FindResult<Elements> {
    if string.isEmpty {
      return .notFound
    }

    // There are many good substring algorithms, and we went with this?
    // Eh… whatever…
    var position = BigInt(0)
    var index = string.startIndex

    self._wouldBeBetterWithRandomAccessCollection()
    while index != string.endIndex {
      // Subscript is 'O(1)', but the usage is 'O(n)'
      let fromIndex = string[index...]
      if fromIndex.starts(with: value) {
        return .index(index: index, position: position)
      }

      position += 1
      string.formIndex(after: &index)
    }

    return .notFound
  }

  // MARK: - RFind

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _rfind(object: PyObject,
                       start: PyObject?,
                       end: PyObject?) -> PyResult<BigInt> {
    return self._template(object: object,
                          start: start,
                          end: end,
                          findFn: self._rfindImpl(in:value:))
  }

  /// Use this method to rfind a `value` in `self`.
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _rfindImpl(value: Elements) -> AbstractString_FindResult<Elements> {
    let elementsAsSubstring = self.elements[...] // O(1)
    return self._rfindImpl(in: elementsAsSubstring, value: value)
  }

  /// Use this method to find a `value` in a given `substring`.
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _rfindImpl(
    in string: Elements.SubSequence,
    value: Elements
  ) -> AbstractString_FindResult<Elements> {
    if string.isEmpty {
      return .notFound
    }

    // There are many good substring algorithms, and we went with this?
    // Eh… whatever…
    var position = string.count - 1
    var index = string.endIndex

    // `endIndex` is AFTER the collection
    string.formIndex(before: &index)

    self._wouldBeBetterWithRandomAccessCollection()
    while index != string.startIndex {
      // Subscript is 'O(1)', but the usage is 'O(n)'
      let fromIndex = string[index...]
      if fromIndex.starts(with: value) {
        return .index(index: index, position: BigInt(position))
      }

      position -= 1
      string.formIndex(before: &index)
    }

    // Check if maybe we start with it (it was not checked inside the loop!)
    if string.starts(with: value) {
      return .index(index: index, position: 0)
    }

    return .notFound
  }

  // MARK: - Template

  private func _template(
    object: PyObject,
    start: PyObject?,
    end: PyObject?,
    findFn: (Elements.SubSequence, Elements) -> AbstractString_FindResult<Elements>
  ) -> PyResult<BigInt> {
    let valueToFind: Elements
    switch Self._getElementsForFindCountContainsIndexOf(object: object) {
    case .value(let s):
      valueToFind = s
    case .invalidObjectType:
      let objectType = object.typeName
      return .typeError("find arg must be \(Self._pythonTypeName), not \(objectType)")
    case .error(let e):
      return .error(e)
    }

    let substring: AbstractString_Substring<Elements>
    switch self._substringImpl(start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    let result = findFn(substring.value, valueToFind)

    switch result {
    case let .index(index: _, position: position):
      // If we found the value, then we have return an index
      // from the start of the string!
      let start = substring.start?.adjustedInt ?? 0
      return .value(BigInt(start) + position)

    case .notFound:
      // Python convention of returning '-1'.
      return .value(-1)
    }
  }
}

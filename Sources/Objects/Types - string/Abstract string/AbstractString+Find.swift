import BigInt

internal enum AbstractStringFindResult<C: Collection> {
  case index(index: C.Index, position: BigInt)
  case notFound
}

extension AbstractString {

  // MARK: - Find

  internal static func abstractFind(_ py: Py,
                                    zelf _zelf: PyObject,
                                    object: PyObject,
                                    start: PyObject?,
                                    end: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "find")
    }

    return Self.template(py,
                         zelf: zelf,
                         object: object,
                         start: start,
                         end: end,
                         findFn: Self.findHelper(string:value:))
  }

  /// Helper for other functions in 'AbstractString'.
  internal static func findHelper(
    zelf: Self,
    value: Elements
  ) -> AbstractStringFindResult<Elements> {
    let zelfElementsAsSubstring = zelf.elements[...] // O(1)
    return Self.findHelper(string: zelfElementsAsSubstring, value: value)
  }

  /// Helper for other functions in 'AbstractString'.
  internal static func findHelper(
    string: Elements.SubSequence,
    value: Elements
  ) -> AbstractStringFindResult<Elements> {
    if string.isEmpty {
      return .notFound
    }

    // There are many good substring algorithms, and we went with this?
    // Eh… whatever…
    var position = BigInt(0)
    var index = string.startIndex

    Self.wouldBeBetterWithRandomAccessCollection()
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

  internal static func abstractRfind(_ py: Py,
                                     zelf _zelf: PyObject,
                                     object: PyObject,
                                     start: PyObject?,
                                     end: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "rfind")
    }

    return Self.template(py,
                         zelf: zelf,
                         object: object,
                         start: start,
                         end: end,
                         findFn: Self.rfindHelper(string:value:))
  }

  /// Helper for other functions in 'AbstractString'.
  internal static func rfindHelper(
    zelf: Self,
    value: Elements
  ) -> AbstractStringFindResult<Elements> {
    let zelfElementsAsSubstring = zelf.elements[...] // O(1)
    return Self.rfindHelper(string: zelfElementsAsSubstring, value: value)
  }

  /// Helper for other functions in 'AbstractString'.
  internal static func rfindHelper(
    string: Elements.SubSequence,
    value: Elements
  ) -> AbstractStringFindResult<Elements> {
    if string.isEmpty {
      return .notFound
    }

    // There are many good substring algorithms, and we went with this?
    // Eh… whatever…
    var position = string.count - 1
    var index = string.endIndex

    // `endIndex` is AFTER the collection
    string.formIndex(before: &index)

    Self.wouldBeBetterWithRandomAccessCollection()
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

  // swiftlint:disable:next function_parameter_count
  private static func template(
    _ py: Py,
    zelf: Self,
    object: PyObject,
    start: PyObject?,
    end: PyObject?,
    findFn: (Elements.SubSequence, Elements) -> AbstractStringFindResult<Elements>
  ) -> PyResult {
    let valueToFind: Elements
    switch Self.getElementsForFindCountContainsIndexOf(py, object: object) {
    case .value(let s):
      valueToFind = s
    case .invalidObjectType:
      let objectType = object.typeName
      let message = "find arg must be \(Self.pythonTypeName), not \(objectType)"
      return .typeError(py, message: message)
    case .error(let e):
      return .error(e)
    }

    let substring: AbstractStringSubstring<Elements>
    switch Self.abstractSubstring(py, zelf: zelf, start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    let result = findFn(substring.value, valueToFind)

    switch result {
    case let .index(index: _, position: position):
      // If we found the value, then we have return an index
      // from the start of the string!
      let start = substring.start?.adjustedInt ?? 0
      let result = BigInt(start) + position
      return PyResult(py, result)

    case .notFound:
      // Python convention of returning '-1'.
      return PyResult(py, -1)
    }
  }
}

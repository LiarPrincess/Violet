import BigInt

// cSpell:ignore STRINGLIB

extension AbstractString {

  // MARK: - Contains

  internal static func abstract__contains__(_ py: Py,
                                            zelf _zelf: PyObject,
                                            object: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__contains__")
    }

    switch Self.getElementsForFindCountContainsIndexOf(py, object: object) {
    case .value(let value):
      let result = zelf.abstractContains(elements: value)
      return PyResult(py, result)

    case .invalidObjectType:
      let t = Self.pythonTypeName
      let objectType = object.typeName
      let message = "'in <\(t)>' requires \(t) as left operand, not \(objectType)"
      return .typeError(py, message: message)

    case .error(let e):
      return .error(e)
    }
  }

  internal func abstractContains(elements: Elements) -> Bool {
    // In Python: "\u00E9" in "Cafe\u0301" -> False
    // In Swift:  "Cafe\u{0301}".contains("\u{00E9}") -> True
    // which is 'e with acute (as a single char)' in 'Cafe{accent}'
    switch Self.findHelper(zelf: self, value: elements) {
    case .index:
      return true
    case .notFound:
      return false
    }
  }

  // MARK: - Count

  /// STRINGLIB(count)(const STRINGLIB_CHAR* str, Py_ssize_t str_len,
  ///                  const STRINGLIB_CHAR* sub, Py_ssize_t sub_len,
  ///                  Py_ssize_t maxcount)
  internal static func abstractCount(_ py: Py,
                                     zelf _zelf: PyObject,
                                     object: PyObject,
                                     start: PyObject?,
                                     end: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "count")
    }

    let value: Elements
    switch Self.getElementsForFindCountContainsIndexOf(py, object: object) {
    case .value(let v):
      value = v
    case .invalidObjectType:
      let t = Self.pythonTypeName
      let message = "count arg must be \(t), not \(object.typeName)"
      return .typeError(py, message: message)
    case .error(let e):
      return .error(e)
    }

    let substring: AbstractStringSubstring<Elements>
    switch Self.abstractSubstring(py, zelf: zelf, start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    let result = Self.count(string: substring.value, value: value)
    return PyResult(py, result)
  }

  private static func count(string: Elements.SubSequence, value: Elements) -> BigInt {
    if string.isEmpty {
      return 0
    }

    if value.isEmpty {
      return BigInt(string.count + 1)
    }

    var result = BigInt(0)
    var index = string.startIndex

    Self.wouldBeBetterWithRandomAccessCollection()
    while index != string.endIndex {
      let fromIndex = string[index...]
      if fromIndex.starts(with: value) {
        result += 1

        // We know that 'element.count' != 0, because we checked 'value.isEmpty'
        index = string.index(index, offsetBy: value.count)
      } else {
        string.formIndex(after: &index)
      }
    }

    return result
  }

  // MARK: - Index of

  internal static func abstractIndex(_ py: Py,
                                     zelf: PyObject,
                                     object: PyObject,
                                     start: PyObject?,
                                     end: PyObject?) -> PyResult {
    return Self.indexOfTemplate(py,
                                zelf: zelf,
                                object: object,
                                start: start,
                                end: end,
                                fnName: "index",
                                findFn: Self.findHelper(string:value:))
  }

  internal static func abstractRIndex(_ py: Py,
                                      zelf: PyObject,
                                      object: PyObject,
                                      start: PyObject?,
                                      end: PyObject?) -> PyResult {
    return Self.indexOfTemplate(py,
                                zelf: zelf,
                                object: object,
                                start: start,
                                end: end,
                                fnName: "rindex",
                                findFn: Self.rfindHelper(string:value:))
  }

  // swiftlint:disable:next function_parameter_count
  private static func indexOfTemplate(
    _ py: Py,
    zelf _zelf: PyObject,
    object: PyObject,
    start: PyObject?,
    end: PyObject?,
    fnName: String,
    findFn: (Elements.SubSequence, Elements) -> AbstractStringFindResult<Elements>
  ) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    let value: Elements
    switch Self.getElementsForFindCountContainsIndexOf(py, object: object) {
    case .value(let v):
      value = v
    case .invalidObjectType:
      let t = Self.pythonTypeName
      let message = "\(fnName) arg must be \(t), not \(object.typeName)"
      return .typeError(py, message: message)
    case .error(let e):
      return .error(e)
    }

    let substring: AbstractStringSubstring<Elements>
    switch Self.abstractSubstring(py, zelf: zelf, start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    let result = findFn(substring.value, value)
    switch result {
    case let .index(index: _, position: position):
      // If we found the value, then we have return an index
      // from the start of the string!
      let start = substring.start?.adjustedInt ?? 0
      let result = BigInt(start) + position
      return PyResult(py, result)

    case .notFound:
      return .valueError(py, message: "substring not found")
    }
  }
}

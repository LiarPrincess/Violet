import BigInt

// cSpell:ignore STRINGLIB

extension AbstractString {

  // MARK: - Contains

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _contains(object: PyObject) -> PyResult<Bool> {
    switch Self._getElementsForFindCountContainsIndexOf(object: object) {
    case .value(let value):
      let result = self._contains(value: value)
      return .value(result)
    case .invalidObjectType:
      let t = Self._pythonTypeName
      let objectType = object.typeName
      let msg = "'in <\(t)>' requires \(t) as left operand, not \(objectType)"
      return .typeError(msg)
    case .error(let e):
      return .error(e)
    }
  }

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _contains(value: Elements) -> Bool {
    // In Python: "\u00E9" in "Cafe\u0301" -> False
    // In Swift:  "Cafe\u{0301}".contains("\u{00E9}") -> True
    // which is 'e with acute (as a single char)' in 'Cafe{accent}'
    let findResult = self._findImpl(value: value)
    switch findResult {
    case .index: return true
    case .notFound: return false
    }
  }

  // MARK: - Count

  /// STRINGLIB(count)(const STRINGLIB_CHAR* str, Py_ssize_t str_len,
  ///                  const STRINGLIB_CHAR* sub, Py_ssize_t sub_len,
  ///                  Py_ssize_t maxcount)
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _count(object: PyObject,
                       start: PyObject?,
                       end: PyObject?) -> PyResult<BigInt> {
    let value: Elements
    switch Self._getElementsForFindCountContainsIndexOf(object: object) {
    case .value(let v):
      value = v
    case .invalidObjectType:
      let t = Self._pythonTypeName
      return .typeError("count arg must be \(t), not \(object.typeName)")
    case .error(let e):
      return .error(e)
    }

    let substring: AbstractString_Substring<Elements>
    switch self._substringImpl(start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    let result = self._count(in: substring.value, value: value)
    return .value(result)
  }

  private func _count(in string: Elements.SubSequence,
                      value: Elements) -> BigInt {
    if string.isEmpty {
      return 0
    }

    if value.isEmpty {
      return BigInt(string.count + 1)
    }

    var result = BigInt(0)
    var index = string.startIndex

    self._wouldBeBetterWithRandomAccessCollection()
    while index != string.endIndex {
      let fromIndex = string[index...]
      if fromIndex.starts(with: value) {
        result += 1

        // We know that 'element.count' != 0, because we checked 'element.isEmpty'
        index = string.index(index, offsetBy: value.count)
      } else {
        string.formIndex(after: &index)
      }
    }

    return result
  }

  // MARK: - Index of

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _indexOf(object: PyObject,
                         start: PyObject?,
                         end: PyObject?) -> PyResult<BigInt> {
    return self._indexOfTemplate(fnName: "index",
                                 object: object,
                                 start: start,
                                 end: end,
                                 findFn: self._findImpl(in:value:))
  }

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _rindexOf(object: PyObject,
                          start: PyObject?,
                          end: PyObject?) -> PyResult<BigInt> {
    return self._indexOfTemplate(fnName: "rindex",
                                 object: object,
                                 start: start,
                                 end: end,
                                 findFn: self._rfindImpl(in:value:))
  }

  private func _indexOfTemplate(
    fnName: String,
    object: PyObject,
    start: PyObject?,
    end: PyObject?,
    findFn: (Elements.SubSequence, Elements) -> AbstractString_FindResult<Elements>
  ) -> PyResult<BigInt> {
    let value: Elements
    switch Self._getElementsForFindCountContainsIndexOf(object: object) {
    case .value(let v):
      value = v
    case .invalidObjectType:
      let t = Self._pythonTypeName
      return .typeError("\(fnName) arg must be \(t), not \(object.typeName)")
    case .error(let e):
      return .error(e)
    }

    let substring: AbstractString_Substring<Elements>
    switch self._substringImpl(start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    let result = findFn(substring.value, value)
    switch result {
    case let .index(index: _, position: position):
      // If we found the value, then we have return an index
      // from the start of the string!
      let start = substring.start?.adjustedInt ?? 0
      return .value(BigInt(start) + position)
    case .notFound:
      return .valueError("substring not found")
    }
  }
}

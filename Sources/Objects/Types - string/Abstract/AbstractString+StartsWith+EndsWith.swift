extension AbstractString {

  // MARK: - Starts with

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _startsWith(prefix: PyObject,
                            start: PyObject?,
                            end: PyObject?) -> PyResult<Bool> {
    return self._template(fnName: "startswith",
                          element: prefix,
                          start: start,
                          end: end,
                          checkSubstring: self._startsWith(substring:prefix:))
  }

  private func _startsWith(substring: AbstractString_Substring<Elements>,
                           prefix: Elements) -> Bool {
    let substringIsLonger = self._isLonger(substring: substring, than: prefix)
    if substringIsLonger {
      return false
    }

    // Do not move this before 'isLonger' check!
    if prefix.isEmpty {
      return true
    }

    let result = substring.value.starts(with: prefix)
    return result
  }

  private func _isLonger(substring: AbstractString_Substring<Elements>,
                         than element: Elements) -> Bool {
    let start = substring.start?.adjustedInt ?? Int.min
    var end = substring.end?.adjustedInt ?? Int.max
    // We have to do it this way to prevent overflows
    end -= element.count
    return start > end
  }

  // MARK: - Ends with

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _endsWith(suffix: PyObject,
                          start: PyObject?,
                          end: PyObject?) -> PyResult<Bool> {
    return self._template(fnName: "endswith",
                          element: suffix,
                          start: start,
                          end: end,
                          checkSubstring: self._endsWith(substring:suffix:))
  }

  private func _endsWith(substring: AbstractString_Substring<Elements>,
                         suffix: Elements) -> Bool {
    let substringIsLonger = self._isLonger(substring: substring, than: suffix)
    if substringIsLonger {
      return false
    }

    // Do not move this before 'isLonger' check!
    if suffix.isEmpty {
      return true
    }

    let result = substring.value.ends(with: suffix)
    return result
  }

  // MARK: - Template

  private func _template(
    fnName: String,
    element: PyObject,
    start: PyObject?,
    end: PyObject?,
    checkSubstring: (AbstractString_Substring<Elements>, Elements) -> Bool
  ) -> PyResult<Bool> {
    let substring: AbstractString_Substring<Elements>
    switch self._substringImpl(start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    if let elts = Self._getElements(object: element) {
      let result = checkSubstring(substring, elts)
      return .value(result)
    }

    if let tuple = PyCast.asTuple(element) {
      for element in tuple.elements {
        switch Self._getElements(object: element) {
        case .some(let elts):
          let elementResult = checkSubstring(substring, elts)
          if elementResult {
            return .value(true)
          }
        case .none:
          let t = Self._pythonTypeName
          let elementType = element.typeName
          let msg = "tuple for \(fnName) must only contain \(t), not \(elementType)"
          return .typeError(msg)
        }
      }

      return .value(false)
    }

    let t = Self._pythonTypeName
    let elementType = element.typeName
    let msg = "\(fnName) first arg must be \(t) or a tuple of \(t), not \(elementType)"
    return .typeError(msg)
  }
}

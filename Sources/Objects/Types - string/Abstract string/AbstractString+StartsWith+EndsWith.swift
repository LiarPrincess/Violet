extension AbstractString {

  // MARK: - Starts with

  internal static func abstractStartsWith(_ py: Py,
                                          zelf: PyObject,
                                          prefix: PyObject,
                                          start: PyObject?,
                                          end: PyObject?) -> PyResult {
    return Self.template(py,
                         zelf: zelf,
                         element: prefix,
                         start: start,
                         end: end,
                         fnName: "startswith",
                         checkSubstring: Self.startsWith(substring:prefix:))
  }

  private static func startsWith(substring: AbstractStringSubstring<Elements>,
                                 prefix: Elements) -> Bool {
    if Self.isLonger(substring: substring, than: prefix) {
      return false
    }

    // Do not move this before 'isLonger' check!
    if prefix.isEmpty {
      return true
    }

    let result = substring.value.starts(with: prefix)
    return result
  }

  private static func isLonger(substring: AbstractStringSubstring<Elements>,
                               than element: Elements) -> Bool {
    let start = substring.start?.adjustedInt ?? Int.min
    var end = substring.end?.adjustedInt ?? Int.max
    // We have to do it this way to prevent overflows
    end -= element.count
    return start > end
  }

  // MARK: - Ends with

  internal static func abstractEndsWith(_ py: Py,
                                        zelf: PyObject,
                                        suffix: PyObject,
                                        start: PyObject?,
                                        end: PyObject?) -> PyResult {
    return Self.template(py,
                         zelf: zelf,
                         element: suffix,
                         start: start,
                         end: end,
                         fnName: "endswith",
                         checkSubstring: Self.endsWith(substring:suffix:))
  }

  private static func endsWith(substring: AbstractStringSubstring<Elements>,
                               suffix: Elements) -> Bool {
    if Self.isLonger(substring: substring, than: suffix) {
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

  // swiftlint:disable:next function_parameter_count
  private static func template(
    _ py: Py,
    zelf _zelf: PyObject,
    element: PyObject,
    start: PyObject?,
    end: PyObject?,
    fnName: String,
    checkSubstring: (AbstractStringSubstring<Elements>, Elements) -> Bool
  ) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, fnName)
    }

    let substring: AbstractStringSubstring<Elements>
    switch Self.abstractSubstring(py, zelf: zelf, start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    if let elts = Self.getElements(py, object: element) {
      let result = checkSubstring(substring, elts)
      return PyResult(py, result)
    }

    if let tuple = py.cast.asTuple(element) {
      for element in tuple.elements {
        switch Self.getElements(py, object: element) {
        case .some(let elts):
          let elementResult = checkSubstring(substring, elts)
          if elementResult {
            return PyResult(py, true)
          }
        case .none:
          let t = Self.pythonTypeName
          let elementType = element.typeName
          let message = "tuple for \(fnName) must only contain \(t), not \(elementType)"
          return .typeError(py, message: message)
        }
      }

      return PyResult(py, false)
    }

    let t = Self.pythonTypeName
    let elementType = element.typeName
    let message = "\(fnName) first arg must be \(t) or a tuple of \(t), not \(elementType)"
    return .typeError(py, message: message)
  }
}

internal enum CompareResult {
  case value(Bool)
  /// Shortcut for `Py.notImplemented`
  case notImplemented
  case error(PyBaseException)

  // swiftlint:disable:next discouraged_optional_boolean
  internal init(_ value: Bool?) {
    switch value {
    case .some(let b):
      self = .value(b)
    case .none:
      self = .notImplemented
    }
  }

  /// Method used when implementing `__ne__`.
  ///
  /// We don't want to override `!` operator, because it is tiny and easy to miss.
  internal var not: CompareResult {
    switch self {
    case .value(let bool):
      return .value(!bool)
    case .error(let e):
      return .error(e)
    case .notImplemented:
      return .notImplemented
    }
  }
}

extension CompareResult: PyFunctionResultConvertible {
  internal var asFunctionResult: PyFunctionResult {
    switch self {
    case .value(let bool):
      return bool.asFunctionResult
    case .error(let e):
      return .error(e)
    case .notImplemented:
      return .value(Py.notImplemented)
    }
  }
}

extension PyResult where Wrapped == Bool {
  internal var asCompareResult: CompareResult {
    switch self {
    case let .value(v):
      return .value(v)
    case let .error(e):
      return .error(e)
    }
  }
}

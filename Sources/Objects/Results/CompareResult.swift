/* MARKER
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

  internal init(_ value: PyResult<Bool>) {
    switch value {
    case let .value(b):
      self = .value(b)
    case let .error(e):
      self = .error(e)
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
    case .notImplemented:
      return .value(Py.notImplemented)
    case .error(let e):
      return .error(e)
    }
  }
}

*/
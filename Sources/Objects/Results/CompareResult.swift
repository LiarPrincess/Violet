/// Helper type used when implementing compare methods.
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
    case .notImplemented:
      return .notImplemented
    case .error(let e):
      return .error(e)
    }
  }

  internal func toResult(_ py: Py) -> PyResult<PyObject> {
    switch self {
    case .value(let value):
      let bool = value ? py.true : py.false
      return .value(bool.asObject)
    case .notImplemented:
      let value = py.notImplemented
      return .value(value.asObject)
    case .error(let e):
      return .error(e)
    }
  }
}

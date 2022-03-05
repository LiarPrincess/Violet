// TODO: Rename to PyCompareResult

/// Helper type used when implementing compare methods.
public enum CompareResult {
  case value(Bool)
  /// Shortcut for `py.notImplemented`
  case notImplemented
  /// `Zelf` object, expected type, performed operation.
  case invalidSelfArgument(PyObject, String, Operation)
  case error(PyBaseException)

  public enum Operation: String {
    case __eq__ = "__eq__"
    case __ne__ = "__ne__"
    case __lt__ = "__lt__"
    case __le__ = "__le__"
    case __gt__ = "__gt__"
    case __ge__ = "__ge__"
  }

  // swiftlint:disable:next discouraged_optional_boolean
  public init(_ value: Bool?) {
    switch value {
    case .some(let b):
      self = .value(b)
    case .none:
      self = .notImplemented
    }
  }

  public init(_ value: PyResult<Bool>) {
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
  public var not: CompareResult {
    switch self {
    case .value(let bool):
      return .value(!bool)
    case .notImplemented:
      return .notImplemented
    case let .invalidSelfArgument(object, expectedType, operation):
      return .invalidSelfArgument(object, expectedType, operation)
    case .error(let e):
      return .error(e)
    }
  }

  public func toResult(_ py: Py) -> PyResult<PyObject> {
    switch self {
    case .value(let value):
      let bool = value ? py.true : py.false
      return .value(bool.asObject)
    case .notImplemented:
      let value = py.notImplemented
      return .value(value.asObject)
    case let .invalidSelfArgument(object, expectedType, operation):
      let error = py.newInvalidSelfArgumentError(object: object,
                                                 expectedType: expectedType,
                                                 fnName: operation.rawValue)
      return .error(error.asBaseException)
    case .error(let e):
      return .error(e)
    }
  }
}

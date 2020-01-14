public enum CompareResult {
  case value(Bool)
  case error(PyErrorEnum)
  case notImplemented

  // swiftlint:disable:next discouraged_optional_boolean
  internal init(_ value: Bool?) {
    switch value {
    case .some(let b):
      self = .value(b)
    case .none:
      self = .notImplemented
    }
  }
}

extension CompareResult: PyFunctionResultConvertible {
  internal func toFunctionResult(in context: PyContext) -> PyFunctionResult {
    switch self {
    case .value(let bool):
      return bool.toFunctionResult(in: context)
    case .error(let e):
      return .error(e)
    case .notImplemented:
      return .value(context.builtins.notImplemented)
    }
  }
}

extension PyResult where V == Bool {
  public var asCompareResult: CompareResult {
    switch self {
    case let .value(v):
      return .value(v)
    case let .error(e):
      return .error(e)
    }
  }
}

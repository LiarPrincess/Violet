public enum HashResult {
  case value(PyHash)
  case error(PyErrorEnum)
  case notImplemented
}

extension HashResult: FunctionResultConvertible {
  internal func toFunctionResult(in context: PyContext) -> FunctionResult {
    switch self {
    case .value(let hash):
      return hash.toFunctionResult(in: context)
    case .error(let e):
      return .error(e)
    case .notImplemented:
      return .value(context.builtins.notImplemented)
    }
  }
}

extension PyResult where V == PyHash {
  public var asHashResult: HashResult {
    switch self {
    case let .value(v):
      return .value(v)
    case let .error(e):
      return .error(e)
    }
  }
}

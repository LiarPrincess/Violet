public enum HashResult {
  case value(PyHash)
  case error(PyBaseException)
  case notImplemented
}

extension HashResult: PyFunctionResultConvertible {
  internal var asFunctionResult: PyFunctionResult {
    switch self {
    case .value(let hash):
      return hash.asFunctionResult
    case .error(let e):
      return .error(e)
    case .notImplemented:
      return .value(Py.notImplemented)
    }
  }
}

extension PyResult where Wrapped == PyHash {
  public var asHashResult: HashResult {
    switch self {
    case let .value(v):
      return .value(v)
    case let .error(e):
      return .error(e)
    }
  }
}

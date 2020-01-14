internal enum NotEqualHelper {
  internal static func fromIsEqual(_ isEqual: CompareResult) -> CompareResult {
    switch isEqual {
    case let .value(b): return .value(!b)
    case let .error(e): return .error(e)
    case .notImplemented: return .notImplemented
    }
  }
}

internal enum NotEqualHelper {
  internal static func fromIsEqual(_ isEqual: EquatableResult) -> EquatableResult {
    switch isEqual {
    case let .value(b): return .value(!b)
    case let .error(msg): return .error(msg)
    case .notImplemented: return .notImplemented
    }
  }
}

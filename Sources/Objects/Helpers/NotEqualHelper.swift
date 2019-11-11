internal enum NotEqualHelper {
  internal static func fromIsEqual(_ isEqual: PyResultOrNot<Bool>)
    -> PyResultOrNot<Bool> {

    switch isEqual {
    case let .value(b): return .value(!b)
    case let .error(e): return .error(e)
    case .notImplemented: return .notImplemented
    }
  }
}

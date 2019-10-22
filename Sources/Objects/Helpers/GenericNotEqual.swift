internal protocol GenericNotEqual {
  func isEqual(_ other: PyObject) -> EquatableResult
}

extension GenericNotEqual {
  func genericIsNotEqual(_ other: PyObject) -> EquatableResult {
    switch self.isEqual(other) {
    case let .value(b): return .value(!b)
    case let .error(msg): return .error(msg)
    case .notImplemented: return .notImplemented
    }
  }
}

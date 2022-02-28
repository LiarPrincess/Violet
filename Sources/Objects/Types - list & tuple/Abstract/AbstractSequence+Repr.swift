/* MARKER
extension AbstractSequence {

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  internal func _joinElementsForRepr() -> PyResult<String> {
    var result = ""
    for element in self.elements {
      if !result.isEmpty {
        result += ", "
      }

      switch Py.reprString(object: element) {
      case let .value(s): result.append(s)
      case let .error(e): return .error(e)
      }
    }

    return .value(result)
  }
}

*/
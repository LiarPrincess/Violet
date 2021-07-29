extension AbstractSet {

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _joinElementsForRepr() -> PyResult<String> {
    var result = ""

    for element in self.elements {
      if !result.isEmpty {
        result.append(", ")
      }

      switch Py.reprString(object: element.object) {
      case let .value(s): result.append(s)
      case let .error(e): return .error(e)
      }
    }

    return .value(result)
  }
}

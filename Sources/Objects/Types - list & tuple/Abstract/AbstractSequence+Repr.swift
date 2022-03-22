extension AbstractSequence {

  internal static func abstractJoinElementsForRepr(
    _ py: Py,
    zelf: Self,
    prefix: String,
    suffix: String
  ) -> PyResultGen<String> {
    var result = prefix
    for element in zelf.elements {
      if !result.isEmpty {
        result.append(", ")
      }

      switch py.reprString(object: element) {
      case let .value(s): result.append(s)
      case let .error(e): return .error(e)
      }
    }

    result.append(suffix)
    return .value(result)
  }
}

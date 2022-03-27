extension AbstractSequence {

  internal static func abstractJoinElementsForRepr(
    _ py: Py,
    zelf: Self,
    prefix: String,
    suffix: String
  ) -> PyResultGen<String> {
    var result = prefix
    for (index, element) in zelf.elements.enumerated() {
      if index != 0 {
        result.append(", ")
      }

      switch py.reprString(element) {
      case let .value(s): result.append(s)
      case let .error(e): return .error(e)
      }
    }

    result.append(suffix)
    return .value(result)
  }
}

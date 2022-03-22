extension AbstractSequence {

  internal static func abstractJoinElementsForRepr(_ py: Py,
                                                   zelf: Self) -> PyResultGen<String> {
    var result = ""
    for element in zelf.elements {
      if !result.isEmpty {
        result += ", "
      }

      switch py.reprString(object: element) {
      case let .value(s): result.append(s)
      case let .error(e): return .error(e)
      }
    }

    return .value(result)
  }
}

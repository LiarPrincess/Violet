extension AbstractSet {

  internal static func abstractJoinElementsForRepr(_ py: Py,
                                                   zelf: Self) -> PyResult<String> {
    var result = ""

    for element in zelf.elements {
      if !result.isEmpty {
        result.append(", ")
      }

      switch py.reprString(object: element.object) {
      case let .value(s): result.append(s)
      case let .error(e): return .error(e)
      }
    }

    return .value(result)
  }
}

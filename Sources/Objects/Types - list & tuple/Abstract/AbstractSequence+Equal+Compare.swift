private enum FirstNonEqualElements {
  case elements(zelfElement: PyObject, otherElement: PyObject)
  case allEqualUpToShorterCount
  case error(PyBaseException)
}

extension AbstractSequence {

  // MARK: - Equality

  internal static func abstract__eq__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__eq__)
    }

    return Self.isEqual(py, zelf: zelf, other: other)
  }

  internal static func abstract__ne__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__ne__)
    }

    let isEqual = Self.isEqual(py, zelf: zelf, other: other)
    return isEqual.not
  }

  private static func isEqual(_ py: Py, zelf: Self, other: PyObject) -> CompareResult {
    guard let other = Self.downcast(py, other) else {
      return .notImplemented
    }

    guard zelf.count == other.count else {
      return .value(false)
    }

    switch Self.getFirstNotEqualElement(py, zelf: zelf, other: other) {
    case .elements:
      return .value(false)
    case .allEqualUpToShorterCount:
      return .value(true)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Compare

  internal static func abstract__lt__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__lt__)
    }

    guard let other = Self.downcast(py, other) else {
      return .notImplemented
    }

    switch Self.getFirstNotEqualElement(py, zelf: zelf, other: other) {
    case let .elements(zelfElement: l, otherElement: r):
      let result = py.isLessBool(left: l, right: r)
      return CompareResult(result)

    case .allEqualUpToShorterCount:
      let result = zelf.count < other.count
      return CompareResult(result)

    case let .error(e):
      return .error(e)
    }
  }

  internal static func abstract__le__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__le__)
    }

    guard let other = Self.downcast(py, other) else {
      return .notImplemented
    }

    switch Self.getFirstNotEqualElement(py, zelf: zelf, other: other) {
    case let .elements(zelfElement: l, otherElement: r):
      let result = py.isLessEqualBool(left: l, right: r)
      return CompareResult(result)

    case .allEqualUpToShorterCount:
      let result = zelf.count <= other.count
      return CompareResult(result)

    case let .error(e):
      return .error(e)
    }
  }

  internal static func abstract__gt__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__gt__)
    }

    guard let other = Self.downcast(py, other) else {
      return .notImplemented
    }

    switch Self.getFirstNotEqualElement(py, zelf: zelf, other: other) {
    case let .elements(zelfElement: l, otherElement: r):
      let result = py.isGreaterBool(left: l, right: r)
      return CompareResult(result)

    case .allEqualUpToShorterCount:
      let result = zelf.count > other.count
      return CompareResult(result)

    case let .error(e):
      return .error(e)
    }
  }

  internal static func abstract__ge__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__ge__)
    }

    guard let other = Self.downcast(py, other) else {
      return .notImplemented
    }

    switch Self.getFirstNotEqualElement(py, zelf: zelf, other: other) {
    case let .elements(zelfElement: l, otherElement: r):
      let result = py.isGreaterEqualBool(left: l, right: r)
      return CompareResult(result)

    case .allEqualUpToShorterCount:
      let result = zelf.count >= other.count
      return CompareResult(result)

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - First not equal

  private static func getFirstNotEqualElement(_ py: Py,
                                              zelf: Self,
                                              other: Self) -> FirstNonEqualElements {
    for (l, r) in zip(zelf.elements, other.elements) {
      switch py.isEqualBool(left: l, right: r) {
      case .value(true):
        break // go to next element
      case .value(false):
        return .elements(zelfElement: l, otherElement: r)
      case .error(let e):
        return .error(e)
      }
    }

    return .allEqualUpToShorterCount
  }
}

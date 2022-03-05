private enum FirstNonEqualElements {
  case elements(zelfElement: PyObject, otherElement: PyObject)
  case allEqualUpToShorterCount
  case error(PyBaseException)
}

extension AbstractSequence {

  // MARK: - Equality

  internal static func abstract__eq__(_ py: Py,
                                      zelf: PyObject,
                                      other: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castAsSelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf, "__eq__")
    }

    let result = Self.isEqual(py, zelf: zelf, other: other)
    return result.toResult(py)
  }

  internal static func abstract__ne__(_ py: Py,
                                      zelf: PyObject,
                                      other: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castAsSelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf, "__ne__")
    }

    let isEqual = Self.isEqual(py, zelf: zelf, other: other)
    let result = isEqual.not
    return result.toResult(py)
  }

  private static func isEqual(_ py: Py, zelf: Self, other: PyObject) -> CompareResult {
    guard let other = Self.castAsSelf(py, other) else {
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
                                      zelf: PyObject,
                                      other: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castAsSelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf, "__lt__")
    }

    guard let other = Self.castAsSelf(py, other) else {
      return .notImplemented(py)
    }

    switch Self.getFirstNotEqualElement(py, zelf: zelf, other: other) {
    case let .elements(zelfElement: l, otherElement: r):
      let result = py.isLessBool(left: l, right: r)
      return result.asObject(py)

    case .allEqualUpToShorterCount:
      let result = zelf.count < other.count
      return result.toResult(py)

    case let .error(e):
      return .error(e)
    }
  }

  internal static func abstract__le__(_ py: Py,
                                      zelf: PyObject,
                                      other: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castAsSelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf, "__le__")
    }

    guard let other = Self.castAsSelf(py, other) else {
      return .notImplemented(py)
    }

    switch Self.getFirstNotEqualElement(py, zelf: zelf, other: other) {
    case let .elements(zelfElement: l, otherElement: r):
      let result = py.isLessEqualBool(left: l, right: r)
      return result.asObject(py)

    case .allEqualUpToShorterCount:
      let result = zelf.count <= other.count
      return result.toResult(py)

    case let .error(e):
      return .error(e)
    }
  }

  internal static func abstract__gt__(_ py: Py,
                                      zelf: PyObject,
                                      other: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castAsSelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf, "__gt__")
    }

    guard let other = Self.castAsSelf(py, other) else {
      return .notImplemented(py)
    }

    switch Self.getFirstNotEqualElement(py, zelf: zelf, other: other) {
    case let .elements(zelfElement: l, otherElement: r):
      let result = py.isGreaterBool(left: l, right: r)
      return result.asObject(py)

    case .allEqualUpToShorterCount:
      let result = zelf.count > other.count
      return result.toResult(py)

    case let .error(e):
      return .error(e)
    }
  }

  internal static func abstract__ge__(_ py: Py,
                                      zelf: PyObject,
                                      other: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.castAsSelf(py, zelf) else {
      return Self.invalidSelfArgument(py, zelf, "__ge__")
    }

    guard let other = Self.castAsSelf(py, other) else {
      return .notImplemented(py)
    }

    switch Self.getFirstNotEqualElement(py, zelf: zelf, other: other) {
    case let .elements(zelfElement: l, otherElement: r):
      let result = py.isGreaterEqualBool(left: l, right: r)
      return result.asObject(py)

    case .allEqualUpToShorterCount:
      let result = zelf.count >= other.count
      return result.toResult(py)

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

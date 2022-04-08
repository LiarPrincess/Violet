extension AbstractSet {

  // MARK: - Equal

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

    // CPython has different implementation here,
    // but in the end it all comes down to:
    let isEqual = Self.isEqual(py, zelf: zelf, other: other)
    return isEqual.not
  }

  private static func isEqual(_ py: Py, zelf: Self, other: PyObject) -> CompareResult {
    guard let other = py.cast.asAnySet(other) else {
      return .notImplemented
    }

    let otherElements = other.elements

    // Equal count + isSubset -> equal
    guard zelf.count == otherElements.count else {
      return .value(false)
    }

    switch Self.abstractIsSubset(py, zelf: zelf, other: otherElements) {
    case let .value(b): return .value(b)
    case let .error(e): return .error(e)
    }
  }

  // MARK: - Compare

  internal static func abstract__lt__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__lt__)
    }

    guard let other = py.cast.asAnySet(other) else {
      return .notImplemented
    }

    let otherElements = other.elements

    guard zelf.count < otherElements.count else {
      return .value(false)
    }

    switch Self.abstractIsSubset(py, zelf: zelf, other: otherElements) {
    case let .value(b): return .value(b)
    case let .error(e): return .error(e)
    }
  }

  internal static func abstract__le__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__le__)
    }

    guard let other = py.cast.asAnySet(other) else {
      return .notImplemented
    }

    switch Self.abstractIsSubset(py, zelf: zelf, other: other.elements) {
    case let .value(b): return .value(b)
    case let .error(e): return .error(e)
    }
  }

  internal static func abstract__gt__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__gt__)
    }

    guard let other = py.cast.asAnySet(other) else {
      return .notImplemented
    }

    let otherElements = other.elements

    guard zelf.count > otherElements.count else {
      return .value(false)
    }

    switch Self.abstractIsSuperset(py, zelf: zelf, other: otherElements) {
    case let .value(b): return .value(b)
    case let .error(e): return .error(e)
    }
  }

  internal static func abstract__ge__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__ge__)
    }

    guard let other = py.cast.asAnySet(other) else {
      return .notImplemented
    }

    switch Self.abstractIsSuperset(py, zelf: zelf, other: other.elements) {
    case let .value(b): return .value(b)
    case let .error(e): return .error(e)
    }
  }
}

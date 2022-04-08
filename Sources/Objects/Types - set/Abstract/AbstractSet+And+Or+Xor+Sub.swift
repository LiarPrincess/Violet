extension AbstractSet {

  // MARK: - And

  internal static func abstract__and__(_ py: Py,
                                       zelf _zelf: PyObject,
                                       other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__and__")
    }

    return Self.and(py, zelf: zelf, other: other)
  }

  internal static func abstract__rand__(_ py: Py,
                                        zelf _zelf: PyObject,
                                        other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__rand__")
    }

    return Self.and(py, zelf: zelf, other: other)
  }

  private static func and(_ py: Py, zelf: Self, other: PyObject) -> PyResult {
    guard let other = py.cast.asAnySet(other) else {
      return .notImplemented(py)
    }

    switch Self.abstractIntersection(py, lhs: zelf.elements, rhs: other.elements) {
    case let .value(set):
      let result = Self.newObject(py, elements: set)
      return PyResult(result)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Or

  internal static func abstract__or__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__or__")
    }

    return Self.or(py, zelf: zelf, other: other)
  }

  internal static func abstract__ror__(_ py: Py,
                                       zelf _zelf: PyObject,
                                       other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__ror__")
    }

    return Self.or(py, zelf: zelf, other: other)
  }

  private static func or(_ py: Py, zelf: Self, other: PyObject) -> PyResult {
    guard let other = py.cast.asAnySet(other) else {
      return .notImplemented(py)
    }

    switch Self.abstractUnion(py, lhs: zelf.elements, rhs: other.elements) {
    case let .value(set):
      let result = Self.newObject(py, elements: set)
      return PyResult(result)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Xor

  internal static func abstract__xor__(_ py: Py,
                                       zelf _zelf: PyObject,
                                       other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__xor__")
    }

    return Self.xor(py, zelf: zelf, other: other)
  }

  internal static func abstract__rxor__(_ py: Py,
                                        zelf _zelf: PyObject,
                                        other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__rxor__")
    }

    return Self.xor(py, zelf: zelf, other: other)
  }

  private static func xor(_ py: Py, zelf: Self, other: PyObject) -> PyResult {
    guard let other = py.cast.asAnySet(other) else {
      return .notImplemented(py)
    }

    switch self.abstractSymmetricDifference(py, lhs: zelf.elements, rhs: other.elements) {
    case let .value(set):
      let result = Self.newObject(py, elements: set)
      return PyResult(result)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Sub

  internal static func abstract__sub__(_ py: Py,
                                       zelf _zelf: PyObject,
                                       other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__sub__")
    }

    return Self.sub(py, zelf: zelf, other: other)
  }

  internal static func abstract__rsub__(_ py: Py,
                                        zelf _zelf: PyObject,
                                        other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__rsub__")
    }

    return Self.sub(py, zelf: zelf, other: other)
  }

  private static func sub(_ py: Py, zelf: Self, other: PyObject) -> PyResult {
    guard let other = py.cast.asAnySet(other) else {
      return .notImplemented(py)
    }

    switch Self.abstractDifference(py, lhs: zelf.elements, rhs: other.elements) {
    case let .value(set):
      let result = Self.newObject(py, elements: set)
      return PyResult(result)
    case let .error(e):
      return .error(e)
    }
  }
}

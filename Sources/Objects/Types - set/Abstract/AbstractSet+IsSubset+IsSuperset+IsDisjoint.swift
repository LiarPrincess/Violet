extension AbstractSet {

  // MARK: - Subset

  internal static func abstractIsSubset(_ py: Py,
                                        zelf _zelf: PyObject,
                                        other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "issubset")
    }

    switch Self.getElements(py, iterable: other) {
    case let .value(elements):
      let result = Self.abstractIsSubset(py, zelf: zelf, other: elements)
      return PyResult(py, result)
    case let .error(e):
      return .error(e)
    }
  }

  internal static func abstractIsSubset(_ py: Py,
                                        zelf: Self,
                                        other: OrderedSet) -> PyResultGen<Bool> {
    guard zelf.count <= other.count else {
      return .value(false)
    }

    for element in zelf.elements {
      switch other.contains(py, element: element) {
      case .value(true): break // try next
      case .value(false): return .value(false)
      case .error(let e): return .error(e)
      }
    }

    return .value(true)
  }

  // MARK: - Superset

  internal static func abstractIsSuperset(_ py: Py,
                                          zelf _zelf: PyObject,
                                          other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "issuperset")
    }

    switch Self.getElements(py, iterable: other) {
    case let .value(elements):
      let result = Self.abstractIsSuperset(py, zelf: zelf, other: elements)
      return PyResult(py, result)
    case let .error(e):
      return .error(e)
    }
  }

  internal static func abstractIsSuperset(_ py: Py,
                                          zelf: Self,
                                          other: OrderedSet) -> PyResultGen<Bool> {
    guard zelf.count >= other.count else {
      return .value(false)
    }

    for element in other {
      switch zelf.elements.contains(py, element: element) {
      case .value(true): break // try next
      case .value(false): return .value(false)
      case .error(let e): return .error(e)
      }
    }

    return .value(true)
  }

  // MARK: - Is disjoint

  internal static func abstractIsDisjoint(_ py: Py,
                                          zelf _zelf: PyObject,
                                          other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "isdisjoint")
    }

    switch Self.getElements(py, iterable: other) {
    case let .value(elements):
      let result = Self.abstractIsDisjoint(py, zelf: zelf, other: elements)
      return PyResult(py, result)
    case let .error(e):
      return .error(e)
    }
  }

  private static func abstractIsDisjoint(_ py: Py,
                                         zelf: Self,
                                         other: OrderedSet) -> PyResultGen<Bool> {
    let isSelfSmaller = zelf.count < other.count
    let smaller = isSelfSmaller ? zelf.elements : other
    let bigger = isSelfSmaller ? other : zelf.elements

    for element in smaller {
      switch bigger.contains(py, element: element) {
      case .value(true): return .value(false)
      case .value(false): break
      case .error(let e): return .error(e)
      }
    }

    return .value(true)
  }
}

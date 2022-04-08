extension AbstractSet {

  // MARK: - Intersection

  internal static func abstractIntersection(_ py: Py,
                                            zelf _zelf: PyObject,
                                            other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "intersection")
    }

    switch Self.getElements(py, iterable: other) {
    case let .value(elements):
      switch Self.abstractIntersection(py, lhs: zelf.elements, rhs: elements) {
      case let .value(set):
        let result = Self.newObject(py, elements: set)
        return PyResult(result)
      case let .error(e):
        return .error(e)
      }

    case let .error(e):
      return .error(e)
    }
  }

  internal static func abstractIntersection(_ py: Py,
                                            lhs: OrderedSet,
                                            rhs: OrderedSet) -> PyResultGen<OrderedSet> {
    let isLhsSmaller = lhs.count < rhs.count
    let smaller = isLhsSmaller ? lhs : rhs
    let bigger = isLhsSmaller ? rhs : lhs

    var result = OrderedSet()
    for element in smaller {
      switch bigger.contains(py, element: element) {
      case .value(true):
        switch result.insert(py, element: element) {
        case .inserted,
            .updated:
          break
        case .error(let e):
          return .error(e)
        }

      case .value(false):
        break
      case .error(let e):
        return .error(e)
      }
    }

    return .value(result)
  }

  // MARK: - Union

  internal static func abstractUnion(_ py: Py,
                                     zelf _zelf: PyObject,
                                     other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "union")
    }

    switch Self.getElements(py, iterable: other) {
    case let .value(elements):
      switch Self.abstractUnion(py, lhs: zelf.elements, rhs: elements) {
      case let .value(set):
        let result = Self.newObject(py, elements: set)
        return PyResult(result)
      case let .error(e):
        return .error(e)
      }

    case let .error(e):
      return .error(e)
    }
  }

  internal static func abstractUnion(_ py: Py,
                                     lhs: OrderedSet,
                                     rhs: OrderedSet) -> PyResultGen<OrderedSet> {
    let isLhsSmaller = lhs.count < rhs.count
    let smaller = isLhsSmaller ? lhs : rhs
    let bigger = isLhsSmaller ? rhs : lhs

    var result = bigger
    for element in smaller {
      switch result.insert(py, element: element) {
      case .inserted,
          .updated:
        break
      case .error(let e):
        return .error(e)
      }
    }

    return .value(result)
  }

  // MARK: - Difference

  internal static func abstractDifference(_ py: Py,
                                          zelf _zelf: PyObject,
                                          other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "difference")
    }

    switch Self.getElements(py, iterable: other) {
    case let .value(elements):
      switch Self.abstractDifference(py, lhs: zelf.elements, rhs: elements) {
      case let .value(set):
        let result = Self.newObject(py, elements: set)
        return PyResult(result)

      case let .error(e):
        return .error(e)
      }
    case let .error(e):
      return .error(e)
    }
  }

  internal static func abstractDifference(_ py: Py,
                                          lhs: OrderedSet,
                                          rhs: OrderedSet) -> PyResultGen<OrderedSet> {
    var result = OrderedSet()

    for element in lhs {
      switch rhs.contains(py, element: element) {
      case .value(true):
        break

      case .value(false):
        switch result.insert(py, element: element) {
        case .inserted,
            .updated:
          break
        case .error(let e):
          return .error(e)
        }

      case .error(let e):
        return .error(e)
      }
    }

    return .value(result)
  }

  // MARK: - Symmetric difference

  internal static func abstractSymmetricDifference(_ py: Py,
                                                   zelf _zelf: PyObject,
                                                   other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "symmetric_difference")
    }

    switch Self.getElements(py, iterable: other) {
    case let .value(elements):
      switch Self.abstractSymmetricDifference(py, lhs: zelf.elements, rhs: elements) {
      case let .value(set):
        let result = Self.newObject(py, elements: set)
        return PyResult(result)
      case let .error(e):
        return .error(e)
      }

    case let .error(e):
      return .error(e)
    }
  }

  internal static func abstractSymmetricDifference(_ py: Py,
                                                   lhs: OrderedSet,
                                                   rhs: OrderedSet) -> PyResultGen<OrderedSet> {
    var result = OrderedSet()

    for element in lhs {
      switch rhs.contains(py, element: element) {
      case .value(true):
        break
      case .value(false):
        switch result.insert(py, element: element) {
        case .inserted,
            .updated:
          break
        case .error(let e):
          return .error(e)
        }
      case .error(let e):
        return .error(e)
      }
    }

    for element in rhs {
      switch lhs.contains(py, element: element) {
      case .value(true):
        break
      case .value(false):
        switch result.insert(py, element: element) {
        case .inserted,
            .updated:
          break
        case .error(let e):
          return .error(e)
        }
      case .error(let e):
        return .error(e)
      }
    }

    return .value(result)
  }
}

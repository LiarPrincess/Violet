extension AbstractSet {

  // MARK: - Intersection

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _intersection(with other: PyObject) -> PyResult<PyObject> {
    switch Self._getElements(iterable: other) {
    case let .value(elements):
      switch self._intersection(lhs: self.elements, rhs: elements) {
      case let .value(set):
        let result = Self._toSelf(elements: set)
        return .value(result)
      case let .error(e):
        return .error(e)
      }

    case let .error(e):
      return .error(e)
    }
  }

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _intersection(lhs: OrderedSet,
                              rhs: OrderedSet) -> PyResult<OrderedSet> {
    let isLhsSmaller = lhs.count < rhs.count
    let smaller = isLhsSmaller ? lhs : rhs
    let bigger = isLhsSmaller ? rhs : lhs

    var result = OrderedSet()
    for element in smaller {
      switch bigger.contains(element: element) {
      case .value(true):
        switch result.insert(element: element) {
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

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _union(with other: PyObject) -> PyResult<PyObject> {
    switch Self._getElements(iterable: other) {
    case let .value(elements):
      switch self._union(lhs: self.elements, rhs: elements) {
      case let .value(set):
        let result = Self._toSelf(elements: set)
        return .value(result)
      case let .error(e):
        return .error(e)
      }

    case let .error(e):
      return .error(e)
    }
  }

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _union(lhs: OrderedSet,
                       rhs: OrderedSet) -> PyResult<OrderedSet> {
    let isLhsSmaller = lhs.count < rhs.count
    let smaller = isLhsSmaller ? lhs : rhs
    let bigger = isLhsSmaller ? rhs : lhs

    var result = bigger
    for element in smaller {
      switch result.insert(element: element) {
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

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _difference(with other: PyObject) -> PyResult<PyObject> {
    switch Self._getElements(iterable: other) {
    case let .value(elements):
      switch self._difference(lhs: self.elements, rhs: elements) {
      case let .value(set):
        let result = Self._toSelf(elements: set)
        return .value(result)

      case let .error(e):
        return .error(e)
      }
    case let .error(e):
      return .error(e)
    }
  }

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _difference(lhs: OrderedSet,
                            rhs: OrderedSet) -> PyResult<OrderedSet> {
    var result = OrderedSet()

    for element in lhs {
      switch rhs.contains(element: element) {
      case .value(true):
        break

      case .value(false):
        switch result.insert(element: element) {
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

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _symmetricDifference(with other: PyObject) -> PyResult<PyObject> {
    switch Self._getElements(iterable: other) {
    case let .value(elements):
      switch self._symmetricDifference(lhs: self.elements, rhs: elements) {
      case let .value(set):
        let result = Self._toSelf(elements: set)
        return .value(result)
      case let .error(e):
        return .error(e)
      }

    case let .error(e):
      return .error(e)
    }
  }

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _symmetricDifference(lhs: OrderedSet,
                                     rhs: OrderedSet) -> PyResult<OrderedSet> {
    var result = OrderedSet()

    for element in lhs {
      switch rhs.contains(element: element) {
      case .value(true):
        break
      case .value(false):
        switch result.insert(element: element) {
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
      switch lhs.contains(element: element) {
      case .value(true):
        break
      case .value(false):
        switch result.insert(element: element) {
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

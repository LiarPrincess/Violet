extension AbstractSet {

  // MARK: - Subset

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _isSubset(of other: PyObject) -> PyResult<Bool> {
    switch Self._getElements(iterable: other) {
    case let .value(elements):
      return self._isSubset(of: elements)
    case let .error(e):
      return .error(e)
    }
  }

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _isSubset(of other: OrderedSet) -> PyResult<Bool> {
    guard self._count <= other.count else {
      return .value(false)
    }

    for element in self.elements {
      switch other.contains(element: element) {
      case .value(true): break // try next
      case .value(false): return .value(false)
      case .error(let e): return .error(e)
      }
    }

    return .value(true)
  }

  // MARK: - Superset

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _isSuperset(of other: PyObject) -> PyResult<Bool> {
    switch Self._getElements(iterable: other) {
    case let .value(elements):
      return self._isSuperset(of: elements)
    case let .error(e):
      return .error(e)
    }
  }

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _isSuperset(of other: OrderedSet) -> PyResult<Bool> {
    guard self._count >= other.count else {
      return .value(false)
    }

    for element in other {
      switch self.elements.contains(element: element) {
      case .value(true): break // try next
      case .value(false): return .value(false)
      case .error(let e): return .error(e)
      }
    }

    return .value(true)
  }

  // MARK: - Is disjoint

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _isDisjoint(with other: PyObject) -> PyResult<Bool> {
    switch Self._getElements(iterable: other) {
    case let .value(elements):
      return self._isDisjoint(with: elements)
    case let .error(e):
      return .error(e)
    }
  }

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  private func _isDisjoint(with other: OrderedSet) -> PyResult<Bool> {
    let isSelfSmaller = self._count < other.count
    let smaller = isSelfSmaller ? self.elements : other
    let bigger = isSelfSmaller ? other : self.elements

    for element in smaller {
      switch bigger.contains(element: element) {
      case .value(true): return .value(false)
      case .value(false): break
      case .error(let e): return .error(e)
      }
    }

    return .value(true)
  }
}

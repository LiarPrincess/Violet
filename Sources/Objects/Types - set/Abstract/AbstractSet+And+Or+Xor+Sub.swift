/* MARKER
extension AbstractSet {

  // MARK: - And

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _and(other: PyObject) -> PyResult<PyObject> {
    guard let other = PyCast.asAnySet(other) else {
      return .value(Py.notImplemented)
    }

    switch self._intersection(lhs: self.elements, rhs: other.elements) {
    case let .value(set):
      let result = Self._toSelf(elements: set)
      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _rand(other: PyObject) -> PyResult<PyObject> {
    return self._and(other: other)
  }

  // MARK: - Or

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _or(other: PyObject) -> PyResult<PyObject> {
    guard let other = PyCast.asAnySet(other) else {
      return .value(Py.notImplemented)
    }

    switch self._union(lhs: self.elements, rhs: other.elements) {
    case let .value(set):
      let result = Self._toSelf(elements: set)
      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _ror(other: PyObject) -> PyResult<PyObject> {
    return self._or(other: other)
  }

  // MARK: - Xor

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _xor(other: PyObject) -> PyResult<PyObject> {
    guard let other = PyCast.asAnySet(other) else {
      return .value(Py.notImplemented)
    }

    switch self._symmetricDifference(lhs: self.elements, rhs: other.elements) {
    case let .value(set):
      let result = Self._toSelf(elements: set)
      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _rxor(other: PyObject) -> PyResult<PyObject> {
    return self._xor(other: other)
  }

  // MARK: - Sub

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _sub(other: PyObject) -> PyResult<PyObject> {
    guard let other = PyCast.asAnySet(other) else {
      return .value(Py.notImplemented)
    }

    return self._sub(lhs: self.elements, rhs: other.elements)
  }

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _rsub(other: PyObject) -> PyResult<PyObject> {
    guard let other = PyCast.asAnySet(other) else {
      return .value(Py.notImplemented)
    }

    return self._sub(lhs: other.elements, rhs: self.elements)
  }

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  private func _sub(lhs: OrderedSet, rhs: OrderedSet) -> PyResult<PyObject> {
    switch self._difference(lhs: lhs, rhs: rhs) {
    case let .value(set):
      let result = Self._toSelf(elements: set)
      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }
}

*/
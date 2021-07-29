extension AbstractSet {

  // MARK: - Equal

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _isEqual(other: PyObject) -> CompareResult {
    guard let other = PyCast.asAnySet(other) else {
      return .notImplemented
    }

    let otherElements = other.elements

    // Equal count + isSubset -> equal
    guard self._count == otherElements.count else {
      return .value(false)
    }

    switch self._isSubset(of: otherElements) {
    case let .value(b): return .value(b)
    case let .error(e): return .error(e)
    }
  }

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _isNotEqual(other: PyObject) -> CompareResult {
    // CPython has different implementation here,
    // but in the end it all comes down to:
    return self._isEqual(other: other).not
  }

  // MARK: - Compare

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _isLess(other: PyObject) -> CompareResult {
    guard let other = PyCast.asAnySet(other) else {
      return .notImplemented
    }

    let otherElements = other.elements

    guard self._count < otherElements.count else {
      return .value(false)
    }

    switch self._isSubset(of: otherElements) {
    case let .value(b): return .value(b)
    case let .error(e): return .error(e)
    }
  }

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _isLessEqual(other: PyObject) -> CompareResult {
    guard let other = PyCast.asAnySet(other) else {
      return .notImplemented
    }

    switch self._isSubset(of: other.elements) {
    case let .value(b): return .value(b)
    case let .error(e): return .error(e)
    }
  }

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _isGreater(other: PyObject) -> CompareResult {
    guard let other = PyCast.asAnySet(other) else {
      return .notImplemented
    }

    let otherElements = other.elements

    guard self._count > otherElements.count else {
      return .value(false)
    }

    switch self._isSuperset(of: otherElements) {
    case let .value(b): return .value(b)
    case let .error(e): return .error(e)
    }
  }

  /// DO NOT USE! This is a part of `AbstractSet` implementation.
  internal func _isGreaterEqual(other: PyObject) -> CompareResult {
    guard let other = PyCast.asAnySet(other) else {
      return .notImplemented
    }

    switch self._isSuperset(of: other.elements) {
    case let .value(b): return .value(b)
    case let .error(e): return .error(e)
    }
  }
}

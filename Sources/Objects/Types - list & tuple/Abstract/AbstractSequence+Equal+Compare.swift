/* MARKER
extension AbstractSequence {

  // MARK: - Equal

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  internal func _isEqual(other: PyObject) -> CompareResult {
    if self === other {
      return .value(true)
    }

    guard let otherAsSelf = Self._asSelf(object: other) else {
      return .notImplemented
    }

    let result = self._isEqual(other: otherAsSelf)
    return CompareResult(result)
  }

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  internal func _isEqual(other: Self) -> PyResult<Bool> {
    guard self._length == other.elements.count else {
      return .value(false)
    }

    for (l, r) in zip(self.elements, other.elements) {
      switch Py.isEqualBool(left: l, right: r) {
      case .value(true): break // go to next element
      case .value(false): return .value(false)
      case .error(let e): return .error(e)
      }
    }

    return .value(true)
  }

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  internal func _isNotEqual(other: PyObject) -> CompareResult {
    return self._isEqual(other: other).not
  }

  // MARK: - Compare

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  internal func _isLess(other: PyObject) -> CompareResult {
    guard let otherAsSelf = Self._asSelf(object: other) else {
      return .notImplemented
    }

    let otherElements = otherAsSelf.elements

    switch self._getFirstNotEqualElement(with: otherElements) {
    case let .elements(selfElement: l, otherElement: r):
      let result = Py.isLessBool(left: l, right: r)
      return CompareResult(result)
    case .allEqualUpToShorterCount:
      return .value(self._length < otherElements.count)
    case let .error(e):
      return .error(e)
    }
  }

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  internal func _isLessEqual(other: PyObject) -> CompareResult {
    guard let otherAsSelf = Self._asSelf(object: other) else {
      return .notImplemented
    }

    let otherElements = otherAsSelf.elements

    switch self._getFirstNotEqualElement(with: otherElements) {
    case let .elements(selfElement: l, otherElement: r):
      let result = Py.isLessEqualBool(left: l, right: r)
      return CompareResult(result)
    case .allEqualUpToShorterCount:
      return .value(self._length <= otherElements.count)
    case let .error(e):
      return .error(e)
    }
  }

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  internal func _isGreater(other: PyObject) -> CompareResult {
    guard let otherAsSelf = Self._asSelf(object: other) else {
      return .notImplemented
    }

    let otherElements = otherAsSelf.elements

    switch self._getFirstNotEqualElement(with: otherElements) {
    case let .elements(selfElement: l, otherElement: r):
      let result = Py.isGreaterBool(left: l, right: r)
      return CompareResult(result)
    case .allEqualUpToShorterCount:
      return .value(self._length > otherElements.count)
    case let .error(e):
      return .error(e)
    }
  }

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  internal func _isGreaterEqual(other: PyObject) -> CompareResult {
    guard let otherAsSelf = Self._asSelf(object: other) else {
      return .notImplemented
    }

    let otherElements = otherAsSelf.elements

    switch self._getFirstNotEqualElement(with: otherElements) {
    case let .elements(selfElement: l, otherElement: r):
      let result = Py.isGreaterEqualBool(left: l, right: r)
      return CompareResult(result)
    case .allEqualUpToShorterCount:
      return .value(self._length >= otherElements.count)
    case let .error(e):
      return .error(e)
    }
  }
}

// MARK: - FirstNotEqualElements

private enum FirstNonEqualElements {
  case elements(selfElement: PyObject, otherElement: PyObject)
  case allEqualUpToShorterCount
  case error(PyBaseException)
}

extension AbstractSequence {

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  private func _getFirstNotEqualElement(
    with elements: Elements
  ) -> FirstNonEqualElements {
    for (l, r) in zip(self.elements, elements) {
      switch Py.isEqualBool(left: l, right: r) {
      case .value(true):
        break // go to next element
      case .value(false):
        return .elements(selfElement: l, otherElement: r)
      case .error(let e):
        return .error(e)
      }
    }

    return .allEqualUpToShorterCount
  }
}

*/
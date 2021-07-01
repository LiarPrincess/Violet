import VioletCore

// swiftlint:disable:next type_name
private enum AbstractString_CompareResult: Equatable {
  case less
  case greater
  case equal

  fileprivate var isEqual: Bool { self == .equal }
  fileprivate var isLess: Bool { self == .less }
  fileprivate var isLessEqual: Bool { self == .less || self == .equal }
  fileprivate var isGreater: Bool { self == .greater }
  fileprivate var isGreaterEqual: Bool { self == .greater || self == .equal }
}

extension AbstractString {

  // MARK: - Equal

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isEqual(other: PyObject) -> CompareResult {
    if self === other {
      return .value(true)
    }

    let result = self._compare(other: other)
    return CompareResult(result?.isEqual)
  }

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isEqual(other: Self) -> Bool {
    if self === other {
      return true
    }

    let result = self._compare(other: other.elements)
    return result.isEqual
  }

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isEqual(other: Elements) -> Bool {
    let result = self._compare(other: other)
    return result.isEqual
  }

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isNotEqual(other: PyObject) -> CompareResult {
    return self._isEqual(other: other).not
  }

  // MARK: - Compare

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isLess(other: PyObject) -> CompareResult {
    let result = self._compare(other: other)
    return CompareResult(result?.isLess)
  }

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isLessEqual(other: PyObject) -> CompareResult {
    let result = self._compare(other: other)
    return CompareResult(result?.isLessEqual)
  }

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isGreater(other: PyObject) -> CompareResult {
    let result = self._compare(other: other)
    return CompareResult(result?.isGreater)
  }

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isGreaterEqual(other: PyObject) -> CompareResult {
    let result = self._compare(other: other)
    return CompareResult(result?.isGreaterEqual)
  }

  // MARK: - Helpers

  private func _compare(other: PyObject) -> AbstractString_CompareResult? {
    guard let otherElements = Self._getElements(object: other) else {
      return nil
    }

    return self._compare(other: otherElements)
  }

  private func _compare(other: Elements) -> AbstractString_CompareResult {
    // We need to compare on scalars
    // "Cafe\u0301" (e + acute accent) == "Café" (e with acute) -> False
    // "Cafe\u0301" (e + acute accent) <  "Café" (e with acute) -> True

    var selfIter = self.elements.makeIterator()
    var otherIter = other.makeIterator()

    var selfValue = selfIter.next()
    var otherValue = otherIter.next()

    while let s = selfValue, let o = otherValue {
      if s < o {
        return .less
      }

      if s > o {
        return .greater
      }

      selfValue = selfIter.next()
      otherValue = otherIter.next()
    }

    // One (or both) of the values is nil (which means that we arrived to end)
    switch (selfValue, otherValue) {
    case (nil, nil): return .equal // Both at end
    case (nil, _): return .less // Finished self, other has some remaining
    case (_, nil): return .greater // Finished other, self has some remaining
    default:
      // Not possible? See `while` condition.
      trap("Error when comparing '\(self.elements)' and '\(other)'")
    }
  }
}

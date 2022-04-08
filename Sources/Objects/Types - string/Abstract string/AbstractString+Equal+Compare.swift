import VioletCore

private enum AbstractStringCompareResult: Equatable {
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

  // MARK: - Equality

  internal static func abstract__eq__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__eq__)
    }

    return Self.abstractIsEqual(py, zelf: zelf, other: other)
  }

  internal static func abstract__ne__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__ne__)
    }

    let isEqual = Self.abstractIsEqual(py, zelf: zelf, other: other)
    return isEqual.not
  }

  private static func abstractIsEqual(_ py: Py,
                                      zelf: Self,
                                      other: PyObject) -> CompareResult {
    if zelf.ptr === other.ptr {
      return .value(true)
    }

    guard let otherElements = Self.getElements(py, object: other) else {
      return .notImplemented
    }

    let isEqual = Self.abstractIsEqual(zelf: zelf, other: otherElements)
    return CompareResult(isEqual)
  }

  internal static func abstractIsEqual(zelf: Self, other: Elements) -> Bool {
    guard zelf.count == other.count else {
      return false
    }

    let result = Self.compare(zelf: zelf, other: other)
    return result.isEqual
  }

  // MARK: - Compare

  internal static func abstract__lt__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__lt__)
    }

    let result = Self.compare(py, zelf: zelf, other: other)
    return CompareResult(result?.isLess)
  }

  internal static func abstract__le__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__le__)
    }

    let result = Self.compare(py, zelf: zelf, other: other)
    return CompareResult(result?.isLessEqual)
  }

  internal static func abstract__gt__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__gt__)
    }

    let result = Self.compare(py, zelf: zelf, other: other)
    return CompareResult(result?.isGreater)
  }

  internal static func abstract__ge__(_ py: Py,
                                      zelf _zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__ge__)
    }

    let result = Self.compare(py, zelf: zelf, other: other)
    return CompareResult(result?.isGreaterEqual)
  }

  // MARK: - Helpers

  private static func compare(_ py: Py,
                              zelf: Self,
                              other: PyObject) -> AbstractStringCompareResult? {
    guard let otherElements = Self.getElements(py, object: other) else {
      return nil
    }

    return Self.compare(zelf: zelf, other: otherElements)
  }

  private static func compare(zelf: Self,
                              other: Elements) -> AbstractStringCompareResult {
    // We need to compare on scalars
    // "Cafe\u0301" (e + acute accent) == "Café" (e with acute) -> False
    // "Cafe\u0301" (e + acute accent) <  "Café" (e with acute) -> True

    var selfIter = zelf.elements.makeIterator()
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
      trap("Error when comparing '\(zelf.elements)' and '\(other)'")
    }
  }
}

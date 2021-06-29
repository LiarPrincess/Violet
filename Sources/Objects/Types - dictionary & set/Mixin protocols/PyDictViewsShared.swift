import BigInt
import VioletCore

/// Shared methods for various `PyDict` views.
internal protocol PyDictViewsShared: PyObject {
  var dict: PyDict { get }
}

extension PyDictViewsShared {

  internal var elements: PyDict.OrderedDictionary {
    return self.dict.elements
  }

  // MARK: - Equatable

  internal func isEqualShared(_ other: PyObject) -> CompareResult {
    guard let size = self.getDictOrSetSize(other) else {
      return .notImplemented
    }

    guard self.elements.count == size else {
      return .value(false)
    }

    return Py.contains(iterable: self, allFrom: other).asCompareResult
  }

  internal func isNotEqualShared(_ other: PyObject) -> CompareResult {
    return self.isEqualShared(other).not
  }

  // MARK: - Comparable

  internal func isLessShared(_ other: PyObject) -> CompareResult {
    guard let size = self.getDictOrSetSize(other) else {
      return .notImplemented
    }

    guard self.elements.count < size else {
      return .value(false)
    }

    return Py.contains(iterable: other, allFrom: self).asCompareResult
  }

  internal func isLessEqualShared(_ other: PyObject) -> CompareResult {
    guard let size = self.getDictOrSetSize(other) else {
      return .notImplemented
    }

    guard self.elements.count <= size else {
      return .value(false)
    }

    return Py.contains(iterable: other, allFrom: self).asCompareResult
  }

  internal func isGreaterShared(_ other: PyObject) -> CompareResult {
    guard let size = self.getDictOrSetSize(other) else {
      return .notImplemented
    }

    guard self.elements.count > size else {
      return .value(false)
    }

    return Py.contains(iterable: self, allFrom: other).asCompareResult
  }

  internal func isGreaterEqualShared(_ other: PyObject) -> CompareResult {
    guard let size = self.getDictOrSetSize(other) else {
      return .notImplemented
    }

    guard self.elements.count >= size else {
      return .value(false)
    }

    return Py.contains(iterable: self, allFrom: other).asCompareResult
  }

  private func getDictOrSetSize(_ other: PyObject) -> Int? {
    if let set = PyCast.asAnySet(other) {
      return set.data.count
    }

    if let dict = PyCast.asDict(other) {
      return dict.elements.count
    }

    return nil
  }

  // MARK: - Hashable

  internal func hashShared() -> HashResult {
    return .error(Py.hashNotImplemented(self))
  }

  // MARK: - String

  internal func reprShared(typeName: String) -> PyResult<String> {
    if self.hasReprLock {
      return .value("...")
    }

    return self.withReprLock {
      var result = typeName + "("
      for (index, element) in self.dict.elements.enumerated() {
        if index > 0 {
          result += ", " // so that we don't have ', )'.
        }

        switch Py.repr(object: element.key.object) {
        case let .value(s): result += s
        case let .error(e): return .error(e)
        }
      }

      result += ")"
      return .value(result)
    }
  }

  // MARK: - Length

  internal func getLengthShared() -> BigInt {
    return BigInt(self.elements.count)
  }
}
import VioletCore

/// Shared methods for various `PyDict` views.
internal protocol PyDictViewsShared: PyObject {
  var dict: PyDict { get }
}

extension PyDictViewsShared {

  internal var data: PyDictData {
    return self.dict.data
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqualShared(_ other: PyObject) -> CompareResult {
    guard let size = self.getSetOrDictSize(other) else {
      return .notImplemented
    }

    guard self.data.count == size else {
      return .value(false)
    }

    return Py.contains(iterable: self, allFrom: other).asCompareResult
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqualShared(_ other: PyObject) -> CompareResult {
    return self.isEqualShared(other).not
  }

  // MARK: - Comparable

  internal func isLessShared(_ other: PyObject) -> CompareResult {
    guard let size = self.getSetOrDictSize(other) else {
      return .notImplemented
    }

    guard self.data.count < size else {
      return .value(false)
    }

    return Py.contains(iterable: other, allFrom: self).asCompareResult
  }

  internal func isLessEqualShared(_ other: PyObject) -> CompareResult {
    guard let size = self.getSetOrDictSize(other) else {
      return .notImplemented
    }

    guard self.data.count <= size else {
      return .value(false)
    }

    return Py.contains(iterable: other, allFrom: self).asCompareResult
  }

  internal func isGreaterShared(_ other: PyObject) -> CompareResult {
    guard let size = self.getSetOrDictSize(other) else {
      return .notImplemented
    }

    guard self.data.count > size else {
      return .value(false)
    }

    return Py.contains(iterable: self, allFrom: other).asCompareResult
  }

  internal func isGreaterEqualShared(_ other: PyObject) -> CompareResult {
    guard let size = self.getSetOrDictSize(other) else {
      return .notImplemented
    }

    guard self.data.count >= size else {
      return .value(false)
    }

    return Py.contains(iterable: self, allFrom: other).asCompareResult
  }

  private func getSetOrDictSize(_ other: PyObject) -> Int? {
    if let set = other as? PySetType {
      return set.data.count
    }

    if let dict = other as? PyDict {
      return dict.data.count
    }

    return nil
  }

  // MARK: - String

  internal func reprShared(typeName: String) -> PyResult<String> {
    if self.hasReprLock {
      return .value("...")
    }

    return self.withReprLock {
      var result = typeName + "("
      for (index, element) in self.dict.data.enumerated() {
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
}

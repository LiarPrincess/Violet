import Core

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
  internal func isEqualShared(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let size = self.getSetOrDictSize(other) else {
      return .notImplemented
    }

    guard self.data.count == size else {
      return .value(false)
    }

    return self.builtins.contains(iterable: self, allFrom: other).asResultOrNot
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqualShared(_ other: PyObject) -> PyResultOrNot<Bool> {
    return NotEqualHelper.fromIsEqual(self.isEqualShared(other))
  }

  // MARK: - Comparable

  internal func isLessShared(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let size = self.getSetOrDictSize(other) else {
      return .notImplemented
    }

    guard self.data.count < size else {
      return .value(false)
    }

    return self.builtins.contains(iterable: other, allFrom: self).asResultOrNot
  }

  internal func isLessEqualShared(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let size = self.getSetOrDictSize(other) else {
      return .notImplemented
    }

    guard self.data.count <= size else {
      return .value(false)
    }

    return self.builtins.contains(iterable: other, allFrom: self).asResultOrNot
  }

  internal func isGreaterShared(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let size = self.getSetOrDictSize(other) else {
      return .notImplemented
    }

    guard self.data.count > size else {
      return .value(false)
    }

    return self.builtins.contains(iterable: self, allFrom: other).asResultOrNot
  }

  internal func isGreaterEqualShared(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let size = self.getSetOrDictSize(other) else {
      return .notImplemented
    }

    guard self.data.count >= size else {
      return .value(false)
    }

    return self.builtins.contains(iterable: self, allFrom: other).asResultOrNot
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

        switch self.builtins.repr(element.key.object) {
        case let .value(s): result += s
        case let .error(e): return .error(e)
        }
      }

      result += ")"
      return .value(result)
    }
  }
}

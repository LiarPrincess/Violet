import BigInt
import VioletCore

/// Mixin with methods for various `PyDict` views.
///
/// All of the methods/properties should be prefixed with `_`.
/// DO NOT use them outside of the dict view objects!
internal protocol AbstractDictView: PyObject {
  var dict: PyDict { get }
}

extension AbstractDictView {

  internal typealias OrderedDictionary = PyDict.OrderedDictionary
  internal typealias Element = OrderedDictionary.Element

  /// DO NOT USE! This is a part of `AbstractDictView` implementation.
  internal var _elements: OrderedDictionary {
    return self.dict.elements
  }

  // MARK: - Equatable

  /// DO NOT USE! This is a part of `AbstractDictView` implementation.
  internal func _isEqual(_ other: PyObject) -> CompareResult {
    guard let size = self._getDictOrSetSize(other) else {
      return .notImplemented
    }

    guard self._elements.count == size else {
      return .value(false)
    }

    let result = Py.contains(iterable: self, allFrom: other)
    return CompareResult(result)
  }

  /// DO NOT USE! This is a part of `AbstractDictView` implementation.
  internal func _isNotEqual(_ other: PyObject) -> CompareResult {
    return self._isEqual(other).not
  }

  // MARK: - Comparable

  /// DO NOT USE! This is a part of `AbstractDictView` implementation.
  internal func _isLess(_ other: PyObject) -> CompareResult {
    guard let size = self._getDictOrSetSize(other) else {
      return .notImplemented
    }

    guard self._elements.count < size else {
      return .value(false)
    }

    let result = Py.contains(iterable: other, allFrom: self)
    return CompareResult(result)
  }

  /// DO NOT USE! This is a part of `AbstractDictView` implementation.
  internal func _isLessEqual(_ other: PyObject) -> CompareResult {
    guard let size = self._getDictOrSetSize(other) else {
      return .notImplemented
    }

    guard self._elements.count <= size else {
      return .value(false)
    }

    let result = Py.contains(iterable: other, allFrom: self)
    return CompareResult(result)
  }

  /// DO NOT USE! This is a part of `AbstractDictView` implementation.
  internal func _isGreater(_ other: PyObject) -> CompareResult {
    guard let size = self._getDictOrSetSize(other) else {
      return .notImplemented
    }

    guard self._elements.count > size else {
      return .value(false)
    }

    let result = Py.contains(iterable: self, allFrom: other)
    return CompareResult(result)
  }

  /// DO NOT USE! This is a part of `AbstractDictView` implementation.
  internal func _isGreaterEqual(_ other: PyObject) -> CompareResult {
    guard let size = self._getDictOrSetSize(other) else {
      return .notImplemented
    }

    guard self._elements.count >= size else {
      return .value(false)
    }

    let result = Py.contains(iterable: self, allFrom: other)
    return CompareResult(result)
  }

  /// DO NOT USE! This is a part of `AbstractDictView` implementation.
  private func _getDictOrSetSize(_ other: PyObject) -> Int? {
    if let set = PyCast.asAnySet(other) {
      return set.elements.count
    }

    if let dict = PyCast.asDict(other) {
      return dict.elements.count
    }

    return nil
  }

  // MARK: - Hashable

  /// DO NOT USE! This is a part of `AbstractDictView` implementation.
  internal func _hash() -> HashResult {
    return .unhashable(self)
  }

  // MARK: - String

  /// DO NOT USE! This is a part of `AbstractDictView` implementation.
  internal func _repr(
    typeName: String,
    elementRepr: (Element) -> PyResult<String>
  ) -> PyResult<String> {
    if self.hasReprLock {
      return .value("...")
    }

    return self.withReprLock {
      var result = typeName + "("
      for (index, element) in self.dict.elements.enumerated() {
        if index > 0 {
          result += ", " // so that we don't have ', )'.
        }

        switch elementRepr(element) {
        case let .value(s): result += s
        case let .error(e): return .error(e)
        }
      }

      result += ")"
      return .value(result)
    }
  }

  // MARK: - Length

  /// DO NOT USE! This is a part of `AbstractDictView` implementation.
  internal func _getLength() -> BigInt {
    return BigInt(self._elements.count)
  }
}

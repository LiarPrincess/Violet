import Core

// In CPython:
// Objects -> dictobject.c

// sourcery: pytype = dict_keys, default, hasGC
public class PyDictKeys: PyObject {

  internal let dict: PyDict

  private var data: PyDictData {
    return self.dict.data
  }

  // MARK: - Init

  internal init(dict: PyDict) {
    self.dict = dict
    super.init(type: dict.builtins.types.dict_keys)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let size = self.getSetOrDictSize(other) else {
      return .notImplemented
    }

    guard self.data.count == size else {
      return .value(false)
    }

    return self.builtins.contains(self, allFrom: other).asResultOrNot
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return NotEqualHelper.fromIsEqual(self.isEqual(other))
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let size = self.getSetOrDictSize(other) else {
      return .notImplemented
    }

    guard self.data.count < size else {
      return .value(false)
    }

    return self.builtins.contains(other, allFrom: self).asResultOrNot
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let size = self.getSetOrDictSize(other) else {
      return .notImplemented
    }

    guard self.data.count <= size else {
      return .value(false)
    }

    return self.builtins.contains(other, allFrom: self).asResultOrNot
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let size = self.getSetOrDictSize(other) else {
      return .notImplemented
    }

    guard self.data.count > size else {
      return .value(false)
    }

    return self.builtins.contains(self, allFrom: other).asResultOrNot
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let size = self.getSetOrDictSize(other) else {
      return .notImplemented
    }

    guard self.data.count >= size else {
      return .value(false)
    }

    return self.builtins.contains(self, allFrom: other).asResultOrNot
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

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    if self.hasReprLock {
      return .value("...")
    }

    return self.withReprLock {
      var result = "dict_keys("
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

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Length

  internal var isEmpty: Bool {
    return self.data.isEmpty
  }

  // sourcery: pymethod = __len__
  internal func getLength() -> BigInt {
    return BigInt(self.data.count)
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(_ element: PyObject) -> PyResult<Bool> {
    return self.dict.contains(element)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return PyDictKeyIterator(dict: self.dict)
  }
}

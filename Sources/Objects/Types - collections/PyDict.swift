import Core

// In CPython:
// Objects -> dictobject.c
// https://docs.python.org/3.7/c-api/dict.html

internal struct PyDictKey: VioletHashable {

  internal var hash: PyHash
  internal var object: PyObject

  internal init(hash: PyHash, object: PyObject) {
    self.hash = hash
    self.object = object
  }

  internal func isEqual(to other: PyDictKey) -> Bool {
    return self.hash == other.hash &&
      self.object.builtins.isEqualBool(left: self.object, right: other.object)
  }
}

// sourcery: pytype = dict
/// This subtype of PyObject represents a Python dictionary object.
internal final class PyDict: PyObject {

  internal static let doc: String = """
    dict() -> new empty dictionary
    dict(mapping) -> new dictionary initialized from a mapping object's
    (key, value) pairs
    dict(iterable) -> new dictionary initialized as if via:
    d = {}
    for k, v in iterable:
    d[k] = v
    dict(**kwargs) -> new dictionary initialized with the name=value pairs
    in the keyword argument list.  For example:  dict(one=1, two=2)
    """

  private var elements = OrderedDictionary<PyDictKey, PyObject>()

  // MARK: - Init

  internal init(_ context: PyContext) {
    super.init(type: context.builtins.types.dict)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyDict else {
      return .notImplemented
    }

    return .value(self.isEqual(other))
  }

  internal func isEqual(_ other: PyDict) -> Bool {
    guard self.elements.count == other.elements.count else {
      return false
    }

    for entry in self.elements {
      guard let otherValue = other.elements[entry.key] else {
        return false
      }

      guard self.builtins.isEqualBool(left: entry.value, right: otherValue) else {
        return false
      }
    }

    return true
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return NotEqualHelper.fromIsEqual(self.isEqual(other))
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> PyResultOrNot<PyHash> {
    return .error(self.builtins.hashNotImplemented(self))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    if self.elements.isEmpty {
      return .value("{}")
    }

    if self.hasReprLock {
      return .value("{...}")
    }

    return self.withReprLock {
      var result = "{"
      for (index, element) in self.elements.enumerated() {
        if index > 0 {
          result += ", " // so that we don't have ', )'.
        }

        result += self.context._repr(value: element.key.object)
        result += ": "
        result += self.context._repr(value: element.value)
      }

      result += "}"
      return .value(result)
    }
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(zelf: self, name: name)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Sequence

  // sourcery: pymethod = __len__
  internal func getLength() -> BigInt {
    return BigInt(self.elements.count)
  }

  // sourcery: pymethod = __getitem__
  internal func getItem(at index: PyObject) -> PyResult<PyObject> {
    let key: PyDictKey
    switch self.createKey(from: index) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    if let result = self.elements[key] {
      return .value(result)
    }

    let missing = "__missing__"
    switch self.builtins.callMethod(on: self, selector: missing, arg: index) {
    case .value(let o): return .value(o)
    case .noSuchMethod: break
    case .methodIsNotCallable(let e): return .error(e)
    }

    return .keyError(hash: key.hash, key: key.object)
  }

  // sourcery: pymethod = __setitem__
  internal func setItem(at index: PyObject, to value: PyObject) -> PyResult<PyNone> {
    let key: PyDictKey
    switch self.createKey(from: index) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    self.elements[key] = value
    return .value(self.builtins.none)
  }

  // sourcery: pymethod = __delitem__
  internal func delItem(at index: PyObject) -> PyResult<PyNone> {
    let key: PyDictKey
    switch self.createKey(from: index) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    if self.elements.remove(key: key) != nil {
      return .value(self.builtins.none)
    }

    return .keyError(hash: key.hash, key: key.object)
  }

  // sourcery: pymethod = __contains__
  internal func contains(_ element: PyObject) -> PyResult<Bool> {
    let key: PyDictKey
    switch self.createKey(from: element) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    let result = self.elements[key] != nil
    return .value(result)
  }

  internal static let clearDoc = """
    D.clear() -> None.  Remove all items from D.
    """

  // sourcery: pymethod = clear, doc = clearDoc
  internal func clear() -> PyResult<PyNone> {
    self.elements.clear()
    return .value(self.builtins.none)
  }

  // MARK: - Helpers

  private func createKey(from object: PyObject) -> PyResult<PyDictKey> {
    switch self.builtins.hash(object) {
    case let .value(hash):
      return .value(PyDictKey(hash: hash, object: object))
    case let .error(e):
      return .error(e)
    }
  }

/*
  internal func contains(owner: PyObject, element: PyObject) throws -> Bool {
    let v = try self.matchType(owner)

    let hash = try self.context.hash(value: element)
    let key = PyDictKey(hash: hash, object: element)

    return v.elements.contains(key)
  }
*/
}

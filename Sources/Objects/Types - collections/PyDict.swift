import Core

// In CPython:
// Objects -> dictobject.c
// https://docs.python.org/3.7/c-api/dict.html

// swiftlint:disable file_length

internal typealias PyDictData = OrderedDictionary<PyDictKey, PyObject>

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
public final class PyDict: PyObject {

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

  private var elements: PyDictData

  // MARK: - Init

  internal init(_ context: PyContext) {
    self.elements = PyDictData()
    super.init(type: context.builtins.types.dict)
  }

  internal init(_ context: PyContext, elements: PyDictData) {
    self.elements = elements
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

  // MARK: - Length

  // sourcery: pymethod = __len__
  internal func getLength() -> BigInt {
    return BigInt(self.elements.count)
  }

  // MARK: - Get/set/del item

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

    return .keyErrorForKey(index)
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

    return .keyErrorForKey(index)
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(_ element: PyObject) -> PyResult<Bool> {
    let key: PyDictKey
    switch self.createKey(from: element) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    return .value(self.elements.contains(key: key))
  }

  // MARK: - Clear

  internal static let clearDoc = """
    D.clear() -> None.  Remove all items from D.
    """

  // sourcery: pymethod = clear, doc = clearDoc
  internal func clear() -> PyResult<PyNone> {
    self.elements.clear()
    return .value(self.builtins.none)
  }

  // MARK: - Get

  internal static let getDoc = """
    get($self, key, default=None, /)
    --

    Return the value for key if key is in the dictionary, else default.
    """

  // sourcery: pymethod = get, doc = getDoc
  internal func get(_ index: PyObject, default: PyObject?) -> PyResult<PyObject> {
    let key: PyDictKey
    switch self.createKey(from: index) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    if let result = self.elements[key] {
      return .value(result)
    }

    let result = `default` ?? self.builtins.none
    return .value(result)
  }

  // MARK: - Set default

  internal static let setdefaultDoc = """
    setdefault($self, key, default=None, /)
    --

    Insert key with a value of default if key is not in the dictionary.

    Return the value for key if key is in the dictionary, else default.
    """

  // sourcery: pymethod = setdefault, doc = setdefaultDoc
  /// If `key` is in the dictionary, return its value.
  /// If not, insert key with a value of `default` and return `default`.
  /// `default` defaults to None.
  internal func setDefault(_ index: PyObject,
                           default: PyObject?) -> PyResult<PyObject> {
    let key: PyDictKey
    switch self.createKey(from: index) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    if let oldValue = self.elements.get(key: key) {
      return .value(oldValue)
    }

    let value = `default` ?? self.builtins.none
    self.elements.insert(key: key, value: value)
    return .value(value)
  }

  // MARK: - Copy

  internal static let copyDoc = "D.copy() -> a shallow copy of D"

  // sourcery: pymethod = copy, doc = copyDoc
  internal func copy() -> PyObject {
    let result = PyDict(self.context)
    result.elements = self.elements
    return result
  }

  // MARK: - Pop

  internal static let popDoc = """
    D.pop(k[,d]) -> v, remove specified key and return the corresponding value.
    If key is not found, d is returned if given, otherwise KeyError is raised
    """

  // sourcery: pymethod = pop, doc = popDoc
  internal func pop(_ index: PyObject,
                    default: PyObject?) -> PyResult<PyObject> {
    let key: PyDictKey
    switch self.createKey(from: index) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    if let result = self.elements.remove(key: key) {
      return .value(result)
    }

    if let def = `default` {
      return .value(def)
    }

    return .keyErrorForKey(index)
  }

  internal static let popitemDoc = """
    D.popitem() -> (k, v), remove and return some (key, value) pair as a
    2-tuple; but raise KeyError if D is empty.
    """

  // sourcery: pymethod = popitem, doc = popitemDoc
  internal func popitem() -> PyResult<PyObject> {
    guard let last = self.elements.last else {
      return .keyError("popitem(): dictionary is empty")
    }

    _ = self.elements.remove(key: last.key)

    let key = last.key.object
    let value = last.value
    let result = PyTuple(self.context, elements: [key, value])
    return .value(result)
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
}

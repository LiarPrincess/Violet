import Core

// In CPython:
// Objects -> dictobject.c
// https://docs.python.org/3.7/c-api/dict.html

// swiftlint:disable file_length

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

  internal var elements: PyDictData

  // MARK: - Init

  internal init(_ context: PyContext) {
    self.elements = PyDictData()
    super.init(type: context.builtins.types.dict, hasDict: false)
  }

  internal init(_ context: PyContext, elements: PyDictData) {
    self.elements = elements
    super.init(type: context.builtins.types.dict, hasDict: false)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyDict else {
      return .notImplemented
    }

    guard self.elements.count == other.elements.count else {
      return .value(false)
    }

    for entry in self.elements {
      let otherValue: PyObject
      switch other.elements.get(key: entry.key) {
      case .value(let o): otherValue = o
      case .notFound: return .value(false)
      case .error(let e): return .error(e)
      }

      switch self.builtins.isEqualBool(left: entry.value, right: otherValue) {
      case .value(true): break // Go to next element
      case .value(false): return .value(false)
      case .error(let e): return .error(e)
      }
    }

    return .value(true)
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

        switch self.builtins.repr(element.key.object) {
        case let .value(s): result += s
        case let .error(e): return .error(e)
        }

        result += ": "

        switch self.builtins.repr(element.value) {
        case let .value(s): result += s
        case let .error(e): return .error(e)
        }
      }

      result += "}"
      return .value(result)
    }
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
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

    switch self.elements.get(key: key) {
    case .value(let o): return .value(o)
    case .notFound: break // Try '__missing__'
    case .error(let e): return .error(e)
    }

    let missing = "__missing__"
    switch self.builtins.callMethod(on: self, selector: missing, arg: index) {
    case .value(let o):
      return .value(o)
    case .noSuchMethod,
         .notImplemented:
      break
    case .methodIsNotCallable(let e),
         .error(let e):
      return .error(e)
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

    switch self.elements.insert(key: key, value: value) {
    case .inserted, .updated:
      return .value(self.builtins.none)
    case .error(let e):
      return .error(e)
    }
  }

  // sourcery: pymethod = __delitem__
  internal func delItem(at index: PyObject) -> PyResult<PyNone> {
    let key: PyDictKey
    switch self.createKey(from: index) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    switch self.elements.remove(key: key) {
    case .value:
      return .value(self.builtins.none)
    case .notFound:
      return .keyErrorForKey(index)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(_ element: PyObject) -> PyResult<Bool> {
    let key: PyDictKey
    switch self.createKey(from: element) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    switch self.elements.contains(key: key) {
    case let .value(b):
      return .value(b)
    case let .error(e):
      return .error(e)
    }
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

    switch self.elements.get(key: key) {
    case .value(let o):
      return .value(o)
    case .notFound:
      return .value(`default` ?? self.builtins.none)
    case .error(let e):
      return .error(e)
    }
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

    switch self.elements.get(key: key) {
    case .value(let o):
      return .value(o)
    case .notFound:
      let value = `default` ?? self.builtins.none
      switch self.elements.insert(key: key, value: value) {
      case .inserted, .updated:
        return .value(value)
      case .error(let e):
        return .error(e)
      }
    case .error(let e):
      return .error(e)
    }
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

    switch self.elements.remove(key: key) {
    case .value(let o):
      return .value(o)
    case .notFound:
      if let def = `default` {
        return .value(def)
      }

      return .keyErrorForKey(index)
    case .error(let e):
      return .error(e)
    }
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

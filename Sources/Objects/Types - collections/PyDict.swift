import Core

// In CPython:
// Objects -> dictobject.c
// https://docs.python.org/3.7/c-api/dict.html

// swiftlint:disable file_length

// sourcery: pytype = dict, default, hasGC, baseType, dictSubclass
/// This subtype of PyObject represents a Python dictionary object.
public class PyDict: PyObject {

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

  public private(set) var data: PyDictData

  override public var description: String {
    return "PyDict(count: \(self.data.count))"
  }

  // MARK: - Init

  override internal convenience init() {
    self.init(data: PyDictData())
  }

  internal init(data: PyDictData) {
    self.data = data
    super.init(type: Py.types.dict)
  }

  /// Use only in `__new__`!
  internal init(type: PyType, data: PyDictData) {
    self.data = data
    super.init(type: type)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  public func isEqual(_ other: PyObject) -> CompareResult {
    guard let other = other as? PyDict else {
      return .notImplemented
    }

    guard self.data.count == other.data.count else {
      return .value(false)
    }

    for entry in self.data {
      let otherValue: PyObject
      switch other.data.get(key: entry.key) {
      case .value(let o): otherValue = o
      case .notFound: return .value(false)
      case .error(let e): return .error(e)
      }

      switch Py.isEqualBool(left: entry.value, right: otherValue) {
      case .value(true): break // Go to next element
      case .value(false): return .value(false)
      case .error(let e): return .error(e)
      }
    }

    return .value(true)
  }

  // sourcery: pymethod = __ne__
  public func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  public func isLess(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  public func isLessEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  public func isGreater(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  public func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  public func hash() -> HashResult {
    return .error(Py.hashNotImplemented(self))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  public func repr() -> PyResult<String> {
    if self.data.isEmpty {
      return .value("{}")
    }

    if self.hasReprLock {
      return .value("{...}")
    }

    return self.withReprLock {
      var result = "{"
      for (index, element) in self.data.enumerated() {
        if index > 0 {
          result += ", " // so that we don't have ugly ', }'.
        }

        switch Py.repr(element.key.object) {
        case let .value(s): result += s
        case let .error(e): return .error(e)
        }

        result += ": "

        switch Py.repr(element.value) {
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
  public func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  public func getClass() -> PyType {
    return self.type
  }

  // MARK: - Length

  // sourcery: pymethod = __len__
  public func getLength() -> BigInt {
    return BigInt(self.data.count)
  }

  // MARK: - Get/set/del item

  // sourcery: pymethod = __getitem__
  public func getItem(at index: PyObject) -> PyResult<PyObject> {
    switch Py.hash(index) {
    case let .value(hash):
      return self.getItem(at: index, hash: hash)
    case let .error(e):
      return .error(e)
    }
  }

  public func getItem(at index: PyObject, hash: PyHash) -> PyResult<PyObject> {
    let key = PyDictKey(hash: hash, object: index)

    switch self.data.get(key: key) {
    case .value(let o): return .value(o)
    case .notFound: break // Try '__missing__'
    case .error(let e): return .error(e)
    }

    let missing = "__missing__"
    switch Py.callMethod(on: self, selector: missing, arg: index) {
    case .value(let o):
      return .value(o)
    case .missingMethod:
      return .keyError(key: index)
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  // sourcery: pymethod = __setitem__
  public func setItem(at index: PyObject,
                      to value: PyObject) -> PyResult<PyNone> {
    switch Py.hash(index) {
    case let .value(hash):
      return self.setItem(at: index, hash: hash, to: value)
    case let .error(e):
      return .error(e)
    }
  }

  public func setItem(at index: PyObject,
                      hash: PyHash,
                      to value: PyObject) -> PyResult<PyNone> {
    let key = PyDictKey(hash: hash, object: index)

    switch self.data.insert(key: key, value: value) {
    case .inserted, .updated:
      return .value(Py.none)
    case .error(let e):
      return .error(e)
    }
  }

  // sourcery: pymethod = __delitem__
  public func delItem(at index: PyObject) -> PyResult<PyNone> {
    switch Py.hash(index) {
    case let .value(hash):
      return self.delItem(at: index, hash: hash)
    case let .error(e):
      return .error(e)
    }
  }

  public func delItem(at index: PyObject,
                      hash: PyHash) -> PyResult<PyNone> {
    let key = PyDictKey(hash: hash, object: index)

    switch self.data.remove(key: key) {
    case .value:
      return .value(Py.none)
    case .notFound:
      return .keyError(key: index)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Id - get/set/del item

  internal func getItem(id: IdString) -> PyObject? {
    let key = self.createKey(from: id)

    switch self.data.get(key: key) {
    case .value(let o):
      return o
    case .notFound:
      return nil
    case .error(let e):
      self.idErrorNotHandled(operation: "get", error: e)
    }
  }

  internal func setItem(id: IdString,
                        to value: PyObject) {
    let key = self.createKey(from: id)

    switch self.data.insert(key: key, value: value) {
    case .inserted,
         .updated:
      break
    case .error(let e):
      self.idErrorNotHandled(operation: "set", error: e)
    }
  }

  private func createKey(from id: IdString) -> PyDictKey {
    return PyDictKey(hash: id.hash, object: id.value)
  }

  /// Errors can happen when the value is not-hashable.
  /// Strings are always hashable, so we don't expect errors.
  private func idErrorNotHandled(operation: String,
                                 error: PyBaseException) -> Never {
    // TODO: PyDict.idErrorNotHandled
    // This may still fail when we insert to '__dict__' value that will
    // always throw on compare. We will ignore this for now.

    let repr = Py.reprOrGeneric(error)
    trap("Dict operation '\(operation)' returned an error: '\(repr)'")
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  public func contains(_ element: PyObject) -> PyResult<Bool> {
    let key: PyDictKey
    switch self.createKey(from: element) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    return self.data.contains(key: key)
  }

  // MARK: - Clear

  internal static let clearDoc = """
    D.clear() -> None.  Remove all items from D.
    """

  // sourcery: pymethod = clear, doc = clearDoc
  public func clear() -> PyResult<PyNone> {
    self.data.clear()
    return .value(Py.none)
  }

  // MARK: - Get

  internal static let getDoc = """
    get($self, key, default=None, /)
    --

    Return the value for key if key is in the dictionary, else default.
    """

  private static let getArguments = ArgumentParser.createOrTrap(
    arguments: ["", "default"],
    format: "O|O:get"
  )

  // sourcery: pymethod = get, doc = getDoc
  internal func get(args: [PyObject],
                    kwargs: PyDictData?) -> PyResult<PyObject> {
    switch PyDict.getArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 1, "Invalid required argument count.")
      assert(binding.optionalCount == 1, "Invalid optional argument count.")

      let arg0 = binding.required(at: 0)
      let arg1 = binding.optional(at: 1)
      return self.get(arg0, default: arg1)
    case let .error(e):
      return .error(e)
    }
  }

  public func get(_ index: PyObject, default: PyObject?) -> PyResult<PyObject> {
    let key: PyDictKey
    switch self.createKey(from: index) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    switch self.data.get(key: key) {
    case .value(let o):
      return .value(o)
    case .notFound:
      return .value(`default` ?? Py.none)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  public func iter() -> PyObject {
    return PyDictKeyIterator(dict: self)
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
  public func setDefault(_ index: PyObject,
                         default: PyObject?) -> PyResult<PyObject> {
    let key: PyDictKey
    switch self.createKey(from: index) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    switch self.data.get(key: key) {
    case .value(let o):
      return .value(o)
    case .notFound:
      let value = `default` ?? Py.none
      switch self.data.insert(key: key, value: value) {
      case .inserted, .updated:
        return .value(value)
      case .error(let e):
        return .error(e)
      }
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Update

  // sourcery: pymethod = update
  internal func update(args: [PyObject],
                       kwargs: PyDictData?) -> PyResult<PyNone> {
    // Guarantee 0 or 1 args
    if let e = ArgumentParser.guaranteeArgsCountOrError(fnName: "update",
                                                        args: args,
                                                        min: 0,
                                                        max: 1) {
      return .error(e)
    }

    if let arg = args.first {
      switch self.update(from: arg) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    if let kwargs = kwargs {
      switch self.update(from: kwargs) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    return .value(Py.none)
  }

  public func update(from object: PyObject) -> PyResult<PyNone> {
    if let dict = object as? PyDict {
      return self.update(from: dict.data)
    }

    switch self.callKeys(on: object) {
    case .value(let keys): // We have keys -> dict-like object
      return self.update(fromKeysOwner: object, keys: keys)

    case .missingMethod: // We don't have keys -> try iterable
      return self.update(fromIterableOfPairs: object)

    case .error(let e):
      return .error(e)
    }
  }

  private enum CallKeysResult {
    case value(PyObject)
    case error(PyBaseException)
    case missingMethod
  }

  private func callKeys(on object: PyObject) -> CallKeysResult {
    if let owner = object as? keysOwner {
      return .value(owner.keys())
    }

    switch Py.callMethod(on: object, selector: "keys") {
    case .value(let o):
      return .value(o)
    case .missingMethod:
      return .missingMethod
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  public func update(from data: PyDictData) -> PyResult<PyNone> {
    for entry in data {
      switch self.insert(key: entry.key, value: entry.value) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    return .value(Py.none)
  }

  private func insert(key: PyDictKey, value: PyObject) -> PyResult<()> {
    switch self.data.insert(key: key, value: value) {
    case .inserted, .updated:
      return .value()
    case .error(let e):
      return .error(e)
    }
  }

  private typealias KeyValue = (key: PyDictKey, value: PyObject)

  /// int
  /// PyDict_MergeFromSeq2(PyObject *d, PyObject *seq2, int override)
  ///
  /// Iterable of sequences with 2 elements (key and value).
  private func update(fromIterableOfPairs iterable: PyObject) -> PyResult<PyNone> {
    let kvs = Py.reduce(iterable: iterable, into: [KeyValue]()) { acc, object in
      switch self.unpackKeyValue(fromIterable: object) {
      case let .value(keyValue):
        acc.append(keyValue)
        return .goToNextElement
      case let .error(e):
        return .error(e)
      }
    }

    switch kvs {
    case let .value(keyValues):
      for (key, value) in keyValues {
        switch self.insert(key: key, value: value) {
        case .value: break
        case .error(let e): return .error(e)
        }
      }

      return .value(Py.none)

    case let .error(e):
      return .error(e)
    }
  }

  /// Given iterable of 2 elements it will return
  /// `iterable[0]` as key and `iterable[1]` as value.
  private func unpackKeyValue(fromIterable iterable: PyObject) -> PyResult<KeyValue> {
    switch Py.toArray(iterable: iterable) {
    case let .value(array):
      guard array.count == 2 else {
        let l = array.count
        let msg = "dictionary update sequence element has length \(l); 2 is required"
        return .valueError(msg)
      }

      return self.createKey(from: array[0]).map { ($0, array[1]) }

    case let .error(e):
      return .error(e)
    }
  }

  /// static int
  /// dict_merge(PyObject *a, PyObject *b, int override)
  private func update(fromKeysOwner dict: PyObject,
                      keys keyIterable: PyObject) -> PyResult<PyNone> {
    let keys: [PyObject]
    switch Py.toArray(iterable: keyIterable) {
    case let .value(k): keys = k
    case let .error(e): return .error(e)
    }

    for keyObject in keys {
      let key: PyDictKey
      switch self.createKey(from: keyObject) {
      case let .value(k): key = k
      case let .error(e): return .error(e)
      }

      let value: PyObject
      switch Py.getItem(dict, at: keyObject) {
      case let .value(v): value = v
      case let .error(e): return .error(e)
      }

      switch self.insert(key: key, value: value) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    return .value(Py.none)
  }

  // MARK: - Copy

  internal static let copyDoc = "D.copy() -> a shallow copy of D"

  // sourcery: pymethod = copy, doc = copyDoc
  public func copy() -> PyObject {
    let result = Py.newDict()
    result.data = self.data
    return result
  }

  // MARK: - Pop

  internal static let popDoc = """
    D.pop(k[,d]) -> v, remove specified key and return the corresponding value.
    If key is not found, d is returned if given, otherwise KeyError is raised
    """

  // sourcery: pymethod = pop, doc = popDoc
  public func pop(_ index: PyObject,
                  default: PyObject?) -> PyResult<PyObject> {
    let key: PyDictKey
    switch self.createKey(from: index) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    switch self.data.remove(key: key) {
    case .value(let o):
      return .value(o)
    case .notFound:
      if let def = `default` {
        return .value(def)
      }

      return .keyError(key: index)
    case .error(let e):
      return .error(e)
    }
  }

  internal static let popitemDoc = """
    D.popitem() -> (k, v), remove and return some (key, value) pair as a
    2-tuple; but raise KeyError if D is empty.
    """

  // sourcery: pymethod = popitem, doc = popitemDoc
  internal func popItem() -> PyResult<PyObject> {
    guard let last = self.data.last else {
      return .keyError("popitem(): dictionary is empty")
    }

    _ = self.data.remove(key: last.key)

    let key = last.key.object
    let value = last.value
    let result = Py.newTuple(key, value)
    return .value(result)
  }

  // MARK: - Views

  // sourcery: pymethod = keys
  public func keys() -> PyObject {
    return PyDictKeys(dict: self)
  }

  // sourcery: pymethod = items
  public func items() -> PyObject {
    return PyDictItems(dict: self)
  }

  // sourcery: pymethod = values
  public func values() -> PyObject {
    return PyDictValues(dict: self)
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDictData?) -> PyResult<PyObject> {
    let isBuiltin = type === Py.types.dict
    let alloca = isBuiltin ?
      PyDict.init(type:data:) :
      PyDictHeap.init(type:data:)

    let data = PyDictData()
    return .value(alloca(type, data))
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal static func pyInit(zelf: PyDict,
                              args: [PyObject],
                              kwargs: PyDictData?) -> PyResult<PyNone> {
    return zelf
      .update(args: args, kwargs: kwargs)
      .map { _ in Py.none }
  }

  // MARK: - Helpers

  private func createKey(from object: PyObject) -> PyResult<PyDictKey> {
    switch Py.hash(object) {
    case let .value(hash):
      return .value(PyDictKey(hash: hash, object: object))
    case let .error(e):
      return .error(e)
    }
  }
}

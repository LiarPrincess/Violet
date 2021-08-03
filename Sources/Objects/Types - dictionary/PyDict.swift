import BigInt
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore dictobject

// In CPython:
// Objects -> dictobject.c
// https://docs.python.org/3.7/c-api/dict.html

// sourcery: pytype = dict, isDefault, hasGC, isBaseType, isDictSubclass
// sourcery: subclassInstancesHave__dict__
/// This subtype of PyObject represents a Python dictionary object.
public final class PyDict: PyObject {

  // MARK: - OrderedDictionary

  internal typealias OrderedDictionary = VioletObjects.OrderedDictionary<Key, PyObject>

  // MARK: - Key

  internal struct Key: PyHashable, CustomStringConvertible {

    internal var hash: PyHash
    internal var object: PyObject

    internal var description: String {
      return "PyDict.Key(hash: \(self.hash), object: \(self.object))"
    }

    internal init(id: IdString) {
      self.hash = id.hash
      self.object = id.value
    }

    internal init(hash: PyHash, object: PyObject) {
      self.hash = hash
      self.object = object
    }

    internal func isEqual(to other: Key) -> PyResult<Bool> {
      // >>> class HashCollisionWith1:
      // ...     def __hash__(self): return 1
      // ...     def __eq__(self, other): raise NotImplementedError('Ooo!')
      //
      // >>> d = {}
      // >>> d[1] = 'a'
      // >>> c = HashCollisionWith1()
      // >>> d[c] = 'b'
      // NotImplementedError: Ooo!

      guard self.hash == other.hash else {
        return .value(false)
      }

      return Py.isEqualBool(left: self.object, right: other.object)
    }
  }

  // MARK: - Properties

  // sourcery: pytypedoc
  internal static let doc = """
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

  internal var elements: OrderedDictionary

  // MARK: - Init

  internal init(elements: PyDict.OrderedDictionary) {
    self.elements = elements
    super.init(type: Py.types.dict)
  }

  internal init(type: PyType, elements: PyDict.OrderedDictionary) {
    self.elements = elements
    super.init(type: type)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    guard let other = PyCast.asDict(other) else {
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

      switch Py.isEqualBool(left: entry.value, right: otherValue) {
      case .value(true): break // Go to next element
      case .value(false): return .value(false)
      case .error(let e): return .error(e)
      }
    }

    return .value(true)
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> HashResult {
    return .unhashable(self)
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
          result += ", " // so that we don't have ugly ', }'.
        }

        switch Py.reprString(object: element.key.object) {
        case let .value(s): result += s
        case let .error(e): return .error(e)
        }

        result += ": "

        switch Py.reprString(object: element.value) {
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

  // MARK: - Get

  public enum GetResult {
    case value(PyObject)
    case notFound
    case error(PyBaseException)
  }

  /// Get value from a dictionary.
  ///
  /// It will trap on fail.
  public func get(id: IdString) -> PyObject? {
    let key = Key(id: id)

    switch self.get(key: key) {
    case .value(let o):
      return o
    case .notFound:
      return nil
    case .error(let e):
      self.idErrorNotHandled(operation: "get", error: e)
    }
  }

  /// Get value from a dictionary.
  ///
  /// It may fail if hashing or actual storage access fails.
  public func get(key: PyObject) -> GetResult {
    switch Self.createKey(from: key) {
    case let .value(key):
      return self.get(key: key)
    case let .error(e):
      return .error(e)
    }
  }

  /// Get value from a dictionary.
  ///
  /// It may fail.
  internal func get(key: Key) -> GetResult {
    switch self.elements.get(key: key) {
    case .value(let o):
      return .value(o)
    case .notFound:
      return .notFound
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Set

  public enum SetResult {
    case ok
    case error(PyBaseException)
  }

  public func set(id: IdString, to value: PyObject) {
    let key = Key(id: id)

    switch self.set(key: key, to: value) {
    case .ok:
      break
    case .error(let e):
      self.idErrorNotHandled(operation: "set", error: e)
    }
  }

  public func set(key: PyObject, to value: PyObject) -> SetResult {
    switch Self.createKey(from: key) {
    case let .value(key):
      return self.set(key: key, to: value)
    case let .error(e):
      return .error(e)
    }
  }

  internal func set(key: Key, to value: PyObject) -> SetResult {
    switch self.elements.insert(key: key, value: value) {
    case .inserted,
         .updated:
      return .ok
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Del

  public enum DelResult {
    case value(PyObject)
    case notFound
    case error(PyBaseException)
  }

  public func del(id: IdString) -> PyObject? {
    let key = Key(id: id)

    switch self.del(key: key) {
    case .value(let o):
      return o
    case .notFound:
      return nil
    case .error(let e):
      self.idErrorNotHandled(operation: "del", error: e)
    }
  }

  public func del(key: PyObject) -> DelResult {
    switch Self.createKey(from: key) {
    case let .value(key):
      return self.del(key: key)
    case let .error(e):
      return .error(e)
    }
  }

  internal func del(key: Key) -> DelResult {
    switch self.elements.remove(key: key) {
    case .value(let o):
      return .value(o)
    case .notFound:
      return .notFound
    case .error(let e):
      return .error(e)
    }
  }

  /// Errors can happen when the value is not-hashable.
  /// Strings are always hashable, so we don't expect errors.
  ///
  /// This may still fail when we:
  /// 1. insert to `__dict__` value that will always throw on compare
  /// 2. have hash collision with that value
  /// We will ignore this for now.
  private func idErrorNotHandled(operation: String,
                                 error: PyBaseException) -> Never {
    // TODO: PyDict.idErrorNotHandled
    let repr = Py.reprOrGenericString(object: error)
    trap("Dict operation '\(operation)' returned an error: '\(repr)'")
  }

  // MARK: - Get - subscript

  // sourcery: pymethod = __getitem__
  /// Implementation of `Python` subscript.
  internal func getItem(index: PyObject) -> PyResult<PyObject> {
    switch Py.hash(object: index) {
    case let .value(hash):
      return self.getItem(index: index, hash: hash)
    case let .error(e):
      return .error(e)
    }
  }

  /// Implementation of `Python` subscript.
  internal func getItem(index: PyObject, hash: PyHash) -> PyResult<PyObject> {
    let key = Key(hash: hash, object: index)

    switch self.elements.get(key: key) {
    case .value(let o): return .value(o)
    case .notFound: break // Try other
    case .error(let e): return .error(e)
    }

    // Call '__missing__' method if we're a subclass.
    let isExactlyDictNotSubclass = PyCast.isExactlyDict(self)
    let isSubclass = !isExactlyDictNotSubclass
    if isSubclass {
      switch Py.callMethod(object: self, selector: .__missing__, arg: index) {
      case .value(let o):
        return .value(o)
      case .missingMethod:
        return .keyError(key: index)
      case .error(let e),
           .notCallable(let e):
        return .error(e)
      }
    }

    return .keyError(key: index)
  }

  // MARK: - Set - subscript

  // sourcery: pymethod = __setitem__
  /// Implementation of `Python` subscript.
  internal func setItem(index: PyObject, value: PyObject) -> PyResult<PyNone> {
    switch Py.hash(object: index) {
    case let .value(hash):
      return self.setItem(index: index, hash: hash, value: value)
    case let .error(e):
      return .error(e)
    }
  }

  /// Implementation of `Python` subscript.
  internal func setItem(index: PyObject,
                        hash: PyHash,
                        value: PyObject) -> PyResult<PyNone> {
    let key = Key(hash: hash, object: index)

    switch self.elements.insert(key: key, value: value) {
    case .inserted,
         .updated:
      return .value(Py.none)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Del - subscript

  // sourcery: pymethod = __delitem__
  /// Implementation of `Python` subscript.
  internal func delItem(index: PyObject) -> PyResult<PyNone> {
    switch Py.hash(object: index) {
    case let .value(hash):
      return self.delItem(index: index, hash: hash)
    case let .error(e):
      return .error(e)
    }
  }

  /// Implementation of `Python` subscript.
  internal func delItem(index: PyObject, hash: PyHash) -> PyResult<PyNone> {
    let key = Key(hash: hash, object: index)

    switch self.elements.remove(key: key) {
    case .value:
      return .value(Py.none)
    case .notFound:
      return .keyError(key: index)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Get - default

  internal static let getWithDefaultDoc = """
    get($self, key, default=None, /)
    --

    Return the value for key if key is in the dictionary, else default.
    """

  private static let getWithDefaultArguments = ArgumentParser.createOrTrap(
    arguments: ["", "default"],
    format: "O|O:get"
  )

  // sourcery: pymethod = get, doc = getWithDefaultDoc
  /// Implementation of Python `get($self, key, default=None, /)` method.
  internal func getWithDefault(args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    switch PyDict.getWithDefaultArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 1, "Invalid required argument count.")
      assert(binding.optionalCount == 1, "Invalid optional argument count.")

      let arg0 = binding.required(at: 0)
      let arg1 = binding.optional(at: 1)
      return self.getWithDefault(index: arg0, default: arg1)
    case let .error(e):
      return .error(e)
    }
  }

  /// Implementation of Python `get($self, key, default=None, /)` method.
  internal func getWithDefault(index: PyObject,
                               default: PyObject?) -> PyResult<PyObject> {
    let key: Key
    switch Self.createKey(from: index) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    switch self.elements.get(key: key) {
    case .value(let o):
      return .value(o)
    case .notFound:
      return .value(`default` ?? Py.none)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Set - default

  internal static let setWithDefaultDoc = """
    setdefault($self, key, default=None, /)
    --

    Insert key with a value of default if key is not in the dictionary.

    Return the value for key if key is in the dictionary, else default.
    """

  private static let setWithDefaultArguments = ArgumentParser.createOrTrap(
    arguments: ["", "default"],
    format: "O|O:get"
  )

  // sourcery: pymethod = setdefault, doc = setWithDefaultDoc
  /// Implementation of Python `setdefault($self, key, default=None, /)` method.
  ///
  /// If `key` is in the dictionary, return its value.
  /// If not, insert key with a value of `default` and return `default`.
  /// `default` defaults to None.
  internal func setWithDefault(args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    switch PyDict.setWithDefaultArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 1, "Invalid required argument count.")
      assert(binding.optionalCount == 1, "Invalid optional argument count.")

      let arg0 = binding.required(at: 0)
      let arg1 = binding.optional(at: 1)
      return self.setWithDefault(index: arg0, default: arg1)
    case let .error(e):
      return .error(e)
    }
  }

  /// Implementation of Python `setdefault($self, key, default=None, /)` method.
  ///
  /// If `key` is in the dictionary, return its value.
  /// If not, insert key with a value of `default` and return `default`.
  /// `default` defaults to `None`.
  internal func setWithDefault(index: PyObject,
                               default: PyObject?) -> PyResult<PyObject> {
    let key: Key
    switch Self.createKey(from: index) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    switch self.elements.get(key: key) {
    case .value(let o):
      return .value(o)
    case .notFound:
      let value = `default` ?? Py.none
      switch self.elements.insert(key: key, value: value) {
      case .inserted,
           .updated:
        return .value(value)
      case .error(let e):
        return .error(e)
      }
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(object: PyObject) -> PyResult<Bool> {
    switch Self.createKey(from: object) {
    case let .value(key):
      return self.contains(key: key)
    case let .error(e):
      return .error(e)
    }
  }

  internal func contains(key: Key) -> PyResult<Bool> {
    return self.elements.contains(key: key)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return PyMemory.newDictKeyIterator(dict: self)
  }

  // MARK: - Clear

  internal static let clearDoc = """
    D.clear() -> None.  Remove all items from D.
    """

  // sourcery: pymethod = clear, doc = clearDoc
  internal func clear() -> PyNone {
    self.elements.clear()
    return Py.none
  }

  // MARK: - Update

  // sourcery: pymethod = update
  internal func update(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    // Guarantee 0 or 1 args
    if let e = ArgumentParser.guaranteeArgsCountOrError(fnName: "update",
                                                        args: args,
                                                        min: 0,
                                                        max: 1) {
      return .error(e)
    }

    // Specific 'update' methods are in different file
    if let arg = args.first {
      switch self.update(from: arg, onKeyDuplicate: .continue) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    if let kwargs = kwargs {
      switch self.update(from: kwargs, onKeyDuplicate: .continue) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    return .value(Py.none)
  }

  // MARK: - Copy

  internal static let copyDoc = "D.copy() -> a shallow copy of D"

  // sourcery: pymethod = copy, doc = copyDoc
  internal func copy() -> PyDict {
    return Py.newDict(elements: self.elements)
  }

  // MARK: - Pop

  internal static let popDoc = """
    D.pop(k[,d]) -> v, remove specified key and return the corresponding value.
    If key is not found, d is returned if given, otherwise KeyError is raised
    """

  // sourcery: pymethod = pop, doc = popDoc
  internal func pop(_ index: PyObject, default: PyObject?) -> PyResult<PyObject> {
    let key: Key
    switch Self.createKey(from: index) {
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
    guard let last = self.elements.last else {
      return .keyError("popitem(): dictionary is empty")
    }

    _ = self.elements.remove(key: last.key)

    let key = last.key.object
    let value = last.value
    let result = Py.newTuple(key, value)
    return .value(result)
  }

  // MARK: - From keys

  // sourcery: pyclassmethod = fromkeys
  internal static func fromKeys(type: PyType,
                                iterable: PyObject,
                                value: PyObject?) -> PyResult<PyObject> {
    let value = value ?? Py.none

    let dictObject: PyObject
    switch Py.call(callable: type) {
    case let .value(d):
      dictObject = d
    case let .notCallable(e),
         let .error(e):
      return .error(e)
    }

    // Fast path for empty 'dict'
    if let dict = PyCast.asExactlyDict(dictObject), dict.elements.isEmpty {
      if let iterDict = PyCast.asExactlyDict(iterable) {
        return self.fillFromKeys(target: dict, dict: iterDict, value: value)
      }

      if let iterSet = PyCast.asExactlyAnySet(iterable) {
        return self.fillFromKeys(target: dict, set: iterSet, value: value)
      }
    }

    let e = Py.forEach(iterable: iterable) { object in
      switch Py.setItem(object: dictObject, index: object, value: value) {
      case .value: return .goToNextElement
      case .error(let e): return .error(e)
      }
    }

    if let e = e {
      return .error(e)
    }

    return .value(dictObject)
  }

  private static let onFillFromKeysDuplicate = OnUpdateKeyDuplicate.continue

  private static func fillFromKeys(target: PyDict,
                                   dict: PyDict,
                                   value: PyObject) -> PyResult<PyObject> {
    assert(PyCast.isExactlyDict(target))
    assert(PyCast.isExactlyDict(dict))

    for entry in dict.elements {
      if let e = target.updateSingleEntry(key: entry.key,
                                          value: value,
                                          onKeyDuplicate: Self.onFillFromKeysDuplicate) {
        return .error(e)
      }
    }

    return .value(target)
  }

  private static func fillFromKeys(target: PyDict,
                                   set: PyAnySet,
                                   value: PyObject) -> PyResult<PyObject> {
    assert(PyCast.isExactlyDict(target))
    assert(PyCast.isExactlyAnySet(set))

    for element in set.elements {
      let key = Key(hash: element.hash, object: element.object)
      if let e = target.updateSingleEntry(
          key: key,
          value: value,
          onKeyDuplicate: Self.onFillFromKeysDuplicate
      ) {
        return .error(e)
      }
    }

    return .value(target)
  }

  // MARK: - Views

  // sourcery: pymethod = keys
  internal func keys() -> PyObject {
    return PyMemory.newDictKeys(dict: self)
  }

  // sourcery: pymethod = items
  internal func items() -> PyObject {
    return PyMemory.newDictItems(dict: self)
  }

  // sourcery: pymethod = values
  internal func values() -> PyObject {
    return PyMemory.newDictValues(dict: self)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyDict> {
    let elements = OrderedDictionary()

    let isBuiltin = type === Py.types.dict
    let dict = isBuiltin ?
      Py.newDict(elements: elements) :
      PyMemory.newDict(type: type, elements: elements)

    return .value(dict)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    return self.update(args: args, kwargs: kwargs)
  }

  // MARK: - GC

  /// Remove all of the references to other Python objects.
  override internal func gcClean() {
    self.elements.clear()
    super.gcClean()
  }

  // MARK: - Helpers

  internal static func createKey(from object: PyObject) -> PyResult<Key> {
    switch Py.hash(object: object) {
    case let .value(hash):
      return .value(Key(hash: hash, object: object))
    case let .error(e):
      return .error(e)
    }
  }
}

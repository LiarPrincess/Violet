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
public struct PyDict: PyObjectMixin {

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

  public typealias OrderedDictionary = VioletObjects.OrderedDictionary<PyObject>
  public typealias Key = OrderedDictionary.Key

  // sourcery: storedProperty
  internal var elements: PyDict.OrderedDictionary {
    // Do not add 'nonmutating set/_modify' - the compiler could get confused
    // sometimes. Use 'self.elementsPtr.pointee' for modification.
    self.elementsPtr.pointee
  }

  internal var count: Int {
    return self.elements.count
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py,
                           type: PyType,
                           elements: PyDict.OrderedDictionary) {
    self.initializeBase(py, type: type)
    self.elementsPtr.initialize(to: elements)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyDict(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "count", value: zelf.count, includeInDescription: true)
    result.append(name: "elements", value: zelf.elements, includeInDescription: true)
    return result
  }

  // MARK: - Equatable, comparable

  // sourcery: pymethod = __eq__
  internal static func __eq__(_ py: Py,
                              zelf _zelf: PyObject,
                              other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__eq__)
    }

    return zelf.isEqual(py, other: other)
  }

  // sourcery: pymethod = __ne__
  internal static func __ne__(_ py: Py,
                              zelf _zelf: PyObject,
                              other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__ne__)
    }

    let isEqual = zelf.isEqual(py, other: other)
    return isEqual.not
  }

  internal func isEqual(_ py: Py, other: PyObject) -> CompareResult {
    guard let other = Self.downcast(py, other) else {
      return .notImplemented
    }

    let result = self.isEqual(py, other: other)
    return CompareResult(result)
  }

  internal func isEqual(_ py: Py, other: PyDict) -> PyResultGen<Bool> {
    guard self.count == other.count else {
      return .value(false)
    }

    for entry in self.elements {
      let otherValue: PyObject
      switch other.elements.get(py, key: entry.key) {
      case .value(let o): otherValue = o
      case .notFound: return .value(false)
      case .error(let e): return .error(e)
      }

      switch py.isEqualBool(left: entry.value, right: otherValue) {
      case .value(true): break // Go to next element
      case .value(false): return .value(false)
      case .error(let e): return .error(e)
      }
    }

    return .value(true)
  }

  // sourcery: pymethod = __lt__
  internal static func __lt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__lt__)
  }

  // sourcery: pymethod = __le__
  internal static func __le__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__le__)
  }

  // sourcery: pymethod = __gt__
  internal static func __gt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__gt__)
  }

  // sourcery: pymethod = __ge__
  internal static func __ge__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__ge__)
  }

  private static func compare(_ py: Py,
                              zelf: PyObject,
                              operation: CompareResult.Operation) -> CompareResult {
    guard Self.downcast(py, zelf) != nil else {
      return .invalidSelfArgument(zelf, Self.pythonTypeName, operation)
    }

    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal static func __hash__(_ py: Py, zelf _zelf: PyObject) -> HashResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName)
    }

    return .unhashable(zelf.asObject)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__repr__")
    }

    if zelf.elements.isEmpty {
      return PyResult(py, interned: "{}")
    }

    if zelf.hasReprLock {
      return PyResult(py, interned: "{...}")
    }

    return zelf.withReprLock {
      var result = "{"
      for (index, element) in zelf.elements.enumerated() {
        if index > 0 {
          result += ", " // so that we don't have ugly ', }'.
        }

        switch py.reprString(element.key.object) {
        case let .value(s): result += s
        case let .error(e): return .error(e)
        }

        result += ": "

        switch py.reprString(element.value) {
        case let .value(s): result += s
        case let .error(e): return .error(e)
        }
      }

      result += "}"
      return PyResult(py, result)
    }
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf _zelf: PyObject,
                                        name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Length

  // sourcery: pymethod = __len__
  internal static func __len__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__len__")
    }

    let result = zelf.count
    return PyResult(py, result)
  }

  // MARK: - Get

  public enum GetResult {
    case value(PyObject)
    case notFound
    case error(PyBaseException)
  }

  /// Get value from a dictionary. Will trap on fail.
  public func get(_ py: Py, id: IdString) -> PyObject? {
    let key = Key(py, id: id)

    switch self.get(py, key: key) {
    case .value(let o):
      return o
    case .notFound:
      return nil
    case .error(let e):
      self.idErrorNotHandled(py, operation: "get", error: e)
    }
  }

  public func get(_ py: Py, key: PyString) -> GetResult {
    return self.get(py, key: key.asObject)
  }

  public func get(_ py: Py, key: PyObject) -> GetResult {
    switch Self.createKey(py, object: key) {
    case let .value(key):
      return self.get(py, key: key)
    case let .error(e):
      return .error(e)
    }
  }

  internal func get(_ py: Py, key: Key) -> GetResult {
    switch self.elements.get(py, key: key) {
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
  private func idErrorNotHandled(_ py: Py,
                                 operation: String,
                                 error: PyBaseException) -> Never {
    // TODO: PyDict.idErrorNotHandled
    let repr = py.reprOrGenericString(error.asObject)
    trap("Dict operation '\(operation)' returned an error: '\(repr)'")
  }

  // MARK: - Set

  public enum SetResult {
    case ok
    case error(PyBaseException)
  }

  /// Set value in a dictionary. Will trap on fail.
  public func set(_ py: Py, id: IdString, value: PyObject) {
    let key = Key(py, id: id)

    switch self.set(py, key: key, value: value) {
    case .ok:
      break
    case .error(let e):
      self.idErrorNotHandled(py, operation: "set", error: e)
    }
  }

  public func set(_ py: Py, key: PyString, value: PyObject) -> SetResult {
    return self.set(py, key: key.asObject, value: value)
  }

  public func set(_ py: Py, key: PyObject, value: PyObject) -> SetResult {
    switch Self.createKey(py, object: key) {
    case let .value(key):
      return self.set(py, key: key, value: value)
    case let .error(e):
      return .error(e)
    }
  }

  internal func set(_ py: Py, key: Key, value: PyObject) -> SetResult {
    switch self.elementsPtr.pointee.insert(py, key: key, value: value) {
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

  /// Delete value from a dictionary. Will trap on fail.
  public func del(_ py: Py, id: IdString) -> PyObject? {
    let key = Key(py, id: id)

    switch self.del(py, key: key) {
    case .value(let o):
      return o
    case .notFound:
      return nil
    case .error(let e):
      self.idErrorNotHandled(py, operation: "del", error: e)
    }
  }

  public func del(_ py: Py, key: PyString) -> DelResult {
    return self.del(py, key: key.asObject)
  }

  public func del(_ py: Py, key: PyObject) -> DelResult {
    switch Self.createKey(py, object: key) {
    case let .value(key):
      return self.del(py, key: key)
    case let .error(e):
      return .error(e)
    }
  }

  internal func del(_ py: Py, key: Key) -> DelResult {
    switch self.elementsPtr.pointee.remove(py, key: key) {
    case .value(let o):
      return .value(o)
    case .notFound:
      return .notFound
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Get - subscript

  // sourcery: pymethod = __getitem__
  /// Implementation of `Python` subscript.
  internal static func __getitem__(_ py: Py,
                                   zelf _zelf: PyObject,
                                   index: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getitem__")
    }

    let key: Key
    switch Self.createKey(py, object: index) {
    case let .value(k): key = k
    case let .error(e): return .error(e)
    }

    switch zelf.elements.get(py, key: key) {
    case .value(let o): return .value(o)
    case .notFound: break // Try other
    case .error(let e): return .error(e)
    }

    // Call '__missing__' method if we're a subclass.
    let isSubclass = !py.cast.isExactlyDict(zelf.asObject)
    if isSubclass {
      switch py.callMethod(object: zelf.asObject,
                           selector: .__missing__,
                           arg: index) {
      case .value(let o):
        return .value(o)
      case .missingMethod:
        break
      case .error(let e),
           .notCallable(let e):
        return .error(e)
      }
    }

    return .keyError(py, key: index)
  }

  // MARK: - Set - subscript

  // sourcery: pymethod = __setitem__
  /// Implementation of `Python` subscript.
  internal static func __setitem__(_ py: Py,
                                   zelf _zelf: PyObject,
                                   index: PyObject,
                                   value: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__setitem__")
    }

    let key: Key
    switch Self.createKey(py, object: index) {
    case let .value(k): key = k
    case let .error(e): return .error(e)
    }

    switch zelf.elementsPtr.pointee.insert(py, key: key, value: value) {
    case .inserted,
         .updated:
      return .none(py)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Del - subscript

  // sourcery: pymethod = __delitem__
  /// Implementation of `Python` subscript.
  internal static func __delitem__(_ py: Py,
                                   zelf _zelf: PyObject,
                                   index: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__delitem__")
    }

    let key: Key
    switch Self.createKey(py, object: index) {
    case let .value(k): key = k
    case let .error(e): return .error(e)
    }

    switch zelf.elementsPtr.pointee.remove(py, key: key) {
    case .value:
      return .none(py)
    case .notFound:
      return .keyError(py, key: index)
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
  internal static func get(_ py: Py,
                           zelf _zelf: PyObject,
                           args: [PyObject],
                           kwargs: PyDict?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "get")
    }

    switch Self.getWithDefaultArguments.bind(py, args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 1, "Invalid required argument count.")
      assert(binding.optionalCount == 1, "Invalid optional argument count.")

      let arg0 = binding.required(at: 0)
      let arg1 = binding.optional(at: 1)
      return self.get(py, zelf: zelf, index: arg0, default: arg1)
    case let .error(e):
      return .error(e)
    }
  }

  /// Implementation of Python `get($self, key, default=None, /)` method.
  internal static func get(_ py: Py,
                           zelf: PyDict,
                           index: PyObject,
                           default: PyObject?) -> PyResult {
    let key: Key
    switch Self.createKey(py, object: index) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    switch zelf.elements.get(py, key: key) {
    case .value(let o):
      return .value(o)
    case .notFound:
      let result = `default` ?? py.none.asObject
      return .value(result)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Set - default

  internal static let setDefaultDoc = """
    setdefault($self, key, default=None, /)
    --

    Insert key with a value of default if key is not in the dictionary.

    Return the value for key if key is in the dictionary, else default.
    """

  private static let setDefaultArguments = ArgumentParser.createOrTrap(
    arguments: ["", "default"],
    format: "O|O:get"
  )

  // sourcery: pymethod = setdefault, doc = setDefaultDoc
  /// Implementation of Python `setdefault($self, key, default=None, /)` method.
  ///
  /// If `key` is in the dictionary, return its value.
  /// If not, insert key with a value of `default` and return `default`.
  /// `default` defaults to None.
  internal static func setdefault(_ py: Py,
                                  zelf _zelf: PyObject,
                                  args: [PyObject],
                                  kwargs: PyDict?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "setdefault")
    }

    switch Self.setDefaultArguments.bind(py, args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 1, "Invalid required argument count.")
      assert(binding.optionalCount == 1, "Invalid optional argument count.")

      let arg0 = binding.required(at: 0)
      let arg1 = binding.optional(at: 1)
      return Self.setdefault(py, zelf: zelf, index: arg0, default: arg1)
    case let .error(e):
      return .error(e)
    }
  }

  /// Implementation of Python `setdefault($self, key, default=None, /)` method.
  ///
  /// If `key` is in the dictionary, return its value.
  /// If not, insert key with a value of `default` and return `default`.
  /// `default` defaults to `None`.
  internal static func setdefault(_ py: Py,
                                  zelf: PyDict,
                                  index: PyObject,
                                  default: PyObject?) -> PyResult {
    let key: Key
    switch Self.createKey(py, object: index) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    switch zelf.elements.get(py, key: key) {
    case .value(let o):
      return .value(o)
    case .notFound:
      let value = `default` ?? py.none.asObject
      switch zelf.elementsPtr.pointee.insert(py, key: key, value: value) {
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
  internal static func __contains__(_ py: Py,
                                    zelf _zelf: PyObject,
                                    object: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__contains__")
    }

    return Self.contains(py, zelf: zelf, object: object)
  }

  internal static func contains(_ py: Py,
                                zelf: PyDict,
                                object: PyObject) -> PyResult {
    let key: Key
    switch Self.createKey(py, object: object) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    let result = zelf.elements.contains(py, key: key)
    return PyResult(py, result)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal static func __iter__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__iter__")
    }

    let result = py.newIterator(keys: zelf)
    return PyResult(result)
  }

  // MARK: - Clear

  internal static let clearDoc = """
    D.clear() -> None.  Remove all items from D.
    """

  // sourcery: pymethod = clear, doc = clearDoc
  internal static func clear(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "clear")
    }

    zelf.elementsPtr.pointee.clear()
    return .none(py)
  }

  // MARK: - Update

  // sourcery: pymethod = update
  internal static func update(_ py: Py,
                              zelf _zelf: PyObject,
                              args: [PyObject],
                              kwargs: PyDict?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "update")
    }

    // Guarantee 0 or 1 args
    if let e = ArgumentParser.guaranteeArgsCountOrError(py,
                                                        fnName: "update",
                                                        args: args,
                                                        min: 0,
                                                        max: 1) {
      return .error(e.asBaseException)
    }

    // Specific 'update' methods are in different file
    if let arg = args.first,
       let e = zelf.update(py, from: arg, onKeyDuplicate: .continue) {
      return .error(e)
    }

    if let kwargs = kwargs,
       let e = zelf.update(py, from: kwargs.asObject, onKeyDuplicate: .continue) {
      return .error(e)
    }

    return .none(py)
  }

  // MARK: - Copy

  internal static let copyDoc = "D.copy() -> a shallow copy of D"

  // sourcery: pymethod = copy, doc = copyDoc
  internal static func copy(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "copy")
    }

    let result = zelf.copy(py)
    return PyResult(result)
  }

  internal func copy(_ py: Py) -> PyDict {
    return py.newDict(elements: self.elements)
  }

  // MARK: - Pop

  internal static let popDoc = """
    D.pop(k[,d]) -> v, remove specified key and return the corresponding value.
    If key is not found, d is returned if given, otherwise KeyError is raised
    """

  // sourcery: pymethod = pop, doc = popDoc
  internal static func pop(_ py: Py,
                           zelf _zelf: PyObject,
                           index: PyObject,
                           default: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "pop")
    }

    let key: Key
    switch Self.createKey(py, object: index) {
    case let .value(v): key = v
    case let .error(e): return .error(e)
    }

    switch zelf.elementsPtr.pointee.remove(py, key: key) {
    case .value(let o):
      return .value(o)
    case .notFound:
      if let def = `default` {
        return .value(def)
      }

      return .keyError(py, key: index)
    case .error(let e):
      return .error(e)
    }
  }

  internal static let popitemDoc = """
    D.popitem() -> (k, v), remove and return some (key, value) pair as a
    2-tuple; but raise KeyError if D is empty.
    """

  // sourcery: pymethod = popitem, doc = popitemDoc
  internal static func popitem(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "popitem")
    }

    guard let last = zelf.elements.last else {
      return .keyError(py, message: "popitem(): dictionary is empty")
    }

    _ = zelf.elementsPtr.pointee.remove(py, key: last.key)

    let key = last.key.object
    let value = last.value
    return PyResult(py, tuple: key, value)
  }

  // MARK: - From keys

  // sourcery: pyclassmethod = fromkeys
  internal static func fromkeys(_ py: Py,
                                type: PyType,
                                iterable: PyObject,
                                value: PyObject?) -> PyResult {
    let value = value ?? py.none.asObject

    let dictObject: PyObject
    switch py.call(callable: type.asObject) {
    case let .value(d):
      dictObject = d
    case let .notCallable(e),
      let .error(e):
      return .error(e)
    }

    // Fast path for empty 'dict'
    if let dict = py.cast.asExactlyDict(dictObject), dict.elements.isEmpty {
      if let iterDict = py.cast.asExactlyDict(iterable) {
        return Self.fillFromKeys(py, target: dict, dict: iterDict, value: value)
      }

      if let iterSet = py.cast.asExactlyAnySet(iterable) {
        return Self.fillFromKeys(py, target: dict, set: iterSet, value: value)
      }
    }

    let e = py.forEach(iterable: iterable) { object in
      switch py.setItem(object: dictObject, index: object, value: value) {
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

  private static func fillFromKeys(_ py: Py,
                                   target: PyDict,
                                   dict: PyDict,
                                   value: PyObject) -> PyResult {
    assert(py.cast.isExactlyDict(target.asObject))
    assert(py.cast.isExactlyDict(dict.asObject))

    for entry in dict.elements {
      if let e = target.updateSingleEntry(py,
                                          key: entry.key,
                                          value: value,
                                          onKeyDuplicate: Self.onFillFromKeysDuplicate) {
        return .error(e)
      }
    }

    return .value(target.asObject)
  }

  private static func fillFromKeys(_ py: Py,
                                   target: PyDict,
                                   set: PyAnySet,
                                   value: PyObject) -> PyResult {
    assert(py.cast.isExactlyDict(target.asObject))
    assert(py.cast.isExactlyAnySet(set))

    for element in set.elements {
      let key = Key(hash: element.hash, object: element.object)
      if let e = target.updateSingleEntry(py,
                                          key: key,
                                          value: value,
                                          onKeyDuplicate: Self.onFillFromKeysDuplicate) {
        return .error(e)
      }
    }

    return .value(target.asObject)
  }

  // MARK: - Views

  // sourcery: pymethod = keys
  internal static func keys(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "keys")
    }

    let result = py.newDictKeys(dict: zelf)
    return PyResult(result)
  }

  // sourcery: pymethod = items
  internal static func items(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "items")
    }

    let result = py.newDictItems(dict: zelf)
    return PyResult(result)
  }

  // sourcery: pymethod = values
  internal static func values(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "values")
    }

    let result = py.newDictValues(dict: zelf)
    return PyResult(result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    let elements = OrderedDictionary()

    let isBuiltin = type === py.types.dict
    let dict = isBuiltin ?
      py.newDict(elements: elements) :
      py.memory.newDict(type: type, elements: elements)

    return .value(dict.asObject)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf _zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__init__")
    }

    return Self.update(py, zelf: zelf.asObject, args: args, kwargs: kwargs)
  }

  // MARK: - Helpers

  internal static func createKey(_ py: Py, object: PyObject) -> PyResultGen<Key> {
    switch py.hash(object: object) {
    case let .value(hash):
      let result = Key(hash: hash, object: object)
      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }
}

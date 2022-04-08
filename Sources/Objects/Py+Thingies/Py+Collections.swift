import BigInt
import VioletCore

// cSpell:ignore elments newitem anyset

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Py {

  // MARK: - Tuple

  /// PyObject * PyTuple_New(Py_ssize_t size)
  public func newTuple(elements: PyObject...) -> PyTuple {
    return self.newTuple(elements: elements)
  }

  /// PyObject * PyTuple_New(Py_ssize_t size)
  public func newTuple(elements: [PyObject]) -> PyTuple {
    if elements.isEmpty {
      return self.emptyTuple
    }

    let type = self.types.tuple
    return self.memory.newTuple(type: type, elements: elements)
  }

  /// PyObject * PyList_AsTuple(PyObject *v)
  public func newTuple(list object: PyObject) -> PyResultGen<PyTuple> {
    guard let list = self.cast.asList(object) else {
      let message = "expected tuple, but received a '\(object.typeName)'"
      return .typeError(self, message: message)
    }

    let result = self.newTuple(list: list)
    return .value(result)
  }

  public func newTuple(list: PyList) -> PyTuple {
    return self.newTuple(elements: list.elements)
  }

  public func newTuple(iterable: PyObject) -> PyResultGen<PyTuple> {
    let array = self.toArray(iterable: iterable)
    return array.map(self.newTuple)
  }

  public func newIterator(tuple: PyTuple) -> PyTupleIterator {
    let type = self.types.tuple_iterator
    return self.memory.newTupleIterator(type: type, tuple: tuple)
  }

  // MARK: - List

  /// PyObject * PyList_New(Py_ssize_t size)
  public func newList(elements: PyObject...) -> PyList {
    return self.newList(elements: elements)
  }

  /// PyObject * PyList_New(Py_ssize_t size)
  public func newList(elements: [PyObject]) -> PyList {
    let type = self.types.list
    return self.memory.newList(type: type, elements: elements)
  }

  public func newList(iterable: PyObject) -> PyResultGen<PyList> {
    let array = self.toArray(iterable: iterable)
    return array.map(self.newList)
  }

  /// int PyList_Append(PyObject *op, PyObject *newitem)
  public func add(list: PyObject, object: PyObject) -> PyBaseException? {
    guard let list = self.cast.asList(list) else {
      let message = "expected list, but received a '\(object.typeName)'"
      let error = self.newTypeError(message: message)
      return error.asBaseException
    }

    self.add(list: list, object: object)
    return nil
  }

  public func add(list: PyList, object: PyObject) {
    list.append(object: object)
  }

  public func newIterator(list: PyList) -> PyListIterator {
    let type = self.types.list_iterator
    return self.memory.newListIterator(type: type, list: list)
  }

  public func newReverseIterator(list: PyList) -> PyListReverseIterator {
    let type = self.types.list_reverseiterator
    return self.memory.newListReverseIterator(type: type, list: list)
  }

  // MARK: - Set

  public func newSet() -> PySet {
    let elements = PySet.OrderedSet()
    return self.newSet(elements: elements)
  }

  internal func newSet(elements: PySet.OrderedSet) -> PySet {
    let type = self.types.set
    return self.memory.newSet(type: type, elements: elements)
  }

  /// PyObject * PySet_New(PyObject *iterable)
  public func newSet(elements args: [PyObject]) -> PyResultGen<PySet> {
    let elements = self.asSetElements(args: args)
    return elements.map(self.newSet(elements:))
  }

  private func asSetElements(args: [PyObject]) -> PyResultGen<PySet.OrderedSet> {
    var result = PySet.OrderedSet(count: args.count)

    for object in args {
      switch self.hash(object: object) {
      case let .value(hash):
        let element = PySet.Element(hash: hash, object: object)

        switch result.insert(self, element: element) {
        case .inserted,
             .updated:
          break
        case let .error(e):
          return .error(e)
        }

      case let .error(e):
        return .error(e)
      }
    }

    return .value(result)
  }

  /// int PySet_Add(PyObject *anyset, PyObject *key)
  public func add(set: PyObject, object: PyObject) -> PyBaseException? {
    guard let set = self.cast.asSet(set) else {
      let message = "expected set, but received a '\(object.typeName)'"
      let error = self.newTypeError(message: message)
      return error.asBaseException
    }

    return self.add(set: set, object: object)
  }

  public func add(set: PySet, object: PyObject) -> PyBaseException? {
    return set.add(self, object: object)
  }

  public func update(set: PySet, fromIterable iterable: PyObject) -> PyBaseException? {
    return set.update(self, fromIterable: iterable)
  }

  public func newIterator(set: PySet) -> PySetIterator {
    let type = self.types.set_iterator
    return self.memory.newSetIterator(type: type, set: set)
  }

  // MARK: - Frozen set

  public func newFrozenSet() -> PyFrozenSet {
    return self.emptyFrozenSet
  }

  internal func newFrozenSet(elements: PyFrozenSet.OrderedSet) -> PyFrozenSet {
    if elements.isEmpty {
      return self.emptyFrozenSet
    }

    let type = self.types.frozenset
    return self.memory.newFrozenSet(type: type, elements: elements)
  }

  public func newFrozenSet(elements args: [PyObject]) -> PyResultGen<PyFrozenSet> {
    let elements = self.asSetElements(args: args)
    return elements.map(self.newFrozenSet(elements:))
  }

 public func newIterator(set: PyFrozenSet) -> PySetIterator {
   let type = self.types.set_iterator
   return self.memory.newSetIterator(type: type, frozenSet: set)
 }

  // MARK: - Dictionary

  public func newDict() -> PyDict {
    let elements = PyDict.OrderedDictionary()
    return self.newDict(elements: elements)
  }

  internal func newDict(elements: PyDict.OrderedDictionary) -> PyDict {
    let type = self.types.dict
    return self.memory.newDict(type: type, elements: elements)
  }

  public struct DictionaryElement {
    public let key: PyObject
    public let value: PyObject

    public init(key: PyObject, value: PyObject) {
      self.key = key
      self.value = value
    }
  }

  public func newDict(elements: [DictionaryElement]) -> PyResultGen<PyDict> {
    let result = self.newDict()

    for element in elements {
      let setResult = result.set(self, key: element.key, value: element.value)
      switch setResult {
      case .ok:
        break
      case .error(let e):
        return .error(e)
      }
    }

    return .value(result)
  }

  public func newDict(keys: PyTuple, elements: [PyObject]) -> PyResultGen<PyDict> {
    guard keys.elements.count == elements.count else {
      let message = "bad 'dictionary(keyTuple:elements:)' keys argument"
      return .valueError(self, message: message)
    }

    var result = PyDict.OrderedDictionary()

    for (keyObject, value) in Swift.zip(keys.elements, elements) {
      switch self.hash(object: keyObject) {
      case let .value(hash):
        let key = PyDict.Key(hash: hash, object: keyObject)
        switch result.insert(self, key: key, value: value) {
        case .inserted,
             .updated: break
        case .error(let e): return .error(e)
        }
      case let .error(e):
        return .error(e)
      }
    }

    let dict = self.newDict(elements: result)
    return .value(dict)
  }

  public func add(dict: PyObject, key: IdString, value: PyObject) -> PyBaseException? {
    let keyObject = self.resolve(id: key).asObject
    return self.add(dict: dict, key: keyObject, value: value)
  }

  public func add(dict: PyObject, key: PyString, value: PyObject) -> PyBaseException? {
    let keyObject = key.asObject
    return self.add(dict: dict, key: keyObject, value: value)
  }

  public func add(dict _dict: PyObject, key: PyObject, value: PyObject) -> PyBaseException? {
    guard let dict = self.cast.asDict(_dict) else {
      let message = "expected dict, but received a '\(_dict.typeName)'"
      let error = self.newTypeError(message: message)
      return error.asBaseException
    }

    return self.add(dict: dict, key: key, value: value)
  }

  public func add(dict: PyDict, key: PyObject, value: PyObject) -> PyBaseException? {
    switch dict.set(self, key: key, value: value) {
    case .ok:
      return nil
    case .error(let e):
      return e
    }
  }

  public func newDictKeys(dict: PyDict) -> PyDictKeys {
    let type = self.types.dict_keys
    return self.memory.newDictKeys(type: type, dict: dict)
  }

  public func newDictItems(dict: PyDict) -> PyDictItems {
    let type = self.types.dict_items
    return self.memory.newDictItems(type: type, dict: dict)
  }

  public func newDictValues(dict: PyDict) -> PyDictValues {
    let type = self.types.dict_values
    return self.memory.newDictValues(type: type, dict: dict)
  }

  public func newIterator(keys dict: PyDict) -> PyDictKeyIterator {
    let type = self.types.dict_keyiterator
    return self.memory.newDictKeyIterator(type: type, dict: dict)
  }

  public func newIterator(items dict: PyDict) -> PyDictItemIterator {
    let type = self.types.dict_itemiterator
    return self.memory.newDictItemIterator(type: type, dict: dict)
  }

  public func newIterator(values dict: PyDict) -> PyDictValueIterator {
    let type = self.types.dict_valueiterator
    return self.memory.newDictValueIterator(type: type, dict: dict)
  }

  // MARK: - Keys

  public enum GetKeysResult {
    case value(PyObject)
    case missingMethod(PyBaseException)
    case error(PyBaseException)
  }

  /// Call the `keys` method on object.
  public func getKeys(object: PyObject) -> GetKeysResult {
    if let result = PyStaticCall.keys(self, object: object) {
      switch result {
      case let .value(o): return .value(o)
      case let .error(e): return .error(e)
      }
    }

    switch self.callMethod(object: object, selector: .keys) {
    case let .value(o):
      return .value(o)
    case let .missingMethod(e):
      return .missingMethod(e)
    case let .error(e),
         let .notCallable(e):
      return .error(e)
    }
  }

  // MARK: - Range

  public func newRange(stop: BigInt) -> PyResultGen<PyRange> {
    return self.newRange(stop: self.newInt(stop))
  }

  public func newRange(stop: PyInt) -> PyResultGen<PyRange> {
    let start = self.newInt(0)
    return self.newRange(start: start, stop: stop, step: nil)
  }

  public func newRange(stop: PyObject) -> PyResultGen<PyRange> {
    let extracted = self.extractRangeProperty(stop)
    return extracted.flatMap(self.newRange(stop:))
  }

  public func newRange(start: BigInt,
                       stop: BigInt,
                       step: BigInt?) -> PyResultGen<PyRange> {
    return self.newRange(
      start: self.newInt(start),
      stop: self.newInt(stop),
      step: step.map(self.newInt)
    )
  }

  public func newRange(start: PyInt,
                       stop: PyInt,
                       step: PyInt?) -> PyResultGen<PyRange> {
    if let s = step, s.value == 0 {
      let error = self.newInvalidRangeStepError()
      return .error(error.asBaseException)
    }

    let type = self.types.range
    let result = self.memory.newRange(type: type, start: start, stop: stop, step: step)
    return .value(result)
  }

  private func newInvalidRangeStepError() -> PyValueError {
    return self.newValueError(message: "range() arg 3 must not be zero")
  }

  public func newRange(start: PyObject,
                       stop: PyObject,
                       step: PyObject?) -> PyResultGen<PyRange> {
    let parsedStart: PyInt
    switch self.extractRangeProperty(start) {
    case let .value(i): parsedStart = i
    case let .error(e): return .error(e)
    }

    let parsedStop: PyInt
    switch self.extractRangeProperty(stop) {
    case let .value(i): parsedStop = i
    case let .error(e): return .error(e)
    }

    guard let step = step else {
      return self.newRange(start: parsedStart, stop: parsedStop, step: nil)
    }

    let parsedStep: PyInt
    switch self.extractRangeProperty(step) {
    case let .value(i): parsedStep = i
    case let .error(e): return .error(e)
    }

    return self.newRange(start: parsedStart, stop: parsedStop, step: parsedStep)
  }

  private func extractRangeProperty(_ object: PyObject) -> PyResultGen<PyInt> {
    // If we are already 'PyInt' then we have to use EXACTLY this value!
    // >>> i = 2**60 # <-- high value to skip interned values (small int cache)
    // >>> assert range(i).stop is i

    if let objectInt = self.cast.asInt(object) {
      return .value(objectInt)
    }

    switch IndexHelper.pyInt(self, object: object) {
    case let .value(int):
      return .value(int)
    case let .notIndex(lazyError):
      let e = lazyError.create(self)
      return .error(e)
    case let .error(e):
      return .error(e)
    }
  }

  public func newRangeIterator(start: BigInt,
                               step: BigInt,
                               length: BigInt) -> PyRangeIterator {
    let type = self.types.range_iterator
    return self.memory.newRangeIterator(type: type,
                                        start: start,
                                        step: step,
                                        length: length)
  }

  // MARK: - Enumerate

  public func newEnumerate(iterable: PyObject,
                           initialIndex: Int) -> PyResultGen<PyEnumerate> {
    let bigIndex = BigInt(initialIndex)
    return self.newEnumerate(iterable: iterable, initialIndex: bigIndex)
  }

  public func newEnumerate(iterable: PyObject,
                           initialIndex: BigInt) -> PyResultGen<PyEnumerate> {
    let iterator: PyObject
    switch self.iter(object: iterable) {
    case let .value(i): iterator = i
    case let .error(e): return .error(e)
    }

    let type = self.types.enumerate
    let result = self.memory.newEnumerate(type: type,
                                          iterator: iterator,
                                          initialIndex: initialIndex)

    return .value(result)
  }

  // MARK: - Slice

  public func newSlice(stop: PyObject) -> PySlice {
    let none = self.none.asObject
    return self.newSlice(start: none, stop: stop, step: none)
  }

  public func newSlice(start: PyObject?,
                       stop: PyObject?,
                       step: PyObject? = nil) -> PySlice {
    let type = self.types.slice
    let none = self.none.asObject
    return self.memory.newSlice(type: type,
                                start: start ?? none,
                                stop: stop ?? none,
                                step: step ?? none)
  }

  // MARK: - Length

  /// len(s)
  /// See [this](https://docs.python.org/3/library/functions.html#len)
  public func length(iterable: PyObject) -> PyResult {
    if let result = PyStaticCall.__len__(self, object: iterable) {
      return result
    }

    switch self.callMethod(object: iterable, selector: .__len__) {
    case .value(let o):
      return .value(o)
    case .missingMethod:
      let message = "object of type '\(iterable.typeName)' has no len()"
      return .typeError(self, message: message)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  public func lengthPyInt(iterable: PyObject) -> PyResultGen<PyInt> {
    switch self.length(iterable: iterable) {
    case let .value(object):
      guard let result = self.cast.asInt(object) else {
        let message = "'\(object)' object cannot be interpreted as an integer"
        return .typeError(self, message: message)
      }

      return .value(result)

    case let .error(e):
      return .error(e)
    }
  }

  public func lengthInt(tuple: PyTuple) -> Int {
    return tuple.count
  }

  public func lengthInt(dict: PyDict) -> Int {
    return dict.elements.count
  }

  public func lengthInt(iterable: PyObject) -> PyResultGen<Int> {
    switch self.lengthPyInt(iterable: iterable) {
    case let .value(pyInt):
      guard let int = Int(exactly: pyInt.value) else {
        return .overflowError(self, message: "Object length is too big")
      }

      return .value(int)

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Contains

  /// Does this `iterable` contain this element?
  ///
  /// int
  /// PySequence_Contains(PyObject *seq, PyObject *ob)
  public func contains(iterable: PyObject, object: PyObject) -> PyResult {
    if let result = PyStaticCall.__contains__(self, object: iterable, element: object) {
      return result
    }

    switch self.callMethod(object: iterable, selector: .__contains__, arg: object) {
    case .value(let o):
      return PyResult(o)
    case .missingMethod:
      break // try other things
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }

    return self.iterSearch(iterable: iterable, object: object)
  }

  /// Py_ssize_t
  /// _PySequence_IterSearch(PyObject *seq, PyObject *obj, int operation)
  private func iterSearch(iterable: PyObject, object: PyObject) -> PyResult {
    let result = self.reduce(iterable: iterable, initial: false) { _, element in
      switch self.isEqualBool(left: element, right: object) {
      case .value(true): return .finish(true)
      case .value(false): return .goToNextElement
      case .error(let e): return .error(e)
      }
    }

    return result.map { $0 ? self.true.asObject : self.false.asObject }
  }

  /// Does this `iterable` contain all of the elments from other iterable?
  public func contains(iterable: PyObject,
                       allFrom subset: PyObject) -> PyResultGen<Bool> {
    // Iterate 'subset' and check if every element is in 'iterable'.
    return self.reduce(iterable: subset, initial: true) { _, object in
      switch self.contains(iterable: iterable, object: object) {
      case let .value(object):
        switch self.isTrueBool(object: object) {
        case .value(true): return .goToNextElement
        case .value(false): return .finish(false)
        case .error(let e): return .error(e)
        }

      case let .error(e):
        return .error(e)
      }
    }
  }

  // MARK: - Sort

  /// sorted(iterable, *, key=None, reverse=False)
  /// See [this](https://docs.python.org/3/library/functions.html#sorted)
  internal func sorted(iterable: PyObject,
                       kwargs: PyDict?) -> PyResultGen<PyList> {
    switch self.newList(iterable: iterable) {
    case let .value(list):
      let listObject = list.asObject
      switch PyList.sort(self, zelf: listObject, args: [], kwargs: kwargs) {
      case .value: return .value(list)
      case .error(let e): return .error(e)
      }
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Select key

  /// In various places (for example: `min`, `max`, `list.sort`) we need to
  /// 'select given key'.
  internal func selectKey(object: PyObject, key: PyObject?) -> PyResult {
    guard let key = key else {
      return .value(object)
    }

    switch self.call(callable: key, arg: object) {
    case .value(let e):
      return .value(e)
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }
}

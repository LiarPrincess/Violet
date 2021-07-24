import BigInt
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore elments newitem anyset

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension PyInstance {

  // MARK: - Tuple

  /// PyObject * PyTuple_New(Py_ssize_t size)
  public func newTuple(_ elements: PyObject...) -> PyTuple {
    return self.newTuple(elements: elements)
  }

  /// PyObject * PyTuple_New(Py_ssize_t size)
  public func newTuple(elements: [PyObject]) -> PyTuple {
    return elements.isEmpty ?
      self.emptyTuple :
      PyMemory.newTuple(elements: elements)
  }

  /// PyObject * PyList_AsTuple(PyObject *v)
  public func newTuple(fromList object: PyObject) -> PyResult<PyTuple> {
    guard let list = PyCast.asList(object) else {
      let e = self.unexpectedCollectionTypeError(expected: "list", got: object)
      return .error(e)
    }

    let result = self.newTuple(fromList: list)
    return .value(result)
  }

  public func newTuple(fromList list: PyList) -> PyTuple {
    return self.newTuple(elements: list.elements)
  }

  public func newTuple(iterable: PyObject) -> PyResult<PyTuple> {
    return self.toArray(iterable: iterable).map(self.newTuple)
  }

  private func unexpectedCollectionTypeError(expected: String,
                                             got: PyObject) -> PyTypeError {
    let gotType = got.typeName
    let msg = "expected \(expected), but received a '\(gotType)'"
    return Py.newTypeError(msg: msg)
  }

  // MARK: - List

  /// PyObject * PyList_New(Py_ssize_t size)
  public func newList(_ elements: PyObject...) -> PyList {
    return self.newList(elements: elements)
  }

  /// PyObject * PyList_New(Py_ssize_t size)
  public func newList(elements: [PyObject]) -> PyList {
    return PyMemory.newList(elements: elements)
  }

  public func newList(iterable: PyObject) -> PyResult<PyList> {
    return self.toArray(iterable: iterable).map(self.newList)
  }

  /// int PyList_Append(PyObject *op, PyObject *newitem)
  public func add(list object: PyObject, element: PyObject) -> PyResult<PyNone> {
    guard let list = PyCast.asList(object) else {
      let e = self.unexpectedCollectionTypeError(expected: "list", got: object)
      return .error(e)
    }

    self.add(list: list, element: element)
    return .value(Py.none)
  }

  public func add(list: PyList, element: PyObject) {
    list.append(element)
  }

  // MARK: - Set

  public func newSet() -> PySet {
    let elements = PySet.OrderedSet()
    return self.newSet(elements: elements)
  }

  internal func newSet(elements: PySet.OrderedSet) -> PySet {
    return PyMemory.newSet(elements: elements)
  }

  /// PyObject * PySet_New(PyObject *iterable)
  public func newSet(elements args: [PyObject]) -> PyResult<PySet> {
    let elements = self.asSetElements(args: args)
    return elements.map(self.newSet(elements:))
  }

  private func asSetElements(args: [PyObject]) -> PyResult<PySet.OrderedSet> {
    var data = PySetData()

    for object in args {
      switch data.insert(object: object) {
      case .ok:
        break
      case .error(let e):
        return .error(e)
      }
    }

    let result = data.elements
    return .value(result)
  }

  /// int PySet_Add(PyObject *anyset, PyObject *key)
  public func add(set object: PyObject, element: PyObject) -> PyResult<PyNone> {
    guard let set = PyCast.asSet(object) else {
      let e = self.unexpectedCollectionTypeError(expected: "set", got: object)
      return .error(e)
    }

    return self.add(set: set, element: element)
  }

  public func add(set: PySet, element: PyObject) -> PyResult<PyNone> {
    return set.add(element)
  }

  public func update(set: PySet, from object: PyObject) -> PyResult<PyNone> {
    return set.update(from: object)
  }

  // MARK: - Frozen set

  public func newFrozenSet() -> PyFrozenSet {
    return self.emptyFrozenSet
  }

  internal func newFrozenSet(elements: PyFrozenSet.OrderedSet) -> PyFrozenSet {
    return elements.isEmpty ?
      self.emptyFrozenSet :
      PyMemory.newFrozenSet(elements: elements)
  }

  public func newFrozenSet(elements args: [PyObject]) -> PyResult<PyFrozenSet> {
    let elements = self.asSetElements(args: args)
    return elements.map(self.newFrozenSet(elements:))
  }

  // MARK: - Dictionary

  public func newDict() -> PyDict {
    let elements = PyDict.OrderedDictionary()
    return self.newDict(elements: elements)
  }

  internal func newDict(elements: PyDict.OrderedDictionary) -> PyDict {
    return PyMemory.newDict(elements: elements)
  }

  public struct DictionaryElement {
    public let key: PyObject
    public let value: PyObject

    public init(key: PyObject, value: PyObject) {
      self.key = key
      self.value = value
    }
  }

  public func newDict(elements: [DictionaryElement]) -> PyResult<PyDict> {
    let result = self.newDict()

    for element in elements {
      let setResult = result.set(key: element.key, to: element.value)
      switch setResult {
      case .ok:
        break
      case .error(let e):
        return .error(e)
      }
    }

    return .value(result)
  }

  public func newDict(keys: PyTuple, elements: [PyObject]) -> PyResult<PyDict> {
    guard keys.elements.count == elements.count else {
      return .valueError("bad 'dictionary(keyTuple:elements:)' keys argument")
    }

    var result = PyDict.OrderedDictionary()

    for (key, value) in Swift.zip(keys.elements, elements) {
      switch self.hash(object: key) {
      case let .value(hash):
        let dictKey = PyDict.Key(hash: hash, object: key)
        switch result.insert(key: dictKey, value: value) {
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

  public func add(dict object: PyObject,
                  key: IdString,
                  value: PyObject) -> PyResult<PyNone> {
    return self.add(dict: object, key: key.value, value: value)
  }

  public func add(dict object: PyObject,
                  key: PyObject,
                  value: PyObject) -> PyResult<PyNone> {
    guard let dict = PyCast.asDict(object) else {
      let e = self.unexpectedCollectionTypeError(expected: "dict", got: object)
      return .error(e)
    }

    return self.add(dict: dict, key: key, value: value)
  }

  public func add(dict: PyDict,
                  key: PyObject,
                  value: PyObject) -> PyResult<PyNone> {
    switch dict.set(key: key, to: value) {
    case .ok:
      return .value(Py.none)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Keys

  public enum GetKeysResult {
    case value(PyObject)
    case error(PyBaseException)
    case missingMethod(PyBaseException)
  }

  /// Call the `keys` method on object.
  public func getKeys(object: PyObject) -> GetKeysResult {
    if let result = PyStaticCall.keys(object) {
      return .value(result)
    }

    switch Py.callMethod(object: object, selector: .keys) {
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

  public func newRange(stop: BigInt) -> PyResult<PyRange> {
    return self.newRange(stop: self.newInt(stop))
  }

  public func newRange(stop: PyInt) -> PyResult<PyRange> {
    let start = self.newInt(0)
    return self.newRange(start: start, stop: stop, step: nil)
  }

  public func newRange(stop: PyObject) -> PyResult<PyRange> {
    return self.extractRangeProperty(stop).flatMap(self.newRange(stop:))
  }

  public func newRange(start: BigInt,
                       stop: BigInt,
                       step: BigInt?) -> PyResult<PyRange> {
    return self.newRange(
      start: self.newInt(start),
      stop: self.newInt(stop),
      step: step.map(self.newInt)
    )
  }

  public func newRange(start: PyInt,
                       stop: PyInt,
                       step: PyInt?) -> PyResult<PyRange> {
    if let s = step, s.value == 0 {
      return .valueError("range() arg 3 must not be zero")
    }

    let result = PyMemory.newRange(start: start, stop: stop, step: step)
    return .value(result)
  }

  public func newRange(start: PyObject,
                       stop: PyObject,
                       step: PyObject?) -> PyResult<PyRange> {
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

  private func extractRangeProperty(_ object: PyObject) -> PyResult<PyInt> {
    // If we are already 'PyInt' then we have to use EXACTLY this value!
    // >>> i = 2**60 # <-- high value to skip interned values (small int cache)
    // >>> assert range(i).stop is i

    if let objectInt = PyCast.asInt(object) {
      return .value(objectInt)
    }

    switch IndexHelper.bigInt(object) {
    case let .value(int):
      return .value(self.newInt(int))
    case let .error(e),
         let .notIndex(e):
      return .error(e)
    }
  }

  // MARK: - Enumerate

  public func newEnumerate(iterable: PyObject,
                           startFrom index: Int) -> PyResult<PyEnumerate> {
    return self.newEnumerate(iterable: iterable, startFrom: BigInt(index))
  }

  public func newEnumerate(iterable: PyObject,
                           startFrom index: BigInt) -> PyResult<PyEnumerate> {
    let iter: PyObject
    switch self.iter(object: iterable) {
    case let .value(i): iter = i
    case let .error(e): return .error(e)
    }

    let result = PyMemory.newEnumerate(iterator: iter, startFrom: index)
    return .value(result)
  }

  // MARK: - Slice

  public func newSlice(stop: PyObject) -> PySlice {
    return PyMemory.newSlice(start: self.none,
                             stop: stop,
                             step: self.none)
  }

  public func newSlice(start: PyObject?,
                       stop: PyObject?,
                       step: PyObject? = nil) -> PySlice {
    return PyMemory.newSlice(start: start ?? self.none,
                             stop: stop ?? self.none,
                             step: step ?? self.none)
  }

  // MARK: - Length

  /// len(s)
  /// See [this](https://docs.python.org/3/library/functions.html#len)
  public func len(iterable: PyObject) -> PyResult<PyObject> {
    if let result = PyStaticCall.__len__(iterable) {
      return .value(self.newInt(result))
    }

    switch self.callMethod(object: iterable, selector: .__len__) {
    case .value(let o):
      return .value(o)
    case .missingMethod:
      return .typeError("object of type '\(iterable.typeName)' has no len()")
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }
  }

  public func lenBigInt(iterable: PyObject) -> PyResult<BigInt> {
    // Avoid 'PyObject' allocation inside `self.length(iterable: PyObject)`
    if let result = PyStaticCall.__len__(iterable) {
      return .value(result)
    }

    // Use `self.length(iterable: PyObject)`
    switch self.len(iterable: iterable) {
    case let .value(object):
      guard let pyInt = PyCast.asInt(object) else {
        return .typeError("'\(object)' object cannot be interpreted as an integer")
      }

      return .value(pyInt.value)

    case let .error(e):
      return .error(e)
    }
  }

  public func lenInt(tuple: PyTuple) -> Int {
    return tuple.data.count
  }

  public func lenInt(iterable: PyObject) -> PyResult<Int> {
    return self.lenBigInt(iterable: iterable)
      .flatMap { bigInt -> PyResult<Int> in
        guard let int = Int(exactly: bigInt) else {
          return .overflowError("Object length is too big")
        }

        return .value(int)
      }
  }

  // MARK: - Contains

  /// Does this `iterable` contain this element?
  ///
  /// int
  /// PySequence_Contains(PyObject *seq, PyObject *ob)
  public func contains(iterable: PyObject, element: PyObject) -> PyResult<Bool> {
    if let result = PyStaticCall.__contains__(iterable, element: element) {
      return result
    }

    switch self.callMethod(object: iterable, selector: .__contains__, arg: element) {
    case .value(let o):
      return self.isTrueBool(object: o)
    case .missingMethod:
      break // try other things
    case .error(let e),
         .notCallable(let e):
      return .error(e)
    }

    return self.iterSearch(iterable: iterable, element: element)
  }

  /// Py_ssize_t
  /// _PySequence_IterSearch(PyObject *seq, PyObject *obj, int operation)
  private func iterSearch(iterable: PyObject,
                          element: PyObject) -> PyResult<Bool> {
    return self.reduce(iterable: iterable, initial: false) { _, object in
      switch self.isEqualBool(left: object, right: element) {
      case .value(true): return .finish(true)
      case .value(false): return .goToNextElement
      case .error(let e): return .error(e)
      }
    }
  }

  /// Does this `iterable` contain all of the elments from other iterable?
  public func contains(iterable: PyObject,
                       allFrom subset: PyObject) -> PyResult<Bool> {
    // Iterate 'subset' and check if every element is in 'iterable'.
    return self.reduce(iterable: subset, initial: true) { _, object in
      switch self.contains(iterable: iterable, element: object) {
      case .value(true): return .goToNextElement
      case .value(false): return .finish(false)
      case .error(let e): return .error(e)
      }
    }
  }

  // MARK: - Sort

  /// sorted(iterable, *, key=None, reverse=False)
  /// See [this](https://docs.python.org/3/library/functions.html#sorted)
  internal func sorted(iterable: PyObject,
                       kwargs: PyDict?) -> PyResult<PyList> {
    switch self.newList(iterable: iterable) {
    case let .value(list):
      switch list.sort(args: [], kwargs: kwargs) {
      case .value: return .value(list)
      case .error(let e): return .error(e)
      }
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - To array

  /// Convert iterable to Swift array.
  ///
  /// Most of the time you want to use `Py.reduce` though…
  public func toArray(iterable: PyObject) -> PyResult<[PyObject]> {
    if let trivialArray = self.triviallyIntoSwiftArray(iterable: iterable) {
      return .value(trivialArray)
    }

    var result = [PyObject]()
    let reduceError = self.reduce(iterable: iterable, into: &result) { acc, object in
      acc.append(object)
      return .goToNextElement
    }

    if let e = reduceError {
      return .error(e)
    }

    return .value(result)
  }

  /// Some types can be trivially converted to Swift array without all of that
  /// `__iter__/__next__` ceremony.
  private func triviallyIntoSwiftArray(iterable: PyObject) -> [PyObject]? {
    // swiftlint:disable:previous discouraged_optional_collection

    // We always have to go with 'asExactly…' version because user can override
    // '__iter__' or '__next__' in which case they are no longer 'trivial'.

    if let tuple = PyCast.asExactlyTuple(iterable) {
      return tuple.elements
    }

    if let list = PyCast.asExactlyList(iterable) {
      return list.elements
    }

    if let dict = PyCast.asExactlyDict(iterable) {
      // '__iter__' on dict returns 'dict_keyiterator'
      return dict.elements.map { $0.key.object }
    }

    if let set = PyCast.asSet(iterable) {
      return set.data.elements.map { $0.object }
    }

    if let set = PyCast.asFrozenSet(iterable) {
      return set.data.elements.map { $0.object }
    }

    if let bytes = PyCast.asExactlyAnyBytes(iterable) {
      return bytes.elements.map(self.newInt)
    }

    if let string = PyCast.asExactlyString(iterable) {
      return string.elements.map(self.intern(scalar:))
    }

    return nil
  }

  // MARK: - Reduce

  /// `Builtins.reduce(iterable:initial:fn)` trampoline.
  public enum ReduceStep<Acc> {
    /// Go to the next item without changing `acc`.
    case goToNextElement
    /// Go to the next item using given `acc`.
    case setAcc(Acc)
    /// End reduction with given `acc`.
    /// Use this if you already have the result and don't need to iterate anymore.
    case finish(Acc)
    /// Finish reduction with given error.
    case error(PyBaseException)
  }

  public typealias ReduceFn<Acc> = (Acc, PyObject) -> ReduceStep<Acc>

  /// Returns the result of combining the elements of the sequence
  /// using the given closure.
  ///
  /// This method is similar to `Swift.Sequence.reduce(_:_:)`.
  public func reduce<Acc>(iterable: PyObject,
                          initial: Acc,
                          fn: ReduceFn<Acc>) -> PyResult<Acc> {
    // Fast path if we are an object with known conversion.
    if let array = self.triviallyIntoSwiftArray(iterable: iterable) {
      return self.reduce(array: array, initial: initial, fn: fn)
    }

    let iter: PyObject
    switch self.iter(object: iterable) {
    case let .value(i): iter = i
    case let .error(e): return .error(e)
    }

    var acc = initial
    while true {
      switch self.next(iterator: iter) {
      case .value(let object):
        switch fn(acc, object) {
        case .goToNextElement: break // do nothing
        case .setAcc(let a): acc = a
        case .finish(let a): return .value(a)
        case .error(let e): return .error(e)
        }

      case .error(let e):
        if PyCast.isStopIteration(e) {
          return .value(acc)
        }

        return .error(e)
      }
    }
  }

  private func reduce<Acc>(array: [PyObject],
                           initial: Acc,
                           fn: ReduceFn<Acc>) -> PyResult<Acc> {
    var acc = initial

    for o in array {
      switch fn(acc, o) {
      case .goToNextElement: break // do nothing
      case .setAcc(let a): acc = a
      case .finish(let a): return .value(a)
      case .error(let e): return .error(e)
      }
    }

    return .value(acc)
  }

  // MARK: - Reduce into

  /// `Builtins.reduce(iterable:into:fn)` trampoline.
  public enum ReduceIntoStep<Acc> {
    /// Go to the next item.
    case goToNextElement
    /// End reduction.
    /// Use this if you already have the result and don't need to iterate anymore.
    case finish
    /// Finish reduction with given error.
    case error(PyBaseException)
  }

  public typealias ReduceIntoFn<Acc> = (inout Acc, PyObject) -> ReduceIntoStep<Acc>

  /// Returns the result of combining the elements of the sequence
  /// using the given closure.
  ///
  /// This is preferred over `reduce(iterable:initial:fn:)` for efficiency when
  /// the result is a copy-on-write type, for example an `Array` or a `Dictionary`.
  ///
  /// - Important
  /// This is a bit different than the `Swift.Sequence.reduce(into:)`!
  /// It will not copy  the `into` argument, but pass it directly into provided
  /// `fn` function for modification.
  ///
  /// Example usage:
  ///
  /// ```Swift
  /// var values = [1, 2, 3]
  /// let reduceError = Py.reduce(iterable: iterable, into: &values) { acc, object in
  ///   // Modify 'acc'
  ///   // Swift non-overlapping access guarantees that 'values' are not accessible
  /// }
  ///
  /// // Handle 'error' (if any) or use 'values' (now you can access them)
  /// ```
  ///
  /// - Warning
  /// Do not merge into `Py.reduce(iterable:initial:fn:)`!
  /// I am 90% sure it will create needles copy during COW.
  public func reduce<Acc>(iterable: PyObject,
                          into acc: inout Acc,
                          fn: ReduceIntoFn<Acc>) -> PyBaseException? {
    // Fast path if we are an object with known conversion.
    if let array = self.triviallyIntoSwiftArray(iterable: iterable) {
      return self.reduce(array: array, into: &acc, fn: fn)
    }

    let iter: PyObject
    switch self.iter(object: iterable) {
    case let .value(i): iter = i
    case let .error(e): return e
    }

    while true {
      switch self.next(iterator: iter) {
      case .value(let object):
        switch fn(&acc, object) {
        case .goToNextElement: break // mutation is our side-effect
        case .finish: return nil
        case .error(let e): return e
        }

      case .error(let e):
        if PyCast.isStopIteration(e) {
          return nil
        }

        return e
      }
    }
  }

  private func reduce<Acc>(array: [PyObject],
                           into acc: inout Acc,
                           fn: ReduceIntoFn<Acc>) -> PyBaseException? {
    for object in array {
      switch fn(&acc, object) {
      case .goToNextElement: break // mutation is our side-effect
      case .finish: return nil
      case .error(let e): return e
      }
    }

    return nil
  }

  // MARK: - Select key

  /// In various places (for example: `min`, `max`, `list.sort`) we need to
  /// 'select given key'.
  internal func selectKey(object: PyObject, key: PyObject?) -> PyResult<PyObject> {
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

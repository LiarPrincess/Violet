import Core

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

// swiftlint:disable file_length

public class CreateDictionaryArg {
  public let key: PyObject
  public let value: PyObject

  public init(key: PyObject, value: PyObject) {
    self.key = key
    self.value = value
  }
}

extension Builtins {

  // MARK: - Tuple

  /// PyObject * PyTuple_New(Py_ssize_t size)
  public func newTuple(_ elements: PyObject...) -> PyTuple {
    return self.newTuple(elements)
  }

  /// PyObject * PyTuple_New(Py_ssize_t size)
  public func newTuple(_ elements: [PyObject]) -> PyTuple {
    return elements.isEmpty ?
      self.emptyTuple :
      PyTuple(elements: elements)
  }

  /// PyObject * PyList_AsTuple(PyObject *v)
  public func newTuple(list object: PyObject) -> PyResult<PyTuple> {
    return self.cast(object, as: PyList.self, typeName: "list")
      .map { self.newTuple($0.data) }
  }

  public func newTuple(iterable: PyObject) -> PyResult<PyTuple> {
    if let seq = iterable as? PySequenceType {
      return .value(self.newTuple(seq.data))
    }

    return self.toArray(iterable: iterable).map(self.newTuple)
  }

  internal func newTuple(_ data: PySequenceData) -> PyTuple {
    return data.isEmpty ?
      self.emptyTuple :
      PyTuple(data: data)
  }

  // MARK: - List

  /// PyObject * PyList_New(Py_ssize_t size)
  public func newList(_ elements: PyObject...) -> PyList {
    return self.newList(elements)
  }

  /// PyObject * PyList_New(Py_ssize_t size)
  public func newList(_ elements: [PyObject]) -> PyList {
    return PyList(elements: elements)
  }

  internal func newList(_ data: PySequenceData) -> PyList {
    return PyList(data: data)
  }

  internal func newList(iterable: PyObject) -> PyResult<PyList> {
    return self.toArray(iterable: iterable).map(self.newList)
  }

  /// int PyList_Append(PyObject *op, PyObject *newitem)
  public func add(list object: PyObject, element: PyObject) -> PyResult<PyNone> {
    return self.cast(object, as: PyList.self, typeName: "list")
      .flatMap { $0.append(element) }
  }

  // MARK: - Set

  /// PyObject * PySet_New(PyObject *iterable)
  public func newSet(_ elements: [PyObject] = []) -> PyResult<PySet> {
    return self.toSetData(elements).map(self.newSet(_:))
  }

  internal func newSet(_ data: PySetData) -> PySet {
    return PySet(data: data)
  }

  /// int PySet_Add(PyObject *anyset, PyObject *key)
  public func add(set object: PyObject, value: PyObject) -> PyResult<PyNone> {
    return self.cast(object, as: PySet.self, typeName: "set")
      .flatMap { $0.add(value) }
  }

  private func toSetData(_ elements: [PyObject]) -> PyResult<PySetData> {
    var data = PySetData()

    for element in elements {
      switch data.insert(value: element) {
      case .ok: break
      case .error(let e): return .error(e)
      }
    }

    return .value(data)
  }

  // MARK: - Frozen set

  public func newFrozenSet(_ elements: [PyObject] = []) -> PyResult<PyFrozenSet> {
    return self.toSetData(elements).map(self.newFrozenSet(_:))
  }

  internal func newFrozenSet(_ data: PySetData) -> PyFrozenSet {
    return data.isEmpty ?
      self.emptyFrozenSet :
      PyFrozenSet(data: data)
  }

  // MARK: - Dictionary

  internal func newDict(data: PyDictData? = nil) -> PyDict {
    return PyDict(data: data ?? PyDictData())
  }

  public func newDict(elements: [CreateDictionaryArg]) -> PyResult<PyDict> {
    var data = PyDictData()
    for arg in elements {
      switch self.hash(arg.key) {
      case let .value(hash):
        let key = PyDictKey(hash: hash, object: arg.key)
        switch data.insert(key: key, value: arg.value) {
        case .inserted, .updated: break
        case .error(let e): return .error(e)
        }
      case let .error(e):
        return .error(e)
      }
    }

    return .value(PyDict(data: data))
  }

  public func newDict(keys: PyTuple, elements: [PyObject]) -> PyResult<PyDict> {
    guard keys.elements.count == elements.count else {
      return .valueError("bad 'dictionary(keyTuple:elements:)' keys argument")
    }

    var data = PyDictData()
    for (keyObject, value) in Swift.zip(keys.elements, elements) {
      switch self.hash(keyObject) {
      case let .value(hash):
        let key = PyDictKey(hash: hash, object: keyObject)
        switch data.insert(key: key, value: value) {
        case .inserted, .updated: break
        case .error(let e): return .error(e)
        }
      case let .error(e):
        return .error(e)
      }
    }

    return .value(PyDict(data: data))
  }

  public func add(dict object: PyObject,
                  key: PyObject,
                  value: PyObject) -> PyResult<PyNone> {
    return self.cast(object, as: PyDict.self, typeName: "dict")
      .flatMap { $0.setItem(at: key, to: value) }
  }

  // MARK: - Range

  public func newRange(stop: BigInt) -> PyResult<PyRange> {
    return self.newRange(stop: self.newInt(stop))
  }

  public func newRange(stop: PyInt) -> PyResult<PyRange> {
    return self.newRange(start: self.newInt(0), stop: stop, step: nil)
  }

  public func newRange(stop: PyObject) -> PyResult<PyRange> {
    return IndexHelper.bigInt(stop).flatMap(self.newRange(stop:))
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

    return .value(PyRange(start: start, stop: stop, step: step))
  }

  public func newRange(start: PyObject,
                       stop: PyObject,
                       step: PyObject?) -> PyResult<PyRange> {
    let parsedStart: BigInt
    switch IndexHelper.bigInt(start) {
    case let .value(i): parsedStart = i
    case let .error(e): return .error(e)
    }

    let parsedStop: BigInt
    switch IndexHelper.bigInt(stop) {
    case let .value(i): parsedStop = i
    case let .error(e): return .error(e)
    }

    guard let step = step else {
      return self.newRange(start: parsedStart, stop: parsedStop, step: nil)
    }

    let parsedStep: BigInt
    switch IndexHelper.bigInt(step) {
    case let .value(i): parsedStep = i
    case let .error(e): return .error(e)
    }

    return self.newRange(start: parsedStart, stop: parsedStop, step: parsedStep)
  }

  // MARK: - Enumerate

  public func newEnumerate(iterable: PyObject,
                           startFrom index: Int) -> PyResult<PyEnumerate> {
    return self.newEnumerate(iterable: iterable, startFrom: BigInt(index))
  }

  public func newEnumerate(iterable: PyObject,
                           startFrom index: BigInt) -> PyResult<PyEnumerate> {
    let iter: PyObject
    switch self.iter(from: iterable) {
    case let .value(i): iter = i
    case let .error(e): return .error(e)
    }

    let result = PyEnumerate(iterator: iter, startFrom: index)
    return .value(result)
  }

  // MARK: - Slice

  public func newSlice(stop: PyObject) -> PySlice {
    return PySlice(
      start: self.none,
      stop: stop,
      step: self.none
    )
  }

  public func newSlice(start: PyObject?,
                       stop: PyObject?,
                       step: PyObject? = nil) -> PySlice {
    return PySlice(
      start: start ?? self.none,
      stop: stop ?? self.none,
      step: step ?? self.none
    )
  }

  // MARK: - Length

  // sourcery: pymethod = len
  /// len(s)
  /// See [this](https://docs.python.org/3/library/functions.html#len)
  public func length(iterable: PyObject) -> PyResult<PyObject> {
    if let owner = iterable as? __len__Owner {
      let bigInt = owner.getLength()
      return .value(self.newInt(bigInt))
    }

    switch self.callMethod(on: iterable, selector: "__len__") {
    case .value(let o):
      return .value(o)
    case .missingMethod:
      return .typeError("object of type '\(iterable.typeName)' has no len()")
    case .error(let e), .notCallable(let e):
      return .error(e)
    }
  }

  public func lengthBigInt(iterable: PyObject) -> PyResult<BigInt> {
    // Avoid 'PyObject' allocation inside `self.length(iterable: PyObject)`
    if let owner = iterable as? __len__Owner {
      let bigInt = owner.getLength()
      return .value(bigInt)
    }

    // Use `self.length(iterable: PyObject)`
    switch self.length(iterable: iterable) {
    case let .value(object):
      guard let pyInt = object as? PyInt else {
        return .typeError("'\(object)' object cannot be interpreted as an integer")
      }

      return .value(pyInt.value)

    case let .error(e):
      return .error(e)
    }
  }

  public func lengthInt(tuple: PyTuple) -> Int {
    return tuple.data.count
  }

  public func lengthInt(iterable: PyObject) -> PyResult<Int> {
    return self.lengthBigInt(iterable: iterable)
      .flatMap { bigInt -> PyResult<Int> in
        guard let int = Int(exactly: bigInt) else {
          return .overflowError("Object length is too big")
        }

        return .value(int)
      }
  }

  // MARK: - Contains

  /// int
  /// PySequence_Contains(PyObject *seq, PyObject *ob)
  public func contains(iterable: PyObject,
                       element: PyObject) -> PyResult<Bool> {
    if let owner = iterable as? __contains__Owner {
      return owner.contains(element)
    }

    switch self.callMethod(on: iterable, selector: "__contains__", arg: element) {
    case .value(let o):
      return self.isTrueBool(o)
    case .missingMethod:
      break // try other things
    case .error(let e), .notCallable(let e):
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

  public func contains(iterable: PyObject,
                       allFrom subset: PyObject) -> PyResult<Bool> {
    return self.reduce(iterable: subset, initial: true) { _, object in
      switch self.contains(iterable: iterable, element: object) {
      case .value(true): return .goToNextElement
      case .value(false): return .finish(false)
      case .error(let e): return .error(e)
      }
    }
  }

  // MARK: - Sort

  private static let sortedDoc = """
    sorted($module, iterable, /, *, key=None, reverse=False)
    --

    Return a new list containing all items from the iterable in ascending order.

    A custom key function can be supplied to customize the sort order, and the
    reverse flag can be set to request the result in descending order.
    """

  // sourcery: pymethod = sorted
  /// sorted(iterable, *, key=None, reverse=False)
  /// See [this](https://docs.python.org/3/library/functions.html#sorted)
  public func sorted(iterable: PyObject,
                     key: PyObject? = nil,
                     reverse: PyObject? = nil) -> PyResult<PyList> {
    switch self.newList(iterable: iterable) {
    case let .value(list):
      switch list.sort(key: key, isReverse: reverse) {
      case .value: return .value(list)
      case .error(let e): return .error(e)
      }
    case let .error(e):
      return .error(e)
    }
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
    case error(PyErrorEnum)
  }

  public typealias ReduceFn<Acc> = (Acc, PyObject) -> ReduceStep<Acc>

  /// Returns the result of combining the elements of the sequence
  /// using the given closure.
  ///
  /// This method is similiar to `Array.reduce(_:_:)`.
  public func reduce<Acc>(iterable: PyObject,
                          initial: Acc,
                          fn: ReduceFn<Acc>)  -> PyResult<Acc> {
    let iter: PyObject
    switch self.iter(from: iterable) {
    case let .value(i): iter = i
    case let .error(e): return .error(e)
    }

    var acc = initial
    while true {
      switch self.next(iterator: iter) {
      case .value(let o):
        switch fn(acc, o) {
        case .goToNextElement: break // do nothing
        case .setAcc(let a): acc = a
        case .finish(let a): return .value(a)
        case .error(let e): return .error(e)
        }

      case .error(.stopIteration):
        return .value(acc)

      case .error(let e):
        return .error(e)
      }
    }
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
    case error(PyErrorEnum)
  }

  public typealias ReduceIntoFn<Acc> = (inout Acc, PyObject) -> ReduceIntoStep<Acc>

  /// Returns the result of combining the elements of the sequence
  /// using the given closure.
  ///
  /// This method is similiar to `Array.reduce(into:_:)`.
  ///
  /// It is preferred over `reduce(_:_:)` for efficiency when the result
  /// is a copy-on-write type, for example an `Array` or a `Dictionary`.
  ///
  /// - Warning
  /// Do not merge into `reduce(_:_:)`!
  /// I am 90% sure it will create needles copy during COW.
  public func reduce<Acc>(iterable: PyObject,
                          into initial: Acc,
                          fn: ReduceIntoFn<Acc>)  -> PyResult<Acc> {
    let iter: PyObject
    switch self.iter(from: iterable) {
    case let .value(i): iter = i
    case let .error(e): return .error(e)
    }

    var acc = initial
    while true {
      switch self.next(iterator: iter) {
      case .value(let o):
        switch fn(&acc, o) {
        case .goToNextElement: break // mutation is our side-effect
        case .finish: return .value(acc)
        case .error(let e): return .error(e)
        }

      case .error(.stopIteration):
        return .value(acc)

      case .error(let e):
        return .error(e)
      }
    }
  }

  // MARK: - Helpers

  private func cast<T>(_ object: PyObject,
                       as type: T.Type,
                       typeName: String) -> PyResult<T> {
    if let v = object as? T {
      return .value(v)
    }

    return .typeError("expected \(typeName), but received a '\(object.typeName)'")
  }

  internal func toArray(iterable: PyObject) -> PyResult<[PyObject]> {
    return self.reduce(iterable: iterable, into: [PyObject]()) { acc, object in
      acc.append(object)
      return .goToNextElement
    }
  }

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

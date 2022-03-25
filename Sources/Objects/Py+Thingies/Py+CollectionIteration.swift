import Foundation
import BigInt
import VioletCore

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Py {

  // MARK: - To array

  /// Convert iterable to Swift array.
  ///
  /// Most of the time you want to use `self.reduce` though…
  public func toArray(iterable: PyObject) -> PyResultGen<[PyObject]> {
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

  // MARK: - For each

  public enum ForEachStep {
    /// Go to the next item.
    case goToNextElement
    /// Finish iteration.
    case finish
    /// Finish iteration with given error.
    case error(PyBaseException)
  }

  public typealias ForEachFn = (PyObject) -> ForEachStep

  /// Iterate `iterable` without returning any result (just for the side-effects).
  public func forEach(iterable: PyObject, fn: ForEachFn) -> PyBaseException? {
    let result = self.reduce(iterable: iterable, initial: ()) { _, object in
      switch fn(object) {
      case .goToNextElement: return .goToNextElement
      case .finish: return .finish(())
      case .error(let e): return .error(e)
      }
    }

    switch result {
    case .value:
      return nil
    case .error(let e):
      return e
    }
  }

  public typealias ForEachDictFn = (PyObject, PyObject) -> ForEachStep

  /// Iterate `dict` without returning any result (just for the side-effects).
  ///
  /// 1st argument is `key`.
  /// 2nd argument is `value`.
  public func forEach(dict: PyDict, fn: ForEachDictFn) -> PyBaseException? {
    for entry in dict.elements {
      let key = entry.key.object
      let value = entry.value

      switch fn(key, value) {
      case .goToNextElement:
        break
      case .finish:
        return nil
      case .error(let e):
        return e
      }
    }

    return nil
  }

  public typealias ForEachTupleFn = (Int, PyObject) -> ForEachStep

  public func forEach(tuple: PyTuple, fn: ForEachTupleFn) -> PyBaseException? {
    for (index, object) in tuple.elements.enumerated() {
      switch fn(index, object) {
      case .goToNextElement:
        break
      case .finish:
        return nil
      case .error(let e):
        return e
      }
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
    /// Finish reduction with given `acc`.
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
                          fn: ReduceFn<Acc>) -> PyResultGen<Acc> {
    // Fast path if we are an object with known conversion.
    if let iterator = self.triviallyIntoSwiftIterator(iterable: iterable) {
      return self.reduce(iterator: iterator, initial: initial, fn: fn)
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
        if self.cast.isStopIteration(e.asObject) {
          return .value(acc)
        }

        return .error(e)
      }
    }
  }

  private func reduce<Acc>(iterator: AnyIterator<PyObject>,
                           initial: Acc,
                           fn: ReduceFn<Acc>) -> PyResultGen<Acc> {
    var acc = initial

    for o in iterator {
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
    /// Finish reduction.
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
  /// let reduceError = self.reduce(iterable: iterable, into: &values) { acc, object in
  ///   // Modify 'acc'
  ///   // Swift non-overlapping access guarantees that 'values' are not accessible
  /// }
  ///
  /// // Handle 'error' (if any) or use 'values' (now you can access them)
  /// ```
  ///
  /// - Warning
  /// Do not merge into `self.reduce(iterable:initial:fn:)`!
  /// I am 90% sure it will create needles copy during COW.
  public func reduce<Acc>(iterable: PyObject,
                          into acc: inout Acc,
                          fn: ReduceIntoFn<Acc>) -> PyBaseException? {
    // Fast path if we are an object with known conversion.
    if let iterator = self.triviallyIntoSwiftIterator(iterable: iterable) {
      return self.reduce(iterator: iterator, into: &acc, fn: fn)
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
        if self.cast.isStopIteration(e.asObject) {
          return nil
        }

        return e
      }
    }
  }

  private func reduce<Acc>(iterator: AnyIterator<PyObject>,
                           into acc: inout Acc,
                           fn: ReduceIntoFn<Acc>) -> PyBaseException? {
    for object in iterator {
      switch fn(&acc, object) {
      case .goToNextElement: break // mutation is our side-effect
      case .finish: return nil
      case .error(let e): return e
      }
    }

    return nil
  }

  // MARK: - Into Swift array

  /// Some types can be trivially converted to Swift array without all of that
  /// `__iter__/__next__` ceremony.
  private func triviallyIntoSwiftArray(iterable: PyObject) -> [PyObject]? {
    // swiftlint:disable:previous discouraged_optional_collection

    // We always have to go with 'asExactly…' version because user can override
    // '__iter__' or '__next__' in which case they are no longer 'trivial'.

    if let tuple = self.cast.asExactlyTuple(iterable) {
      return tuple.elements
    }

    if let list = self.cast.asExactlyList(iterable) {
      return list.elements
    }

    if let dict = self.cast.asExactlyDict(iterable) {
      // '__iter__' on dict returns 'dict_keyiterator'
      return dict.elements.map { $0.key.object }
    }

    if let set = self.cast.asExactlyAnySet(iterable) {
      return set.elements.map { $0.object }
    }

    if let bytes = self.cast.asExactlyAnyBytes(iterable) {
      return bytes.elements.map { self.newInt($0).asObject }
    }

    if let string = self.cast.asExactlyString(iterable) {
      return string.elements.map { self.intern(scalar: $0).asObject }
    }

    return nil
  }

  // MARK: - Into Swift iterator

  /// Some types can be trivially converted to Swift iterator without all of that
  /// `__iter__/__next__` ceremony.
  private func triviallyIntoSwiftIterator(iterable: PyObject) -> AnyIterator<PyObject>? {
    // We always have to go with 'asExactly…' version because user can override
    // '__iter__' or '__next__' in which case they are no longer 'trivial'.

    if let tuple = self.cast.asExactlyTuple(iterable) {
      let result = TupleListIterator(elements: tuple.elements)
      return AnyIterator(result)
    }

    if let list = self.cast.asExactlyList(iterable) {
      let result = TupleListIterator(elements: list.elements)
      return AnyIterator(result)
    }

    if let dict = self.cast.asExactlyDict(iterable) {
      let result = DictIterator(dict: dict)
      return AnyIterator(result)
    }

    if let set = self.cast.asExactlyAnySet(iterable) {
      let result = SetIterator(set: set)
      return AnyIterator(result)
    }

    if let bytes = self.cast.asExactlyAnyBytes(iterable) {
      let result = BytesIterator(self, bytes: bytes)
      return AnyIterator(result)
    }

    if let string = self.cast.asExactlyString(iterable) {
      let result = StringIterator(self, string: string)
      return AnyIterator(result)
    }

    return nil
  }

  private struct TupleListIterator: IteratorProtocol {

    private var inner: Array<PyObject>.Iterator

    fileprivate init(elements: [PyObject]) {
      self.inner = elements.makeIterator()
    }

    fileprivate mutating func next() -> PyObject? {
      return self.inner.next()
    }
  }

  /// `__iter__` on dict returns `dict_keyiterator`
  private struct DictIterator: IteratorProtocol {

    private var inner: PyDict.OrderedDictionary.Iterator

    fileprivate init(dict: PyDict) {
      self.inner = dict.elements.makeIterator()
    }

    fileprivate mutating func next() -> PyObject? {
      let entry = self.inner.next()
      return entry?.key.object
    }
  }

  private struct SetIterator: IteratorProtocol {

    private var inner: PySet.OrderedSet.Iterator

    fileprivate init(set: PyAnySet) {
      self.inner = set.elements.makeIterator()
    }

    fileprivate mutating func next() -> PyObject? {
      let entry = self.inner.next()
      return entry?.object
    }
  }

  private struct BytesIterator: IteratorProtocol {

    private let py: Py
    private var inner: Data.Iterator

    fileprivate init(_ py: Py, bytes: PyAnyBytes) {
      self.py = py
      self.inner = bytes.elements.makeIterator()
    }

    fileprivate mutating func next() -> PyObject? {
      guard let byte = self.inner.next() else {
        return nil
      }

      let int = self.py.newInt(byte)
      return int.asObject
    }
  }

  private struct StringIterator: IteratorProtocol {

    private let py: Py
    private var inner: String.UnicodeScalarView.Iterator

    fileprivate init(_ py: Py, string: PyString) {
      self.py = py
      self.inner = string.elements.makeIterator()
    }

    fileprivate mutating func next() -> PyObject? {
      guard let scalar = self.inner.next() else {
        return nil
      }

      let string = self.py.newString(scalar: scalar)
      return string.asObject
    }
  }
}

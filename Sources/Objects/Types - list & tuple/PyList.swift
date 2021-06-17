import BigInt
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore listobject

// In CPython:
// Objects -> listobject.c
// https://docs.python.org/3.7/c-api/list.html

// sourcery: pytype = list, default, hasGC, baseType, listSubclass
/// This subtype of PyObject represents a Python list object.
public class PyList: PyObject, PySequenceType {

  internal static let doc: String = """
    list(iterable=(), /)
    --

    Built-in mutable sequence.

    If no argument is given, the constructor creates a new empty list.
    The argument must be an iterable if specified.
    """

  internal var data: PySequenceData

  internal var elements: [PyObject] {
    return self.data.elements
  }

  override public var description: String {
    return "PyList(count: \(self.elements.count))"
  }

  // MARK: - Init

  convenience init(elements: [PyObject]) {
    let data = PySequenceData(elements: elements)
    self.init(data: data)
  }

  internal init(data: PySequenceData) {
    self.data = data
    super.init(type: Py.types.list)
  }

  /// Use only in `__new__`!
  internal init(type: PyType, data: PySequenceData) {
    self.data = data
    super.init(type: type)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0.isEqual(to: $1) }
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0.isLess(than: $1) }
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0.isLessEqual(than: $1) }
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0.isGreater(than: $1) }
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0.isGreaterEqual(than: $1) }
  }

  private func compare(
    with other: PyObject,
    using compareFn: (PySequenceData, PySequenceData) -> CompareResult
  ) -> CompareResult {
    guard let other = PyCast.asList(other) else {
      return .notImplemented
    }

    return compareFn(self.data, other.data)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> HashResult {
    return .error(Py.hashNotImplemented(self))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    if self.hasReprLock {
      return .value("[...]")
    }

    return self.withReprLock {
      self.data.repr(openBracket: "[",
                     closeBracket: "]",
                     appendCommaIfSingleElement: false)
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

  // sourcery: pymethod = __len__
  internal func getLength() -> BigInt {
    return BigInt(self.data.count)
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(element: PyObject) -> PyResult<Bool> {
    return self.data.contains(value: element)
  }

  // MARK: - Get/set/del item

  // sourcery: pymethod = __getitem__
  internal func getItem(index: PyObject) -> PyResult<PyObject> {
    switch self.data.getItem(index: index) {
    case let .single(s): return .value(s)
    case let .slice(s): return .value(Py.newList(s))
    case let .error(e): return .error(e)
    }
  }

  // sourcery: pymethod = __setitem__
  internal func setItem(index: PyObject, value: PyObject) -> PyResult<PyNone> {
    return self.data.setItem(index: index, value: value)
  }

  // sourcery: pymethod = __delitem__
  internal func delItem(index: PyObject) -> PyResult<PyNone> {
    return self.data.delItem(index: index)
  }

  // MARK: - Count

  // sourcery: pymethod = count
  internal func count(element: PyObject) -> PyResult<BigInt> {
    return self.data.count(element: element).map(BigInt.init)
  }

  // MARK: - Index

  // Special overload for `IndexOwner` protocol
  internal func index(of element: PyObject) -> PyResult<BigInt> {
    return self.index(of: element, start: nil, end: nil)
  }

  // sourcery: pymethod = index
  internal func index(of element: PyObject,
                      start: PyObject?,
                      end: PyObject?) -> PyResult<BigInt> {
    return self.data.index(of: element,
                           start: start,
                           end: end,
                           typeName: "list")
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return PyListIterator(list: self)
  }

  // sourcery: pymethod = __reversed__
  internal func reversed() -> PyObject {
    return PyListReverseIterator(list: self)
  }

  // MARK: - Append

  // sourcery: pymethod = append
  internal func append(_ element: PyObject) -> PyResult<PyNone> {
    self.data.append(element)
    return .value(Py.none)
  }

  // MARK: - Insert

  internal static let insertDoc = """
    insert($self, index, object, /)
    --

    Insert object before index.
    """

  // sourcery: pymethod = insert, doc = insertDoc
  internal func insert(index: PyObject, item: PyObject) -> PyResult<PyNone> {
    return self.data.insert(index: index, item: item)
  }

  // MARK: - Extend

  // sourcery: pymethod = extend
  internal func extend(iterable: PyObject) -> PyResult<PyNone> {
    return self.data.extend(iterable: iterable)
  }

  // MARK: - Remove

  internal static let removeDoc = """
    remove($self, value, /)
    --

    Remove first occurrence of value.

    Raises ValueError if the value is not present.
    """

  // sourcery: pymethod = remove, doc = removeDoc
  internal func remove(_ value: PyObject) -> PyResult<PyNone> {
    return self.data.remove(typeName: self.typeName, value: value)
  }

  // MARK: - Pop

  // sourcery: pymethod = pop
  internal func pop(index: PyObject?) -> PyResult<PyObject> {
    return self.data.pop(index: index, typeName: "list")
  }

  // MARK: - Sort

  internal static let sortDoc = """
    sort($self, /, *, key=None, reverse=False)
    --

    Stable sort *IN PLACE*.
    """

  private static let sortArguments = ArgumentParser.createOrTrap(
    arguments: ["key", "reverse"],
    format: "|$OO:sort"
  )

  // sourcery: pymethod = sort, doc = sortDoc
  internal func sort(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    if let e = ArgumentParser.guaranteeArgsCountOrError(fnName: "sort",
                                                        args: args,
                                                        min: 0,
                                                        max: 0) {
      return .error(e)
    }

    switch PyList.sortArguments.bind(args: [], kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      let key = binding.optional(at: 0)
      let isReverse = binding.optional(at: 1)
      return self.sort(key: key, isReverse: isReverse)
    case let .error(e):
      return .error(e)
    }
  }

  internal func sort(key _key: PyObject?,
                     isReverse: PyObject?) -> PyResult<PyNone> {
    let isKeyNilOrNone = _key?.isNone ?? true
    let key = isKeyNilOrNone ? nil : _key

    guard let isReverse = isReverse else {
      return self.sort(key: key, isReverse: false)
    }

    switch Py.isTrueBool(isReverse) {
    case let .value(b):
      return self.sort(key: key, isReverse: b)
    case let .error(e):
      return .error(e)
    }
  }

  private struct ElementWithKey {
    /// Sort key (result of calling `key` function on `self.element`).
    fileprivate let key: PyObject
    fileprivate let element: PyObject
  }

  /// Wrapper for `PyBaseException` so that it can be used with `throw`.
  private enum SortError: Error {
    case wrapper(PyBaseException)
  }

  internal func sort(key: PyObject?, isReverse: Bool) -> PyResult<PyNone> {
    // Make list is temporarily empty to detect any modifications made by 'key' fn.
    // CPython does the same:
    // >>> l = [1, 2, 3]
    // >>> def get_key(e):
    // ...   print(l)
    // ...   return e
    // ...
    // >>> l.sort(key=get_key)
    // []
    // []
    // []
    var copy = self.data.elements
    _ = self.data.clear()

    // Cache keys (for a brief moment we will use 3*memory)
    var keyedElements = [ElementWithKey]()
    for object in copy {
      switch Py.selectKey(object: object, key: key) {
      case let .value(k):
        keyedElements.append(ElementWithKey(key: k, element: object))
      case let .error(e):
        self.data = PySequenceData(elements: copy) // Go back to elements before keys
        return .error(e)
      }
    }

    guard self.data.isEmpty else {
      self.data = PySequenceData(elements: copy) // Go back to elements before keys
      return .error(self.createListModifiedDuringSortError())
    }

    // On exit we will assign sorted elements to 'self.data'.
    // Even if sort fails we will assign partially sorted elements.
    // Also, we no longer need 'copy' (we moved data to 'keyedElements').
    defer { self.data = PySequenceData(elements: keyedElements.map { $0.element }) }
    copy = []

    do {
      let fn = self.createSortFn()

      // Reverse sort stability achieved by initially reversing the list,
      // applying a forward sort, then reversing the final result.
      //
      // Remember that the last declared 'defer' will run first!
      // So it will be:
      // 1. undo reversal
      // 2. assign to 'self.data.elements'
      if isReverse { keyedElements.reverse() }
      defer { if isReverse { keyedElements.reverse() } }

      // Note that Python requires STABLE sort, which Swift does not guarantee!
      // But we will conveniently ignore this fact… because reasons…
      // Btw. under certain conditions Swift sort is actually stable
      // (at the time of writing this comment), but that's an implementation detail.
      try keyedElements.sort(by: fn)

      // Check if user tried to touch our list.
      // Remember that 'self.data' was set to []
      // (and it still should be empty because 'defer' did not run yet)!
      guard self.data.isEmpty else {
        return .error(self.createListModifiedDuringSortError())
      }

      return .value(Py.none)
    } catch let SortError.wrapper(e) {
      return .error(e)
    } catch {
      trap("Unexpected error type in PyList.sort: \(error)")
    }
  }

  private typealias SortFn = (ElementWithKey, ElementWithKey) throws -> Bool

  private func createSortFn() -> SortFn {
    return { (lhs: ElementWithKey, rhs: ElementWithKey) -> Bool in
      switch Py.isLessBool(left: lhs.key, right: rhs.key) {
      case let .value(b): return b
      case let .error(e): throw SortError.wrapper(e)
      }
    }
  }

  private func createListModifiedDuringSortError() -> PyBaseException {
    return Py.newValueError(msg: "list modified during sort")
  }

  // MARK: - Reverse

  internal static let reverseDoc = """
    reverse($self, /)
    --

    Reverse *IN PLACE*.
    """

  // sourcery: pymethod = reverse, doc = reverseDoc
  internal func reverse() -> PyResult<PyNone> {
    return self.data.reverse()
  }

  // MARK: - Clear

  // sourcery: pymethod = clear
  internal func clear() -> PyNone {
    return self.data.clear()
  }

  // MARK: - Copy

  // sourcery: pymethod = copy
  internal func copy() -> PyObject {
    return Py.newList(self.data)
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResult<PyObject> {
    guard let otherList = PyCast.asList(other) else {
      let msg = "can only concatenate list (not '\(other.typeName)') to list"
      return .typeError(msg)
    }

    let result = self.data.add(other: otherList.data)
    return .value(Py.newList(result))
  }

  // sourcery: pymethod = __iadd__
  internal func iadd(_ other: PyObject) -> PyResult<PyObject> {
    switch self.extend(iterable: other) {
    case .value:
      return .value(self)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  internal func mul(_ other: PyObject) -> PyResult<PyObject> {
    return self.mulResult(self.data.mul(count: other))
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResult<PyObject> {
    return self.mulResult(self.data.rmul(count: other))
  }

  // sourcery: pymethod = __imul__
  internal func imul(_ other: PyObject) -> PyResult<PyObject> {
    switch self.data.mul(count: other) {
    case .value(let elements):
      self.data = PySequenceData(elements: elements)
      return .value(self)
    case .notImplemented:
      return .value(Py.notImplemented)
    case .error(let e):
      return .error(e)
    }
  }

  private func mulResult(_ result: PySequenceData.MulResult) -> PyResult<PyObject> {
    switch result {
    case .value(let elements):
      return .value(Py.newList(elements))
    case .error(let e):
      return .error(e)
    case .notImplemented:
      return .value(Py.notImplemented)
    }
  }

  // MARK: - Check exact

  public func checkExact() -> Bool {
    return self.type === Py.types.list
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyList> {
    let isBuiltin = type === Py.types.list
    let alloca = isBuiltin ?
      PyList.init(type:data:) :
      PyListHeap.init(type:data:)

    let data = PySequenceData()
    return .value(alloca(type, data))
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal func pyInit(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> {
    if self.type === Py.types.list {
      if let e = ArgumentParser.noKwargsOrError(fnName: self.typeName,
                                                kwargs: kwargs) {
        return .error(e)
      }
    }

    if let e = ArgumentParser.guaranteeArgsCountOrError(fnName: self.typeName,
                                                        args: args,
                                                        min: 0,
                                                        max: 1) {
      return .error(e)
    }

    if let iterable = args.first {
      switch self.data.extend(iterable: iterable) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    return .value(Py.none)
  }
}
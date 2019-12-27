import Core

// In CPython:
// Objects -> listobject.c
// https://docs.python.org/3.7/c-api/list.html

// swiftlint:disable file_length

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

  // MARK: - Init

  convenience init(_ context: PyContext, elements: [PyObject]) {
    let data = PySequenceData(elements: elements)
    self.init(context, data: data)
  }

  internal init(_ context: PyContext, data: PySequenceData) {
    self.data = data
    super.init(type: context.builtins.types.list)
  }

  /// Use only in `__new__`!
  internal init(type: PyType, data: PySequenceData) {
    self.data = data
    super.init(type: type)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyList else {
      return .notImplemented
    }

    return self.data.isEqual(to: other.data).asResultOrNot
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return NotEqualHelper.fromIsEqual(self.isEqual(other))
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyList else {
      return .notImplemented
    }

    return self.data.isLess(than: other.data).asResultOrNot
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyList else {
      return .notImplemented
    }

    return self.data.isLessEqual(than: other.data).asResultOrNot
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyList else {
      return .notImplemented
    }

    return self.data.isGreater(than: other.data).asResultOrNot
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyList else {
      return .notImplemented
    }

    return self.data.isGreaterEqual(than: other.data).asResultOrNot
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> PyResultOrNot<PyHash> {
    return .error(self.builtins.hashNotImplemented(self))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    if self.hasReprLock {
      return .value("[...]")
    }

    return self.withReprLock {
      self.data.repr(openBrace: "[", closeBrace: "]")
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

  internal var isEmpty: Bool {
    return self.data.isEmpty
  }

  // sourcery: pymethod = __len__
  internal func getLength() -> BigInt {
    return BigInt(self.data.count)
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(_ element: PyObject) -> PyResult<Bool> {
    return self.data.contains(value: element)
  }

  // MARK: - Get item

  // sourcery: pymethod = __getitem__
  internal func getItem(at index: PyObject) -> PyResult<PyObject> {
    switch self.data.getItem(index: index, typeName: "list") {
    case let .single(s): return .value(s)
    case let .slice(s): return .value(self.builtins.newList(s))
    case let .error(e): return .error(e)
    }
  }

  // MARK: - Set/del item

  // sourcery: pymethod = __setitem__
  internal func setItem(at index: PyObject,
                        to value: PyObject) -> PyResult<PyNone> {
    return self.data.setItem(at: index, to: value)
      .map { _ in self.builtins.none }
  }

  // sourcery: pymethod = __delitem__
  internal func delItem(at index: PyObject) -> PyResult<PyNone> {
    return self.data.delItem(at: index)
      .map { _ in self.builtins.none }
  }

  // MARK: - Count

  // sourcery: pymethod = count
  internal func count(_ element: PyObject) -> PyResult<BigInt> {
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
      .map(BigInt.init)
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
    return .value(self.builtins.none)
  }

  // MARK: - Insert

  internal static let insertDoc = """
    insert($self, index, object, /)
    --

    Insert object before index.
    """

  // sourcery: pymethod = insert, doc = insertDoc
  internal func insert(at index: PyObject, item: PyObject) -> PyResult<PyNone> {
    return self.data.insert(at: index, item: item).map { _ in self.builtins.none }
  }

  // MARK: - Extend

  // sourcery: pymethod = extend
  internal func extend(iterable: PyObject) -> PyResult<PyNone> {
    return self.data.extend(iterable: iterable).map { _ in self.builtins.none }
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
    return self.data.remove(value).map { _ in self.builtins.none }
  }

  // MARK: - Pop

  // sourcery: pymethod = pop
  internal func pop(index: PyObject?) -> PyResult<PyObject> {
    switch self.parsePopIndex(from: index) {
    case let .value(i):
      return self.data.pop(at: i, typeName: "list")
    case let .error(e):
      return .error(e)
    }
  }

  private func parsePopIndex(from index: PyObject?) -> PyResult<Int> {
    guard let index = index else {
      return .value(-1)
    }

    return IndexHelper.int(index)
  }

  // MARK: - Sort

  private static let sortDoc = """
    sort($self, /, *, key=None, reverse=False)
    --

    Stable sort *IN PLACE*.
    """

  private static let sortArguments = ArgumentParser.createOrFatal(
    arguments: ["key", "reverse"],
    format: "|$OO:sort"
  )

  // sourcery: pymethod = sort, doc = sortDoc
  internal func sort(args: [PyObject], kwargs: PyDictData?) -> PyResult<PyNone> {
    switch PyList.sortArguments.parse(args: [], kwargs: kwargs) {
    case let .value(bind):
      assert(bind.count <= 2, "Invalid argument count returned from parser.")
      let key = bind.count >= 1 ? bind[0] : nil
      let isReverse = bind.count >= 2 ? bind[1] : nil
      return self.sort(key: key, isReverse: isReverse)
    case let .error(e):
      return .error(e)
    }
  }

  private struct SortElement {
    fileprivate let key: PyObject
    fileprivate let element: PyObject
  }

  /// Wrapper for `PyErrorEnum` so that it can be used after `throw`.
  private enum SortError: Error {
    case builtin(PyErrorEnum)
  }

  internal func sort(key: PyObject?, isReverse: PyObject?) -> PyResult<PyNone> {
    guard let isReverse = isReverse else {
      return self.sort(key: key, isReverse: false)
    }

    switch self.builtins.isTrueBool(isReverse) {
    case let .value(b):
      return self.sort(key: key, isReverse: b)
    case let .error(e):
      return .error(e)
    }
  }

  internal func sort(key: PyObject?, isReverse: Bool) -> PyResult<PyNone> {
    var elements = [SortElement]()
    for object in self.elements {
      switch self.builtins.selectKey(object: object, key: key) {
      case let .value(k): elements.append(SortElement(key: k, element: object))
      case let .error(e): return .error(e)
      }
    }

    do {
      let fn = self.createSortFn(isReverse: isReverse)

      // Note that Python requires STABLE sort, but Swift does not guarantee
      // that! We will ignore this. (Because reasons...)
      // Btw. under certain conditions Swift sort is actually stable (at the time
      // of writting this comment), but that's an implementation detail.
      try elements.sort(by: fn)
      self.data = PySequenceData(elements: elements.map { $0.element })
      return .value(self.builtins.none)
    } catch let SortError.builtin(e) {
      return .error(e)
    } catch {
      fatalError("Unexpected error in PyList.sort: \(error)")
    }
  }

  private typealias SortFn = (SortElement, SortElement) throws -> Bool

  private func createSortFn(isReverse: Bool) -> SortFn {
    return { (lhs: SortElement, rhs: SortElement) in
      let builtins = lhs.element.builtins

      switch builtins.isLessBool(left: lhs.key, right: rhs.key) {
      case let .value(b): return isReverse ? !b : b
      case let .error(e): throw SortError.builtin(e)
      }
    }
  }

  // MARK: - Reverse

  internal static let reverseDoc = """
    reverse($self, /)
    --

    Reverse *IN PLACE*.
    """

  // sourcery: pymethod = reverse, doc = reverseDoc
  internal func reverse() -> PyResult<PyNone> {
    self.data.reverse()
    return .value(self.builtins.none)
  }

  // MARK: - Clear

  // sourcery: pymethod = clear
  internal func clear() -> PyResult<PyNone> {
    self.data.clear()
    return .value(self.builtins.none)
  }

  // MARK: - Copy

  // sourcery: pymethod = copy
  internal func copy() -> PyObject {
    return self.builtins.newList(self.data)
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let otherList = other as? PyList else {
      let msg = "can only concatenate list (not '\(other.typeName)') to list"
      return .typeError(msg)
    }

    let result = self.data.add(other: otherList.data)
    return .value(self.builtins.newList(result))
  }

  // sourcery: pymethod = __iadd__
  internal func iadd(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let otherList = other as? PyList else {
      let msg = "can only concatenate list (not '\(other.typeName)') to list"
      return .typeError(msg)
    }

    self.data.iadd(other: otherList.data)
    return .value(self)
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  internal func mul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.data.mul(count: other).map(self.builtins.newList)
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return self.data.rmul(count: other).map(self.builtins.newList)
  }

  // sourcery: pymethod = __imul__
  internal func imul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    switch self.data.mul(count: other) {
    case .value(let elements):
      self.data = PySequenceData(elements: elements)
      return .value(self)
    case .notImplemented:
      return .notImplemented
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDictData?) -> PyResult<PyObject> {
    let isBuiltin = type === type.builtins.list
    let alloca = isBuiltin ?
      PyList.init(type:data:) :
      PyListHeap.init(type:data:)

    let data = PySequenceData()
    return .value(alloca(type, data))
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal static func pyInit(zelf: PyList,
                              args: [PyObject],
                              kwargs: PyDictData?) -> PyResult<PyNone> {
    if zelf.type === zelf.builtins.list {
      if let e = ArgumentParser.noKwargsOrError(fnName: zelf.typeName,
                                                kwargs: kwargs) {
        return .error(e)
      }
    }

    if let e = ArgumentParser.guaranteeArgsCountOrError(fnName: zelf.typeName,
                                                        args: args,
                                                        min: 0,
                                                        max: 1) {
      return .error(e)
    }

    if let iterable = args.first {
      switch zelf.data.extend(iterable: iterable) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    return .value(zelf.builtins.none)
  }
}

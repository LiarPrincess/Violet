import BigInt
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore listobject

// In CPython:
// Objects -> listobject.c
// https://docs.python.org/3.7/c-api/list.html

// sourcery: pytype = list, default, hasGC, baseType, listSubclass
// sourcery: subclassInstancesHave__dict__
/// This subtype of PyObject represents a Python list object.
public final class PyList: PyObject, AbstractSequence {

  // sourcery: pytypedoc
  internal static let doc = """
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

  internal var isEmpty: Bool {
    return self.elements.isEmpty
  }

  internal var count: Int {
    return self.elements.count
  }

  override public var description: String {
    return "PyList(count: \(self.elements.count))"
  }

  // MARK: - Init

  internal convenience init(elements: [PyObject]) {
    let type = Py.types.list
    self.init(type: type, elements: elements)
  }

  internal init(type: PyType, elements: [PyObject]) {
    self.data = PySequenceData(elements: elements)
    super.init(type: type)
  }

  // MARK: - AbstractSequence

  internal static let _pythonTypeName = "list"

  internal static func _toSelf(elements: [PyObject]) -> PyList {
    return Py.newList(elements: elements)
  }

  internal static func _asSelf(object: PyObject) -> PyList? {
    return PyCast.asList(object)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    return self._isEqual(other: other)
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self._isNotEqual(other: other)
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    return self._isLess(other: other)
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    return self._isLessEqual(other: other)
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    return self._isGreater(other: other)
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return self._isGreaterEqual(other: other)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> HashResult {
    return .unhashable(self)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    return self._repr(openBracket: "[",
                      closeBracket: "]",
                      appendCommaIfSingleElement: false)
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
    return BigInt(self._length)
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(object: PyObject) -> PyResult<Bool> {
    return self._contains(object: object)
  }

  // MARK: - Get/set/del item

  // sourcery: pymethod = __getitem__
  internal func getItem(index: PyObject) -> PyResult<PyObject> {
    return self._getItem(index: index)
  }

  // sourcery: pymethod = __setitem__
  internal func setItem(index: PyObject, object: PyObject) -> PyResult<PyNone> {
    return self.data.setItem(index: index, object: object)
  }

  // sourcery: pymethod = __delitem__
  internal func delItem(index: PyObject) -> PyResult<PyNone> {
    return self.data.delItem(index: index)
  }

  // MARK: - Count

  // sourcery: pymethod = count
  internal func count(object: PyObject) -> PyResult<BigInt> {
    return self._count(object: object)
  }

  // MARK: - Index

  // Special overload for `index` static method
  internal func indexOf(object: PyObject) -> PyResult<BigInt> {
    return self.indexOf(object: object, start: nil, end: nil)
  }

  // sourcery: pymethod = index
  internal func indexOf(object: PyObject,
                        start: PyObject?,
                        end: PyObject?) -> PyResult<BigInt> {
    return self._indexOf(object: object, start: start, end: end)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return PyMemory.newListIterator(list: self)
  }

  // sourcery: pymethod = __reversed__
  internal func reversed() -> PyObject {
    return PyMemory.newListReverseIterator(list: self)
  }

  // MARK: - Append

  // sourcery: pymethod = append
  internal func append(object: PyObject) {
    self.data.append(object: object)
  }

  // MARK: - Insert

  internal static let insertDoc = """
    insert($self, index, object, /)
    --

    Insert object before index.
    """

  // sourcery: pymethod = insert, doc = insertDoc
  internal func insert(index: PyObject, object: PyObject) -> PyResult<PyNone> {
    return self.data.insert(index: index, object: object)
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
  internal func remove(object: PyObject) -> PyResult<PyNone> {
    return self.data.remove(typeName: self.typeName, object: object)
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
    return Py.newList(elements: self.data.elements)
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResult<PyObject> {
    switch self._handleAddArgument(object: other) {
    case let .value(list):
      let result = self._add(other: list)
      return .value(result)
    case let .error(e):
      return .error(e)
    }
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
    switch self._handleMulArgument(object: other) {
    case .value(let int):
      let result = self._mul(count: int)
      return .value(result)
    case .notImplemented:
      return .value(Py.notImplemented)
    }
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResult<PyObject> {
    return self.mul(other)
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

  private func handle(mulResult: PySequenceData.MulResult) -> PyResult<PyObject> {
    switch mulResult {
    case .value(let elements):
      return .value(Py.newList(elements: elements))
    case .error(let e):
      return .error(e)
    case .notImplemented:
      return .value(Py.notImplemented)
    }
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyList> {
    let elements = [PyObject]()
    let isBuiltin = type === Py.types.list

    // If this is a builtin then try to re-use interned values
    // (if we even have interned 'list').
    let result: PyList = isBuiltin ?
      Py.newList(elements: elements) :
      PyMemory.newList(type: type, elements: elements)

    return .value(result)
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

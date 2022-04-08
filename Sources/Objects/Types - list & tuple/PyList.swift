import BigInt
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore listobject

// In CPython:
// Objects -> listobject.c
// https://docs.python.org/3.7/c-api/list.html

// sourcery: pytype = list, isDefault, hasGC, isBaseType, isListSubclass
// sourcery: subclassInstancesHave__dict__
public struct PyList: PyObjectMixin, AbstractSequence {

  // sourcery: pytypedoc
  internal static let doc = """
    list(iterable=(), /)
    --

    Built-in mutable sequence.

    If no argument is given, the constructor creates a new empty list.
    The argument must be an iterable if specified.
    """

  // sourcery: storedProperty
  internal var elements: [PyObject] {
    // Do not add 'nonmutating set/_modify' - the compiler could get confused
    // sometimes. Use 'self.elementsPtr.pointee' for modification.
    self.elementsPtr.pointee
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, elements: [PyObject]) {
    self.initializeBase(py, type: type)
    self.elementsPtr.initialize(to: elements)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyList(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "count", value: zelf.count, includeInDescription: true)
    result.append(name: "elements", value: zelf.elements, includeInDescription: true)
    return result
  }

  // MARK: - AbstractSequence

  internal static func newObject(_ py: Py, elements: [PyObject]) -> PyList {
    return py.newList(elements: elements)
  }

  // MARK: - Equatable, comparable

  // sourcery: pymethod = __eq__
  internal static func __eq__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__eq__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __ne__
  internal static func __ne__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__ne__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __lt__
  internal static func __lt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__lt__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __le__
  internal static func __le__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__le__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __gt__
  internal static func __gt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__gt__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __ge__
  internal static func __ge__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__ge__(py, zelf: zelf, other: other)
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

    if zelf.isEmpty {
      return PyResult(py, interned: "[]")
    }

    if zelf.hasReprLock {
      return PyResult(py, interned: "[...]")
    }

    return zelf.withReprLock {
      switch Self.abstractJoinElementsForRepr(py, zelf: zelf, prefix: "[", suffix: "]") {
      case let .value(result):
        return PyResult(py, result)
      case let .error(e):
        return .error(e)
      }
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

  // MARK: - Contains, count, index of

  // sourcery: pymethod = __contains__
  internal static func __contains__(_ py: Py, zelf: PyObject, object: PyObject) -> PyResult {
    return Self.abstract__contains__(py, zelf: zelf, object: object)
  }

  // sourcery: pymethod = count
  internal static func count(_ py: Py, zelf: PyObject, object: PyObject) -> PyResult {
    return Self.abstractCount(py, zelf: zelf, object: object)
  }

  // Special overload for `index` static method
  internal static func index(_ py: Py, zelf: PyObject, object: PyObject) -> PyResult {
    return Self.index(py, zelf: zelf, object: object, start: nil, end: nil)
  }

  // sourcery: pymethod = index
  internal static func index(_ py: Py,
                             zelf: PyObject,
                             object: PyObject,
                             start: PyObject?,
                             end: PyObject?) -> PyResult {
    return Self.abstractIndex(py, zelf: zelf, object: object, start: start, end: end)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal static func __iter__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__iter__")
    }

    let result = py.newIterator(list: zelf)
    return PyResult(result)
  }

  // sourcery: pymethod = __reversed__
  internal static func __reversed__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__reversed__")
    }

    let result = py.newReverseIterator(list: zelf)
    return PyResult(result)
  }

  // MARK: - Get item

  // sourcery: pymethod = __getitem__
  internal static func __getitem__(_ py: Py,
                                   zelf: PyObject,
                                   index: PyObject) -> PyResult {
    return Self.abstract__getitem__(py, zelf: zelf, index: index)
  }

  // MARK: - Set item

  private enum SetItemImpl: SetItemHelper {

    // swiftlint:disable nesting
    fileprivate typealias Target = [PyObject]
    fileprivate typealias SliceSource = [PyObject]
    // swiftlint:enable nesting

    fileprivate static func getElementToSetAtIntIndex(
      _ py: Py,
      object: PyObject
    ) -> PyResultGen<PyObject> {
      return .value(object)
    }

    fileprivate static func getElementsToSetAtSliceIndices(
      _ py: Py,
      object: PyObject
    ) -> PyResultGen<[PyObject]> {
      switch py.toArray(iterable: object) {
      case let .value(elements):
        return .value(elements)
      case .error:
        return .typeError(py, message: "can only assign an iterable")
      }
    }
  }

  // sourcery: pymethod = __setitem__
  internal static func __setitem__(_ py: Py,
                                   zelf _zelf: PyObject,
                                   index: PyObject,
                                   value: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__setitem__")
    }

    return zelf.setItem(py, index: index, value: value)
  }

  internal func setItem(_ py: Py, index: PyObject, value: PyObject) -> PyResult {
    return SetItemImpl.setItem(py,
                               target: &self.elementsPtr.pointee,
                               index: index,
                               value: value)
  }

  internal func setItem(_ py: Py, index: Int, value: PyObject) -> PyResult {
    return SetItemImpl.setItem(py,
                               target: &self.elementsPtr.pointee,
                               index: index,
                               value: value)
  }

  // MARK: - Del item

  private enum DelItemImpl: DelItemHelper {
    // swiftlint:disable:next nesting
    fileprivate typealias Target = [PyObject]
  }

  // sourcery: pymethod = __delitem__
  internal static func __delitem__(_ py: Py,
                                   zelf _zelf: PyObject,
                                   index: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__delitem__")
    }

    return DelItemImpl.delItem(py, target: &zelf.elementsPtr.pointee, index: index)
  }

  // MARK: - Append, prepend, insert

  // sourcery: pymethod = append
  internal static func append(_ py: Py,
                              zelf _zelf: PyObject,
                              object: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "append")
    }

    zelf.append(object: object)
    return .none(py)
  }

  internal func append(object: PyObject) {
    self.elementsPtr.pointee.append(object)
  }

  // This is not a Python method, but it is used by other types
  internal func prepend(object: PyObject) {
    self.elementsPtr.pointee.insert(object, at: 0)
  }

  internal static let insertDoc = """
    insert($self, index, object, /)
    --

    Insert object before index.
    """

  // sourcery: pymethod = insert, doc = insertDoc
  internal static func insert(_ py: Py,
                              zelf _zelf: PyObject,
                              index: PyObject,
                              object: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "insert")
    }

    let unwrappedIndex = IndexHelper.int(
      py,
      object: index,
      onOverflow: .overflowError(message: "cannot add more objects to list")
    )

    switch unwrappedIndex {
    case let .value(int):
      Self.insert(zelf: zelf, index: int, object: object)
      return .none(py)
    case let .notIndex(lazyError):
      let e = lazyError.create(py)
      return .error(e)
    case let .overflow(_, lazyError):
      let e = lazyError.create(py)
      return .error(e)
    case let .error(e):
      return .error(e)
    }
  }

  private static func insert(zelf: PyList, index: Int, object: PyObject) {
    var index = index

    if index < 0 {
      index += zelf.count
      if index < 0 {
        index = 0
      }
    }

    if index > zelf.count {
      index = zelf.count
    }

    zelf.elementsPtr.pointee.insert(object, at: index)
  }

  // MARK: - Extend

  // sourcery: pymethod = extend
  internal static func extend(_ py: Py,
                              zelf _zelf: PyObject,
                              iterable: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "extend")
    }

    return Self.extend(py, zelf: zelf, iterable: iterable)
  }

  internal static func extend(_ py: Py, zelf: PyList, iterable: PyObject) -> PyResult {
    // Do not modify 'self.elements' until we finished iteration!
    // We do not want to end with half-baked product!
    switch py.toArray(iterable: iterable) {
    case let .value(elements):
      zelf.elementsPtr.pointee.append(contentsOf: elements)
      return .none(py)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Remove

  internal static let removeDoc = """
    remove($self, value, /)
    --

    Remove first occurrence of value.

    Raises ValueError if the value is not present.
    """

  // sourcery: pymethod = remove, doc = removeDoc
  internal static func remove(_ py: Py,
                              zelf _zelf: PyObject,
                              object: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "remove")
    }

    switch Self.findIndex(py, zelf: zelf, object: object) {
    case .index(let index):
      zelf.elementsPtr.pointee.remove(at: index)
      return .none(py)
    case .notFound:
      return .valueError(py, message: "list.remove(x): x not in list")
    case .error(let e):
      return .error(e)
    }
  }

  private enum FindIndexResult {
    case index(Int)
    case notFound
    case error(PyBaseException)
  }

  private static func findIndex(_ py: Py,
                                zelf: PyList,
                                object: PyObject) -> FindIndexResult {
    for (index, element) in zelf.elements.enumerated() {
      switch py.isEqualBool(left: element, right: object) {
      case .value(true):
        return .index(index)
      case .value(false):
        break // go to next element
      case .error(let e):
        return .error(e)
      }
    }

    return .notFound
  }

  // MARK: - Pop

  // sourcery: pymethod = pop
  internal static func pop(_ py: Py,
                           zelf _zelf: PyObject,
                           index: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "pop")
    }

    switch Self.parsePopIndex(py, from: index) {
    case let .value(int):
      return Self.pop(py, zelf: zelf, index: int)
    case let .error(e):
      return .error(e)
    }
  }

  private static func parsePopIndex(_ py: Py, from index: PyObject?) -> PyResultGen<Int> {
    guard let index = index else {
      return .value(-1)
    }

    let unwrappedIndex = IndexHelper.int(
      py,
      object: index,
      onOverflow: .indexError(message: "pop index out of range")
    )

    switch unwrappedIndex {
    case let .value(int):
      return .value(int)
    case let .notIndex(lazyError):
      let e = lazyError.create(py)
      return .error(e)
    case let .overflow(_, lazyError):
      let e = lazyError.create(py)
      return .error(e)
    case let .error(e):
      return .error(e)
    }
  }

  private static func pop(_ py: Py, zelf: PyList, index: Int) -> PyResult {
    if zelf.isEmpty {
      return .indexError(py, message: "pop from empty list")
    }

    var index = index
    if index < 0 {
      index += zelf.count
    }

    // swiftlint:disable:next yoda_condition
    guard 0 <= index && index < zelf.count else {
      return .indexError(py, message: "pop index out of range")
    }

    let result = zelf.elementsPtr.pointee.remove(at: index)
    return .value(result)
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
  internal static func sort(_ py: Py,
                            zelf _zelf: PyObject,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "sort")
    }

    if let e = ArgumentParser.guaranteeArgsCountOrError(py,
                                                        fnName: "sort",
                                                        args: args,
                                                        min: 0,
                                                        max: 0) {
      return .error(e.asBaseException)
    }

    switch Self.sortArguments.bind(py, args: [], kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      let key = binding.optional(at: 0)
      let isReverse = binding.optional(at: 1)
      return zelf.sort(py, key: key, isReverse: isReverse)
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
  internal static func reverse(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "reverse")
    }

    zelf.elementsPtr.pointee.reverse()
    return .none(py)
  }

  // MARK: - Clear

  // sourcery: pymethod = clear
  internal static func clear(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "clear")
    }

    zelf.elementsPtr.pointee.removeAll()
    return .none(py)
  }

  // MARK: - Copy

  // sourcery: pymethod = copy
  internal static func copy(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "copy")
    }

    let result = py.newList(elements: zelf.elements)
    return PyResult(result)
  }

  // MARK: - Add, mul

  // sourcery: pymethod = __add__
  internal static func __add__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.abstract__add__(py, zelf: zelf, other: other, isTuple: false)
  }

  // sourcery: pymethod = __iadd__
  internal static func __iadd__(_ py: Py,
                                zelf _zelf: PyObject,
                                other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__iadd__")
    }

    switch Self.extend(py, zelf: zelf, iterable: other) {
    case .value:
      return PyResult(zelf)
    case .error(let e):
      return .error(e)
    }
  }

  // sourcery: pymethod = __mul__
  internal static func __mul__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.abstract__mul__(py, zelf: zelf, other: other, isTuple: false)
  }

  // sourcery: pymethod = __rmul__
  internal static func __rmul__(_ py: Py, zelf: PyObject, other: PyObject) -> PyResult {
    return Self.abstract__rmul__(py, zelf: zelf, other: other, isTuple: false)
  }

  // sourcery: pymethod = __imul__
  internal static func __imul__(_ py: Py,
                                zelf _zelf: PyObject,
                                other: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__imul__")
    }

    switch Self.abstractParseMulCount(py, object: other) {
    case .value(let int):
      Self.abstractMul(elements: &zelf.elementsPtr.pointee, count: int)
      return PyResult(zelf)
    case .notImplemented:
      return .notImplemented(py)
    }
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    let elements = [PyObject]()
    let isBuiltin = type === py.types.list

    // If this is a builtin then try to re-use interned values
    // (if we even have interned 'list').
    let result: PyList = isBuiltin ?
    py.newList(elements: elements) :
    py.memory.newList(type: type, elements: elements)

    return PyResult(result)
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

    let isBuiltin = zelf.type === py.types.list
    if isBuiltin {
      if let e = ArgumentParser.noKwargsOrError(py,
                                                fnName: Self.pythonTypeName,
                                                kwargs: kwargs) {
        return .error(e.asBaseException)
      }
    }

    if let e = ArgumentParser.guaranteeArgsCountOrError(py,
                                                        fnName: Self.pythonTypeName,
                                                        args: args,
                                                        min: 0,
                                                        max: 1) {
      return .error(e.asBaseException)
    }

    if let iterable = args.first {
      switch Self.extend(py, zelf: zelf, iterable: iterable) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    return .none(py)
  }
}

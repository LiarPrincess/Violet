import BigInt
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore tupleobject

// In CPython:
// Objects -> tupleobject.c
// https://docs.python.org/3.7/c-api/tuple.html

// sourcery: pytype = tuple, isDefault, hasGC, isBaseType, isTupleSubclass
// sourcery: subclassInstancesHave__dict__
public struct PyTuple: PyObjectMixin, AbstractSequence {

  // sourcery: pytypedoc
  internal static let doc = """
    tuple() -> an empty tuple
    tuple(sequence) -> tuple initialized from sequence's items

    If the argument is a tuple, the return value is the same object.
    """

  // Layout will be automatically generated, from `Ptr` fields.
  // Just remember to initialize them in `initialize`!
  internal static let layout = PyMemory.PyTupleLayout()

  internal var elementsPtr: Ptr<[PyObject]> { self.ptr[Self.layout.elementsOffset] }
  internal var elements: [PyObject] { self.elementsPtr.pointee }

  internal var isEmpty: Bool {
    return self.elements.isEmpty
  }

  internal var count: Int {
    return self.elements.count
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, elements: [PyObject]) {
    self.header.initialize(py, type: type)
    self.elementsPtr.initialize(to: elements)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyTuple(ptr: ptr)
    let count = zelf.count
    return "PyTuple(type: \(zelf.typeName), flags: \(zelf.flags), count: \(count))"
  }
}

/* MARKER
  // MARK: - AbstractSequence

  internal static let _pythonTypeName = "tuple"

  internal static func _toSelf(elements: [PyObject]) -> PyTuple {
    return Py.newTuple(elements: elements)
  }

  internal static func _asSelf(object: PyObject) -> PyTuple? {
    return PyCast.asTuple(object)
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
    return PyTuple.calculateHash(elements: self.elements)
  }

  internal static func calculateHash(elements: [PyObject]) -> HashResult {
    var x: PyHash = 0x34_5678
    var multiplier = Hasher.multiplier

    for e in elements {
      switch Py.hash(object: e) {
      case let .value(y):
        x = (x ^ y) &* multiplier
        multiplier &+= 82_520 + PyHash(2 * elements.count)
      case let .error(e):
        return .error(e)
      }
    }

    return .value(x &+ 97_531)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    if self._isEmpty {
      return .value("()")
    }

    // While not mutable, it is still possible to end up with a cycle in a tuple
    // through an object that stores itself within a tuple (and thus infinitely
    // asks for the repr of itself).
    if self.hasReprLock {
      return .value("(...)")
    }

    return self.withReprLock {
      switch self._joinElementsForRepr() {
      case let .value(elements):
        let commaIfNeeded = self._length == 1 ? "," : ""
        let result = "(" + elements + commaIfNeeded + ")"
        return .value(result)
      case let .error(e):
        return .error(e)
      }
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
    return BigInt(self._length)
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(object: PyObject) -> PyResult<Bool> {
    return self._contains(object: object)
  }

  // MARK: - Get item

  // sourcery: pymethod = __getitem__
  internal func getItem(index: PyObject) -> PyResult<PyObject> {
    return self._getItem(index: index)
  }

  // MARK: - Count

  // sourcery: pymethod = count
  internal func count(object: PyObject) -> PyResult<BigInt> {
    return self._count(object: object)
  }

  // MARK: - Index of

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
    return PyMemory.newTupleIterator(tuple: self)
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResult<PyObject> {
    switch self._handleAddArgument(object: other) {
    case let .value(tuple):
      let result = self.add(tuple)
      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }

  private func add(_ other: PyTuple) -> PyTuple {
    // Tuples are immutable, so we can do some minor performance improvements
    if self._isEmpty {
      return other
    }

    if other._isEmpty {
      return self
    }

    return self._add(other: other)
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  internal func mul(_ other: PyObject) -> PyResult<PyObject> {
    switch self._handleMulArgument(object: other) {
    case .value(let int):
      let result = self.mul(int)
      return .value(result)
    case .notImplemented:
      return .value(Py.notImplemented)
    }
  }

  private func mul(_ count: BigInt) -> PyTuple {
    // Tuples are immutable, so we can do some minor performance improvements

    // swiftlint:disable:next empty_count
    if count == 0 {
      return Py.emptyTuple
    }

    if count == 1 {
      return self
    }

    var copy = self.elements
    self._mul(elements: &copy, count: count)
    return Py.newTuple(elements: copy)
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResult<PyObject> {
    return self.mul(other)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyTuple> {
    if let e = ArgumentParser.noKwargsOrError(fnName: "tuple", kwargs: kwargs) {
      return .error(e)
    }

    if let e = ArgumentParser.guaranteeArgsCountOrError(fnName: "tuple",
                                                        args: args,
                                                        min: 0,
                                                        max: 1) {
      return .error(e)
    }

    let elements: [PyObject]
    switch args.count {
    case 0:
      elements = []
    case 1:
      let iterable = args[0]
      switch Py.toArray(iterable: iterable) {
      case let .value(e): elements = e
      case let .error(e): return .error(e)
      }
    default:
      trap("We already checked max count = 1")
    }

    // If this is a builtin then try to re-use interned values
    let isBuiltin = type === Py.types.tuple
    let result: PyTuple = isBuiltin ?
      Py.newTuple(elements: elements) :
      PyMemory.newTuple(type: type, elements: elements)

    return .value(result)
  }
}

*/

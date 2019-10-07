import Core

// In CPython:
// Objects -> tupleobject.c
// https://docs.python.org/3.7/c-api/tuple.html

// TODO: Tuple
// def __init__(self, iterable: Iterable[_T_co] = ...): ...
// def __iter__(self) -> Iterator[_T_co]: ...

// swiftlint:disable yoda_condition
// swiftlint:disable file_length

/// This instance of PyTypeObject represents the Python tuple type;
/// it is the same object as tuple in the Python layer.
internal final class PyTuple: PyObject,
  ReprTypeClass,
  EquatableTypeClass, ComparableTypeClass,
  HashableTypeClass,
  BoolConvertibleTypeClass,
  LengthTypeClass, ContainsTypeClass, GetItemTypeClass, CountTypeClass, GetIndexOfTypeClass,
  AddTypeClass, MulTypeClass, RMulTypeClass {

  internal var elements: [PyObject]

  // MARK: - Init

  internal static func new(_ context: PyContext,
                           _ elements: [PyObject]) -> PyTuple {
    let tupleTupe = context.types.tuple
    return PyTuple(type: tupleTupe, elements: elements)
  }

  internal static func new(_ context: PyContext,
                           _ elements: PyObject...) -> PyTuple {
    let tupleTupe = context.types.tuple
    return PyTuple(type: tupleTupe, elements: elements)
  }

  private init(type: PyTupleType, elements: [PyObject]) {
    self.elements = elements
    super.init(type: type)
  }

  // MARK: - Equatable

  internal func isEqual(_ other: PyObject) -> EquatableResult {
    return (other as? PyTuple)
      .map(self.isEqual)
      .flatMap(EquatableResult.value) ?? .notImplemented
  }

  internal func isEqual(_ other: PyTuple) -> EquatableResult {
    guard self.elements.count == other.elements.count else {
      return .value(false)
    }

    for (l, r) in zip(self.elements, other.elements) {
      switch self.context.isEqual(left: l, right: r) {
      case .value(true): break // go to next element
      case .value(false): return .value(false)
      case .error(let msg): return .error(msg)
      case .notImplemented: return .notImplemented
      }
    }

    return .value(true)
  }

  // MARK: - Comparable

  internal func isLess(_ other: PyObject) -> ComparableResult {
    return (other as? PyTuple)
      .map(self.isLess)
      .flatMap(ComparableResult.value) ?? .notImplemented
  }

  internal func isLess(_ other: PyTuple) -> ComparableResult {
    for (l, r) in zip(self.elements, other.elements) {
      switch self.context.isEqual(left: l, right: r) {
      case .value(true): break // go to next element
      case .value(false): return self.context.isLess(left: l, right: r)
      case .error(let msg): return .error(msg)
      case .notImplemented: return .notImplemented
      }
    }

    return .value(self.elements.count < other.elements.count)
  }

  internal func isLessEqual(_ other: PyObject) -> ComparableResult {
    return (other as? PyTuple)
      .map(self.isLessEqual)
      .flatMap(ComparableResult.value) ?? .notImplemented
  }

  internal func isLessEqual(_ other: PyTuple) -> ComparableResult {
    for (l, r) in zip(self.elements, other.elements) {
      switch self.context.isEqual(left: l, right: r) {
      case .value(true): break // go to next element
      case .value(false): return self.context.isLessEqual(left: l, right: r)
      case .error(let msg): return .error(msg)
      case .notImplemented: return .notImplemented
      }
    }

    return .value(self.elements.count <= other.elements.count)
  }

  internal func isGreater(_ other: PyObject) -> ComparableResult {
    return (other as? PyTuple)
      .map(self.isGreater)
      .flatMap(ComparableResult.value) ?? .notImplemented
  }

  internal func isGreater(_ other: PyTuple) -> ComparableResult {
    for (l, r) in zip(self.elements, other.elements) {
      switch self.context.isEqual(left: l, right: r) {
      case .value(true): break // go to next element
      case .value(false): return self.context.isGreater(left: l, right: r)
      case .error(let msg): return .error(msg)
      case .notImplemented: return .notImplemented
      }
    }

    return .value(self.elements.count > other.elements.count)
  }

  internal func isGreaterEqual(_ other: PyObject) -> ComparableResult {
    return (other as? PyTuple)
      .map(self.isGreaterEqual)
      .flatMap(ComparableResult.value) ?? .notImplemented
  }

  internal func isGreaterEqual(_ other: PyTuple) -> ComparableResult {
    for (l, r) in zip(self.elements, other.elements) {
      switch self.context.isEqual(left: l, right: r) {
      case .value(true): break // go to next element
      case .value(false): return self.context.isGreaterEqual(left: l, right: r)
      case .error(let msg): return .error(msg)
      case .notImplemented: return .notImplemented
      }
    }

    return .value(self.elements.count >= other.elements.count)
  }

  // MARK: - Hashable

  internal var hash: PyHash {
    let hasher = self.context.hasher

    var x: PyHash = 0x345678
    var mult = hasher._PyHASH_MULTIPLIER
    for e in self.elements {
      let y = self.context.hash(value: e)
      x = (x ^ y) * mult
      mult += 82_520 + PyHash(2 * self.elements.count)
    }

    return x + 97_531
  }

  // MARK: - String

  internal var repr: String {
    if self.elements.isEmpty {
      return "()"
    }

    // While not mutable, it is still possible to end up with a cycle in a tuple
    // through an object that stores itself within a tuple (and thus infinitely
    // asks for the repr of itself).
    if self.hasReprLock {
      return "(...)"
    }

    return self.withReprLock {
      var result = "("
      for (index, element) in self.elements.enumerated() {
        if index > 0 {
          result += ", " // so that we don't have ', )'.
        }

        result += self.context.reprString(value: element)
      }

      result += self.elements.count > 1 ? ")" : ",)"
      return result
    }
  }

  // MARK: - Convertible

  internal var asBool: PyBool {
    return self.types.bool.new(self.elements.any)
  }

  // MARK: - Length

  internal var length: PyInt {
    return self.pyInt(self.elements.count)
  }

  // MARK: - Contains

  internal func contains(_ element: PyObject) -> Bool {
    for e in self.elements {
      let isEqual = self.context.isEqual(left: e, right: element)
      switch isEqual {
      case .value(true):
        return true
      case .value(false),
           .error,
           .notImplemented:
        break // go to next element
      }
    }

    return false
  }

  // MARK: - Get item

  internal func getItem(at index: PyObject) -> GetItemResult<PyObject> {
    if let index = self.extractIndex(value: index) {
      return self.getItem(at: index, canIndexFromEnd: true)
    }

    if let slice = index as? PySlice {
      let result = self.getItem(at: slice)
      return result.flatMap { GetItemResult<PyObject>.value($0) }
    }

    let indexType = index.type.name
    return .error(
      .typeError("\(self.type.name) indices must be integers or slices, not \(indexType)")
    )
  }

  /// Use `canIndexFromEnd` for `tuple[-1]`.
  internal func getItem(at index: PyInt,
                        canIndexFromEnd: Bool) -> GetItemResult<PyObject> {
    return self.getItem(at: index.value, canIndexFromEnd: canIndexFromEnd)
  }

  /// Use `canIndexFromEnd` for `tuple[-1]`.
  internal func getItem(at index: BigInt,
                        canIndexFromEnd: Bool) -> GetItemResult<PyObject> {
    var index = index
    if index < 0, canIndexFromEnd {
      index += BigInt(self.elements.count)
    }

    guard let indexInt = Int(exactly: index) else {
      return .error(.indexError("\(self.type.name) index out of range"))
    }

    guard 0 <= indexInt && indexInt < self.elements.count else {
      return .error(.indexError("\(self.type.name) index out of range"))
    }

    return .value(self.elements[indexInt])
  }

  internal func getItem(at slice: PySlice) -> GetItemResult<PyTuple> {
    let count = self.elements.count
    let adjusted = self.types.slice.adjustIndices(value: slice, to: count)

    if adjusted.length <= 0 {
      // TODO: Use singleton
      return .value(PyTuple.new(self.context, []))
    }

    // Small otimization, so we don't allocate new object
    if adjusted.start == 0 && adjusted.step == 1 && adjusted.length == count {
      return .value(self)
    }

    // TODO: RustPython does it differently (objsequence -> fn get_slice_items)
    var elements = [PyObject]()
    for i in 0..<adjusted.length {
      let index = adjusted.start + i * adjusted.step
      elements.append(self.elements[index])
    }

    return .value(PyTuple.new(self.context, elements))
  }

  // MARK: - Count

  internal func count(_ element: PyObject) -> CountResult {
    var result: BigInt = 0

    for e in self.elements {
      switch self.context.isEqual(left: e, right: element) {
      case .value(true):
        result += 1
      case .value(false),
           .error,
           .notImplemented:
        break // go to next element
      }
    }

    return .value(result)
  }

  // MARK: - Index

  internal func getIndex(of element: PyObject) -> PyResult<BigInt> {
    for (index, e) in self.elements.enumerated() {
      switch self.context.isEqual(left: e, right: element) {
      case .value(true):
        return .value(BigInt(index))
      case .value(false),
           .error,
           .notImplemented:
        break // go to next element
      }
    }

    return .error(.valueError("tuple.index(x): x not in tuple"))
  }

  // MARK: - Add

  internal func add(_ other: PyObject) -> AddResult<PyObject> {
    if self.elements.isEmpty {
      return .value(other)
    }

    guard let otherTuple = other as? PyTuple else {
      let typeName = other.type.name
      return .error(
        .typeError("can only concatenate tuple (not \"\(typeName)\") to tuple")
      )
    }

    return self.add(otherTuple)
  }

  internal func add(_ other: PyTuple) -> AddResult<PyTuple> {
    if self.elements.isEmpty {
      return .value(other)
    }

    if other.elements.isEmpty {
      return .value(self)
    }

    let result = self.elements + other.elements
    return .value(PyTuple.new(self.context, result))
  }

  // MARK: - Mul

  internal func mul(_ other: PyObject) -> MulResult<PyObject> {
    guard let otherInt = other as? PyInt else {
      return .notImplemented
    }

    return self.mul(otherInt)
  }

  internal func rmul(_ other: PyObject) -> MulResult<PyObject> {
    guard let otherInt = other as? PyInt else {
      return .notImplemented
    }

    return self.mul(otherInt)
  }

  internal func mul(_ other: PyInt) -> MulResult<PyTuple> {
    let count = max(other.value, 0)

    // swiftlint:disable:next empty_count
    if count == 0 {
      // TODO: Empty tuple
      return .value(PyTuple.new(self.context, []))
    }

    if self.elements.isEmpty || count == 1 {
      return .value(self)
    }

    var i: BigInt = 0
    var result = [PyObject]()
    while i < count {
      result.append(contentsOf: self.elements)
      i += 1
    }

    return .value(PyTuple.new(self.context, result))
  }
}

internal final class PyTupleType: PyType {
//  override internal var name: String { return "tuple" }
//  override internal var doc: String? { return """
//    tuple() -> an empty tuple
//    tuple(sequence) -> tuple initialized from sequence's items
//
//    If the argument is a tuple, the return value is the same object.
//    """
//  }
}

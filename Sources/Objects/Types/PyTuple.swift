import Core

// In CPython:
// Objects -> tupleobject.c
// https://docs.python.org/3.7/c-api/tuple.html

// TODO: Tuple
// def __init__(self, iterable: Iterable[_T_co] = ...): ...
// def __iter__(self) -> Iterator[_T_co]: ... < IterTC

/// This instance of PyTypeObject represents the Python tuple type;
/// it is the same object as tuple in the Python layer.
internal final class PyTuple: PyObject,
  ReprTypeClass,
  EquatableTypeClass, ComparableTypeClass, HashableTypeClass,
  BoolConvertibleTypeClass,
  LengthTypeClass, ContainsTypeClass, GetItemTypeClass, CountTypeClass, GetIndexOfTypeClass,
  AddTypeClass, MulTypeClass, RMulTypeClass {

  internal let elements: [PyObject]

  // MARK: - Init

  fileprivate init(type: PyTupleType, elements: [PyObject]) {
    self.elements = elements
    super.init(type: type)
  }

  // MARK: - Equatable

  internal func isEqual(_ other: PyObject) -> EquatableResult {
    guard let other = other as? PyTuple else {
      return .notImplemented
    }

    return SequenceHelper.isEqual(context: self.context,
                                  left: self.elements,
                                  right: other.elements)
  }

  // MARK: - Comparable

  internal func isLess(_ other: PyObject) -> ComparableResult {
    guard let other = other as? PyTuple else {
      return .notImplemented
    }

    return SequenceHelper.isLess(context: self.context,
                                 left: self.elements,
                                 right: other.elements)
  }

  internal func isLessEqual(_ other: PyObject) -> ComparableResult {
    guard let other = other as? PyTuple else {
      return .notImplemented
    }

    return SequenceHelper.isLessEqual(context: self.context,
                                      left: self.elements,
                                      right: other.elements)
  }

  internal func isGreater(_ other: PyObject) -> ComparableResult {
    guard let other = other as? PyTuple else {
      return .notImplemented
    }

    return SequenceHelper.isGreater(context: self.context,
                                    left: self.elements,
                                    right: other.elements)
  }

  internal func isGreaterEqual(_ other: PyObject) -> ComparableResult {
    guard let other = other as? PyTuple else {
      return .notImplemented
    }

    return SequenceHelper.isGreaterEqual(context: self.context,
                                         left: self.elements,
                                         right: other.elements)
  }

  // MARK: - Hashable

  internal var hash: HashableResult {
    let hasher = self.context.hasher

    var x: PyHash = 0x345678
    var mult = hasher._PyHASH_MULTIPLIER
    for e in self.elements {
      let y = self.context.hash(value: e)
      x = (x ^ y) * mult
      mult += 82_520 + PyHash(2 * self.elements.count)
    }

    return .value(x + 97_531)
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

  internal var asBool: PyResult<Bool> {
    return .value(self.elements.any)
  }

  // MARK: - Sequence

  internal var length: PyInt {
    return self.int(self.elements.count)
  }

  internal func contains(_ element: PyObject) -> Bool {
    return SequenceHelper.contains(context: self.context,
                                   elements: self.elements,
                                   element: element)
  }

  internal func getItem(at index: PyObject) -> GetItemResult<PyObject> {
    return SequenceHelper.getItem(context: self.context,
                                  elements: self.elements,
                                  index: index,
                                  canIndexFromEnd: true,
                                  typeName: "tuple")
  }

  internal func count(_ element: PyObject) -> CountResult {
    return SequenceHelper.count(context: self.context,
                                elements: self.elements,
                                element: element)
  }

  internal func getIndex(of element: PyObject) -> PyResult<BigInt> {
    return SequenceHelper.getIndex(context: self.context,
                                   elements: self.elements,
                                   element: element,
                                   typeName: "tuple")
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

    if otherTuple.elements.isEmpty {
      return .value(self)
    }

    let result = self.elements + otherTuple.elements
    return .value(self.tuple(result))
  }

  // MARK: - Mul

  internal func mul(_ other: PyObject) -> MulResult<PyObject> {
    return SequenceHelper
      .mul(elements: self.elements, count: other)
      .map(self.tuple)
  }

  internal func rmul(_ other: PyObject) -> MulResult<PyObject> {
    return SequenceHelper
      .rmul(elements: self.elements, count: other)
      .map(self.tuple)
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

  private lazy var empty = PyTuple(type: self, elements: [])

  internal func new(_ elements: [PyObject]) -> PyTuple {
    return PyTuple(type: self, elements: elements)
  }
}

import Core

// In CPython:
// Objects -> tupleobject.c
// https://docs.python.org/3.7/c-api/tuple.html

// sourcery: pytype = tuple
/// This instance of PyTypeObject represents the Python tuple type;
/// it is the same object as tuple in the Python layer.
internal final class PyTuple: PyObject {

  internal static let doc: String = """
    tuple() -> an empty tuple
    tuple(sequence) -> tuple initialized from sequence's items

    If the argument is a tuple, the return value is the same object.
    """

  internal let elements: [PyObject]

  // MARK: - Init

  internal init(_ context: PyContext, elements: [PyObject]) {
    self.elements = elements
    super.init(type: context.types.tuple)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> EquatableResult {
    guard let other = other as? PyTuple else {
      return .notImplemented
    }

    return SequenceHelper.isEqual(context: self.context,
                                  left: self.elements,
                                  right: other.elements)
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> ComparableResult {
    guard let other = other as? PyTuple else {
      return .notImplemented
    }

    return SequenceHelper.isLess(context: self.context,
                                 left: self.elements,
                                 right: other.elements)
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> ComparableResult {
    guard let other = other as? PyTuple else {
      return .notImplemented
    }

    return SequenceHelper.isLessEqual(context: self.context,
                                      left: self.elements,
                                      right: other.elements)
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> ComparableResult {
    guard let other = other as? PyTuple else {
      return .notImplemented
    }

    return SequenceHelper.isGreater(context: self.context,
                                    left: self.elements,
                                    right: other.elements)
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> ComparableResult {
    guard let other = other as? PyTuple else {
      return .notImplemented
    }

    return SequenceHelper.isGreaterEqual(context: self.context,
                                         left: self.elements,
                                         right: other.elements)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> HashableResult {
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

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
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

        result += self.context._repr(value: element)
      }

      result += self.elements.count > 1 ? ")" : ",)"
      return result
    }
  }

  // MARK: - Sequence

  // sourcery: pymethod = __len__
  internal func getLength() -> BigInt {
    return BigInt(self.elements.count)
  }

  // sourcery: pymethod = __contains__
  internal func contains(_ element: PyObject) -> Bool {
    return SequenceHelper.contains(context: self.context,
                                   elements: self.elements,
                                   element: element)
  }

  // sourcery: pymethod = __getitem__
  internal func getItem(at index: PyObject) -> GetItemResult<PyObject> {
    return SequenceHelper.getItem(context: self.context,
                                  elements: self.elements,
                                  index: index,
                                  canIndexFromEnd: true,
                                  typeName: "tuple")
  }

  // sourcery: pymethod = count
  internal func count(_ element: PyObject) -> CountResult {
    return SequenceHelper.count(context: self.context,
                                elements: self.elements,
                                element: element)
  }

  // sourcery: pymethod = index
  internal func getIndex(of element: PyObject) -> PyResult<BigInt> {
    return SequenceHelper.getIndex(context: self.context,
                                   elements: self.elements,
                                   element: element,
                                   typeName: "tuple")
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
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

  // sourcery: pymethod = __mul__
  internal func mul(_ other: PyObject) -> MulResult<PyObject> {
    return SequenceHelper
      .mul(elements: self.elements, count: other)
      .map(self.tuple)
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> MulResult<PyObject> {
    return SequenceHelper
      .rmul(elements: self.elements, count: other)
      .map(self.tuple)
  }
}

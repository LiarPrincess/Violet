import Core

// In CPython:
// Objects -> tupleobject.c
// https://docs.python.org/3.7/c-api/tuple.html

// sourcery: pytype = tuple
/// This instance of PyTypeObject represents the Python tuple type;
/// it is the same object as tuple in the Python layer.
public final class PyTuple: PyObject {

  internal static let doc: String = """
    tuple() -> an empty tuple
    tuple(sequence) -> tuple initialized from sequence's items

    If the argument is a tuple, the return value is the same object.
    """

  internal let elements: [PyObject]

  // MARK: - Init

  internal init(_ context: PyContext, elements: [PyObject]) {
    self.elements = elements
    super.init(type: context.builtins.types.tuple)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyTuple else {
      return .notImplemented
    }

    return SequenceHelper.isEqual(context: self.context,
                                  left: self.elements,
                                  right: other.elements)
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return NotEqualHelper.fromIsEqual(self.isEqual(other))
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyTuple else {
      return .notImplemented
    }

    return SequenceHelper.isLess(context: self.context,
                                 left: self.elements,
                                 right: other.elements)
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyTuple else {
      return .notImplemented
    }

    return SequenceHelper.isLessEqual(context: self.context,
                                      left: self.elements,
                                      right: other.elements)
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyTuple else {
      return .notImplemented
    }

    return SequenceHelper.isGreater(context: self.context,
                                    left: self.elements,
                                    right: other.elements)
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyTuple else {
      return .notImplemented
    }

    return SequenceHelper.isGreaterEqual(context: self.context,
                                         left: self.elements,
                                         right: other.elements)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> PyResultOrNot<PyHash> {
    var x: PyHash = 0x345678
    var mult = HashHelper.multiplier

    for e in self.elements {
      switch self.builtins.hash(e) {
      case let .value(y):
        x = (x ^ y) * mult
        mult += 82_520 + PyHash(2 * self.elements.count)
      case let .error(e):
        return .error(e)
      }
    }

    return .value(x + 97_531)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    if self.elements.isEmpty {
      return .value("()")
    }

    // While not mutable, it is still possible to end up with a cycle in a tuple
    // through an object that stores itself within a tuple (and thus infinitely
    // asks for the repr of itself).
    if self.hasReprLock {
      return .value("(...)")
    }

    return self.withReprLock {
      var result = "("
      for (index, element) in self.elements.enumerated() {
        if index > 0 {
          result += ", " // so that we don't have ', )'.
        }

        switch self.builtins.repr(element) {
        case let .value(s): result += s
        case let .error(e): return .error(e)
        }
      }

      result += self.elements.count > 1 ? ")" : ",)"
      return .value(result)
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

  // MARK: - Sequence

  // sourcery: pymethod = __len__
  internal func getLength() -> BigInt {
    return BigInt(self.elements.count)
  }

  // sourcery: pymethod = __contains__
  internal func contains(_ element: PyObject) -> PyResult<Bool> {
    let result = SequenceHelper.contains(context: self.context,
                                         elements: self.elements,
                                         element: element)
    return .value(result)
  }

  // sourcery: pymethod = __getitem__
  internal func getItem(at index: PyObject) -> PyResult<PyObject> {
    let result = SequenceHelper.getItem(elements: self.elements,
                                        index: index,
                                        typeName: "tuple")

    switch result {
    case let .single(s): return .value(s)
    case let .slice(s): return .value(self.builtins.newTuple(s))
    case let .error(e): return .error(e)
    }
  }

  // sourcery: pymethod = count
  internal func count(_ element: PyObject) -> PyResult<BigInt> {
    return SequenceHelper.count(context: self.context,
                                elements: self.elements,
                                element: element)
  }

  // sourcery: pymethod = index
  internal func index(of element: PyObject) -> PyResult<BigInt> {
    return SequenceHelper.index(context: self.context,
                                elements: self.elements,
                                element: element,
                                typeName: "tuple")
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResultOrNot<PyObject> {
    if self.elements.isEmpty {
      return .value(other)
    }

    guard let otherTuple = other as? PyTuple else {
      return .typeError(
        "can only concatenate tuple (not '\(other.typeName)') to tuple"
      )
    }

    if otherTuple.elements.isEmpty {
      return .value(self)
    }

    let result = self.elements + otherTuple.elements
    return .value(self.builtins.newTuple(result))
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  internal func mul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return SequenceHelper
      .mul(elements: self.elements, count: other)
      .map(self.builtins.newTuple)
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return SequenceHelper
      .rmul(elements: self.elements, count: other)
      .map(self.builtins.newTuple)
  }
}

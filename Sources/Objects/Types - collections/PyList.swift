import Core

// In CPython:
// Objects -> listobject.c
// https://docs.python.org/3.7/c-api/list.html

// swiftlint:disable yoda_condition

// sourcery: pytype = list
/// This subtype of PyObject represents a Python list object.
public final class PyList: PyObject {

  internal static let doc: String = """
    list(iterable=(), /)
    --

    Built-in mutable sequence.

    If no argument is given, the constructor creates a new empty list.
    The argument must be an iterable if specified.
    """

  internal var elements: [PyObject]

  // MARK: - Init

  internal init(_ context: PyContext, elements: [PyObject]) {
    self.elements = elements
    super.init(type: context.builtins.types.list)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyList else {
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
    guard let other = other as? PyList else {
      return .notImplemented
    }

    return SequenceHelper.isLess(context: self.context,
                                 left: self.elements,
                                 right: other.elements)
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyList else {
      return .notImplemented
    }

    return SequenceHelper.isLessEqual(context: self.context,
                                      left: self.elements,
                                      right: other.elements)
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyList else {
      return .notImplemented
    }

    return SequenceHelper.isGreater(context: self.context,
                                    left: self.elements,
                                    right: other.elements)
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PyList else {
      return .notImplemented
    }

    return SequenceHelper.isGreaterEqual(context: self.context,
                                         left: self.elements,
                                         right: other.elements)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    if self.elements.isEmpty {
      return .value("[]")
    }

    if self.hasReprLock {
      return .value("[...]")
    }

    return self.withReprLock {
      var result = "["
      for (index, element) in self.elements.enumerated() {
        if index > 0 {
          result += ", " // so that we don't have ', )'.
        }

        switch self.builtins.repr(element) {
        case let .value(s): result += s
        case let .error(e): return .error(e)
        }
      }

      result += self.elements.count > 1 ? "]" : ",]"
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
                                        typeName: "list")

    switch result {
    case let .single(s): return .value(s)
    case let .slice(s): return .value(self.builtins.newList(s))
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
                                typeName: "list")
  }

  // sourcery: pymethod = append
  internal func append(_ element: PyObject) -> PyResult<PyNone> {
    self.elements.append(element)
    return .value(self.builtins.none)
  }

  internal func pop(index: BigInt = -1) -> PyResult<PyObject> {
    if self.elements.isEmpty {
      return .indexError("pop from empty list")
    }

    var index = index
    if index < 0 {
      index += BigInt(self.elements.count)
    }

    guard let indexInt = Int(exactly: index) else {
      return .indexError("pop index out of range")
    }

    guard 0 <= indexInt && indexInt < self.elements.count else {
      return .indexError("pop index out of range")
    }

    guard let last = self.elements.popLast() else {
      return .indexError("pop index out of range")
    }

    return .value(last)
  }

  // sourcery: pymethod = clear
  internal func clear() -> PyResult<PyNone> {
    self.elements.removeAll()
    return .value(self.builtins.none)
  }

  // sourcery: pymethod = copy
  internal func copy() -> PyObject {
    return self.builtins.newList(self.elements)
  }

  // MARK: - Add

  // sourcery: pymethod = __add__
  internal func add(_ other: PyObject) -> PyResultOrNot<PyObject> {
    guard let otherList = other as? PyList else {
      return .typeError(
        "can only concatenate list (not '\(other.typeName)') to list"
      )
    }

    let result = self.elements + otherList.elements
    return .value(self.builtins.newList(result))
  }

  // MARK: - Mul

  // sourcery: pymethod = __mul__
  internal func mul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return SequenceHelper
      .mul(elements: self.elements, count: other)
      .map(self.builtins.newList)
  }

  // sourcery: pymethod = __rmul__
  internal func rmul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return SequenceHelper
      .rmul(elements: self.elements, count: other)
      .map(self.builtins.newList)
  }

  // sourcery: pymethod = __imul__
  internal func imul(_ other: PyObject) -> PyResultOrNot<PyObject> {
    return SequenceHelper
      .mul(elements: self.elements, count: other)
      .map { elements -> PyList in
        self.elements = elements
        return self
      }
  }
}

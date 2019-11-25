import Core

// In CPython:
// Objects -> listobject.c
// https://docs.python.org/3.7/c-api/list.html

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

  internal var data: PySequenceData

//  internal var elements: [PyObject] {
//    return self.data.elements
//  }

  // MARK: - Init

  convenience init(_ context: PyContext, elements: [PyObject]) {
    let data = PySequenceData(elements: elements)
    self.init(context, data: data)
  }

  internal init(_ context: PyContext, data: PySequenceData) {
    self.data = data
    super.init(type: context.builtins.types.list)
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

  // sourcery: pymethod = __contains__
  internal func contains(_ element: PyObject) -> PyResult<Bool> {
    return self.data.contains(value: element)
  }

  // sourcery: pymethod = __getitem__
  internal func getItem(at index: PyObject) -> PyResult<PyObject> {
    switch self.data.getItem(index: index, typeName: "list") {
    case let .single(s): return .value(s)
    case let .slice(s): return .value(self.builtins.newList(s))
    case let .error(e): return .error(e)
    }
  }

  // sourcery: pymethod = count
  internal func count(_ element: PyObject) -> PyResult<BigInt> {
    return self.data.count(element: element).map(BigInt.init)
  }

  // sourcery: pymethod = index
  internal func index(of element: PyObject) -> PyResult<BigInt> {
    return self.data.index(of: element, typeName: "list").map(BigInt.init)
  }

  // sourcery: pymethod = append
  internal func append(_ element: PyObject) -> PyResult<PyNone> {
    self.data.append(element)
    return .value(self.builtins.none)
  }

  // sourcery: pymethod = pop
  internal func pop(index: BigInt?) -> PyResult<PyObject> {
    let index = index ?? -1
    return self.data.pop(at: index, typeName: "list")
  }

  // sourcery: pymethod = clear
  internal func clear() -> PyResult<PyNone> {
    self.data.clear()
    return .value(self.builtins.none)
  }

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
}

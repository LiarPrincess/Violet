import Core

// In CPython:
// Objects -> listobject.c
// https://docs.python.org/3.7/c-api/list.html

// TODO: List
// __class__
// __delattr__
// __delitem__
// __dir__
// __doc__
// __format__
// __getattribute__
// __init__
// __init_subclass__
// __iter__
// __new__
// __reduce__
// __reduce_ex__
// __reversed__
// __setattr__
// __setitem__
// __sizeof__
// __subclasshook__
// extend
// insert
// pop
// remove
// reverse
// sort

// swiftlint:disable yoda_condition

// sourcery: pytype = list
/// This subtype of PyObject represents a Python list object.
internal final class PyList: PyObject,
  ReprTypeClass, StrTypeClass,
  ComparableTypeClass, HashableTypeClass,
  LengthTypeClass, ContainsTypeClass, GetItemTypeClass, CountTypeClass, GetIndexOfTypeClass,
  AddTypeClass, AddInPlaceTypeClass, MulTypeClass, RMulTypeClass, MulInPlaceTypeClass {

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
    super.init(type: context.types.list)
  }

  // MARK: - Equatable

  internal func isEqual(_ other: PyObject) -> EquatableResult {
    guard let other = other as? PyList else {
      return .notImplemented
    }

    return SequenceHelper.isEqual(context: self.context,
                                  left: self.elements,
                                  right: other.elements)
  }

  // MARK: - Comparable

  internal func isLess(_ other: PyObject) -> ComparableResult {
    guard let other = other as? PyList else {
      return .notImplemented
    }

    return SequenceHelper.isLess(context: self.context,
                                 left: self.elements,
                                 right: other.elements)
  }

  internal func isLessEqual(_ other: PyObject) -> ComparableResult {
    guard let other = other as? PyList else {
      return .notImplemented
    }

    return SequenceHelper.isLessEqual(context: self.context,
                                      left: self.elements,
                                      right: other.elements)
  }

  internal func isGreater(_ other: PyObject) -> ComparableResult {
    guard let other = other as? PyList else {
      return .notImplemented
    }

    return SequenceHelper.isGreater(context: self.context,
                                    left: self.elements,
                                    right: other.elements)
  }

  internal func isGreaterEqual(_ other: PyObject) -> ComparableResult {
    guard let other = other as? PyList else {
      return .notImplemented
    }

    return SequenceHelper.isGreaterEqual(context: self.context,
                                         left: self.elements,
                                         right: other.elements)
  }

  // MARK: - Hashable

  internal func hash() -> HashableResult {
    // Member exists, but always return .notImplemented.
    return .notImplemented
  }

  // MARK: - String

  internal func repr() -> String {
    if self.elements.isEmpty {
      return "[]"
    }

    if self.hasReprLock {
      return "[...]"
    }

    return self.withReprLock {
      var result = "["
      for (index, element) in self.elements.enumerated() {
        if index > 0 {
          result += ", " // so that we don't have ', )'.
        }

        result += self.context.reprString(value: element)
      }

      result += self.elements.count > 1 ? "]" : ",]"
      return result
    }
  }

  internal func str() -> String {
    return self.repr()
  }

  // MARK: - Sequence

  internal func getLength() -> BigInt {
    return BigInt(self.elements.count)
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
                                  typeName: "list")
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
                                   typeName: "list")
  }

  // sourcery: pymethod = append
  internal func append(_ element: PyObject) {
    self.elements.append(element)
  }

  internal func extend(_ iterator: PyObject) {
    // Check if implementatio is OK with 'addInPlace'
    // TODO: Write this - list_extend(PyListObject *self, PyObject *iterable)
  }

  internal func pop(index: BigInt = -1) -> PyResult<PyObject> {
    if self.elements.isEmpty {
      return .error(.indexError("pop from empty list"))
    }

    var index = index
    if index < 0 {
      index += BigInt(self.elements.count)
    }

    guard let indexInt = Int(exactly: index) else {
      return .error(.indexError("pop index out of range"))
    }

    guard 0 <= indexInt && indexInt < self.elements.count else {
      return .error(.indexError("pop index out of range"))
    }

    guard let last = self.elements.popLast() else {
      return .error(.indexError("pop index out of range"))
    }

    return .value(last)
  }

  // sourcery: pymethod = clear
  internal func clear() {
    self.elements.removeAll()
  }

  // sourcery: pymethod = copy
  internal func copy() -> PyList {
    return self.list(self.elements)
  }

  // MARK: - Add

  internal func add(_ other: PyObject) -> AddResult<PyObject> {
    guard let otherList = other as? PyList else {
      let typeName = other.type.name
      return .error(
        .typeError("can only concatenate list (not \"\(typeName)\") to list")
      )
    }

    let result = self.elements + otherList.elements
    return .value(self.list(result))
  }

  internal func addInPlace(_ other: PyObject) -> AddResult<PyObject> {
    self.extend(other)
    return .value(self)
  }

  // MARK: - Mul

  internal func mul(_ other: PyObject) -> MulResult<PyObject> {
    return SequenceHelper
      .mul(elements: self.elements, count: other)
      .map(self.list)
  }

  internal func rmul(_ other: PyObject) -> MulResult<PyObject> {
    return SequenceHelper
      .rmul(elements: self.elements, count: other)
      .map(self.list)
  }

  internal func mulInPlace(_ other: PyObject) -> MulResult<PyObject> {
    return SequenceHelper
      .mul(elements: self.elements, count: other)
      .map { elements -> PyList in
        self.elements = elements
        return self
      }
  }
}

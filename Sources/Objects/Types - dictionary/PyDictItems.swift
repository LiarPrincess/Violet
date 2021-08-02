import BigInt
import VioletCore

// cSpell:ignore dictobject

// In CPython:
// Objects -> dictobject.c

// sourcery: pytype = dict_items, isDefault, hasGC
public final class PyDictItems: PyObject, AbstractDictView {

  internal typealias OrderedDictionary = PyDict.OrderedDictionary
  internal typealias Element = OrderedDictionary.Element

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  internal let dict: PyDict

  override public var description: String {
    return "PyDictItems(count: \(self._elements.count))"
  }

  // MARK: - Init

  internal init(dict: PyDict) {
    self.dict = dict
    super.init(type: Py.types.dict_items)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    return self._isEqual(other)
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self._isNotEqual(other)
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    return self._isLess(other)
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    return self._isLessEqual(other)
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    return self._isGreater(other)
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return self._isGreaterEqual(other)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> HashResult {
    return self._hash()
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    return self._repr(typeName: "dict_items", elementRepr: Self.repr(element:))
  }

  private static func repr(element: Element) -> PyResult<String> {
    // >>> d = {'a': 1, 'b': 2, 'c': 3}
    //
    // >>> i = d.items()
    // >>> repr(i)
    // "dict_items([('a', 1), ('b', 2), ('c', 3)])"

    let key = element.key.object
    let keyRepr: String
    switch Py.reprString(object: key) {
    case let .value(s): keyRepr = s
    case let .error(e): return .error(e)
    }

    let value = element.value
    let valueRepr: String
    switch Py.reprString(object: value) {
    case let .value(s): valueRepr = s
    case let .error(e): return .error(e)
    }

    let result = "(\(keyRepr), \(valueRepr))"
    return .value(result)
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Length

  // sourcery: pymethod = __len__
  internal func getLength() -> BigInt {
    return self._getLength()
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(object: PyObject) -> PyResult<Bool> {
    guard let tuple = PyCast.asTuple(object), tuple.count == 2 else {
      return .value(false)
    }

    let key = tuple.elements[0]
    let value = tuple.elements[1]

    switch self.dict.get(key: key) {
    case let .value(o):
      return Py.isEqualBool(left: value, right: o)
    case .notFound:
      return .value(false)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return PyMemory.newDictItemIterator(dict: self.dict)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyDictItems> {
    return .typeError("cannot create 'dict_items' instances")
  }
}

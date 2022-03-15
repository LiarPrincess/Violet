import BigInt
import VioletCore

// cSpell:ignore dictobject

// In CPython:
// Objects -> dictobject.c

// sourcery: pytype = dict_items, isDefault, hasGC
public struct PyDictItems: PyObjectMixin, AbstractDictView {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  // sourcery: storedProperty
  internal var dict: PyDict { self.dictPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, dict: PyDict) {
    self.header.initialize(py, type: type)
    self.dictPtr.initialize(to: dict)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyDictItems(ptr: ptr)
    return "PyDictItems(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal static func __eq__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__eq__(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __ne__
  internal static func __ne__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.abstract__ne__(py, zelf: zelf, other: other)
  }

  // MARK: - Comparable

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
  internal static func __hash__(_ py: Py, zelf: PyObject) -> HashResult {
    return Self.abstract__hash__(py, zelf: zelf)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    return Self.abstract__repr__(py, zelf: zelf, elementRepr: Self.repr(_:element:))
  }

  private static func repr(_ py: Py, element: Element) -> PyResult<String> {
    // >>> d = {'a': 1, 'b': 2, 'c': 3}
    //
    // >>> i = d.items()
    // >>> repr(i)
    // "dict_items([('a', 1), ('b', 2), ('c', 3)])"

    let key = element.key.object
    let keyRepr: String
    switch py.reprString(object: key) {
    case let .value(s): keyRepr = s
    case let .error(e): return .error(e)
    }

    let value = element.value
    let valueRepr: String
    switch py.reprString(object: value) {
    case let .value(s): valueRepr = s
    case let .error(e): return .error(e)
    }

    let result = "(\(keyRepr), \(valueRepr))"
    return .value(result)
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf: PyObject,
                                        name: PyObject) -> PyResult<PyObject> {
    return Self.abstract__getattribute__(py, zelf: zelf, name: name)
  }

  // MARK: - Length

  // sourcery: pymethod = __len__
  internal static func __len__(_ py: Py, zelf: PyObject)-> PyResult<PyObject> {
    return Self.abstract__len__(py, zelf: zelf)
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal static func __contains__(_ py: Py,
                                    zelf: PyObject,
                                    object: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__contains__")
    }

    guard let tuple = py.cast.asTuple(object), tuple.count == 2 else {
      return PyResult(py, false)
    }

    let key = tuple.elements[0]
    let value = tuple.elements[1]

    switch zelf.dict.get(py, key: key) {
    case let .value(o):
      return py.isEqual(left: value, right: o)
    case .notFound:
      return PyResult(py, false)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal static func __iter__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__iter__")
    }

    let result = py.newIterator(items: zelf.dict)
    return PyResult(result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    return .typeError(py, message: "cannot create 'dict_items' instances")
  }
}

import BigInt
import VioletCore

// cSpell:ignore dictobject

// In CPython:
// Objects -> dictobject.c

// sourcery: pytype = dict_values, isDefault, hasGC
public struct PyDictValues: PyObjectMixin, AbstractDictView {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  // sourcery: storedProperty
  internal var dict: PyDict { self.dictPtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, dict: PyDict) {
    self.initializeBase(py, type: type)
    self.dictPtr.initialize(to: dict)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyDictValues(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "count", value: zelf.dict.count, includeInDescription: true)
    result.append(name: "dict", value: zelf.dict)
    return result
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstract__repr__(py, zelf: zelf, elementRepr: Self.repr(_:element:))
  }

  private static func repr(_ py: Py, element: Element) -> PyResultGen<String> {
    // >>> d = {'a': 1, 'b': 2, 'c': 3}
    //
    // >>> v = d.values()
    // >>> repr(v)
    // 'dict_values([1, 2, 3])'

    let value = element.value
    return py.reprString(value)
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf: PyObject,
                                        name: PyObject) -> PyResult {
    return Self.abstract__getattribute__(py, zelf: zelf, name: name)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Length

  // sourcery: pymethod = __len__
  internal static func __len__(_ py: Py, zelf: PyObject) -> PyResult {
    return Self.abstract__len__(py, zelf: zelf)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal static func __iter__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__iter__")
    }

    let result = py.newIterator(values: zelf.dict)
    return PyResult(result)
  }
}

import BigInt
import VioletCore

// cSpell:ignore dictobject

// In CPython:
// Objects -> dictobject.c

// sourcery: pytype = dict_values, default, hasGC
public class PyDictValues: PyObject, PyDictViewsShared {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  internal let dict: PyDict

  override public var description: String {
    return "PyDictValues(count: \(self.elements.count))"
  }

  // MARK: - Init

  internal init(dict: PyDict) {
    self.dict = dict
    super.init(type: Py.types.dict_values)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    return self.reprShared(typeName: "dict_values")
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

  // sourcery: pymethod = __len__
  internal func getLength() -> BigInt {
    return self.getLengthShared()
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return PyMemory.newDictValueIterator(dict: self.dict)
  }
}

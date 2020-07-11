import BigInt
import VioletCore

// In CPython:
// Objects -> dictobject.c

// sourcery: pytype = dict_values, default, hasGC
public class PyDictValues: PyObject, PyDictViewsShared {

  internal let dict: PyDict

  private var data: PyDictData {
    return self.dict.data
  }

  override public var description: String {
    return "PyDictValues()"
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

  // MARK: - Length

  // sourcery: pymethod = __len__
  internal func getLength() -> BigInt {
    return BigInt(self.data.count)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return PyDictValueIterator(dict: self.dict)
  }
}

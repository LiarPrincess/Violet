/* MARKER
import BigInt
import VioletCore

// cSpell:ignore dictobject

// In CPython:
// Objects -> dictobject.c

// sourcery: pytype = dict_values, isDefault, hasGC
public final class PyDictValues: PyObject, AbstractDictView {

  internal typealias OrderedDictionary = PyDict.OrderedDictionary
  internal typealias Element = OrderedDictionary.Element

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  internal let dict: PyDict

  // MARK: - Init

  internal init(dict: PyDict) {
    self.dict = dict
    super.init(type: Py.types.dict_values)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    return self._repr(typeName: "dict_values", elementRepr: Self.repr(element:))
  }

  private static func repr(element: Element) -> PyResult<String> {
    // >>> d = {'a': 1, 'b': 2, 'c': 3}
    //
    // >>> v = d.values()
    // >>> repr(v)
    // 'dict_values([1, 2, 3])'

    let value = element.value
    return Py.reprString(object: value)
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
    return self._getLength()
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return PyMemory.newDictValueIterator(dict: self.dict)
  }
}

*/
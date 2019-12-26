import Core

// In CPython:
// Objects -> listobject.c

// sourcery: pytype = list_iterator, default, hasGC
public class PyListIterator: PyObject {

  internal let list: PyList
  internal private(set) var index: Int

  // MARK: - Init

  internal init(list: PyList) {
    self.list = list
    self.index = 0
    super.init(type: list.builtins.types.list_iterator)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return self
  }

  // MARK: - Next

  // sourcery: pymethod = __next__
  internal func next() -> PyResult<PyObject> {
    if self.index < self.list.elements.count {
      let item = self.list.elements[self.index]
      self.index += 1
      return .value(item)
    }

    return .stopIteration
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDictData?) -> PyResult<PyObject> {
    return .typeError("cannot create 'list_iterator' instances")
  }
}

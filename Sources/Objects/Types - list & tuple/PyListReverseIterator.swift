import VioletCore

// cSpell:ignore listobject

// In CPython:
// Objects -> listobject.c

// sourcery: pytype = list_reverseiterator, isDefault, hasGC
public final class PyListReverseIterator: PyObject {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  internal let list: PyList
  internal private(set) var index: Int

  // MARK: - Init

  internal init(list: PyList) {
    self.list = list
    self.index = list.elements.count - 1
    super.init(type: Py.types.list_reverseiterator)
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
    if self.index >= 0 {
      let item = self.list.elements[self.index]
      self.index -= 1
      return .value(item)
    }

    self.index = -1
    return .stopIteration()
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  internal func lengthHint() -> PyInt {
    // '+1' because users start counting from 1, not from 0
    return Py.newInt(self.index + 1)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyListReverseIterator> {
    return .typeError("cannot create 'list_reverseiterator' instances")
  }
}

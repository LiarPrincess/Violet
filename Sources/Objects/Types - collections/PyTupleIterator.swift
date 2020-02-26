import Core

// In CPython:
// Objects -> tupleobject.c

// sourcery: pytype = tuple_iterator, default, hasGC
public class PyTupleIterator: PyObject {

  internal let tuple: PyTuple
  internal private(set) var index: Int

  override public var description: String {
    return "PyTupleIterator()"
  }

  // MARK: - Init

  internal init(tuple: PyTuple) {
    self.tuple = tuple
    self.index = 0
    super.init(type: Py.types.tuple_iterator)
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
    if self.index < self.tuple.elements.count {
      let item = self.tuple.elements[self.index]
      self.index += 1
      return .value(item)
    }

    return .stopIteration()
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyObject> {
    return .typeError("cannot create 'tuple_iterator' instances")
  }
}

import VioletCore

// cSpell:ignore tupleobject

// In CPython:
// Objects -> tupleobject.c

// sourcery: pytype = tuple_iterator, default, hasGC
public final class PyTupleIterator: PyObject {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

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
  public func getClass() -> PyType {
    return self.type
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  public func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  public func iter() -> PyObject {
    return self
  }

  // MARK: - Next

  // sourcery: pymethod = __next__
  public func next() -> PyResult<PyObject> {
    if self.index < self.tuple.elements.count {
      let item = self.tuple.elements[self.index]
      self.index += 1
      return .value(item)
    }

    return .stopIteration()
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  public func lengthHint() -> PyInt {
    let data = self.tuple.data
    let result = data.count - self.index
    return Py.newInt(result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyTupleIterator> {
    return .typeError("cannot create 'tuple_iterator' instances")
  }
}

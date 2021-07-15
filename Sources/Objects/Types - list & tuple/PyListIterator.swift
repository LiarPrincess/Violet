import VioletCore

// cSpell:ignore listobject

// In CPython:
// Objects -> listobject.c

// sourcery: pytype = list_iterator, default, hasGC
public class PyListIterator: PyObject {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  internal let list: PyList
  internal private(set) var index: Int

  // MARK: - Init

  internal init(list: PyList) {
    self.list = list
    self.index = 0
    super.init(type: Py.types.list_iterator)
  }

  override public var description: String {
    let count = self.list.data.count
    return "PyListIterator(count: \(count), index: \(self.index))"
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
    if self.index < self.list.elements.count {
      let item = self.list.elements[self.index]
      self.index += 1
      return .value(item)
    }

    return .stopIteration()
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  public func lengthHint() -> PyInt {
    let data = self.list.data
    let result = data.count - self.index
    return Py.newInt(result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyListIterator> {
    return .typeError("cannot create 'list_iterator' instances")
  }
}

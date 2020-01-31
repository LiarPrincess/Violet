import Core

// In CPython:
// Objects -> dictobject.c

// sourcery: pytype = dict_itemiterator, default, hasGC
public class PyDictItemIterator: PyObject, OrderedDictionaryBackedIterator {

  internal let object: PyDict
  internal var index: Int
  private var initCount: Int

  internal var dict: OrderedDictionary<PyDictKey, PyObject> {
    return self.object.data
  }

  override public var description: String {
    return "PyDictItemIterator()"
  }

  // MARK: - Init

  internal init(dict: PyDict) {
    self.object = dict
    self.index = 0
    self.initCount = dict.data.count
    super.init(type: Py.types.dict_itemiterator)
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

  internal func getAttribute(name: String) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return self.iterShared()
  }

  // MARK: - Next

  // sourcery: pymethod = __next__
  internal func next() -> PyResult<PyObject> {
    guard self.initCount == self.object.data.count else {
      self.index = -1 // Make this state sticky
      return .runtimeError("dictionary changed size during iteration")
    }

    switch self.nextShared() {
    case let .value(entry):
      let key = entry.key.object
      let value = entry.value
      let tuple = Py.newTuple(key, value)
      return .value(tuple)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDictData?) -> PyResult<PyObject> {
    return .typeError("cannot create 'dict_itemiterator' instances")
  }
}

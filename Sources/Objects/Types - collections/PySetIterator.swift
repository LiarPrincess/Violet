import Core

// In CPython:
// Objects -> setobject.c

// sourcery: pytype = set_iterator, default, hasGC
public class PySetIterator: PyObject, OrderedDictionaryBackedIterator {

  internal let set: PySetType
  internal var index: Int
  private var initCount: Int

  internal var dict: OrderedDictionary<PySetElement, ()> {
    return self.set.data.dict
  }

  // MARK: - Init

  internal init(set: PySetType) {
    self.set = set
    self.index = 0
    self.initCount = set.data.count
    super.init(type: set.builtins.types.set_iterator)
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
    return self.iterShared()
  }

  // MARK: - Next

  // sourcery: pymethod = __next__
  internal func next() -> PyResult<PyObject> {
    guard self.initCount == self.set.data.count else {
      self.index = -1 // Make this state sticky
      return .runtimeError("Set changed size during iteration")
    }

    return self.nextShared().map { $0.key.object }
  }

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDictData?) -> PyResult<PyObject> {
    return .typeError("cannot create 'set_iterator' instances")
  }
}

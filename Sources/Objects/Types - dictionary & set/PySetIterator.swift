import VioletCore

// cSpell:ignore setobject

// In CPython:
// Objects -> setobject.c

// sourcery: pytype = set_iterator, default, hasGC
public class PySetIterator: PyObject, OrderedDictionaryBackedIterator {

  internal let set: PySetType
  internal var index: Int
  private var initCount: Int

  internal var dict: OrderedDictionary<PySet.Element, Void> {
    return self.set.data.elements.dict // Ugh…
  }

  override public var description: String {
    return "PySetIterator()"
  }

  // MARK: - Init

  internal init(set: PySetType) {
    self.set = set
    self.index = 0
    self.initCount = set.data.count
    super.init(type: Py.types.set_iterator)
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
    return self.iterShared()
  }

  // MARK: - Next

  // sourcery: pymethod = __next__
  public func next() -> PyResult<PyObject> {
    guard self.initCount == self.set.data.count else {
      self.index = -1 // Make this state sticky
      return .runtimeError("Set changed size during iteration")
    }

    return self.nextShared().map { $0.key.object }
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  public func lengthHint() -> PyInt {
    let data = self.set.data
    let result = data.count - self.index
    return Py.newInt(result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal class func pyNew(type: PyType,
                            args: [PyObject],
                            kwargs: PyDict?) -> PyResult<PySetIterator> {
    return .typeError("cannot create 'set_iterator' instances")
  }
}

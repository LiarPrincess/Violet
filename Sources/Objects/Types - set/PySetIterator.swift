import VioletCore

// cSpell:ignore setobject

// In CPython:
// Objects -> setobject.c

// sourcery: pytype = set_iterator, default, hasGC
public final class PySetIterator: PyObject, OrderedDictionaryBackedIterator {

  // sourcery: pytypedoc
  internal static let doc: String? = nil

  private let set: PyAnySet
  internal var index: Int // 'internal' for 'OrderedDictionaryBackedIterator'
  private var initialCount: Int

  // For 'OrderedDictionaryBackedIterator'
  internal var dict: OrderedDictionary<PySet.Element, Void> {
    let orderedSet = self.set.elements
    return orderedSet.dict
  }

  override public var description: String {
    return "PySetIterator(set: \(self.set), index: \(self.index))"
  }

  // MARK: - Init

  internal convenience init(set: PySet) {
    self.init(set: PyAnySet(set: set))
  }

  internal convenience init(frozenSet: PyFrozenSet) {
    self.init(set: PyAnySet(frozenSet: frozenSet))
  }

  private init(set: PyAnySet) {
    self.set = set
    self.index = 0
    self.initialCount = set.elements.count
    super.init(type: Py.types.set_iterator)
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
    let currentCount = self.set.elements.count
    guard currentCount == self.initialCount else {
      self.index = -1 // Make this state sticky
      return .runtimeError("Set changed size during iteration")
    }

    return self.nextShared().map { $0.key.object }
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  internal func lengthHint() -> PyInt {
    let count = self.set.elements.count
    let result = count - self.index
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

import VioletCore

// cSpell:ignore setobject

// In CPython:
// Objects -> setobject.c

// sourcery: pytype = set_iterator, default, hasGC
public class PySetIterator: PyObject, OrderedDictionaryBackedIterator {

  private enum SetOrFrozenSet: CustomStringConvertible {
    case set(PySet)
    case frozenSet(PyFrozenSet)

    fileprivate var description: String {
      switch self {
      case let .set(s): return s.description
      case let .frozenSet(s): return s.description
      }
    }

    fileprivate var data: PySetData {
      switch self {
      case let .set(s): return s.data
      case let .frozenSet(s): return s.data
      }
    }
  }

  private let set: SetOrFrozenSet
  internal var index: Int // 'internal' for 'OrderedDictionaryBackedIterator'
  private var inititialCount: Int

  // For 'OrderedDictionaryBackedIterator'
  internal var dict: OrderedDictionary<PySet.Element, Void> {
    let orderedSet = self.set.data.elements
    return orderedSet.dict
  }

  override public var description: String {
    return "PySetIterator(set: \(self.set), index: \(self.index))"
  }

  // MARK: - Init

  internal convenience init(set: PySet) {
    self.init(set: .set(set))
  }

  internal convenience init(set: PyFrozenSet) {
    self.init(set: .frozenSet(set))
  }

  private init(set: SetOrFrozenSet) {
    self.set = set
    self.index = 0
    self.inititialCount = set.data.count
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
    let currentCount = self.set.data.count
    guard currentCount == self.inititialCount else {
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

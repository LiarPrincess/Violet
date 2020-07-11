import BigInt
import VioletCore

// In CPython:
// Objects -> iterobject.c

// sourcery: pytype = iterator, default, hasGC
public class PyIterator: PyObject {

  internal let sequence: PyObject
  internal private(set) var index: Int

  private static let endIndex = -1

  override public var description: String {
    return "PyIterator()"
  }

  // MARK: - Init

  internal init(sequence: PyObject) {
    self.sequence = sequence
    self.index = 0
    super.init(type: Py.types.iterator)
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
    guard self.index != PyIterator.endIndex else {
      return .stopIteration()
    }

    switch Py.getItem(object: self.sequence, index: self.index) {
    case .value(let o):
      self.index += 1
      return .value(o)

    case .error(let e):
      if e.isIndexError || e.isStopIteration {
        self.index = PyIterator.endIndex
        return .stopIteration()
      }

      return .error(e)
    }
  }

  // MARK: - Length hint

  // sourcery: pymethod = __length_hint__
  public func lengthHint() -> PyResult<PyInt> {
    let len: BigInt
    switch Py.lenBigInt(iterable: self.sequence) {
    case let .value(l): len = l
    case let .error(e): return .error(e)
    }

    let result = len - BigInt(self.index)
    return .value(Py.newInt(result))
  }
}

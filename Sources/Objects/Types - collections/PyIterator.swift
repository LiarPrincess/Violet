import Core

// In CPython:
// Objects -> iterobject.c

// sourcery: pytype = iterator, default, hasGC
internal class PyIterator: PyObject {

  internal let sequence: PyObject
  internal private(set) var index: Int

  private static let endIndex = -1

  // MARK: - Init

  internal init(sequence: PyObject) {
    self.sequence = sequence
    self.index = 0
    super.init(type: sequence.builtins.types.iterator)
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
    guard self.index != PyIterator.endIndex else {
      return .stopIteration()
    }

    switch Py.getItem(self.sequence, at: self.index) {
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
}

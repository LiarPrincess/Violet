import Core

// In CPython:
// Objects -> enumobject.c

// sourcery: pytype = reversed, default, hasGC, baseType
/// Return a reverse iterator over the values of the given sequence.
internal class PyReversed: PyObject {

  internal static let doc: String = """
    reversed(sequence, /)
    --

    Return a reverse iterator over the values of the given sequence.
    """

  internal let sequence: PyObject
  internal private(set) var index: Int

  private static let endIndex = -1

  // MARK: - Init

  internal init(sequence: PyObject, sequenceCount: Int) {
    self.sequence = sequence
    self.index = sequenceCount - 1
    super.init(type: sequence.builtins.types.reversed)
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
    if self.index >= 0 {
      switch self.builtins.getItem(self.sequence, at: self.index) {
      case .value(let o):
        self.index -= 1
        return .value(o)
      case .error(.indexError),
           .error(.stopIteration):
        break
      case .error(let e):
        return .error(e)
      }
    }

    self.index = PyReversed.endIndex
    return .stopIteration
  }
}

import Core

// sourcery: pytype = enumerate, default, hasGC, baseType
/// Return an enumerate object. iterable must be a sequence, an iterator,
/// or some other object which supports iteration.
internal final class PyEnumerate: PyObject {

  internal static let doc: String = """
    enumerate(iterable, start=0)
    --

    Return an enumerate object.

    iterable
    an object supporting iteration

    The enumerate object yields pairs containing a count (from start, which
    defaults to zero) and a value yielded by the iterable argument.

    enumerate is useful for obtaining an indexed list:
    (0, seq[0]), (1, seq[1]), (2, seq[2]), ...
    """

  /// Secondary iterator of enumeration
  internal let iterator: PyObject
  /// Next used index of enumeration
  internal private(set) var nextIndex: Int

  // MARK: - Init

  internal init(iterator: PyObject, startFrom index: Int) {
    self.iterator = iterator
    self.nextIndex = index
    super.init(type: iterator.builtins.types.enumerate)
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
    let item: PyObject
    switch self.builtins.next(iterator: self.iterator) {
    case .value(let n): item = n
    case .error(.stopIteration): return .error(.stopIteration) // lets be explicit
    case .error(let e): return .error(e)
    }

    let index = self.builtins.newInt(self.nextIndex)
    let result = self.builtins.newTuple(index, item)

    self.nextIndex += 1
    return .value(result)
  }
}

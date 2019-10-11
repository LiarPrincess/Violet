import Core

// TODO: Enumerate
// __getattribute__
// __iter__
// __next__
// __reduce__

internal typealias PyEnumerateSource = PyObject & IterableTypeClass

// sourcery: pytype = enumerate
/// Return an enumerate object. iterable must be a sequence, an iterator,
/// or some other object which supports iteration.
internal final class PyEnumerate: PyObject, IterableTypeClass {

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
  internal let iterable: PyEnumerateSource
  /// Current index of enumeration
  internal var index: Index
  /// Current item
  internal var item: PyObject

  internal enum Index {
    /// Before first call to next
    case notStarted(startingIndex: Int)
    /// After first call to next
    case started(Int)
  }

  // MARK: - Init

  internal init(_ context: PyContext, iterable: PyEnumerateSource, startIndex: Int) {
    self.iterable = iterable
    self.index = .notStarted(startingIndex: startIndex)
    self.item = context._none
    super.init(type: context.types.enumerate)
  }

  // MARK: - Next

  internal func next() -> PyObject {
    self.item = self.iterable.next()
    let index = self.advanceIndex()
    return self.tuple(self.int(index), self.item)
  }

  private func advanceIndex() -> Int {
    switch self.index {
    case let .notStarted(startingIndex: index):
      self.index = .started(index)
      return index
    case let .started(index):
      let nextIndex = index + 1
      self.index = .started(nextIndex)
      return nextIndex
    }
  }
}

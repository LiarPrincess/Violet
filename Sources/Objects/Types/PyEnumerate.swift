import Core

// TODO: Enumerate
// def __iter__(self) -> Iterator[Tuple[int, _T]]: ...

internal typealias PyEnumerateSource = PyObject & IterableTypeClass

/// Return an enumerate object. iterable must be a sequence, an iterator,
/// or some other object which supports iteration.
internal final class PyEnumerate: PyObject, IterableTypeClass {

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

  internal static func new(_ context: PyContext,
                           iterable: PyObject,
                           startIndex: Int) -> PyResult<PyEnumerate> {
    guard let source = iterable as? PyEnumerateSource else {
      let str = context.strString(value: iterable)
      return .error(.typeError("'\(str)' object is not iterable"))
    }

    return .value(
      PyEnumerate(context, iterable: source, startIndex: startIndex)
    )
  }

  private init(_ context: PyContext,
               iterable: PyEnumerateSource,
               startIndex: Int) {
    self.iterable = iterable
    self.index = .notStarted(startingIndex: startIndex)
    self.item = context.none
    super.init(type: context.types.enumerate)
  }

  // MARK: - Next

  internal func next() -> PyObject {
    self.item = self.iterable.next()

    let index = self.advanceIndex()
    let pyIndex = GeneralHelpers.pyInt(index)

    return GeneralHelpers.pyTuple([pyIndex, self.item])
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

internal final class PyEnumerateType: PyType {
//  override internal var name: String { return "enumerate" }
//  override internal var doc: String? { return """
//    enumerate(iterable, start=0)
//    --
//
//    Return an enumerate object.
//
//    iterable
//    an object supporting iteration
//
//    The enumerate object yields pairs containing a count (from start, which
//    defaults to zero) and a value yielded by the iterable argument.
//
//    enumerate is useful for obtaining an indexed list:
//    (0, seq[0]), (1, seq[1]), (2, seq[2]), ...
//    """
//  }
}

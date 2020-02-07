// MARK: - Iterator

/// Wrap `Python` iterator so that it can be used in idiomatic `Swift`.
///
/// Note thet due to readability `Py.reduce` methods are preffered over
/// `PySwiftIterator`/`PySwiftSequence`.
public struct PySwiftIterator: IteratorProtocol {

  public typealias Element = PyResult<PyObject>

  private var iterator: PyObject

  fileprivate init(iterator: PyObject) {
    self.iterator = iterator
  }

  // MARK: - Sequence

  public mutating func next() -> Self.Element? {
    switch Py.next(iterator: self.iterator) {
    case .value(let o):
      return .value(o)

    case .error(let e):
      if e.isStopIteration {
        return nil
      }

      return .error(e)
    }
  }
}

// MARK: - Sequence

/// Wrap `Python` sequence so that it can be used in idiomatic `Swift`
/// (for example `for` loops).
///
/// Note thet due to readability `Py.reduce` methods are preffered over
/// `PySwiftIterator`/`PySwiftSequence`.
public struct PySwiftSequence: Sequence {

  public typealias Element = PyResult<PyObject>

  private let iterator: PySwiftIterator

  private init(iterator: PySwiftIterator) {
    self.iterator = iterator
  }

  public func makeIterator() -> PySwiftIterator {
    return self.iterator
  }

  // MARK: - Factory

  /// Create `PySwiftIterator`.
  ///
  /// Use this method if you have `PyList`, `PyTuple` etc.
  /// This is the method you should probably use!
  internal static func create(iterable: PyObject) -> PyResult<PySwiftSequence> {
    return Py.iter(from: iterable).map(PySwiftSequence.create(iterator:))
  }

  /// Create `PySwiftIterator`.
  ///
  /// Use this method if you already have valid `Python` iterator.
  /// Otherwise consider `PySwiftIterator.create(iterable:)`.
  internal static func create(iterator: PyObject) -> PySwiftSequence {
    let iterator = PySwiftIterator(iterator: iterator)
    return PySwiftSequence(iterator: iterator)
  }
}

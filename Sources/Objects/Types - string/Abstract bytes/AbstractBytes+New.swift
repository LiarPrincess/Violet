import Foundation

private enum AbstractBytesFromCountResult {
  case bytes(Data)
  case tryOther
  case error(PyBaseException)
}

extension AbstractBytes {

  /// Helper for `__new__` method.
  ///
  /// ```
  /// >>> help(bytes)
  /// class bytes(object)
  /// |  bytes(iterable_of_ints) -> bytes
  /// |  bytes(string, encoding[, errors]) -> bytes
  /// |  bytes(bytes_or_buffer) -> immutable copy of bytes_or_buffer
  /// |  bytes(int) -> bytes object of size given by the parameter initialized with null bytes
  /// |  bytes() -> empty bytes object
  /// ```
  internal static func abstract__new__(_ py: Py,
                                       object: PyObject?,
                                       encoding: PyObject?,
                                       errors: PyObject?) -> PyResultGen<Data> {
    guard let object = object else {
      return .value(Data())
    }

    // Fast path when we don't have encoding and kwargs
    let hasEncoding = encoding != nil || errors != nil
    if let bytes = py.cast.asAnyBytes(object), !hasEncoding {
      return .value(bytes.elements)
    }

    if hasEncoding {
      return Self.fromEncoded(py, object: object, encoding: encoding, errors: errors)
    }

    switch Self.fromCount(py, object: object) {
    case .bytes(let data): return .value(data)
    case .tryOther: break
    case .error(let e): return .error(e)
    }

    switch Self.getElementsFromIterable(py, iterable: object) {
    case .bytes(let data): return .value(data)
    case .notIterable: break
    case .error(let e): return .error(e)
    }

    let message = "cannot convert '\(object.typeName)' object to bytes"
    return .typeError(py, message: message)
  }

  // MARK: - From encoded

  private static func fromEncoded(_ py: Py,
                                  object: PyObject,
                                  encoding encodingObject: PyObject?,
                                  errors errorObject: PyObject?) -> PyResultGen<Data> {
    let encoding: PyString.Encoding
    switch PyString.Encoding.from(py, object: encodingObject) {
    case let .value(e): encoding = e
    case let .error(e): return .error(e)
    }

    let errorHandling: PyString.ErrorHandling
    switch PyString.ErrorHandling.from(py, object: errorObject) {
    case let .value(e): errorHandling = e
    case let .error(e): return .error(e)
    }

    guard let string = py.cast.asString(object) else {
      return .typeError(py, message: "encoding without a string argument")
    }

    return encoding.encodeOrError(py, string: string.value, onError: errorHandling)
  }

  // MARK: - From count

  private static func fromCount(_ py: Py,
                                object: PyObject) -> AbstractBytesFromCountResult {
    switch IndexHelper.int(py, object: object, onOverflow: .overflowError) {
    case .value(let count):
      // swiftlint:disable:next empty_count
      guard count >= 0 else {
        let error = py.newValueError(message: "negative count")
        return .error(error.asBaseException)
      }

      let data = Data(repeating: 0, count: count)
      return .bytes(data)

    case .notIndex:
      return .tryOther

    case let .overflow(_, lazyError):
      let e = lazyError.create(py)
      return .error(e)

    case .error(let e):
      return .error(e)
    }
  }
}

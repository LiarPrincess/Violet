import Foundation

// swiftlint:disable:next type_name
private enum AbstractBytes_FromCountResult {
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
  ///
  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _handleNewArgs(object: PyObject?,
                                      encoding: PyObject?,
                                      errors: PyObject?) -> PyResult<Data> {
    guard let object = object else {
      return .value(Data())
    }

    // Fast path when we don't have encoding and kwargs
    let hasEncoding = encoding != nil || errors != nil
    if let bytes = PyCast.asAnyBytes(object), !hasEncoding {
      return .value(bytes.elements)
    }

    if hasEncoding {
      return Self._fromEncoded(object: object,
                               encoding: encoding,
                               errors: errors)
    }

    switch Self._fromCount(object: object) {
    case .bytes(let data): return .value(data)
    case .tryOther: break
    case .error(let e): return .error(e)
    }

    switch Self._getElementsFromIterable(iterable: object) {
    case .bytes(let data): return .value(data)
    case .notIterable: break
    case .error(let e): return .error(e)
    }

    return .typeError("cannot convert '\(object.typeName)' object to bytes")
  }

  // MARK: - From encoded

  private static func _fromEncoded(object: PyObject,
                                   encoding encodingObject: PyObject?,
                                   errors errorObject: PyObject?) -> PyResult<Data> {
    let encoding: PyString.Encoding
    switch PyString.Encoding.from(object: encodingObject) {
    case let .value(e): encoding = e
    case let .error(e): return .error(e)
    }

    let errorHandling: PyString.ErrorHandling
    switch PyString.ErrorHandling.from(object: errorObject) {
    case let .value(e): errorHandling = e
    case let .error(e): return .error(e)
    }

    guard let string = PyCast.asString(object) else {
      return .typeError("encoding without a string argument")
    }

    return encoding.encodeOrError(string: string.value, onError: errorHandling)
  }

  // MARK: - From count

  private static func _fromCount(object: PyObject) -> AbstractBytes_FromCountResult {
    switch IndexHelper.int(object, onOverflow: .overflowError) {
    case .value(let count):
      // swiftlint:disable:next empty_count
      guard count >= 0 else {
        return .error(Py.newValueError(msg: "negative count"))
      }

      let data = Data(repeating: 0, count: count)
      return .bytes(data)

    case .notIndex:
      return .tryOther

    case let .overflow(_, lazyError):
      let e = lazyError.create()
      return .error(e)

    case .error(let e):
      return .error(e)
    }
  }
}

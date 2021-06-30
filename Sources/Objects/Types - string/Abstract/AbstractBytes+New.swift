import Foundation

// swiftlint:disable:next type_name
private enum AbstractBytes_FromXXXResult {
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
    if let bytes = object as? PyBytesType, !hasEncoding {
      return .value(bytes.data.values)
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

    switch Self._fromIterable(iterable: object) {
    case .bytes(let data): return .value(data)
    case .tryOther: break
    case .error(let e): return .error(e)
    }

    return .typeError("cannot convert '\(object.typeName)' object to bytes")
  }

  // MARK: - From encoded

  private static func _fromEncoded(object: PyObject,
                                   encoding encodingObject: PyObject?,
                                   errors errorObject: PyObject?) -> PyResult<Data> {
    let encoding: PyStringEncoding
    switch PyStringEncoding.from(encodingObject) {
    case let .value(e): encoding = e
    case let .error(e): return .error(e)
    }

    let errors: PyStringErrorHandler
    switch PyStringErrorHandler.from(errorObject) {
    case let .value(e): errors = e
    case let .error(e): return .error(e)
    }

    guard let string = PyCast.asString(object) else {
      return .typeError("encoding without a string argument")
    }

    return encoding.encode(string: string.value, errors: errors)
  }

  // MARK: - From count

  private static func _fromCount(object: PyObject) -> AbstractBytes_FromXXXResult {
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

    case .error(let e),
         .overflow(_, let e):
      return .error(e)
    }
  }

  // MARK: - From iterable

  private static func _fromIterable(iterable: PyObject) -> AbstractBytes_FromXXXResult {
    guard Py.hasIter(object: iterable) else {
      return .tryOther
    }

    if let bytes = iterable as? PyBytesType, bytes.checkExact() {
      return .bytes(bytes.data.values)
    }

    var result = Data()

    let reduceError = Py.reduce(iterable: iterable, into: &result) { acc, object in
      switch Self._asByte(object: object) {
      case let .value(byte):
        acc.append(byte)
        return .goToNextElement
      case let .error(e):
        return .error(e)
      }
    }

    if let e = reduceError {
      return .error(e)
    }

    return .bytes(result)
  }
}

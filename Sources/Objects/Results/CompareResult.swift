// TODO: Rename to PyCompareResult

/// Helper type used when implementing compare methods.
public enum CompareResult {
  case value(Bool)
  /// Shortcut for `py.notImplemented`
  case notImplemented
  /// `Zelf` object, expected type, performed operation.
  case invalidSelfArgument(PyObject, String, Operation)
  case error(PyBaseException)

  public enum Operation: String {
    case __eq__
    case __ne__
    case __lt__
    case __le__
    case __gt__
    case __ge__
  }

  // swiftlint:disable:next discouraged_optional_boolean
  public init(_ value: Bool?) {
    switch value {
    case .some(let b):
      self = .value(b)
    case .none:
      self = .notImplemented
    }
  }

  public init(_ value: PyResultGen<Bool>) {
    switch value {
    case let .value(b):
      self = .value(b)
    case let .error(e):
      self = .error(e)
    }
  }

  /// Method used when implementing `__ne__`.
  ///
  /// We don't want to override `!` operator, because it is tiny and easy to miss.
  public var not: CompareResult {
    switch self {
    case .value(let bool):
      return .value(!bool)
    case .notImplemented:
      return .notImplemented
    case let .invalidSelfArgument(object, expectedType, operation):
      return .invalidSelfArgument(object, expectedType, operation)
    case .error(let e):
      return .error(e)
    }
  }

  internal static func createInvalidSelfArgumentError(
    _ py: Py,
    object: PyObject,
    expectedType: String,
    operation: Operation
  ) -> PyTypeError {
    let fnName = operation.rawValue
    return py.newInvalidSelfArgumentError(object: object,
                                          expectedType: expectedType,
                                          fnName: fnName)
  }
}

extension PyResult {

  public init(_ py: Py, _ result: CompareResult) {
    switch result {
    case .value(let bool):
      self = PyResult(py, bool)

    case .notImplemented:
      self = PyResult(py.notImplemented)

    case let .invalidSelfArgument(object, expectedType, operation):
      let error = CompareResult.createInvalidSelfArgumentError(
        py,
        object: object,
        expectedType: expectedType,
        operation: operation
      )

      self = .error(error.asBaseException)

    case .error(let e):
      self = .error(e)
    }
  }
}

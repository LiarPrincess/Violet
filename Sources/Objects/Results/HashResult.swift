/// Helper type used when implementing `__hash__` methods.
public enum HashResult {
  case value(PyHash)
  /// Basically a `type error` from `Py.newUnhashableObjectError(object:)`,
  /// but without allocation.
  case unhashable(PyObject)
  /// `Zelf` object, expected type
  case invalidSelfArgument(PyObject, String)
  case error(PyBaseException)

  internal static func createUnhashableError(_ py: Py,
                                             object: PyObject) -> PyTypeError {
    return py.newUnhashableObjectError(object: object)
  }

  internal static func createInvalidSelfArgumentError(
    _ py: Py,
    object: PyObject,
    expectedType: String
  ) -> PyTypeError {
    return py.newInvalidSelfArgumentError(object: object,
                                          expectedType: expectedType,
                                          fnName: "__hash__")
  }
}

extension PyResultGen where Wrapped == PyObject {
  public init(_ py: Py, _ result: HashResult) {
    switch result {
    case let .value(hash):
      self = PyResultGen(py, hash)

    case let .unhashable(object):
      let error = HashResult.createUnhashableError(py, object: object)
      self = .error(error.asBaseException)

    case let .invalidSelfArgument(object, expectedType):
      let error = HashResult.createInvalidSelfArgumentError(py,
                                                            object: object,
                                                            expectedType: expectedType)

      self = .error(error.asBaseException)

    case let .error(e):
      self = .error(e)
    }
  }
}

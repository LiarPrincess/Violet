/// Helper type used when implementing `__hash__` methods.
public enum HashResult {
  case value(PyHash)
  /// Basically a `type error` from `Py.hashNotAvailable()`,
  /// but without allocation.
  case unhashable(PyObject)
  /// `Zelf` object, expected type
  case invalidSelfArgument(PyObject, String)
  case error(PyBaseException)
}

extension PyResult where Wrapped == PyObject {
  public init(_ py: Py, _ result: HashResult) {
    switch result {
    case let .value(hash):
      self = PyResult(py, hash)

    case let .unhashable(object):
      let e = py.hashNotAvailable(object)
      self = .error(e)

    case let .invalidSelfArgument(object, expectedType):
      let error = py.newInvalidSelfArgumentError(object: object,
                                                 expectedType: expectedType,
                                                 fnName: "__hash__")
      self = .error(error.asBaseException)

    case let .error(e):
      self = .error(e)
    }
  }
}

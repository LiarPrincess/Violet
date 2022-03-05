/// Helper type used when implementing `__hash__` methods.
public enum HashResult {
  case value(PyHash)
  /// Basically a `type error` from `Py.hashNotAvailable()`,
  /// but without allocation.
  case unhashable(PyObject)
  /// `Zelf` object, expected type
  case invalidSelfArgument(PyObject, String)
  case error(PyBaseException)

  public func toResult(_ py: Py) -> PyResult<PyObject> {
    switch self {
    case let .value(hash):
      let int = py.newInt(hash)
      return .value(int.asObject)
    case let .unhashable(object):
      let e = py.hashNotAvailable(object)
      return .error(e)
    case let .invalidSelfArgument(object, expectedType):
      let error = py.newInvalidSelfArgumentError(object: object,
                                                 expectedType: expectedType,
                                                 fnName: "__hash__")
      return .error(error.asBaseException)
    case let .error(e):
      return .error(e)
    }
  }
}

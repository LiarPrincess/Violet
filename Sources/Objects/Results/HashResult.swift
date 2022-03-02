public enum HashResult {
  case value(PyHash)
  /// Basically a `type error` from `Py.hashNotAvailable()`,
  /// but without allocation.
  case unhashable(PyObject)
  case error(PyBaseException)
}

/* MARKER
extension HashResult: PyFunctionResultConvertible {
  public var asFunctionResult: PyFunctionResult {
    switch self {
    case let .value(hash):
      return hash.asFunctionResult
    case let .unhashable(object):
      let e = Py.hashNotAvailable(object)
      return .error(e)
    case let .error(e):
      return .error(e)
    }
  }
}
*/

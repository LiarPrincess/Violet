import Foundation

extension PyString {

  /// What are we going to do when error happen?
  public enum ErrorHandling {

    /// Raise UnicodeError (or a subclass); this is the default.
    case strict
    /// Ignore the malformed data and continue without further notice.
    case ignore

    internal static func from(_ py: Py, object: PyObject?) -> PyResultGen<ErrorHandling> {
      guard let object = object else {
        return .value(.strict)
      }

      guard let string = py.cast.asString(object) else {
        let message = "errors have to be str, not \(object.typeName)"
        return .typeError(py, message: message)
      }

      return Self.from(py, string: string.value)
    }

    internal static func from(_ py: Py, string: String) -> PyResultGen<ErrorHandling> {
      switch string {
      case "strict":
        return .value(.strict)
      case "ignore":
        return .value(.ignore)
      default:
        let message = "unknown error handler name '\(string)'"
        return .lookupError(py, message: message)
      }
    }
  }
}

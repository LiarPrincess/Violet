import Foundation

extension PyString {

  /// What are we going to do when error happen?
  public enum ErrorHandling {

    /// Raise UnicodeError (or a subclass); this is the default.
    case strict
    /// Ignore the malformed data and continue without further notice.
    case ignore

    public static let `default` = ErrorHandling.strict

    public static func from(object: PyObject?) -> PyResult<ErrorHandling> {
      guard let object = object else {
        return .value(.default)
      }

      guard let string = PyCast.asString(object) else {
        return .typeError("errors have to be str, not \(object.typeName)")
      }

      return Self.from(string: string.value)
    }

    public static func from(string: String) -> PyResult<ErrorHandling> {
      switch string {
      case "strict":
        return .value(.strict)
      case "ignore":
        return .value(.ignore)
      default:
        return .lookupError("unknown error handler name '\(string)'")
      }
    }
  }
}

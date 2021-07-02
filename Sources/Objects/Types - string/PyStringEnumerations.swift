import Foundation

/// What are we going to do when error happen?
internal enum PyStringErrorHandler {
  /// Raise UnicodeError (or a subclass); this is the default.
  case strict
  /// Ignore the malformed data and continue without further notice.
  case ignore

  internal static let `default` = PyStringErrorHandler.strict

  internal static func from(_ object: PyObject?) -> PyResult<PyStringErrorHandler> {
    guard let object = object else {
      return .value(.default)
    }

    guard let str = PyCast.asString(object) else {
      return .typeError("errors have to be str, not \(object.typeName)")
    }

    return PyStringErrorHandler.from(str.value)
  }

  internal static func from(_ value: String) -> PyResult<PyStringErrorHandler> {
    switch value {
    case "strict":
      return .value(.strict)
    case "ignore":
      return .value(.ignore)
    default:
      return .lookupError("unknown error handler name '\(value)'")
    }
  }
}

public enum NotImplemented: Error {

  /// We currently support only UTF-8 encoding.
  /// Any try to set it to other value (using `'# -*- coding: xxx -*-'`
  /// or `'# vim:fileencoding=xxx'`) will throw.
  case encodingOtherThanUTF8(String)

  /// Since we dont have BigInts in Swift integers outside of
  /// `<PyInt.min, PyInt.max>` range are not currently supported.
  case unlimitedInteger

  /// Escapes in form of `'\N{UNICODE_NAME}'` (for example: `"\N{Em Dash}"`)
  /// are not currently supported.
  case stringNamedEscape

  /// This will never be implemented, because of Swift limitations.
  /// https://www.python.org/dev/peps/pep-0401/
  case pep401
}

extension NotImplemented: CustomStringConvertible {
  public var description: String {
    switch self {
    case .encodingOtherThanUTF8(let encoding):
      return "Encoding '\(encoding)' is not currently supported (only UTF-8 is)."
    case.unlimitedInteger:
      return "Integers outside of <\(PyInt.min), \(PyInt.max)> range " +
             "are not currently supported."
    case .stringNamedEscape:
      return "Escapes in form of '\\N{UNICODE_NAME}' (for example: " +
             "\"\\N{Em Dash}\" are not currently supported."
    case .pep401:
      return "Uh... Oh... that means that we have to implement '<>' now."
    }
  }
}

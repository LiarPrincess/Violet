import VioletCore

public enum LexerUnimplemented: CustomStringConvertible, Equatable {

  /// Violet supports only UTF-8 encoding.
  /// Trying to set it to other value (for example by using
  /// `'# -*- coding: xxx -*-'` or `'# vim:fileencoding=xxx'`) will throw.
  case nonUTF8Encoding(encoding: String)

  /// Escapes in form of `\N{UNICODE_NAME}` (for example: `\N{Em Dash}`)
  /// are not currently supported.
  case namedUnicodeEscape

  public var description: String {
    switch self {
    case .nonUTF8Encoding(let encoding):
      return "Encoding '\(encoding)' is not currently supported (only UTF-8 is)."
    case .namedUnicodeEscape:
      return "Escapes in form of '\\N{UNICODE_NAME}' " +
      "(for example: '\\N{Em Dash}') are not currently supported."
    }
  }
}

import VioletCore

public enum LexerUnimplemented: CustomStringConvertible, Equatable {

  /// Violet supports only UTF-8 encoding.
  /// Trying to set it to other value (for example by using
  /// `'# -*- coding: xxx -*-'` or `'# vim:fileencoding=xxx'`) will throw.
  case nonUTF8Encoding(encoding: String)

  /// Since we dont have BigInts in Swift integers outside of
  /// `<BigInt.min, BigInt.max>` range are not currently supported.
  case unlimitedInteger(valueToParse: String)

  /// Escapes in form of `\N{UNICODE_NAME}` (for example: `\N{Em Dash}`)
  /// are not currently supported.
  case namedUnicodeEscape

  public var description: String {
    switch self {
    case .nonUTF8Encoding(let encoding):
      return "Encoding '\(encoding)' is not currently supported (only UTF-8 is)."
    case .unlimitedInteger(let valueToParse):
      return "Unable to parse '\(valueToParse)' as int. " +
        "Integers outside of <\(BigInt.min), \(BigInt.max)> range " +
        "are not currently supported. " +
        "(This error message will get better when we have proper BigInt.)"
    case .namedUnicodeEscape:
      return "Escapes in form of '\\N{UNICODE_NAME}' " +
      "(for example: '\\N{Em Dash}') are not currently supported."
    }
  }
}

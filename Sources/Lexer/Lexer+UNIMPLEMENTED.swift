import Core

extension Lexer {

  // MARK: - Non utf-8 encoding

  /// Violet supports only UTF-8 encoding.
  /// Trying to set it to other value (for example by using
  /// `'# -*- coding: xxx -*-'` or `'# vim:fileencoding=xxx'`) will throw.
  internal func trapNonUTF8Encoding(encoding: String) -> Never {
    let msg = "Encoding '\(encoding)' is not currently supported (only UTF-8 is)."
    trap(msg)
  }

  // MARK: - Unlimited int

  /// Since we dont have BigInts in Swift integers outside of
  /// `<BigInt.min, BigInt.max>` range are not currently supported.
  internal func trapUnlimitedInteger(valueToParse value: String) -> Never {
    let msg = "Unable to parse '\(value)' as int. " +
      "Integers outside of <\(BigInt.min), \(BigInt.max)> range " +
      "are not currently supported. " +
      "(This error message will get better when we have proper BigInt.)"
    trap(msg)
  }

  // MARK: - Named unicode escape

  /// Escapes in form of `\N{UNICODE_NAME}` (for example: `\N{Em Dash}`)
  /// are not currently supported.
  internal func trapNamedUnicodeEscape() -> Never {
    let msg = "Escapes in form of '\\N{UNICODE_NAME}' " +
      "(for example: '\\N{Em Dash}') are not currently supported."
    trap(msg)
  }
}

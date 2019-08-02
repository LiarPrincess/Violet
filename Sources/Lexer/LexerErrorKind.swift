// Throwing unicode scalar does not make sense (individual scalars don't
// have meaning). But we also include its location, so that's something.

public enum LexerErrorKind: Equatable {

  /// Unexpected end of file
  case eof
  /// Unexpected character
  case unexpectedCharacter(UnicodeScalar)

  /// Inconsistent mixing of tabs and spaces
//  case tabSpace
  /// Too many indentation levels
  case tooDeep
  /// No matching outer block for dedent
  case dedent

  /// Invalid character in identifier
  case identifier(UnicodeScalar)

  /// EOL in single-quoted string
  case unfinishedShortString
  /// EOF in triple-quoted string
  case unfinishedLongString
  /// Unable to decode string escape sequence
  case unicodeEscape
  /// Bytes can only contain `'0 <= x < 256'` values
  case badByte(UnicodeScalar)

  /// Digit is required after underscore
  case danglingIntegerUnderscore
  /// Character 'x' is not an valid hexadecimal digit
  case invalidIntegerDigit(NumberType, UnicodeScalar)
  /// Unable to parse integer from 'x'
  case unableToParseInteger(NumberType, String)

  /// Character 'x' is not an valid decimal digit
  case invalidDecimalDigit(UnicodeScalar)
  /// Unable to parse integer from 'x'
  case unableToParseDecimal(String)
}

extension LexerErrorKind: CustomStringConvertible {
  public var description: String {
    switch self {
    case .eof:
      return "Unexpected end of file."
    case .unexpectedCharacter(let c):
      return "Unexpected character '\(c)' (unicode: \(unicode(c)))."

//    case .tabSpace:
//      return "Inconsistent mixing of tabs and spaces"
    case .tooDeep:
      return "Too many levels of indentation."
    case .dedent:
      return "Unindent does not match any outer indentation level."

    case .identifier(let c):
      return "Invalid character '\(c)' (unicode: \(unicode(c)) in identifier."

    case .unfinishedShortString:
      return "EOL while scanning string literal."
    case .unfinishedLongString:
      return "EOF while scanning triple-quoted string literal."
    case .badByte(let c):
      return "Invalid character '\(c)' (value: \(c.value)). " +
             "Bytes can only contain '0 <= x < 256' values."
    case .unicodeEscape:
      return "Unable to decode string escape sequence."

    case .danglingIntegerUnderscore:
      return "Digit is required after underscore."
    case let .invalidIntegerDigit(type, c):
      return "Character '\(c)' (unicode: \(unicode(c)) is not valid \(type) digit."
    case let .unableToParseInteger(type, s):
      return "Unable to parse \(type) integer from '\(s)'."

    case .invalidDecimalDigit(let c):
      return "Character '\(c)' (unicode: \(unicode(c)) is not valid decimal digit."
    case .unableToParseDecimal(let s):
      return "Unable to parse decimal from '\(s)'."
    }
  }
}

/// Scalar -> U+XXXX (for example U+005F). Then you can use it
/// [here](https://unicode.org/cldr/utility/character.jsp?a=005f)\.
private func unicode(_ c: UnicodeScalar) -> String {
  let hex = String(c.value, radix: 16, uppercase: true)
  let pad = String(repeating: "0", count: 4 - hex.count)
  return "U+\(pad)\(hex)"
}

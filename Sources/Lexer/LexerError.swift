import Core

// MARK: - Error

public struct LexerError: Error, Equatable, CustomStringConvertible {

  /// Type of the error.
  public let kind: LexerErrorKind

  /// Location of the error in the code.
  public let location: SourceLocation

  public var description: String {
    return "\(self.location): \(self.kind)"
  }

  public init(_ kind: LexerErrorKind, location: SourceLocation) {
    self.kind = kind
    self.location = location
  }
}

// MARK: - Kind

public enum LexerErrorKind: Equatable, CustomStringConvertible {

  /// Unexpected end of file
  case eof
  /// Unexpected character
  case unexpectedCharacter(UnicodeScalar)

  /// Inconsistent mixing of tabs and spaces
//  case tabSpace // nope, we don't have this
  /// Too many indentation levels
  case tooManyIndentationLevels
  /// No matching outer block for dedent
  case noMatchingDedent

  /// Invalid character in identifier
  case invalidCharacterInIdentifier(UnicodeScalar)

  /// EOL in single-quoted string
  case unfinishedShortString
  /// EOF in triple-quoted string
  case unfinishedLongString
  /// Unable to decode string escape sequence
  case invalidUnicodeEscape
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

  // Expected new line after '\'.
  case missingNewLineAfterBackslashEscape

  /// Given feature was not yet implmented.
  case unimplemented(LexerUnimplemented)

  public var description: String {
    switch self {
    case .eof:
      return "Unexpected end of file."
    case .unexpectedCharacter(let c):
      return "Unexpected character '\(c)' (unicode: \(c.uPlus))."

//    case .tabSpace:
//      return "Inconsistent mixing of tabs and spaces"
    case .tooManyIndentationLevels:
      return "Too many levels of indentation."
    case .noMatchingDedent:
      return "Unindent does not match any outer indentation level."

    case .invalidCharacterInIdentifier(let c):
      return "Invalid character '\(c)' (unicode: \(c.uPlus)) in identifier."

    case .unfinishedShortString:
      return "EOL while scanning string literal."
    case .unfinishedLongString:
      return "EOF while scanning triple-quoted string literal."
    case .badByte(let c):
      return "Invalid character '\(c)' (value: \(c.value)). " +
             "Bytes can only contain '0 <= x < 256' values."
    case .invalidUnicodeEscape:
      return "Unable to decode string escape sequence."

    case .danglingIntegerUnderscore:
      return "Digit is required after underscore."
    case let .invalidIntegerDigit(type, c):
      return "Character '\(c)' (unicode: \(c.uPlus)) is not valid \(type) digit."
    case let .unableToParseInteger(type, s):
      return "Unable to parse \(type) integer from '\(s)'."

    case .invalidDecimalDigit(let c):
      return "Character '\(c)' (unicode: \(c.uPlus)) is not valid decimal digit."
    case .unableToParseDecimal(let s):
      return "Unable to parse decimal from '\(s)'."

    case .missingNewLineAfterBackslashEscape:
      return "Expected new line after backslash escape ('\\')."

    case .unimplemented(let u):
      return String(describing: u)
    }
  }
}

import BigInt
import VioletCore

public struct LexerError: Error, Equatable, CustomStringConvertible {

  /// Type of the error.
  public let kind: Kind

  /// Location of the error in the code.
  public let location: SourceLocation

  public var description: String {
    return "\(self.location): \(self.kind)"
  }

  public init(_ kind: Kind, location: SourceLocation) {
    self.kind = kind
    self.location = location
  }

  // MARK: - Kind

  public enum Kind: Equatable, CustomStringConvertible {

    /// Unexpected end of file
    case unexpectedEOF
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

    /// Unable to parse integer from 'string'
    case unableToParseInt(String, NumberType, BigInt.PythonParsingError)
    /// Unable to parse float from 'string'
    case unableToParseFloat(String)

    // Expected new line after '\'.
    case missingNewLineAfterBackslashEscape

    /// Given feature was not yet implemented.
    case unimplemented(LexerUnimplemented)

    public var description: String {
      switch self {
      case .unexpectedEOF:
        return "Unexpected end of file."
      case .unexpectedCharacter(let scalar):
        let char = self.scalarDescription(scalar: scalar)
        return "Unexpected character \(char)."

  //    case .tabSpace:
  //      return "Inconsistent mixing of tabs and spaces"
      case .tooManyIndentationLevels:
        return "Too many levels of indentation."
      case .noMatchingDedent:
        return "Unindent does not match any outer indentation level."

      case .invalidCharacterInIdentifier(let scalar):
        let char = self.scalarDescription(scalar: scalar)
        return "Invalid character \(char) in identifier."

      case .unfinishedShortString:
        return "EOL while scanning string literal."
      case .unfinishedLongString:
        return "EOF while scanning triple-quoted string literal."
      case .badByte(let scalar):
        return "Invalid character '\(scalar)' (value: \(scalar.value)). " +
               "Bytes can only contain '0 <= x < 256' values."
      case .invalidUnicodeEscape:
        return "Unable to decode string escape sequence."

      case let .unableToParseInt(s, type, error):
        return "Unable to parse \(type) integer from '\(s)': \(error)."
      case let .unableToParseFloat(s):
        return "Unable to parse float from '\(s)'"

      case .missingNewLineAfterBackslashEscape:
        return "Expected new line after backslash escape ('\\')."

      case .unimplemented(let u):
        return "UNIMPLEMENTED IN VIOLET: " + String(describing: u)
      }
    }

    private func scalarDescription(scalar: UnicodeScalar) -> String {
      return "'\(scalar)' (unicode: \(scalar.codePointNotation))"
    }
  }
}

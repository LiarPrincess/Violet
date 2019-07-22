// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// MARK: - Error type

public enum LexerErrorType: Equatable {

  // MARK: CPython

  /// Unexpected end of file
  case eof
  /// Inconsistent mixing of tabs and spaces
  case tabSpace
  /// Too many indentation levels
  case tooDeep
  /// No matching outer block for dedent
  case dedent
  /// Error in decoding into Unicode
  case decode
  /// EOF in triple-quoted string
  case eofs // TODO: actually correct, better message than eof
  /// EOL in single-quoted string
  case eols
  /// Unexpected characters after a line continuation
  case lineCont
  /// Invalid characters in identifier
  case identifier
  /// Ill-formed single statement input
  case badSingle

  // MARK: Violet

  /// Bytes can only contain ASCII literal characters
  case badByte
  /// Unable to decode string escape sequence.
  case unicodeEscape
  /// Syntax error
  case syntax(message: String) // TODO: lexer does not have grammar!
}

extension LexerErrorType: CustomStringConvertible {
  // TODO: Check other error translations + unicodeEscape
  public var description: String {
    switch self {
    case .eof: return "Unexpected end of file" // check
    case .tabSpace: return "Inconsistent mixing of tabs and spaces" // check
    case .tooDeep:  return "Too many levels of indentation"
    case .dedent: return "Unindent does not match any outer indentation level"
    case .decode: return "Error in decoding into Unicode" // check
    case .eofs: return "EOF while scanning triple-quoted string literal"
    case .eols: return "EOL while scanning string literal"
    case .lineCont: return "Unexpected characters after a line continuation" // check
    case .identifier: return "Invalid character in identifier"
    case .badSingle: return "Ill-formed single statement input" // check

    case .badByte: return "Bytes can only contain ASCII literal characters"
    case .unicodeEscape: return "Unable to decode string escape sequence"
    case .syntax(let message): return "Syntax error: \(message)"
    }
  }
}

// MARK: - Error

public struct LexerError: Error, Equatable {

  public let type:     LexerErrorType
  public let location: SourceLocation

  internal init(_ type: LexerErrorType, location: SourceLocation) {
    self.type = type
    self.location = location
  }
}

extension LexerError: CustomStringConvertible {

  public var description: String {
    return "[\(self.location)] \(self.type)"
  }
}

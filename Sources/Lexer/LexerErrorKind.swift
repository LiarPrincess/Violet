// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Core

public enum LexerErrorKind: Equatable {

  /// Unexpected end of file
  case eof

  /// Inconsistent mixing of tabs and spaces
  case tabSpace
  /// Too many indentation levels
  case tooDeep
  /// No matching outer block for dedent
  case dedent

  /// Invalid characters in identifier
  case identifier

  /// EOL in single-quoted string
  /// eols
  case unfinishedShortString
  /// EOF in triple-quoted string
  /// eofs
  case unfinishedLongString
  /// Unable to decode string escape sequence
  /// SyntaxError: (unicode error) 'unicodeescape' codec can't decode bytes in position 0-4: truncated \uXXXX escape
  case unicodeEscape
  /// Bytes can only contain ASCII literal characters
  /// SyntaxError
  case badByte(UnicodeScalar)

  /// Digit is required after underscore
  case danglingIntegerUnderscore
  /// Character 'x' is not an valid integer digit
  case invalidIntegerDigit(NumberType, UnicodeScalar)
  /// Unable to parse integer from 'x'
  case unableToParseInteger(NumberType, String)

  /// Character 'x' is not an valid decimal digit
  case invalidDecimalDigit(UnicodeScalar)
  /// Unable to parse integer from 'x'
  case unableToParseDecimal(String)

  /// Error in decoding into Unicode
  // case decode
  /// Unexpected characters after a line continuation
  // case lineCont
  /// Ill-formed single statement input
  // case badSingle
}

extension LexerErrorKind: CustomStringConvertible {
  public var description: String {
    switch self {
    case .eof: return "Unexpected end of file"

    case .tabSpace: return "Inconsistent mixing of tabs and spaces"
    case .tooDeep:  return "Too many levels of indentation"
    case .dedent:   return "Unindent does not match any outer indentation level"

    case .identifier: return "Invalid character in identifier"

    case .unfinishedShortString: return "EOL while scanning string literal"
    case .unfinishedLongString: return "EOF while scanning triple-quoted string literal"
    case .badByte: return "Bytes can only contain ASCII literal characters"
    case .unicodeEscape: return "Unable to decode string escape sequence"

    case .danglingIntegerUnderscore: return "Digit is required after underscore"
    case let .invalidIntegerDigit(type, c): return "Character '\(c)' is not valid \(type) digit."
    case let .unableToParseInteger(type, s):
      var message = ""
      message += "Invalid \(type) integer '\(s)'. "
      message += "Integers outside of <-\(PyInt.max), \(PyInt.max)> range are not supported."
      return message

    case .invalidDecimalDigit(let c): return "Character '\(c)' is not valid decimal digit."
    case .unableToParseDecimal(let s): return "Unable to parse decimal from '\(s)'"

//    case .decode: return "Error in decoding into Unicode" // check
//    case .lineCont: return "Unexpected characters after a line continuation" // check
//    case .badSingle: return "Ill-formed single statement input" // check
    }
  }
}

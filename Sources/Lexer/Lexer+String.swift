// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

// swiftlint:disable file_length
// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity

// https://docs.python.org/3/reference/lexical_analysis.html#string-and-bytes-literals

private enum QuoteType {
  case single
  case triple

  fileprivate var quoteCount: Int {
    switch self {
    case .single: return 1
    case .triple: return 3
    }
  }

  fileprivate var nilPeekError: LexerErrorType {
    switch self {
    case .single: return .eols
    case .triple: return .eofs
    }
  }
}

extension Lexer {

  internal mutating func string() throws -> Token {
    let prefix = StringPrefix()
    return try self.string(prefix: prefix, start: self.location)
  }

  internal mutating func string(prefix: StringPrefix,
                                start:  SourceLocation) throws -> Token {

    let scalars = try readString(prefix: prefix)
    let end = self.location

    if prefix.b {
      // 'self.readString', should find any incorrect input, but just in case:
      var data = Data(capacity: scalars.count)
      for c in scalars {
        if self.isValidByte(c) {
          data.append(UInt8(c.value & 0xff))
        } else {
          // not very precise, 'self.readString' is better
          throw self.createError(.badByte, location: start)
        }
      }

      return Token(.bytes(data), start: start, end: end)
    }

    let string = String(scalars)
    let kind: TokenKind = prefix.f ? .formatString(string) : .string(string)
    return Token(kind, start: start, end: end)
  }

  private mutating func readString(prefix: StringPrefix) throws -> [UnicodeScalar] {
    assert(self.peek == "\"" || self.peek == "'")

    guard let quote = self.peek else {
      throw self.createError(.eof)
    }

    var quoteType = QuoteType.single
    var endQuoteCount = 0 // counting quotes to know when to end

    if self.advance() == quote {
      if self.advance() == quote {
        _ = self.advance()
        quoteType = .triple // quote -> quote -> quote -> (string)
      } else {
        return [] // quote -> quote -> (whatever)
      }
    }

    // State: self.peek = 1st character of string
    var result = [UnicodeScalar]()
    while endQuoteCount != quoteType.quoteCount {
      guard let peek = self.peek else {
        throw self.createError(quoteType.nilPeekError)
      }

      try self.checkValidByteIfNeeded(prefix, peek)

      switch peek {
      case "\\":
        switch try self.readEscaped(prefix, quoteType) {
        case .escaped(let char):  result.append(char)
        case .escapedNewLine:     break
        case .notEscapeCharacter: result.append("\\")
        }
      default:
        if quoteType == .single && peek == "\n" {
          throw self.createError(.eols)
        }

        result.append(peek)
        endQuoteCount = (peek == quote) ? endQuoteCount + 1 : 0
        _ = self.advance()
      }
    }

    let withoutTrailingQuotes = result[0..<(result.count - endQuoteCount)]
    return [UnicodeScalar](withoutTrailingQuotes)
  }

  // MARK: - Byte range

  private func checkValidByteIfNeeded(_ prefix: StringPrefix,
                                      _ c: UnicodeScalar) throws {
    if prefix.b && !self.isValidByte(c) {
      throw self.createError(.badByte)
    }
  }

  private func isValidByte(_ c: UnicodeScalar) -> Bool {
    return c.value < 0x80
  }

  // MARK: - Escape

  private enum EscapeResult {
    case escaped(UnicodeScalar)
    case escapedNewLine
    case notEscapeCharacter
  }

  private mutating func readEscaped(_ prefix: StringPrefix,
                                    _ quoteType: QuoteType) throws -> EscapeResult {
    assert(self.peek == "\\")

    if prefix.r {
      _ = self.advance() // backslash
      return .escaped("\\")
    }

    guard let escaped = self.peekNext else {
      throw self.createError(quoteType.nilPeekError)
    }

    switch escaped {
    case "\n": // Backslash and newline ignored
      _ = self.advance() // backslash
      _ = self.advance() // new line
      return .escapedNewLine

    case "\\": return self.simpleEscaped("\\") // Backslash (\)
    case "'":  return self.simpleEscaped("'")  // Single quote (')
    case "\"": return self.simpleEscaped("\"") // Double quote (")
    case "n":  return self.simpleEscaped("\n") // ASCII Linefeed (LF)
    case "r":  return self.simpleEscaped("\r") // ASCII Carriage Return (CR)
    case "t":  return self.simpleEscaped("\t") // ASCII Horizontal Tab (TAB)

    /// \ooo Character with octal value ooo
    case let c where OctalNumber.isDigit(c):
      return .escaped(try self.readOctal(quoteType))

    // \xhh Character with hex value hh
    case "x":
      return .escaped(try self.readHex(quoteType, count: 2))

    // \uxxxx Character with 16-bit hex value xxxx
    case "u" where prefix.isString:
      return .escaped(try self.readHex(quoteType, count: 4))

    // \Uxxxxxxxx Character with 32-bit hex value xxxxxxxx
    case "U" where prefix.isString:
      return .escaped(try self.readHex(quoteType, count: 8))

    case "a", // ASCII Bell (BEL)
         "b", // ASCII Backspace (BS)
         "f", // ASCII Formfeed (FF)
         "v", // ASCII Vertical Tab (VT)
         "N": // Character named name in the Unicode database
      throw NotImplemented("\(self.location) String escape \\'\(escaped)' " +
        "is not currently supported.")

    default:
      // TODO: 3.6: Unrecognized escape sequences produce a DeprecationWarning.
      return .notEscapeCharacter // invalid escape -> no escape
    }
  }

  private mutating func simpleEscaped(_ c: UnicodeScalar) -> EscapeResult {
    _ = self.advance() // backslash
    _ = self.advance() // escaped character
    return .escaped(c)
  }

  private mutating func readOctal(_ quoteType: QuoteType) throws -> UnicodeScalar {
    _ = self.advance() // backslash

    let maxCount = 3
    var scalars = [UnicodeScalar]()

    for _ in 0..<maxCount {
      guard let peek = self.peek else {
        throw self.createError(quoteType.nilPeekError)
      }

      guard OctalNumber.isDigit(peek) else {
        break // we can exit before we reach all 3 'o'
      }

      scalars.append(peek)
      _ = self.advance()
    }

    return try self.readScalar(scalars, radix: 8)
  }

  private mutating func readHex(_ quoteType: QuoteType,
                                count: Int) throws -> UnicodeScalar {
    _ = self.advance() // backslash
    _ = self.advance() // xuU

    var scalars = [UnicodeScalar]()

    for _ in 0..<count {
      guard let peek = self.peek else {
        throw self.createError(quoteType.nilPeekError)
      }

      guard HexNumber.isDigit(peek) else {
        throw self.createError(.unicodeEscape)
      }

      scalars.append(peek)
      _ = self.advance()
    }

    return try self.readScalar(scalars, radix: 16)
  }

  private func readScalar(_ scalars: [UnicodeScalar],
                          radix: Int) throws -> UnicodeScalar {

    let s = String(scalars)
    guard let v = UInt32(s, radix: radix) else {
      throw self.createError(.unicodeEscape)
    }

    guard let scalar = UnicodeScalar(v) else {
      throw self.createError(.unicodeEscape)
    }

    return scalar
  }
}

// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Core

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

  fileprivate var nilPeekError: LexerErrorKind {
    switch self {
    case .single: return .unfinishedShortString
    case .triple: return .unfinishedLongString
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

    let scalars = try readString(prefix: prefix, start: start)
    let end = self.location

    if prefix.b {
      // 'self.readString', should find any incorrect input, but just in case:
      var data = Data(capacity: scalars.count)
      for char in scalars {
        if self.isValidByte(char) {
          data.append(UInt8(char.value & 0xff))
        } else {
          // not very precise, 'self.readString' is better
          throw self.error(.badByte(char), start: start)
        }
      }

      return self.token(.bytes(data), start: start, end: end)
    }

    let string = String(scalars)
    let kind: TokenKind = prefix.f ? .formatString(string) : .string(string)
    return self.token(kind, start: start, end: end)
  }

  private mutating func readString(prefix: StringPrefix,
                                   start:  SourceLocation) throws -> [UnicodeScalar] {

    assert(self.peek == "\"" || self.peek == "'")

    guard let quote = self.peek else {
      throw self.error(.eof, start: start)
    }

    var quoteType = QuoteType.single
    var endQuoteCount = 0 // counting quotes to know when to end

    if self.advance() == quote { // 2nd quote
      if self.advance() == quote { // 3rd quote
        self.advance()
        quoteType = .triple // quote -> quote -> quote -> (string)
      } else {
        return [] // quote -> quote -> (whatever)
      }
    }

    // State: self.peek = 1st character of string
    var result = [UnicodeScalar]()
    while endQuoteCount != quoteType.quoteCount {
      guard let peek = self.peek else {
        throw self.error(quoteType.nilPeekError, start: start)
      }

      try self.checkValidByteIfNeeded(prefix, peek)

      switch peek {
      case "\\":
        switch try self.readEscaped(prefix, quoteType, start: start) {
        case .escaped(let char):  result.append(char)
        case .escapedNewLine:     break
        case .notEscapeCharacter: result.append("\\")
        }
      default:
        if quoteType == .single && self.isNewLine(peek) {
          throw self.error(.unfinishedShortString, start: start)
        }

        result.append(peek)
        endQuoteCount = (peek == quote) ? endQuoteCount + 1 : 0
        self.advance()
      }
    }

    let withoutTrailingQuotes = result.dropLast(endQuoteCount)
    return [UnicodeScalar](withoutTrailingQuotes)
  }

  // MARK: - Byte range

  private func checkValidByteIfNeeded(_ prefix: StringPrefix,
                                      _ c: UnicodeScalar) throws {
    if prefix.b && !self.isValidByte(c) {
      throw self.error(.badByte(c))
    }
  }

  /// Basically: 0 <= x < 256
  /// https://docs.python.org/3/library/stdtypes.html#bytes-objects
  private func isValidByte(_ c: UnicodeScalar) -> Bool {
    return c.value < 256
  }

  // MARK: - Escape

  private enum EscapeResult {
    case escaped(UnicodeScalar)
    case escapedNewLine
    case notEscapeCharacter
  }

  private mutating func readEscaped(_ prefix: StringPrefix,
                                    _ quoteType: QuoteType,
                                    start:  SourceLocation) throws -> EscapeResult {
    assert(self.peek == "\\")

    if prefix.r {
      self.advance() // backslash
      return .escaped("\\")
    }

    guard let escaped = self.peekNext else {
      throw self.error(quoteType.nilPeekError, start: start)
    }

    switch escaped {
    case "\n": // Backslash and newline ignored
      self.advance() // backslash
      self.advance() // new line
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
      throw NotImplemented.stringEscape(escaped)

    default:
      self.advance() // backslash
      self.warn(.unrecognizedEscapeSequence)
      return .notEscapeCharacter // invalid escape -> no escape
    }
  }

  private mutating func simpleEscaped(_ c: UnicodeScalar) -> EscapeResult {
    self.advance() // backslash
    self.advance() // escaped character
    return .escaped(c)
  }

  private mutating func readOctal(_ quoteType: QuoteType) throws -> UnicodeScalar {
    let start = self.location
    self.advance() // backslash

    let maxCount = 3
    let startIndex = self.sourceIndex

    for _ in 0..<maxCount {
      guard let peek = self.peek else {
        throw self.error(quoteType.nilPeekError, start: start)
      }

      guard OctalNumber.isDigit(peek) else {
        break // we can exit before we reach all 3 'o'
      }

      self.advance()
    }

    let scalars = self.source[startIndex..<self.sourceIndex]
    return try self.decodeScalar(scalars, radix: 8, start: start)
  }

  private mutating func readHex(_ quoteType: QuoteType,
                                count: Int) throws -> UnicodeScalar {
    let start = self.location

    self.advance() // backslash
    self.advance() // xuU

    let startIndex = self.sourceIndex

    for _ in 0..<count {
      guard let peek = self.peek else {
        throw self.error(quoteType.nilPeekError, start: start)
      }

      guard HexNumber.isDigit(peek) else {
        throw self.error(.unicodeEscape, start: start)
      }

      self.advance()
    }

    let scalars = self.source[startIndex..<self.sourceIndex]
    return try self.decodeScalar(scalars, radix: 16, start: start)
  }

  /// string: '123', radix: 10 -> Unicode character at 123
  private func decodeScalar(_ scalars: UnicodeScalarView.SubSequence,
                            radix:     Int,
                            start:     SourceLocation) throws -> UnicodeScalar {

    let string = String(scalars)
    guard let int = UInt32(string, radix: radix) else {
      throw self.error(.unicodeEscape, start: start)
    }

    guard let result = UnicodeScalar(int) else {
      throw self.error(.unicodeEscape, start: start)
    }

    return result
  }
}

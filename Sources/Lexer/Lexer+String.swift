import Foundation
import VioletCore

// https://docs.python.org/3/reference/lexical_analysis.html#string-and-bytes-literals

// cSpell:ignore uxxxx Uxxxxxxxx

private enum QuoteType {
  case single
  case triple

  fileprivate var quoteCount: Int {
    switch self {
    case .single: return 1
    case .triple: return 3
    }
  }

  fileprivate var nilPeekError: LexerError.Kind {
    switch self {
    case .single: return .unfinishedShortString
    case .triple: return .unfinishedLongString
    }
  }
}

extension Lexer {

  internal func string() throws -> Token {
    let prefix = StringPrefix()
    return try self.string(prefix: prefix, start: self.location)
  }

  internal func string(prefix: StringPrefix, start: SourceLocation) throws -> Token {
    let scalars = try readString(prefix: prefix)
    let end = self.location

    if prefix.b {
      // 'self.readString', should find any incorrect input, but just in case:
      var data = Data(capacity: scalars.count)
      for char in scalars {
        if self.isValidByte(char) {
          data.append(UInt8(char.value & 0xff))
        } else {
          // not very precise, 'self.readString' is better
          throw self.error(.badByte(char), location: start)
        }
      }

      return self.token(.bytes(data), start: start, end: end)
    }

    let string = String(scalars)
    let kind: Token.Kind = prefix.f ? .formatString(string) : .string(string)
    return self.token(kind, start: start, end: end)
  }

  private func readString(prefix: StringPrefix) throws -> [UnicodeScalar] {
    assert(self.peek == "\"" || self.peek == "'")

    guard let quote = self.peek else {
      throw self.error(.unexpectedEOF)
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
        throw self.error(quoteType.nilPeekError)
      }

      try self.checkValidByteIfNeeded(prefix, peek)

      switch peek {
      case "\\":
        switch try self.readEscaped(prefix, quoteType) {
        case .escaped(let char): result.append(char)
        case .escapedNewLine: break
        case .notEscapeCharacter: result.append("\\")
        }
      default:
        if quoteType == .single && self.isNewLine(peek) {
          throw self.error(.unfinishedShortString)
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

  // swiftlint:disable function_body_length
  /// PyObject *
  /// _PyUnicode_DecodeUnicodeEscape(const char *s,
  private func readEscaped(_ prefix: StringPrefix,
                           _ quoteType: QuoteType) throws -> EscapeResult {
    // swiftlint:enable function_body_length

    assert(self.peek == "\\")

    if prefix.r {
      self.advance() // backslash
      return .escaped("\\")
    }

    guard let escaped = self.peekNext else {
      throw self.error(quoteType.nilPeekError)
    }

    switch escaped {
    case "\n": // Backslash and newline ignored
      self.advance() // backslash
      self.advance() // new line
      return .escapedNewLine

    case "\\": return self.simpleEscaped("\\") // Backslash (\)
    case "'": return self.simpleEscaped("'") // Single quote (')
    case "\"": return self.simpleEscaped("\"") // Double quote (")
    case "n": return self.simpleEscaped("\n") // ASCII Linefeed (LF)
    case "r": return self.simpleEscaped("\r") // ASCII Carriage Return (CR)
    case "t": return self.simpleEscaped("\t") // ASCII Horizontal Tab (TAB)

    case "a": return self.simpleEscaped("\u{0007}") // ASCII Bell (BEL)
    case "b": return self.simpleEscaped("\u{0008}") // ASCII Backspace (BS)
    case "f": return self.simpleEscaped("\u{000c}") // ASCII Formfeed (FF)
    case "v": return self.simpleEscaped("\u{000b}") // ASCII Vertical Tab (VT)

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

    case "N": // Character named name in the Unicode database
      throw self.unimplemented(.namedUnicodeEscape)

    default:
      self.advance() // backslash
      self.warn(.unrecognizedEscapeSequence("\\\(escaped)"))
      return .notEscapeCharacter // invalid escape -> no escape
    }
  }

  private func simpleEscaped(_ c: UnicodeScalar) -> EscapeResult {
    self.advance() // backslash
    self.advance() // escaped character
    return .escaped(c)
  }

  private func readOctal(_ quoteType: QuoteType) throws -> UnicodeScalar {
    let start = self.location
    self.advance() // backslash

    let maxCount = 3
    let startIndex = self.sourceIndex

    for _ in 0..<maxCount {
      guard let peek = self.peek else {
        throw self.error(quoteType.nilPeekError)
      }

      guard OctalNumber.isDigit(peek) else {
        break // we can exit before we reach all 3 'o'
      }

      self.advance()
    }

    let scalars = self.source[startIndex..<self.sourceIndex]
    return try self.decodeScalar(scalars, radix: 8, start: start)
  }

  private func readHex(_ quoteType: QuoteType, count: Int) throws -> UnicodeScalar {
    let start = self.location
    self.advance() // backslash
    self.advance() // xuU

    let startIndex = self.sourceIndex

    for _ in 0..<count {
      guard let peek = self.peek else {
        throw self.error(quoteType.nilPeekError)
      }

      guard HexNumber.isDigit(peek) else {
        throw self.error(.invalidUnicodeEscape)
      }

      self.advance()
    }

    let scalars = self.source[startIndex..<self.sourceIndex]
    return try self.decodeScalar(scalars, radix: 16, start: start)
  }

  /// string: '123', radix: 10 -> Unicode character at 123
  private func decodeScalar(_ scalars: UnicodeScalarView.SubSequence,
                            radix: Int,
                            start: SourceLocation) throws -> UnicodeScalar {

    let string = String(scalars)
    guard let int = UInt32(string, radix: radix) else {
      throw self.error(.invalidUnicodeEscape, location: start)
    }

    guard let result = UnicodeScalar(int) else {
      throw self.error(.invalidUnicodeEscape, location: start)
    }

    return result
  }
}

// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

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

    let start = self.location
    let scalars = try readString(prefix: prefix)
    let end = self.location

    if prefix.b {
      // 'self.readString', should find any incorrect input, but just in case:
      var data = Data(capacity: scalars.count)
      for c in scalars {
        if c.value >= 0x80 {
          // not very precise, 'self.readString' is better
          throw self.createError(.badByte, location: start)
        } else {
          data.append(UInt8(c.value & 0xff))
        }
      }

      return Token(.bytes(data), start: start, end: end)
    }

    let string = String(String.UnicodeScalarView(scalars))
    let kind: TokenKind = prefix.f ? .formatString(string) : .string(string)
    return Token(kind, start: start, end: end)
  }

  // swiftlint:disable:next function_body_length cyclomatic_complexity
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

    // State: self.peek = 1st string character
    var result = [UnicodeScalar]()
    while endQuoteCount != quoteType.quoteCount {
      // TODO: move to readCharacter(xxx)
      guard let peek = self.peek else {
        throw self.createError(quoteType.nilPeekError)
      }

      switch peek {
      case "\\":
        if prefix.r {
          result.append("\\")
        } else {
          switch try self.readEscaped(prefix: prefix, quoteType: quoteType) {
          case .escaped(let char):  result.append(char)
          case .escapedNewLine:     break
          case .notEscapeCharacter: result.append("\\")
          }
        }
      default:
        result.append(peek)
        endQuoteCount = (peek == quote) ? endQuoteCount + 1 : 0

        if quoteType == .single && peek == "\n" {
          throw self.createError(.eols)
        }
      }

      if prefix.b && !peek.isASCII {
        throw self.createError(.badByte)
      }

      _ = self.advance()
    }

    let noTrailingQuotes = result[0..<(result.count - endQuoteCount)]
    return [UnicodeScalar](noTrailingQuotes)
  }

  private enum EscapeResult {
    case escaped(UnicodeScalar)
    case escapedNewLine
    case notEscapeCharacter
  }

  private mutating func readEscaped(prefix: StringPrefix,
                                    quoteType: QuoteType) throws -> EscapeResult {

    assert(self.peek == "\\")
    guard let escaped = self.peekNext else {
      throw self.createError(quoteType.nilPeekError)
    }

    switch escaped {
    case "\n": _ = self.advance(); return .escapedNewLine // Backslash and newline ignored
    case "\\": _ = self.advance(); return .escaped("\\")  // Backslash (\)
    case "'":  _ = self.advance(); return .escaped("'")   // Single quote (')
    case "\"": _ = self.advance(); return .escaped("\"")   // Double quote (")
//    case "a": not implemented // ASCII Bell (BEL)
//    case "b": not implemented // ASCII Backspace (BS)
//    case "f": not implemented // ASCII Formfeed (FF)
    case "n": _ = self.advance(); return .escaped("\n") // ASCII Linefeed (LF)
    case "r": _ = self.advance(); return .escaped("\r") // ASCII Carriage Return (CR)
    case "t": _ = self.advance(); return .escaped("\t") // ASCII Horizontal Tab (TAB)
//    case "v": not implemented // ASCII Vertical Tab (VT)

//    \ooo Character with octal value ooo
//    \xhh Character with hex value hh

//    \uxxxx     Character with 16-bit hex value xxxx
//    \Uxxxxxxxx Character with 32-bit hex value xxxxxxxx

    default: return .notEscapeCharacter // invalid escape -> no escape
    }
  }
}

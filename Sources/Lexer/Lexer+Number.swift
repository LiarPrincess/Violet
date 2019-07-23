// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Core

// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
// https://github.molgen.mpg.de/git-mirror/glibc/blob/master/stdlib/strtod_l.c

extension Lexer {

  internal func isDecimalDigit(_ c: Character) -> Bool {
    return DecimalNumber.isDigit(c)
  }

  internal mutating func number() throws -> Token {
    assert(self.peek != nil)
    assert(DecimalNumber.isDigit(self.peek ?? " ") || self.peek == ".")

    let start = self.location

    if self.peek == "0" {
      switch self.peekNext {
      case "B", "b":
        self.advance() // 0
        self.advance() // Bb
        return try self.integer(start, base: BinaryNumber.self)
      case "O", "o":
        self.advance() // 0
        self.advance() // Oo
        return try self.integer(start, base: OctalNumber.self)
      case "X", "x":
        self.advance() // 0
        self.advance() // Xx
        return try self.integer(start, base: HexNumber.self)
      default:
        return try self.decimalIntegerOrFloat(start)
      }
    }

    return try self.decimalIntegerOrFloat(start)
  }

  private mutating func integer<T: NumberBase>(_ start: SourceLocation,
                                               base: T.Type) throws -> Token {
    let startIndex = self.sourceIndex
    repeat {
      if self.peek == "_" {
        self.advance()
      }

      // we need to have digit after underscore
      guard let digitPeek = self.peek else {
        throw self.error(.danglingIntegerUnderscore)
      }

      guard base.isDigit(digitPeek) else {
        throw self.error(.invalidIntegerDigit(base.type, digitPeek))
      }

      while let digit = self.peek, base.isDigit(digit) {
        self.advance()
      }
    } while self.peek == "_"

    let string = self.source[startIndex..<self.sourceIndex]
    let value = try self.parseInt(string, start: start, base: base)
    return self.token(.int(value), start: start)
  }

  private mutating func decimalIntegerOrFloat(_ start: SourceLocation) throws -> Token {
    // it can't be nil, otherwise we would never call self.number().
    guard let first = self.peek else { throw self.error(.eof) }

    let startIndex = self.sourceIndex

    if DecimalNumber.isDigit(first) {
      try self.advanceDecimals()
    }
    let integerEnd = self.sourceIndex

    if self.peek == "." {
      self.advance() // .
      try self.advanceDecimals()
    }

    if self.peek == "E" || self.peek == "e" {
      self.advance() // Ee

      if let sign = self.peek, sign == "+" || sign == "-" {
        self.advance() // +-
      }

      try self.advanceDecimals()
    }

    let string = self.source[startIndex..<self.sourceIndex]

    if self.peek == "J" || self.peek == "j" {
      self.advance() // Jj
      let value = try self.parseDouble(string, start: start)
      return self.token(.imaginary(value), start: start)
    }

    let isInteger = self.sourceIndex == integerEnd
    if isInteger {
      let value = try self.parseInt(string, start: start, base: DecimalNumber.self)
      return self.token(.int(value), start: start)
    }

    let value = try self.parseDouble(string, start: start)
    return self.token(.float(value), start: start)
  }

  private mutating func advanceDecimals() throws {
    let type = DecimalNumber.self

    guard let first = self.peek, type.isDigit(first) else {
      return // just point, no fraction
    }

    while true {
      while let digit = self.peek, type.isDigit(digit) {
        self.advance()
      }

      // if '_' then continue else break
      guard let underscore = self.peek, underscore == "_" else {
        break
      }

      // if we have more, then it must be an digit
      if let digit = self.advance(), !type.isDigit(digit) {
        throw self.error(.invalidDecimalDigit(digit))
      }
    }
  }

  // MARK: - Parse

  private func parseInt<T: NumberBase>(_ string: Substring,
                                       start: SourceLocation,
                                       base: T.Type) throws -> PyInt {

    let s = string.replacingOccurrences(of: "_", with: "")
    guard let value = PyInt(s, radix: base.radix) else {
      // After we add proper ints:
      // let kind = LexerErrorKind.unableToParseInteger(base.type, string)
      // throw self.error(kind, start: start)
      throw NotImplemented.unlimitedInteger
    }

    return value
  }

  private func parseDouble(_ string: Substring,
                           start: SourceLocation) throws -> Double {

    let s = string.replacingOccurrences(of: "_", with: "")
    guard let value = Double(s) else {
      throw self.error(.unableToParseDecimal(String(string)), start: start)
    }

    return value
  }
}

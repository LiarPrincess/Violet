// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Core

// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
// https://github.molgen.mpg.de/git-mirror/glibc/blob/master/stdlib/strtod_l.c

extension Lexer {

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
    var string = ""
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
        string.append(digit)
        self.advance()
      }
    } while self.peek == "_"

    let value = try self.parseInt(string, start: start, base: base)
    return self.token(.int(value), start: start)
  }

  // swiftlint:disable:next function_body_length
  private mutating func decimalIntegerOrFloat(_ start: SourceLocation) throws -> Token {
    // it can't be nil, otherwise we would never call self.number().
    guard let first = self.peek else { throw self.error(.eof) }

    var string = ""

    if DecimalNumber.isDigit(first) {
      try self.collectDecimals(into: &string)
    }
    let integerString = string // so we know if we have int or float

    if self.peek == "." {
      self.advance() // .
      string.append(".")
      try self.collectDecimals(into: &string)
    }

    if self.peek == "E" || self.peek == "e" {
      self.advance() // Ee
      string.append("e")

      if let sign = self.peek, sign == "+" || sign == "-" {
        self.advance() // +-
        string.append(sign)
      }

      try self.collectDecimals(into: &string)
    }

    if self.peek == "J" || self.peek == "j" {
      self.advance() // Jj
      let value = try self.parseDouble(string, start: start)
      return self.token(.imaginary(value), start: start)
    }

    let isInteger = string == integerString
    if isInteger {
      let value = try self.parseInt(string, start: start, base: DecimalNumber.self)
      return self.token(.int(value), start: start)
    }

    let value = try self.parseDouble(string, start: start)
    return self.token(.float(value), start: start)
  }

  private mutating func collectDecimals(into string: inout String) throws {
    let type = DecimalNumber.self

    guard let first = self.peek, type.isDigit(first) else {
      return // just point, no fraction
    }

    while true {
      while let digit = self.peek, type.isDigit(digit) {
        string.append(digit)
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

  private func parseInt<T: NumberBase>(_ string: String,
                                       start: SourceLocation,
                                       base: T.Type) throws -> PyInt {

    guard let value = PyInt(string, radix: base.radix) else {
      // After we add proper ints:
      // let kind = LexerErrorKind.unableToParseInteger(base.type, string)
      // throw self.error(kind, start: start)
      throw NotImplemented.unlimitedInteger
    }

    return value
  }

  private func parseDouble(_ string: String,
                           start: SourceLocation) throws -> Double {

    guard let value = Double(string) else {
      throw self.error(.unableToParseDecimal(string), start: start)
    }

    return value
  }
}

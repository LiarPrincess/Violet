// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

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
        _ = self.advance() // 0
        _ = self.advance() // Bb
        return try self.integer(start, type: BinaryNumber.self)
      case "O", "o":
        _ = self.advance() // 0
        _ = self.advance() // Oo
        return try self.integer(start, type: OctalNumber.self)
      case "X", "x":
        _ = self.advance() // 0
        _ = self.advance() // Xx
        return try self.integer(start, type: HexNumber.self)
      default:
        return try self.decimalIntegerOrFloat(start)
      }
    }

    return try self.decimalIntegerOrFloat(start)
  }

  private mutating func integer<T: NumberType>(_ start: SourceLocation,
                                               type: T.Type) throws -> Token {
    var scalars = [UnicodeScalar]()
    repeat {
      if self.peek == "_" {
        _ = self.advance()
      }

      // we need to have digit after underscore
      guard let digitPeek = self.peek else {
        // TODO: separate error with associated value
        // TODO: rename createError to error
        throw self.createError(.syntax(message: "Invalid \(type.name) literal.")) // integerDanglingUnderscore
      }

      guard type.isDigit(digitPeek) else {
        let message = "Invalid digit '\(digitPeek)' in \(type.name) literal."
        throw self.createError(.syntax(message: message))
      }

      while let digit = self.peek, type.isDigit(digit) {
        scalars.append(digit)
        _ = self.advance()
      }
    } while self.peek == "_"

    let value = try self.parseInt(scalars, type: type)
    return Token(.int(value), start: start, end: self.location)
  }

  // swiftlint:disable:next function_body_length
  private mutating func decimalIntegerOrFloat(_ start: SourceLocation) throws -> Token {
    // it can't be nil, otherwise we would never call self.number().
    guard let first = self.peek else { throw self.createError(.eof) }

    var scalars = [UnicodeScalar]()

    if DecimalNumber.isDigit(first) {
      try self.collectDecimals(into: &scalars)
    }
    let integerCount = scalars.count // so we know if we have int or float

    if self.peek == "." {
      _ = self.advance() // .
      scalars.append(".")
      try self.collectDecimals(into: &scalars)
    }

    if self.peek == "E" || self.peek == "e" {
      _ = self.advance() // Ee
      scalars.append("e")

      if let sign = self.peek, sign == "+" || sign == "-" {
        _ = self.advance() // +-
        scalars.append(sign)
      }

      try self.collectDecimals(into: &scalars)
    }

    if self.peek == "J" || self.peek == "j" {
      _ = self.advance() // Jj
      let value = try self.parseDouble(scalars)
      return Token(.imaginary(value), start: start, end: self.location)
    }

    let isInteger = scalars.count == integerCount
    if isInteger {
      let value = try self.parseInt(scalars, type: DecimalNumber.self)
      return Token(.int(value), start: start, end: self.location)
    }

    let value = try self.parseDouble(scalars)
    return Token(.float(value), start: start, end: self.location)
  }

  private mutating func collectDecimals(into scalars: inout [UnicodeScalar]) throws {
    let type = DecimalNumber.self

    guard let first = self.peek, type.isDigit(first) else {
      return // just point, no fraction
    }

    while true {
      while let digit = self.peek, type.isDigit(digit) {
        scalars.append(digit)
        _ = self.advance()
      }

      // if '_' then continue else break
      guard let underscore = self.peek, underscore == "_" else {
        break
      }

      // if we have more, then it must be an digit
      if let digit = self.advance(), !type.isDigit(digit) {
        throw self.createError(.syntax(message: "Invalid decimal literal"))
      }
    }
  }

  // MARK: - Parse

  private func parseInt<T: NumberType>(_ scalars: [UnicodeScalar],
                                       type: T.Type) throws -> PyInt {
    let string = String(scalars)

    guard let value = PyInt(string, radix: Int(type.radix)) else {
      let message = "Invalid \(type.name) integer value. Integers outside of " +
      "<-\(PyInt.max), \(PyInt.max)> range are not supported."

      throw self.createError(.syntax(message: message))
    }

    return value
  }

  private func parseDouble(_ scalars: [UnicodeScalar]) throws -> Double {
    let string = String(scalars)

    guard let value = Double(string) else {
      throw self.createError(.syntax(message: "Invalid decimal value."))
    }

    return value
  }
}

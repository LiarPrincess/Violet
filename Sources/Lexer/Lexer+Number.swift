import VioletCore

// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
// https://github.molgen.mpg.de/git-mirror/glibc/blob/master/stdlib/strtod_l.c

extension Lexer {

  internal func isDecimalDigit(_ c: UnicodeScalar) -> Bool {
    return DecimalNumber.isDigit(c)
  }

  internal func number() throws -> Token {
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

  private func integer<T: NumberBase>(_ start: SourceLocation,
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
    let value = try self.parseInt(string, base: base, start: start)
    return self.token(.int(value), start: start)
  }

  private func decimalIntegerOrFloat(_ start: SourceLocation) throws -> Token {
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
      let base = DecimalNumber.self
      let value = try self.parseInt(string, base: base, start: start)
      return self.token(.int(value), start: start)
    }

    let value = try self.parseDouble(string, start: start)
    return self.token(.float(value), start: start)
  }

  private func advanceDecimals() throws {
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

  private func parseInt<T: NumberBase>(_ scalars: UnicodeScalarView.SubSequence,
                                       base: T.Type,
                                       start: SourceLocation) throws -> BigInt {

    let string = self.toNumberString(scalars)
    guard let value = BigInt(string, radix: base.radix) else {
      // After we add proper ints:
      // let kind = LexerErrorKind.unableToParseInteger(base.type, string)
      // throw self.error(kind, location: start)
      throw self.unimplmented(.unlimitedInteger(valueToParse: string))
    }

    return value
  }

  private func parseDouble(_ scalars: UnicodeScalarView.SubSequence,
                           start: SourceLocation) throws -> Double {

    let string = self.toNumberString(scalars)
    guard let value = Double(string) else {
      throw self.error(.unableToParseDecimal(string), location: start)
    }

    return value
  }

  private func toNumberString(_ scalars: UnicodeScalarView.SubSequence) -> String {
    // Not really sure if 'scalars.filter' should return
    // 'UnicodeScalarView.SubSequence', it seems weird...
    return String(scalars.filter { $0 != "_" }) // smol me maybe
  }
}

import BigInt
import VioletCore

// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
// https://github.molgen.mpg.de/git-mirror/glibc/blob/master/stdlib/strtod_l.c

// cSpell:ignore asciia asciiz

// Tip: use 'man ascii':
private let asciia: UInt32 = 0x61, asciiz: UInt32 = 0x7a
private let asciiA: UInt32 = 0x41, asciiZ: UInt32 = 0x5a
private let ascii0: UInt32 = 0x30, ascii9: UInt32 = 0x39
private let asciiUnderscore: UInt32 = 0x5f

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
      case "B",
           "b":
        return try self.integerWithBase(start: start, base: BinaryNumber.self)
      case "O",
           "o":
        return try self.integerWithBase(start: start, base: OctalNumber.self)
      case "X",
           "x":
        return try self.integerWithBase(start: start, base: HexNumber.self)
      default:
        break
      }
    }

    return try self.decimalIntegerOrFloat(start: start)
  }

  // MARK: - Integer with base

  private func integerWithBase<T: NumberBase>(
    start: SourceLocation,
    base: T.Type
  ) throws -> Token {
    assert(self.peek == "0")
    assert(self.isBbOoXx(scalar: self.peekNext))

    let startIndex = self.sourceIndex
    self.advance() // 0
    self.advance() // BbOoXx

    // 'self.parseInt' will actually validate if this digit/letter
    // is valid for given 'base'
    self.advanceWhileDigitLetterOrUnderscore()

    let scalars = self.source[startIndex..<self.sourceIndex]
    let value = try self.parseInt(scalars: scalars, base: base, start: start)
    return self.token(.int(value), start: start)
  }

  private func isBbOoXx(scalar: UnicodeScalar?) -> Bool {
    // We actually do not need this guard (compare with 'nil' is always 'false'),
    // but it is more readable this way.
    guard let s = scalar else {
      return false
    }

    return s == "B" || s == "b"
        || s == "O" || s == "o"
        || s == "X" || s == "x"
  }

  /// Acceptable values:
  /// - ascii numbers
  /// - ascii lowercase letters (a - z)
  /// - ascii uppercase letters (A - Z)
  /// - underscore
  private func advanceWhileDigitLetterOrUnderscore() {
    func isValid(scalar: UnicodeScalar) -> Bool {
      let value = scalar.value
      return (ascii0 <= value && value <= ascii9)
          || (asciia <= value && value <= asciiz)
          || (asciiA <= value && value <= asciiZ)
          || value == asciiUnderscore
    }

    while let p = self.peek, isValid(scalar: p) {
      self.advance()
    }
  }

  // MARK: - Decimal integer or float

  private func decimalIntegerOrFloat(start: SourceLocation) throws -> Token {
    // It can't be 'nil', otherwise we would never call 'self.number()'.
    guard let first = self.peek else { throw self.error(.unexpectedEOF) }

    let startIndex = self.sourceIndex

    if DecimalNumber.isDigit(first) {
      self.advanceWhileDigitOrUnderscore()
    }
    let integerEndIndex = self.sourceIndex

    if self.peek == "." {
      self.advance() // .
      self.advanceWhileDigitOrUnderscore()
    }

    if self.peek == "E" || self.peek == "e" {
      self.advance() // Ee

      if let sign = self.peek, sign == "+" || sign == "-" {
        self.advance() // +-
      }

      self.advanceWhileDigitOrUnderscore()
    }

    let scalars = self.source[startIndex..<self.sourceIndex]

    if self.peek == "J" || self.peek == "j" {
      self.advance() // Jj
      let value = try self.parseDouble(scalars: scalars, start: start)
      return self.token(.imaginary(value), start: start)
    }

    let isInteger = self.sourceIndex == integerEndIndex
    if isInteger {
      let base = DecimalNumber.self
      let value = try self.parseInt(scalars: scalars, base: base, start: start)
      return self.token(.int(value), start: start)
    }

    let value = try self.parseDouble(scalars: scalars, start: start)
    return self.token(.float(value), start: start)
  }

  /// Acceptable values:
  /// - ascii numbers
  /// - underscore
  private func advanceWhileDigitOrUnderscore() {
    func isValid(scalar: UnicodeScalar) -> Bool {
      let value = scalar.value
      return (ascii0 <= value && value <= ascii9) || value == asciiUnderscore
    }

    while let p = self.peek, isValid(scalar: p) {
      self.advance()
    }
  }

  // MARK: - Parse

  private func parseInt<T: NumberBase>(
    scalars: UnicodeScalarView.SubSequence,
    base: T.Type,
    start: SourceLocation
  ) throws -> BigInt {
    do {
      return try BigInt(parseUsingPythonRules: scalars, base: base.radix)
    } catch let error as BigInt.PythonParsingError {
      let string = String(scalars)
      throw self.error(.unableToParseInt(string, base.type, error), location: start)
    }
  }

  private func parseDouble(scalars: UnicodeScalarView.SubSequence,
                           start: SourceLocation) throws -> Double {
    guard let value = Double(parseUsingPythonRules: scalars) else {
      let string = String(scalars)
      throw self.error(.unableToParseFloat(string), location: start)
    }

    return value
  }
}

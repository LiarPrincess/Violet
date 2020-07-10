// In CPython:
// Objects -> longobject.c
//
// In Swift:
// Repo root -> stdlib -> public -> core -> IntegerParsing.swift

// swiftlint:disable file_length

// TODO: [BigInt] Add 'PythonParse'
/*
extension BigInt {

  // MARK: - Inits

  /// This implements `Python` parsing rules, not `Swift`!
  public init?(
    parseUsingPythonRules string: String,
    radix: Int = 10
  ) {
    self.init(parseUsingPythonRules: string.unicodeScalars, radix: radix)
  }

  /// This implements `Python` parsing rules, not `Swift`!
  public init?(
    parseUsingPythonRules scalars: String.UnicodeScalarView,
    radix: Int = 10
  ) {
    let sub = scalars[scalars.startIndex...]
    self.init(parseUsingPythonRules: sub, radix: radix)
  }

  /// This implements `Python` parsing rules, not `Swift`!
  public init?(
    parseUsingPythonRules scalars: String.UnicodeScalarView.SubSequence,
    radix: Int = 10
  ) {
    guard let value = BigInt.parse(scalars: scalars, radix: radix) else {
      return nil
    }
    self.value = value
  }

  // MARK: - Scalars

  // 'String.UnicodeScalarView' and 'String.UnicodeScalarView.SubSequence'
  // do not share common protocol (that we would be interested in).
  // But we can easly convert 'UnicodeScalarView' to 'UnicodeScalarView.SubSequence'
  // by using 'scalars[scalars.startIndex...]', so we will use this as our common
  // ground.
  private typealias Scalars = String.UnicodeScalarView.SubSequence

  private struct ScalarsIter {

    private let scalars: Scalars
    private var index: Scalars.Index

    fileprivate init(scalars: Scalars) {
      self.scalars = scalars
      self.index = scalars.startIndex
    }

    fileprivate var isAtEnd: Bool {
      return self.index == self.scalars.endIndex
    }

    fileprivate var peek: UnicodeScalar? {
      return self.isAtEnd ? nil : self.scalars[self.index]
    }

    fileprivate var peekNext: UnicodeScalar? {
      if self.isAtEnd {
        return nil
      }

      let nextIndex = self.scalars.index(after: self.index)
      return nextIndex == self.scalars.endIndex ? nil : self.scalars[nextIndex]
    }

    fileprivate mutating func advance() {
      assert(!self.isAtEnd)
      self.scalars.formIndex(after: &self.index)
    }
  }

  // MARK: - Parser

  // CPython:
  // PyObject *
  // PyLong_FromString(const char *str, char **pend, int base)
  private static func parse(scalars: Scalars, radix: Int = 10) -> Storage? {
    guard (radix == 0 || radix >= 2) && radix <= 36 else {
      return nil
    }

    let trimmed = Self.trim(scalars: scalars)
    var iter = ScalarsIter(scalars: trimmed)

    guard let sign = Self.parseSign(iter: &iter) else {
      return nil
    }

    let base: Int
    let errorIfNonzero: Bool
    switch Self.parseBase(iter: &iter, radix: radix) {
    case .none:
      return nil
    case let .value(base: b, errorIfNonzero: e):
      base = b
      errorIfNonzero = e
    }

    // '0[xXoObB]' thingie
    Self.consumePrefixIfEqualToBase(iter: &iter, base: base)

    // Well, after all of that nonsense we can start parsing actual number
    // (which may not start with underscores).
    if iter.peek == "_" {
      return nil
    }

    // CPython does here an interesting check for binary base: 'base & (base - 1)'.
    // That allows them to use 'shift' instead of 'mul' (which is faster on most
    // architectures). We are not that fancy.

    guard let value = Self.parseNumber(iter: &iter,
                                       base: Storage(base),
                                       isPositive: sign.isPositive) else {
      return nil
    }

    if errorIfNonzero && value != 0 {
      return nil
    }

    return value
  }

  // MARK: - Trim

  /// Well... Python calls this operation `strip`. They are wrong....
  private static func trim(scalars: Scalars) -> Scalars {
    func isWhitespace(scalar: UnicodeScalar) -> Bool {
      return scalar.properties.isWhitespace
    }

    return scalars
      .drop(while: isWhitespace(scalar:))
      .dropLast(while: isWhitespace(scalar:))
  }

  // MARK: - Sign

  /// Swift will use `Bool` storage (`Int1`) for this.
  private enum Sign {
    case positive
    case negative

    fileprivate var isPositive: Bool {
      switch self {
      case .positive: return true
      case .negative: return false
      }
    }
  }

  private static func parseSign(iter: inout ScalarsIter) -> Sign? {
    guard let first = iter.peek else {
      return nil // >>> int('') -> ValueError
    }

    if first == "+" {
      iter.advance() // +
      return .positive
    }

    if first == "-" {
      iter.advance() // -
      return .negative
    }

    return .positive
  }

  // MARK: - Base

  private enum ParseBase {
    case none
    case value(base: Int, errorIfNonzero: Bool)

    fileprivate static func value(base: Int) -> ParseBase {
      return .value(base: base, errorIfNonzero: false)
    }
  }

  private static func parseBase(iter: inout ScalarsIter, radix: Int) -> ParseBase {
    assert(radix == 0 || radix >= 2)
    assert(radix <= 36)

    // When 'radix == 0' then get base from prefix, otherwise 'radix'
    guard radix == 0 else {
      return .value(base: radix)
    }

    // We are only interested in strings with '0[xXoObB]' prefix
    guard let first = iter.peek else {
      return .none // >>> int('', 2) -> ValueError
    }

    guard first == "0" else {
      return .value(base: 10)
    }

    guard let second = iter.peekNext else {
      // "old" (C-style) octal literal,
      // now invalid. it might still be zero though
      return .value(base: 10, errorIfNonzero: true)
    }

    switch second {
    case "b", "B": return .value(base: 2)
    case "o", "O": return .value(base: 8)
    case "x", "X": return .value(base: 16)
    default: return .value(base: 10)
    }
  }

  // MARK: - Prefix

  /// Prefix means '0[xXoObB]' + optional '_'
  private static func consumePrefixIfEqualToBase(iter: inout ScalarsIter,
                                                 base: Int) {
    guard let first = iter.peek, let second = iter.peekNext else {
      return
    }

    guard first == "0" else {
      return
    }

    let isBinary = base == 2 && (second == "b" || second == "B")
    let isOctal = base == 8 && (second == "o" || second == "O")
    let isHex = base == 16 && (second == "x" || second == "X")

    guard isBinary || isOctal || isHex else {
      return
    }

    iter.advance() // 0
    iter.advance() // xXoObB

    if iter.peek == "_" {
      iter.advance() // _
    }
  }

  // MARK: - Number

  private static func parseNumber(iter: inout ScalarsIter,
                                  base: Storage,
                                  isPositive: Bool) -> Storage? {
    // Most of our code comes from 'IntegerParsing.swift'
    // (see note at the top of this file).
    // We need to know if number is positive or negative because technically
    // negative numbers have bigger range.

    var result = Storage(0)
    var scalar = iter.peek
    var isPreviousUnderscore = false

    while let s = scalar {
      let isUnderscore = s == "_"
      let isLast = iter.peekNext == nil

      func advanceToNextScalar() {
        isPreviousUnderscore = isUnderscore
        iter.advance()
        scalar = iter.peek
      }

      if isUnderscore && isPreviousUnderscore {
        return nil // Only one underscore allowed
      }

      if isUnderscore && isLast {
        return nil // Trailing underscore not allowed
      }

      if isUnderscore {
        advanceToNextScalar()
        continue
      }

      guard let digit = Self.parseDigit(scalar: s), digit < base else {
        return nil
      }

      let (result1, overflow1) = result.multipliedReportingOverflow(by: base)
      let (result2, overflow2) = isPositive ?
        result1.addingReportingOverflow(digit) :
        result1.subtractingReportingOverflow(digit)

      if overflow1 || overflow2 {
        return nil
      }

      result = result2
      advanceToNextScalar()
    }

    return result
  }

  private static func parseDigit(scalar: UnicodeScalar) -> Storage? {
    guard let int = scalar.asDigit else {
      return nil
    }

    return Storage(exactly: int)
  }
}
*/

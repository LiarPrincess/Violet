// In CPython:
// Objects -> longobject.c // cSpell:disable-line

extension BigInt {

  private typealias Scalars = String.UnicodeScalarView.SubSequence

  // MARK: - Parsing error

  public enum PythonParsingError: Error, Equatable, CustomStringConvertible {
    /// Str is empty
    case emptyString

    /// Base should be 0 or in 2...36 range
    case invalidBase
    /// Str does not contain base (only if `base` argument was `0`)
    case missingBase

    /// String starts with `_`
    case underscorePrefix
    /// String has `_` just after sign
    case underscoreAfterSign
    /// Only a single underscore is acceptable after base
    case multipleUnderscoresAfterBase
    /// String contains `__`
    case doubleUnderscore
    /// String ends with `_`
    case underscoreSuffix

    /// String is not empty, but does not contain any digit (for example `+`)
    case signWithoutDigits
    /// String is not empty, but does not contain any digit (for example `0x`)
    case baseWithoutDigits
    /// '\(scalar)' is not a valid digit for given base
    case notDigit(scalar: UnicodeScalar, base: Int)

    /// Octal numbers with `0` prefix (for example `0123`) are not allowed
    case octalNonZero

    public var description: String {
      switch self {
      case .emptyString:
        return "Empty str is not allowed"

      case .invalidBase:
        return "Base should be 0 or in 2...36 range"
      case .missingBase:
        return "Str does not contain base"

      case .underscorePrefix:
        return "Underscore prefix is not allowed"
      case .underscoreAfterSign:
        return "Underscore just after sign is not allowed"
      case .multipleUnderscoresAfterBase:
        return "Only a single underscore is acceptable after base"
      case .doubleUnderscore:
        return "Multiple underscores in a row are not allowed"
      case .underscoreSuffix:
        return "Underscore suffix is not allowed"

      case .signWithoutDigits:
        return "Expected digits after sign"
      case .baseWithoutDigits:
        return "Expected digits after base"
      case let .notDigit(scalar, base):
        let codePoint = scalar.codePointNotation
        let char = "'\(scalar)' (unicode: \(codePoint))"
        return "\(char) is not a valid digit for given base (\(base))"

      case .octalNonZero:
        return "Octal numbers with '0' prefix (for example '0123') are not allowed"
      }
    }
  }

  // MARK: - BigInt.init

  // 'String.UnicodeScalarView' and 'String.UnicodeScalarView.SubSequence'
  // do not share common protocol (that we would be interested in).
  // But we can easily convert 'UnicodeScalarView' to 'UnicodeScalarView.SubSequence'
  // by using 'scalars[...]', so we will use this as our common ground.

  /// This implements `Python` parsing rules, not `Swift`!
  public init(
    parseUsingPythonRules string: String,
    base: Int = 10
  ) throws {
    try self.init(parseUsingPythonRules: string.unicodeScalars, base: base)
  }

  /// This implements `Python` parsing rules, not `Swift`!
  public init(
    parseUsingPythonRules scalars: String.UnicodeScalarView,
    base: Int = 10
  ) throws {
    let substring = scalars[...]
    try self.init(parseUsingPythonRules: substring, base: base)
  }

// swiftlint:disable function_body_length

  /// This implements `Python` parsing rules, not `Swift`!
  ///
  /// PyObject *
  /// PyLong_FromString(const char *str, char **pend, int base)
  public init(
    parseUsingPythonRules scalars: String.UnicodeScalarView.SubSequence,
    base _base: Int = 10
  ) throws {
// swiftlint:enable function_body_length

    guard _base == 0 || (2 <= _base && _base <= 36) else {
      throw PythonParsingError.invalidBase
    }

    var scalars = Self.trim(scalars: scalars)

    if scalars.isEmpty {
      throw PythonParsingError.emptyString // >>> int('') -> ValueError
    }

    let sign: ParsedSign
    switch Self.parseSign(advancingIfFound: &scalars) {
    case .emptyString:
      throw PythonParsingError.emptyString
    case .sign(let s):
      sign = s
    }

    let parsedBase = try Self.parseBaseFromStringIfBaseIsZero(scalars: scalars,
                                                              base: _base)
    let base = parsedBase.base
    let octalErrorIfNonZero = parsedBase.octalErrorIfNonZero

    // '0[xXoObB]' thingie + single optional '_'
    let hadBasePrefix = Self.consumeBasePrefixIfEqualToBase(scalars: &scalars,
                                                            base: base)

    // Well, after all of that nonsense we can start parsing actual number
    // (which may not start with underscore).
    guard let firstDigit = scalars.first else {
      if hadBasePrefix { throw PythonParsingError.baseWithoutDigits }

      // We already checked for empty, so the only remaining possibility is:
      throw PythonParsingError.signWithoutDigits
    }

    if firstDigit == "_" {
      if hadBasePrefix { throw PythonParsingError.multipleUnderscoresAfterBase }
      if sign.wasExplicitlyProvided { throw PythonParsingError.underscoreAfterSign }
      throw PythonParsingError.underscorePrefix
    }

    // CPython does here an interesting check for binary base: 'base & (base - 1)'.
    // That allows them to use 'shift' instead of 'mul' (which is faster on most
    // architectures). We are not that fancy.

     switch Self.parseMagnitude(scalars: scalars, radix: base, sign: sign) {
     case .value(let value):
       self = value
     case .doubleUnderscore:
       throw PythonParsingError.doubleUnderscore
     case .underscoreSuffix:
       throw PythonParsingError.underscoreSuffix
     case .notDigit(let s):
       throw PythonParsingError.notDigit(scalar: s, base: base)
     }

    if octalErrorIfNonZero && !self.isZero {
      throw PythonParsingError.octalNonZero
    }
  }

  // MARK: - Trim

  /// Well… Python calls this operation `strip`. They are wrong….
  private static func trim(scalars: Scalars) -> Scalars {
    func isWhitespace(scalar: UnicodeScalar) -> Bool {
      return scalar.properties.isWhitespace
    }

    return scalars
      .drop(while: isWhitespace(scalar:))
      .dropLast(while: isWhitespace(scalar:))
  }

  // MARK: - Base

  private struct PythonBase {

    fileprivate let base: Int
    fileprivate let octalErrorIfNonZero: Bool

    fileprivate init(base: Int, errorIfNonZero: Bool = false) {
      self.base = base
      self.octalErrorIfNonZero = errorIfNonZero
    }
  }

  /// When base is `0` we get base from prefix,
  /// otherwise the user-provided `base` is ok.
  private static func parseBaseFromStringIfBaseIsZero(
    scalars: Scalars,
    base: Int
  ) throws -> PythonBase {
    assert(base == 0 || base >= 2)
    assert(base <= 36)

    // We are only interested in case where 'base == 0'.
    guard base == 0 else {
      return PythonBase(base: base)
    }

    // We are only interested in strings with '0[xXoObB]' prefix
    var iter = scalars.makeIterator()

    guard let first = iter.next() else {
      throw PythonParsingError.missingBase
    }

    guard first == "0" else {
      return PythonBase(base: 10)
    }

    guard let second = iter.next() else {
      return PythonBase(base: 10)
    }

    switch second {
    case "b",
         "B":
      return PythonBase(base: 2)
    case "o",
         "O":
      return PythonBase(base: 8)
    case "x",
         "X":
      return PythonBase(base: 16)
    default:
      // "old" (C-style) octal literal, now invalid.
      // It might still be zero though (as in '0000...')
      return PythonBase(base: 10, errorIfNonZero: true)
    }
  }

  /// Consume prefix `0[xXoObB]` + optional `_`.
  /// Returns `true` if prefix was consumed.
  private static func consumeBasePrefixIfEqualToBase(
    scalars: inout Scalars,
    base: Int
  ) -> Bool {
    let firstIndex = scalars.startIndex
    guard firstIndex != scalars.endIndex else {
      return false
    }

    let secondIndex = scalars.index(after: firstIndex)
    guard secondIndex != scalars.endIndex else {
      return false
    }

    let first = scalars[firstIndex]
    let second = scalars[secondIndex]

    guard first == "0" else {
      return false
    }

    let isBinary = base == 2 && (second == "b" || second == "B")
    let isOctal = base == 8 && (second == "o" || second == "O")
    let isHex = base == 16 && (second == "x" || second == "X")

    guard isBinary || isOctal || isHex else {
      return false
    }

    let thirdIndex = scalars.index(after: secondIndex)
    scalars = scalars[thirdIndex...]

    // One underscore allowed here.
    if thirdIndex != scalars.endIndex && scalars[thirdIndex] == "_" {
      let fourthIndex = scalars.index(after: thirdIndex)
      scalars = scalars[fourthIndex...]
    }

    return true
  }
}

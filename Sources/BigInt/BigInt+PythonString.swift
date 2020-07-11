// In CPython:
// Objects -> longobject.c

extension BigInt {

  private typealias Scalars = String.UnicodeScalarView.SubSequence

  // MARK: - Parsing error

  public enum PythonParsingError: Error, Equatable, CustomStringConvertible {
    /// Str is empty
    case emptyString
    /// Str does not contain base
    case missingBase
    /// String contains `__`
    case doubleUnderscore
    /// Number part starts with `_`
    case underscorePrefix
    /// String ends with `_`
    case underscoreSuffix
    /// '\(scalar)' is not a valid digit for given base
    case notDigit(UnicodeScalar)
    /// Octal numbers with `0` prefix (for example `0123`) are not allowed
    case octalNonZero

    public var description: String {
      switch self {
      case .emptyString:
        return "Empty str is not allowed"
      case .missingBase:
        return "Str does not contain base"
      case .doubleUnderscore:
        return "Multiple underscores in a row are not allowed"
      case .underscorePrefix:
        return "Number cannot start with underscore"
      case .underscoreSuffix:
        return "Underscore suffix is not allowed"
      case .notDigit(let scalar):
        let codePoint = scalar.codePointNotation
        return "'\(scalar)' (unicode: \(codePoint)) is not a valid digit for given base"
      case .octalNonZero:
        return "Octal numbers with '0' prefix (for example '0123') are not allowed"
      }
    }
  }

  // MARK: - BigInt.init

  // 'String.UnicodeScalarView' and 'String.UnicodeScalarView.SubSequence'
  // do not share common protocol (that we would be interested in).
  // But we can easly convert 'UnicodeScalarView' to 'UnicodeScalarView.SubSequence'
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

  /// This implements `Python` parsing rules, not `Swift`!
  ///
  /// PyObject *
  /// PyLong_FromString(const char *str, char **pend, int base)
  public init(
    parseUsingPythonRules scalars: String.UnicodeScalarView.SubSequence,
    base _base: Int = 10
  ) throws {
    precondition(_base == 0 || _base >= 2, "Base should be 0 or in 2...36 range.")
    precondition(_base <= 36, "Base should be 0 or in 2...36 range.")

    if scalars.isEmpty {
      throw PythonParsingError.emptyString // >>> int('') -> ValueError
    }

    var scalars = Self.trim(scalars: scalars)

    let sign: ParsedSign
    switch Self.parseSign(advancingIfFound: &scalars) {
    case .emptyString:
      throw PythonParsingError.emptyString
    case .sign(let s):
      sign = s
    }

    let parsedBase = try Self.parseBaseFromStringIfBaseIsZero(scalars: &scalars,
                                                              base: _base)
    let base = parsedBase.base
    let octalErrorIfNonZero = parsedBase.octalErrorIfNonZero

    // '0[xXoObB]' thingie
    Self.consumeBasePrefixIfEqualToBase(scalars: &scalars, base: base)

    // Well, after all of that nonsense we can start parsing actual number
    // (which may not start with underscores).
    if let first = scalars.first, first == "_" {
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
       throw PythonParsingError.notDigit(s)
     }

    if octalErrorIfNonZero && !self.isZero {
      throw PythonParsingError.octalNonZero
    }
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
    scalars: inout Scalars,
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
    case "b", "B":
      return PythonBase(base: 2)
    case "o", "O":
      return PythonBase(base: 8)
    case "x", "X":
      return PythonBase(base: 16)
    default:
      // "old" (C-style) octal literal, now invalid.
      // It might still be zero though (as in '0000...')
      return PythonBase(base: 10, errorIfNonZero: true)
    }
  }

  /// Consume prefix `0[xXoObB]` + optional `_`.
  private static func consumeBasePrefixIfEqualToBase(
    scalars: inout Scalars,
    base: Int
  ) {
    let firstIndex = scalars.startIndex
    guard firstIndex != scalars.endIndex else {
      return
    }

    let secondIndex = scalars.index(after: firstIndex)
    guard secondIndex != scalars.endIndex else {
      return
    }

    let first = scalars[firstIndex]
    let second = scalars[secondIndex]

    guard first == "0" else {
      return
    }

    let isBinary = base == 2 && (second == "b" || second == "B")
    let isOctal = base == 8 && (second == "o" || second == "O")
    let isHex = base == 16 && (second == "x" || second == "X")

    guard isBinary || isOctal || isHex else {
      return
    }

    let thirdIndex = scalars.index(after: secondIndex)
    scalars = scalars[thirdIndex...]

    // One underscore allowed here.
    if thirdIndex != scalars.endIndex && scalars[thirdIndex] == "_" {
      let fourthIndex = scalars.index(after: thirdIndex)
      scalars = scalars[fourthIndex...]
    }
  }
}

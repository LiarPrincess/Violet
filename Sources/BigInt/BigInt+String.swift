// Some code was taken from: https://github.com/attaswift/BigInt

// swiftlint:disable file_length

// MARK: - String.init

extension String {

  // This may be faster than native Swift implementation.
  public init(_ value: BigInt, radix: Int = 10, uppercase: Bool = false) {
    self = value.toString(radix: radix, uppercase: uppercase)
  }
}

extension BigInt {

  private typealias Word = BigIntHeap.Word

  // MARK: - BigInt.init

  public enum ParsingError: Error, Equatable, CustomStringConvertible {
    /// String is empty
    case emptyString
    /// String is not empty, but does not contain any digit (for example `+`)
    case signWithoutDigits
    /// String contains `__`
    case doubleUnderscore
    /// String starts with `_`
    case underscorePrefix
    /// String has `_` just after sign
    case underscoreAfterSign
    /// String ends with `_`
    case underscoreSuffix
    /// '\(scalar)' is not a valid digit for given radix
    case notDigit(UnicodeScalar)

    public var description: String {
      switch self {
      case .emptyString:
        return "Empty string is not allowed"
      case .signWithoutDigits:
        return "Sign without any digit is not allowed"
      case .doubleUnderscore:
        return "Multiple underscores in a row are not allowed"
      case .underscorePrefix:
        return "Underscore prefix is not allowed"
      case .underscoreAfterSign:
        return "Underscore just after sign is not allowed"
      case .underscoreSuffix:
        return "Underscore suffix is not allowed"
      case .notDigit(let scalar):
        let codePoint = scalar.codePointNotation
        return "'\(scalar)' (unicode: \(codePoint)) is not a valid digit for given radix"
      }
    }
  }

  // 'String.UnicodeScalarView' and 'String.UnicodeScalarView.SubSequence'
  // do not share common protocol (that we would be interested in).
  // But we can easly convert 'UnicodeScalarView' to 'UnicodeScalarView.SubSequence'
  // by using 'scalars[...]', so we will use this as our common ground.
  private typealias Scalars = String.UnicodeScalarView.SubSequence

  public init(_ string: String, radix: Int = 10) throws {
    try self.init(string.unicodeScalars, radix: radix)
  }

  public init(_ scalars: String.UnicodeScalarView, radix: Int = 10) throws {
    let substring = scalars[...]
    try self.init(substring, radix: radix)
  }

  public init(
    _ scalars: String.UnicodeScalarView.SubSequence,
    radix: Int = 10
  ) throws {
    precondition(2 <= radix && radix <= 36, "Radix not in range 2...36.")

    if scalars.isEmpty {
      throw ParsingError.emptyString
    }

    var scalars = scalars
    let sign = try Self.parseSign(advancingIfFound: &scalars)

    guard let firstDigit = scalars.first else {
      // We already checked for empty, so the only remainig possibility is:
      throw ParsingError.signWithoutDigits
    }

    if firstDigit == "_" {
      switch sign {
      case .positive, .negative:
        throw ParsingError.underscoreAfterSign
      case .notSpecified:
        throw ParsingError.underscorePrefix
      }
    }

    let result = try Self.parseMagnitude(scalars: scalars,
                                         radix: radix,
                                         sign: sign)

    self = result
  }

  // MARK: - Sign

  private enum Sign {
    case positive
    case negative
    /// No sign in string, use `positive`.
    case notSpecified
  }

  /// Parse sign and advance `scalars` if needed.
  private static func parseSign(
    advancingIfFound scalars: inout Scalars
  ) throws -> Sign {
    guard let first = scalars.first else {
      throw ParsingError.emptyString
    }

    if first == "+" {
      scalars = scalars.dropFirst()
      return .positive
    }

    if first == "-" {
      scalars = scalars.dropFirst()
      return .negative
    }

    return .notSpecified
  }

  // MARK: - Magnitude

  /// Parse number without sign.
  ///
  /// Will skip prefix underscore, so if this is an error in your scenario then
  /// handle it before calling this method.
  private static func parseMagnitude(
    scalars: String.UnicodeScalarView.SubSequence,
    radix: Int,
    sign: Sign
  ) throws -> BigInt {
    let isNegative: Bool = {
      switch sign {
      case .positive, .notSpecified: return false
      case .negative: return true
      }
    }()

    // Instead of using a single 'BigInt' and multipling it by 'radix',
    // we will group scalars into words-sized chunks.
    // Then we will raise those chunks to appropriate power and add together.
    //
    // For example:
    // 1_2345_6789 = (1 * 10^8) + (2345 * 10^4) + (6789 * 10^0)
    //
    // So, we are doing most of our calculations in fast 'Word',
    // and then we switch to slow BigInt for a few final operations.

    let (scalarCountPerGroup, power) = Word.maxRepresentablePower(of: radix)
    let radix = Word(radix)

    // 'groups' are in in right-to-left (lowest power first) order.
    let groups = try Self.parseGroups(scalars: scalars,
                                      radix: radix,
                                      scalarCountPerGroup: scalarCountPerGroup)

    // Fast path: no groups -> 0
    guard let mostSignificantGroup = groups.last else {
      return self.init()
    }

    // Fast path for 'Smi' (avoids allocation for 'BigIntHeap')
    if groups.count == 1 {
      if let smi = mostSignificantGroup.asSmiIfPossible(isNegative: isNegative) {
        return self.init(smi: smi)
      }
    }

    var result = BigIntHeap(minimumStorageCapacity: groups.count)
    result.storage.append(mostSignificantGroup)
    result.storage.isNegative = isNegative

    // 'dropLast' because we already added 'mostSignificantGroup'
    // 'reversed' because we want to start with 'high' powers
    for group in groups.dropLast().reversed() {
      BigIntHeap.mulMagnitude(lhs: &result.storage, rhs: power)
      BigIntHeap.addMagnitude(lhs: &result.storage, rhs: group)
    }

    result.fixInvariants()
    return self.init(result)
  }

  // swiftlint:disable function_body_length

  /// Returns groups in right-to-left order!
  private static func parseGroups(
    scalars: String.UnicodeScalarView.SubSequence,
    radix: Word,
    scalarCountPerGroup: Int
  ) throws -> [Word] {
    // swiftlint:enable function_body_length

    var result = [Word]()

    let minimumCapacity = (scalars.count / scalarCountPerGroup) + 1
    result.reserveCapacity(minimumCapacity)

    // Group that we are currently working on, it will be added to 'result' later
    var currentGroup = Word.zero

    // Prevent '__' (but single '_' is ok)
    var isPreviousUnderscore = false

    // `123 = (1 * power^2) + (2 * power^1) + (3 * power^0)` etc.
    var power = Word(1)

    // Position in string, starting from the right
    var indexExcludingUnderscores = 0

    for scalar in scalars.reversed() {
      let isUnderscore = scalar == "_"
      defer { isPreviousUnderscore = isUnderscore }

      if isUnderscore {
        if isPreviousUnderscore {
          throw ParsingError.doubleUnderscore
        }

        // This name is correct! Remember that we are going 'in reverse'!
        let isLast = indexExcludingUnderscores == 0
        if isLast {
          throw ParsingError.underscoreSuffix
        }

        continue // Skip underscores
      }

      guard let digit = scalar.asDigit, digit < radix else {
        throw ParsingError.notDigit(scalar)
      }

      // Prefix 'currentGroup' with current digit
      currentGroup = power * digit + currentGroup
      // Before the 'if', because we would have to '+1' to check 'isMultiple' anyway
      indexExcludingUnderscores += 1

      // Do not move 'power *= radix' here, because it will overflow!
      // It has to be in 'else' case.
      let isLastInGroup = indexExcludingUnderscores.isMultiple(of: scalarCountPerGroup)
      if isLastInGroup {
        // Append group even if it is '0' - we can have '0' words in the middle!
        result.append(currentGroup)
        currentGroup = 0
        power = 1
      } else {
        power *= radix
      }
    }

    if currentGroup != 0 {
      result.append(currentGroup)
    }

    return result
  }
}

// Most of the code was taken from: https://github.com/attaswift/BigInt

// swiftlint:disable function_body_length

// MARK: - To string

extension String {

  // This may be faster than native Swift implementation.
  public init(_ value: BigInt, radix: Int = 10, uppercase: Bool = false) {
    self = value.toString(radix: radix, uppercase: uppercase)
  }
}

extension BigInt {

  private typealias Word = BigIntHeap.Word

  // MARK: - Error

  public enum ParsingError: Error, CustomStringConvertible {
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
        return "Empty is not allowed"
      case .signWithoutDigits:
        return "Sign without any digits is not allowed"
      case .doubleUnderscore:
        return "Double underscore is not allowed"
      case .underscorePrefix:
        return "Underscore prefix is not allowed"
      case .underscoreAfterSign:
        return "Underscore just after sign is not allowed"
      case .underscoreSuffix:
        return "Underscore suffix is not allowed"
      case .notDigit(let scalar):
        // TODO: [Violet] Use proper 'U+XXXX'
        return "'\(scalar)' is not a valid digit for given radix"
      }
    }
  }

  // MARK: - Init

  public init(_ string: String, radix: Int = 10) throws {
    precondition(2 <= radix && radix <= 36, "Radix not in range 2...36.")

    // We need '[...]' because later we will skip sign (if present)
    var scalars = string.unicodeScalars[...]

    // This will also handle empty string
    guard let first = scalars.first else {
      throw ParsingError.emptyString
    }

    // Sign.
    // We will deal with prefix underscore later.
    var isNegative = false
    var hasSign = false
    if first == "+" {
      scalars = scalars.dropFirst()
      hasSign = true
    } else if first == "-" {
      scalars = scalars.dropFirst()
      hasSign = true
      isNegative = true
    }

    guard let firstDigit = scalars.first else {
      throw ParsingError.signWithoutDigits
    }

    if firstDigit == "_" {
      throw hasSign ?
        ParsingError.underscoreAfterSign :
        ParsingError.underscorePrefix
    }

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
                                      scalarCountPerGroup: scalarCountPerGroup,
                                      hasSign: hasSign)

    // Fast path: no groups -> 0
    guard let mostSignificantGroup = groups.last else {
      self.init()
      return
    }

    // Fast path for 'Smi' (no allocation for 'BigIntHeap')
    if groups.count == 1 {
      if let smi = mostSignificantGroup.asSmiIfPossible(isNegative: isNegative) {
        self.init(smi: smi)
        return
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
    self.init(result)
  }

  // MARK: - Groups

  /// Returns groups in right-to-left order!
  private static func parseGroups(
    scalars: String.UnicodeScalarView.SubSequence,
    radix: Word,
    scalarCountPerGroup: Int,
    hasSign: Bool
  ) throws -> [Word] {
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

    // Note that the 'index' is from the end on the string!
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

// In CPython:
// Python -> dtoa.c // cSpell:disable-line

extension Double {

  // MARK: - Inits

  /// This implements `Python` parsing rules, not `Swift`!
  public init?(
    parseUsingPythonRules string: String
  ) {
    let scalarsSubSequence = string.unicodeScalars[...]
    self.init(parseUsingPythonRules: scalarsSubSequence)
  }

  /// This implements `Python` parsing rules, not `Swift`!
  public init?(
    parseUsingPythonRules scalars: String.UnicodeScalarView
  ) {
    let subSequence = scalars[...]
    self.init(parseUsingPythonRules: subSequence)
  }

  /// This implements `Python` parsing rules, not `Swift`!
  public init?(
    parseUsingPythonRules scalars: String.UnicodeScalarView.SubSequence
  ) {
    guard let value = Self.parse(scalars: scalars) else {
      return nil
    }
    self = value
  }

  // MARK: - Parse

  private typealias Scalars = String.UnicodeScalarView.SubSequence

  /// So… there are some differences between how `Python` and `Swift`
  /// parse doubles, but it is not like we will implement this from scratch.
  /// We will just go with 'close enough'
  private static func parse(scalars: Scalars) -> Double? {
    let scalars = Self.trim(scalars: scalars)

    // We do not allow starting or ending with '_'
    if scalars.first == "_" || scalars.last == "_" {
      return nil
    }

    // '_' before/after '.' is also a sin
    if let dotIndex = scalars.firstIndex(of: ".") {
      if Self.characterBefore(scalars: scalars, index: dotIndex) == "_" {
        return nil
      }

      if Self.characterAfter(scalars: scalars, index: dotIndex) == "_" {
        return nil
      }
    }

    // Build proper Swift input (without '_', because they do not like that).
    // Also, look out for any invalid '__'.
    var refinedInput = ""
    var isPreviousUnderscore = false

    for scalar in scalars {
      let isUnderscore = scalar == "_"
      defer { isPreviousUnderscore = isUnderscore }

      if isUnderscore {
        // '__' -> fail
        if isPreviousUnderscore {
          return nil
        }

        // '_' -> ignore
        continue
      }

      refinedInput.append(scalar)
    }

    return Double(refinedInput)
  }

  // MARK: - Helpers

  /// Well… Python calls this operation `strip`. They are wrong….
  private static func trim(scalars: Scalars) -> Scalars {
    func isWhitespace(scalar: UnicodeScalar) -> Bool {
      return scalar.properties.isWhitespace
    }

    return scalars
      .drop(while: isWhitespace(scalar:))
      .dropLast(while: isWhitespace(scalar:))
  }

  private static func characterBefore(scalars: Scalars,
                                      index: Scalars.Index) -> UnicodeScalar? {
    if index == scalars.startIndex {
      return nil
    }

    let indexBefore = scalars.index(before: index)
    return scalars[indexBefore]
  }

  private static func characterAfter(scalars: Scalars,
                                     index: Scalars.Index) -> UnicodeScalar? {
    if index == scalars.endIndex {
      return nil
    }

    let indexAfter = scalars.index(after: index)
    if indexAfter == scalars.endIndex {
      return nil
    }

    return scalars[indexAfter]
  }
}

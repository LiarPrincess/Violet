// In CPython:
// Python -> dtoa.c

extension Double {

  // MARK: - Inits

  /// This implements `Python` parsing rules, not `Swift`!
  public init?(
    parseUsingPythonRules string: String
  ) {
    guard let value = Double.parse(string: string) else {
      return nil
    }
    self = value
  }

  /// This implements `Python` parsing rules, not `Swift`!
  public init?(
    parseUsingPythonRules scalars: String.UnicodeScalarView
  ) {
    self.init(parseUsingPythonRules: String(scalars))
  }

  /// This implements `Python` parsing rules, not `Swift`!
  public init?(
    parseUsingPythonRules scalars: String.UnicodeScalarView.SubSequence
  ) {
    self.init(parseUsingPythonRules: String(scalars))
  }

  // MARK: - Parser

  /// So… there are some differences between how `Python` and `Swift`
  /// parse doubles, but it is not like we will implement this from scratch.
  /// We will just go with 'close enough'
  private static func parse(string: String) -> Double? {
    var input = string.trimmingCharacters(in: .whitespaces)

    // We do not allow starting or ending with '_'
    if input.hasPrefix("_") || input.hasSuffix("_") {
      return nil
    }

    // We do not allow '_' before and after '.'
    if let dotIndex = input.firstIndex(of: ".") {
      assert(dotIndex != input.endIndex)

      if Self.characterBefore(string: input, index: dotIndex) == "_" {
        return nil
      }

      if Self.characterAfter(string: input, index: dotIndex) == "_" {
        return nil
      }
    }

    // '__' is also a sin
    if input.contains("__") {
      return nil
    }

    // Now that we guaranteed that out '_' are in correct places
    // we should remove them because Swift parser does not like them.
    input.removeAll { $0 == "_" }
    return Double(input)
  }

  private static func characterBefore(string: String,
                                      index: String.Index) -> Character? {
    if index == string.startIndex {
      return nil
    }

    let indexBefore = string.index(before: index)
    return string[indexBefore]
  }

  private static func characterAfter(string: String,
                                     index: String.Index) -> Character? {
    if index == string.endIndex {
      return nil
    }

    let indexAfter = string.index(after: index)
    if indexAfter == string.endIndex {
      return nil
    }

    return string[indexAfter]
  }
}

extension Unicode {

  /// Categories used for `str` implementations of `isAlpha` and `isAlphaNumeric`.
  internal static var alphaCategories: Set<Unicode.GeneralCategory> {
    return data
  }
}

private let data: Set<Unicode.GeneralCategory> = Set([
  .modifierLetter, // Lm
  .titlecaseLetter, // Lt
  .uppercaseLetter, // Lu
  .lowercaseLetter, // Ll
  .otherLetter // Lo
])

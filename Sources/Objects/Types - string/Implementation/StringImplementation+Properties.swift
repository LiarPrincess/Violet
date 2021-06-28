import Foundation

// swiftlint:disable file_length

extension StringImplementation {

  // MARK: - Whitespace

  // This is not exposed to Python, but it is used in various methods
  // (for example strip whitespace ones).
  internal static func isWhitespace<S: UnicodeScalarConvertible>(scalar: S) -> Bool {
    let properties = scalar.asUnicodeScalar.properties
    return properties.isWhitespace
  }

  // MARK: - Line break

  // This is not exposed to Python, but it is used in various methods
  // (for example 'split').
  internal static func isLineBreak<S: UnicodeScalarConvertible>(scalar: S) -> Bool {
    return Unicode.lineBreaks.contains(scalar.asUnicodeScalar)
  }

  // MARK: - AlphaNumeric

  internal static func isAlphaNumeric(scalars: UnicodeScalars) -> Bool {
    return Self.isAlphaNumeric(collection: scalars)
  }

  internal static func isAlphaNumeric(data: Data) -> Bool {
    return Self.isAlphaNumeric(collection: data)
  }

  /// Return true if all characters in the string are alphanumeric
  /// and there is at least one character.
  /// A character c is alphanumeric if one of the following returns True:
  /// c.isalpha(), c.isdecimal(), c.isdigit(), or c.isnumeric()
  /// https://docs.python.org/3/library/stdtypes.html#str.isalnum
  private static func isAlphaNumeric<C: Collection>(
    collection: C
  ) -> Bool where C.Element: UnicodeScalarConvertible {
    return collection.any && collection.allSatisfy(Self.isAlphaNumeric(scalar:))
  }

  internal static func isAlphaNumeric<S: UnicodeScalarConvertible>(scalar: S) -> Bool {
    let properties = scalar.asUnicodeScalar.properties
    if properties.numericType != nil {
      return true
    }

    let category = properties.generalCategory
    if category == .decimalNumber {
      return true
    }

    return Unicode.alphaCategories.contains(category)
  }

  // MARK: - Alpha

  internal static func isAlpha(scalars: UnicodeScalars) -> Bool {
    return Self.isAlpha(collection: scalars)
  }

  internal static func isAlpha(data: Data) -> Bool {
    return Self.isAlpha(collection: data)
  }

  /// Return true if all characters in the string are alphabetic
  /// and there is at least one character.
  /// Alphabetic characters are those characters defined in the Unicode character
  /// database as “Letter”, i.e., those with general category property
  /// being one of “Lm”, “Lt”, “Lu”, “Ll”, or “Lo”.
  /// https://docs.python.org/3/library/stdtypes.html#str.isalpha
  private static func isAlpha<C: Collection>(
    collection: C
  ) -> Bool where C.Element: UnicodeScalarConvertible {
    return collection.any && collection.allSatisfy(Self.isAlpha(scalar:))
  }

  internal static func isAlpha<S: UnicodeScalarConvertible>(scalar: S) -> Bool {
    let properties = scalar.asUnicodeScalar.properties
    let category = properties.generalCategory
    return Unicode.alphaCategories.contains(category)
  }

  // MARK: - Ascii

  internal static func isAscii(scalars: UnicodeScalars) -> Bool {
    return Self.isAscii(collection: scalars)
  }

  internal static func isAscii(data: Data) -> Bool {
    return Self.isAscii(collection: data)
  }

  /// Return true if the string is empty or all characters in the string are ASCII.
  /// ASCII characters have code points in the range U+0000-U+007F.
  /// https://docs.python.org/3/library/stdtypes.html#str.isascii
  private static func isAscii<C: Collection>(
    collection: C
  ) -> Bool where C.Element: UnicodeScalarConvertible {
    return collection.any && collection.allSatisfy(Self.isAscii(scalar:))
  }

  internal static func isAscii<S: UnicodeScalarConvertible>(scalar: S) -> Bool {
    return scalar.asUnicodeScalar.isASCII
  }

  // MARK: - Decimal

  internal static func isDecimal(scalars: UnicodeScalars) -> Bool {
    return Self.isDecimal(collection: scalars)
  }

  internal static func isDecimal(data: Data) -> Bool {
    return Self.isDecimal(collection: data)
  }

  /// Return true if all characters in the string are decimal characters
  /// and there is at least one character.
  /// Formally a decimal character is a character in the Unicode General
  /// Category “Nd”.
  /// https://docs.python.org/3/library/stdtypes.html#str.isdecimal
  private static func isDecimal<C: Collection>(
    collection: C
  ) -> Bool where C.Element: UnicodeScalarConvertible {
    return collection.any && collection.allSatisfy(Self.isDecimal(scalar:))
  }

  internal static func isDecimal<S: UnicodeScalarConvertible>(scalar: S) -> Bool {
    let properties = scalar.asUnicodeScalar.properties
    return properties.generalCategory == .decimalNumber
  }

  // MARK: - Digit

  internal static func isDigit(scalars: UnicodeScalars) -> Bool {
    return Self.isDigit(collection: scalars)
  }

  internal static func isDigit(data: Data) -> Bool {
    return Self.isDigit(collection: data)
  }

  /// Return true if all characters in the string are digits
  /// and there is at least one character.
  /// Formally, a digit is a character that has the property value
  /// Numeric_Type=Digit or Numeric_Type=Decimal.
  /// https://docs.python.org/3/library/stdtypes.html#str.isdigit
  private static func isDigit<C: Collection>(
    collection: C
  ) -> Bool where C.Element: UnicodeScalarConvertible {
    return collection.any && collection.allSatisfy(Self.isDigit(scalar:))
  }

  internal static func isDigit<S: UnicodeScalarConvertible>(scalar: S) -> Bool {
    let properties = scalar.asUnicodeScalar.properties

    guard let numericType = properties.numericType else {
      return false
    }

    return numericType == .digit || numericType == .decimal
  }

  // MARK: - Lower

  internal static func isLower(scalars: UnicodeScalars) -> Bool {
    return Self.isLower(collection: scalars)
  }

  internal static func isLower(data: Data) -> Bool {
    return Self.isLower(collection: data)
  }

  /// Return true if all cased characters 4 in the string are lowercase
  /// and there is at least one cased character.
  /// https://docs.python.org/3/library/stdtypes.html#str.islower
  private static func isLower<C: Collection>(
    collection: C
  ) -> Bool where C.Element: UnicodeScalarConvertible {
    return collection.any && collection.allSatisfy(Self.isLower(scalar:))
  }

  internal static func isLower<S: UnicodeScalarConvertible>(scalar: S) -> Bool {
    // If a character does not have case then True, for example:
    // "a\u02B0b".islower() -> True
    let properties = scalar.asUnicodeScalar.properties
    return !properties.isCased || properties.isLowercase
  }

  // MARK: - Upper

  internal static func isUpper(scalars: UnicodeScalars) -> Bool {
    return Self.isUpper(collection: scalars)
  }

  internal static func isUpper(data: Data) -> Bool {
    return Self.isUpper(collection: data)
  }

  /// Return true if all cased characters 4 in the string are uppercase
  /// and there is at least one cased character.
  /// https://docs.python.org/3/library/stdtypes.html#str.isupper
  private static func isUpper<C: Collection>(
    collection: C
  ) -> Bool where C.Element: UnicodeScalarConvertible {
    return collection.any && collection.allSatisfy(Self.isUpper(scalar:))
  }

  internal static func isUpper<S: UnicodeScalarConvertible>(scalar: S) -> Bool {
    // If a character does not have case then True, for example:
    // "a\u02B0b".isupper() -> True
    let properties = scalar.asUnicodeScalar.properties
    return !properties.isCased || properties.isUppercase
  }

  // MARK: - Numeric

  internal static func isNumeric(scalars: UnicodeScalars) -> Bool {
    return Self.isNumeric(collection: scalars)
  }

  internal static func isNumeric(data: Data) -> Bool {
    return Self.isNumeric(collection: data)
  }

  /// Return true if all characters in the string are numeric characters,
  /// and there is at least one character.
  /// Formally, numeric characters are those with the property value
  /// Numeric_Type=Digit, Numeric_Type=Decimal or Numeric_Type=Numeric.
  /// https://docs.python.org/3/library/stdtypes.html#str.isnumeric
  private static func isNumeric<C: Collection>(
    collection: C
  ) -> Bool where C.Element: UnicodeScalarConvertible {
    return collection.any && collection.allSatisfy(Self.isNumeric(scalar:))
  }

  internal static func isNumeric<S: UnicodeScalarConvertible>(scalar: S) -> Bool {
    let properties = scalar.asUnicodeScalar.properties
    return properties.numericType != nil
  }

  // MARK: - Printable

  internal static func isPrintable(scalars: UnicodeScalars) -> Bool {
    return Self.isPrintable(collection: scalars)
  }

  internal static func isPrintable(data: Data) -> Bool {
    return Self.isPrintable(collection: data)
  }

  /// Return true if all characters in the string are printable
  /// or the string is empty.
  ///
  /// Nonprintable characters are those characters defined in the Unicode
  /// character database as “Other” or “Separator”,
  /// excepting the ASCII space (0x20) which is considered printable.
  ///
  /// All characters except those characters defined in the Unicode character
  /// database as following categories are considered printable.
  ///    * Cc (Other, Control)
  ///    * Cf (Other, Format)
  ///    * Cs (Other, Surrogate)
  ///    * Co (Other, Private Use)
  ///    * Cn (Other, Not Assigned)
  ///    * Zl Separator, Line ('\u2028', LINE SEPARATOR)
  ///    * Zp Separator, Paragraph ('\u2029', PARAGRAPH SEPARATOR)
  ///    * Zs (Separator, Space) other than ASCII space('\x20').
  /// https://docs.python.org/3/library/stdtypes.html#str.isprintable
  private static func isPrintable<C: Collection>(
    collection: C
  ) -> Bool where C.Element: UnicodeScalarConvertible {
    // We do not have to check if 'collection.any'!
    return collection.allSatisfy(Self.isPrintable(scalar:))
  }

  internal static func isPrintable<S: UnicodeScalarConvertible>(scalar: S) -> Bool {
    let s = scalar.asUnicodeScalar

    if s == " " { // 'space' is considered printable
      return true
    }

    let category = s.properties.generalCategory
    switch category {
    case .control, // Cc
         .format, // Cf
         .surrogate, // Cs
         .privateUse, // Co
         .unassigned, // Cn
         .lineSeparator, // Zl
         .paragraphSeparator, // Zp
         .spaceSeparator: // Zs
      return false
    default:
      return true
    }
  }

  // MARK: - Space

  internal static func isSpace(scalars: UnicodeScalars) -> Bool {
    return Self.isSpace(collection: scalars)
  }

  internal static func isSpace(data: Data) -> Bool {
    return Self.isSpace(collection: data)
  }

  /// Return true if there are only whitespace characters in the string
  /// and there is at least one character.
  /// A character is whitespace if in the Unicode character database:
  /// - its general category is Zs (“Separator, space”)
  /// - or its bidirectional class is one of WS, B, or S
  /// https://docs.python.org/3/library/stdtypes.html#str.isspace
  private static func isSpace<C: Collection>(
    collection: C
  ) -> Bool where C.Element: UnicodeScalarConvertible {
    return collection.any && collection.allSatisfy(Self.isSpace(scalar:))
  }

  internal static func isSpace<S: UnicodeScalarConvertible>(scalar: S) -> Bool {
    let s = scalar.asUnicodeScalar
    let category = s.properties.generalCategory
    return category == .spaceSeparator || Unicode.bidiClass_ws_b_s.contains(s.value)
  }

  // MARK: - Title

  internal static func isTitle(scalars: UnicodeScalars) -> Bool {
    return Self.isTitle(collection: scalars)
  }

  internal static func isTitle(data: Data) -> Bool {
    return Self.isTitle(collection: data)
  }

  /// Return true if the string is a title-cased string and there is at least
  /// one character, for example uppercase characters may only follow uncased
  /// characters and lowercase characters only cased ones.
  /// https://docs.python.org/3/library/stdtypes.html#str.istitle
  private static func isTitle<C: Collection>(
    collection: C
  ) -> Bool where C.Element: UnicodeScalarConvertible {
    var cased = false
    var isPreviousCased = false

    for element in collection {
      let scalar = element.asUnicodeScalar

      switch scalar.properties.generalCategory {
      case .lowercaseLetter:
        if !isPreviousCased {
          return false
        }

        isPreviousCased = true
        cased = true

      case .uppercaseLetter, .titlecaseLetter:
        if isPreviousCased {
          return false
        }

        isPreviousCased = true
        cased = true

      default:
        isPreviousCased = false
      }
    }

    return cased
  }
}

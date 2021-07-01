// swiftlint:disable file_length

extension AbstractString {

  // MARK: - Whitespace

  /// This is not exposed to Python, but it is used in various methods
  /// (for example strip whitespace ones).
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func _isWhitespace(element: Element) -> Bool {
    let scalar = Self._asUnicodeScalar(element: element)
    let properties = scalar.properties
    return properties.isWhitespace
  }

  // MARK: - Line break

  /// This is not exposed to Python, but it is used in various methods
  /// (for example strip whitespace ones).
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func _isLineBreak(element: Element) -> Bool {
    let scalar = Self._asUnicodeScalar(element: element)
    return Unicode.lineBreaks.contains(scalar)
  }

  // MARK: - AlphaNumeric

  /// Return true if all characters in the string are alphanumeric
  /// and there is at least one character.
  /// A character c is alphanumeric if one of the following returns True:
  /// c.isalpha(), c.isdecimal(), c.isdigit(), or c.isnumeric()
  /// https://docs.python.org/3/library/stdtypes.html#str.isalnum
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isAlphaNumeric() -> Bool {
    if self.elements.isEmpty {
      return false
    }

    return self.elements.allSatisfy(Self._isAlphaNumeric(element:))
  }

  private static func _isAlphaNumeric(element: Element) -> Bool {
    let scalar = Self._asUnicodeScalar(element: element)
    let properties = scalar.properties
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

  /// Return true if all characters in the string are alphabetic
  /// and there is at least one character.
  /// Alphabetic characters are those characters defined in the Unicode character
  /// database as “Letter”, i.e., those with general category property
  /// being one of “Lm”, “Lt”, “Lu”, “Ll”, or “Lo”.
  /// https://docs.python.org/3/library/stdtypes.html#str.isalpha
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isAlpha() -> Bool {
    if self.elements.isEmpty {
      return false
    }

    return self.elements.allSatisfy(Self._isAlpha(element:))
  }

  private static func _isAlpha(element: Element) -> Bool {
    let scalar = Self._asUnicodeScalar(element: element)
    let properties = scalar.properties
    let category = properties.generalCategory
    return Unicode.alphaCategories.contains(category)
  }

  // MARK: - ASCII

  /// Return true if the string is empty or all characters in the string are ASCII.
  /// ASCII characters have code points in the range U+0000-U+007F.
  /// https://docs.python.org/3/library/stdtypes.html#str.isascii
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isAscii() -> Bool {
    if self.elements.isEmpty {
      return false
    }

    return self.elements.allSatisfy(Self._isAscii(element:))
  }

  private static func _isAscii(element: Element) -> Bool {
    let scalar = Self._asUnicodeScalar(element: element)
    return scalar.isASCII
  }

  // MARK: - Decimal

  /// Return true if all characters in the string are decimal characters
  /// and there is at least one character.
  /// Formally a decimal character is a character in the Unicode General
  /// Category “Nd”.
  /// https://docs.python.org/3/library/stdtypes.html#str.isdecimal
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isDecimal() -> Bool {
    if self.elements.isEmpty {
      return false
    }

    return self.elements.allSatisfy(Self._isDecimal(element:))
  }

  private static func _isDecimal(element: Element) -> Bool {
    let scalar = Self._asUnicodeScalar(element: element)
    let properties = scalar.properties
    return properties.generalCategory == .decimalNumber
  }

  // MARK: - Digit

  /// Return true if all characters in the string are digits
  /// and there is at least one character.
  /// Formally, a digit is a character that has the property value
  /// Numeric_Type=Digit or Numeric_Type=Decimal.
  /// https://docs.python.org/3/library/stdtypes.html#str.isdigit
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isDigit() -> Bool {
    if self.elements.isEmpty {
      return false
    }

    return self.elements.allSatisfy(Self._isDigit(element:))
  }

  private static func _isDigit(element: Element) -> Bool {
    let scalar = Self._asUnicodeScalar(element: element)
    let properties = scalar.properties

    guard let numericType = properties.numericType else {
      return false
    }

    return numericType == .digit || numericType == .decimal
  }

  // MARK: - Lower

  /// Return true if all cased characters 4 in the string are lowercase
  /// and there is at least one cased character.
  /// https://docs.python.org/3/library/stdtypes.html#str.islower
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isLower() -> Bool {
    if self.elements.isEmpty {
      return false
    }

    return self.elements.allSatisfy(Self._isLower(element:))
  }

  private static func _isLower(element: Element) -> Bool {
    let scalar = Self._asUnicodeScalar(element: element)
    // If a character does not have case then True, for example:
    // "a\u02B0b".islower() -> True
    let properties = scalar.properties
    return !properties.isCased || properties.isLowercase
  }

  // MARK: - Upper

  /// Return true if all cased characters 4 in the string are uppercase
  /// and there is at least one cased character.
  /// https://docs.python.org/3/library/stdtypes.html#str.isupper
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isUpper() -> Bool {
    if self.elements.isEmpty {
      return false
    }

    return self.elements.allSatisfy(Self._isUpper(element:))
  }

  private static func _isUpper(element: Element) -> Bool {
    let scalar = Self._asUnicodeScalar(element: element)
    // If a character does not have case then True, for example:
    // "a\u02B0b".isupper() -> True
    let properties = scalar.properties
    return !properties.isCased || properties.isUppercase
  }

  // MARK: - Numeric

  /// Return true if all characters in the string are numeric characters,
  /// and there is at least one character.
  /// Formally, numeric characters are those with the property value
  /// Numeric_Type=Digit, Numeric_Type=Decimal or Numeric_Type=Numeric.
  /// https://docs.python.org/3/library/stdtypes.html#str.isnumeric
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isNumeric() -> Bool {
    if self.elements.isEmpty {
      return false
    }

    return self.elements.allSatisfy(Self._isNumeric(element:))
  }

  private static func _isNumeric(element: Element) -> Bool {
    let scalar = Self._asUnicodeScalar(element: element)
    let properties = scalar.properties
    return properties.numericType != nil
  }

  // MARK: - Printable

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
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isPrintable() -> Bool {
    // We do not have to check if 'self.elements.isEmpty'!
    // Empty string is printable!
    return self.elements.allSatisfy(Self._isPrintable(element:))
  }

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func _isPrintable(element: Element) -> Bool {
    let scalar = Self._asUnicodeScalar(element: element)

    // 'space' is considered printable
    if scalar == " " {
      return true
    }

    let category = scalar.properties.generalCategory
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

  /// Return true if there are only whitespace characters in the string
  /// and there is at least one character.
  /// A character is whitespace if in the Unicode character database:
  /// - its general category is Zs (“Separator, space”)
  /// - or its bidirectional class is one of WS, B, or S
  /// https://docs.python.org/3/library/stdtypes.html#str.isspace
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isSpace() -> Bool {
    if self.elements.isEmpty {
      return false
    }

    return self.elements.allSatisfy(Self._isSpace(element:))
  }

  private static func _isSpace(element: Element) -> Bool {
    let scalar = Self._asUnicodeScalar(element: element)
    let category = scalar.properties.generalCategory
    return category == .spaceSeparator
      || Unicode.bidiClass_ws_b_s.contains(scalar.value)
  }

  // MARK: - Title

   /// Return true if the string is a title-cased string and there is at least
  /// one character, for example uppercase characters may only follow uncased
  /// characters and lowercase characters only cased ones.
  /// https://docs.python.org/3/library/stdtypes.html#str.istitle
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isTitle() -> Bool {
    var cased = false
    var isPreviousCased = false

    for element in self.elements {
      let scalar = Self._asUnicodeScalar(element: element)
      let category = scalar.properties.generalCategory

      switch category {
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

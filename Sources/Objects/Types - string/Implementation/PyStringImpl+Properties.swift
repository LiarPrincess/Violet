extension PyStringImpl {

  /// Return true if all characters in the string are alphanumeric
  /// and there is at least one character.
  /// A character c is alphanumeric if one of the following returns True:
  /// c.isalpha(), c.isdecimal(), c.isdigit(), or c.isnumeric()
  /// https://docs.python.org/3/library/stdtypes.html#str.isalnum
  internal var isAlphaNumeric: Bool {
    return self.scalars.any && self.scalars.allSatisfy { element in
      let scalar = Self.toUnicodeScalar(element)
      let properties = scalar.properties
      let category = properties.generalCategory
      return Unicode.alphaCategories.contains(category)
        || category == .decimalNumber
        || properties.numericType != nil
    }
  }

  /// Return true if all characters in the string are alphabetic
  /// and there is at least one character.
  /// Alphabetic characters are those characters defined in the Unicode character
  /// database as “Letter”, i.e., those with general category property
  /// being one of “Lm”, “Lt”, “Lu”, “Ll”, or “Lo”.
  /// https://docs.python.org/3/library/stdtypes.html#str.isalpha
  internal var isAlpha: Bool {
    return self.scalars.any && self.scalars.allSatisfy { element in
      let scalar = Self.toUnicodeScalar(element)
      let category = scalar.properties.generalCategory
      return Unicode.alphaCategories.contains(category)
    }
  }

  /// Return true if the string is empty or all characters in the string are ASCII.
  /// ASCII characters have code points in the range U+0000-U+007F.
  /// https://docs.python.org/3/library/stdtypes.html#str.isascii
  internal var isAscii: Bool {
    return self.scalars.any && self.scalars.allSatisfy { element in
      let scalar = Self.toUnicodeScalar(element)
      return scalar.isASCII
    }
  }

  /// Return true if all characters in the string are decimal characters
  /// and there is at least one character.
  /// Formally a decimal character is a character in the Unicode General
  /// Category “Nd”.
  /// https://docs.python.org/3/library/stdtypes.html#str.isdecimal
  internal var isDecimal: Bool {
    return self.scalars.any && self.scalars.allSatisfy { element in
      let scalar = Self.toUnicodeScalar(element)
      return scalar.properties.generalCategory == .decimalNumber
    }
  }

  /// Return true if all characters in the string are digits
  /// and there is at least one character.
  /// Formally, a digit is a character that has the property value
  /// Numeric_Type=Digit or Numeric_Type=Decimal.
  /// https://docs.python.org/3/library/stdtypes.html#str.isdigit
  internal var isDigit: Bool {
    return self.scalars.any && self.scalars.allSatisfy { element in
      let scalar = Self.toUnicodeScalar(element)
      guard let numericType = scalar.properties.numericType else {
        return false
      }

      return numericType == .digit || numericType == .decimal
    }
  }

  /// Return true if all cased characters 4 in the string are lowercase
  /// and there is at least one cased character.
  /// https://docs.python.org/3/library/stdtypes.html#str.islower
  internal var isLower: Bool {
    // If the character does not have case then True, for example:
    // "a\u02B0b".islower() -> True
    return self.scalars.any && self.scalars.allSatisfy { element in
      let scalar = Self.toUnicodeScalar(element)
      let properties = scalar.properties
      return !properties.isCased || properties.isLowercase
    }
  }

  /// Return true if all cased characters 4 in the string are uppercase
  /// and there is at least one cased character.
  /// https://docs.python.org/3/library/stdtypes.html#str.isupper
  internal var isUpper: Bool {
    return self.scalars.any && self.scalars.allSatisfy { element in
      let scalar = Self.toUnicodeScalar(element)
      let properties = scalar.properties
      return !properties.isCased || properties.isUppercase
    }
  }

  /// Return true if all characters in the string are numeric characters,
  /// and there is at least one character.
  /// Formally, numeric characters are those with the property value
  /// Numeric_Type=Digit, Numeric_Type=Decimal or Numeric_Type=Numeric.
  /// https://docs.python.org/3/library/stdtypes.html#str.isnumeric
  internal var isNumeric: Bool {
    return self.scalars.any && self.scalars.allSatisfy { element in
      let scalar = Self.toUnicodeScalar(element)
      return scalar.properties.numericType != nil
    }
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
  internal var isPrintable: Bool {
    // We do not have to check if 'self.scalars.any'!
    return self.scalars.allSatisfy(self.isPrintable(element:))
  }

  private func isPrintable(element: Element) -> Bool {
    let scalar = Self.toUnicodeScalar(element)
    return self.isPrintable(scalar: scalar)
  }

  internal func isPrintable(scalar: UnicodeScalar) -> Bool {
    if scalar == " " { // 'space' is considered printable
      return true
    }

    switch scalar.properties.generalCategory {
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

  /// Return true if there are only whitespace characters in the string
  /// and there is at least one character.
  /// A character is whitespace if in the Unicode character database:
  /// - its general category is Zs (“Separator, space”)
  /// - or its bidirectional class is one of WS, B, or S
  /// https://docs.python.org/3/library/stdtypes.html#str.isspace
  internal var isSpace: Bool {
    return self.scalars.any && self.scalars.allSatisfy { element in
      let scalar = Self.toUnicodeScalar(element)
      return scalar.properties.generalCategory == .spaceSeparator
        || Unicode.bidiClass_ws_b_s.contains(scalar.value)
    }
  }

  /// Return true if the string is a title-cased string and there is at least
  /// one character, for example uppercase characters may only follow uncased
  /// characters and lowercase characters only cased ones.
  /// https://docs.python.org/3/library/stdtypes.html#str.istitle
  internal var isTitle: Bool {
    var cased = false
    var isPreviousCased = false
    for element in self.scalars {
      let scalar = Self.toUnicodeScalar(element)
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

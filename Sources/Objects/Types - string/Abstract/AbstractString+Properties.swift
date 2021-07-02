extension AbstractString {

  // MARK: - AlphaNumeric

  /// Return true if all characters in the string are alphanumeric
  /// and there is at least one character.
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isAlphaNumeric() -> Bool {
    if self.elements.isEmpty {
      return false
    }

    return self.elements.allSatisfy(Self._isAlphaNumeric(element:))
  }

  // MARK: - Alpha

  /// Return true if all characters in the string are alphabetic
  /// and there is at least one character.
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isAlpha() -> Bool {
    if self.elements.isEmpty {
      return false
    }

    return self.elements.allSatisfy(Self._isAlpha(element:))
  }

  // MARK: - ASCII

  /// Return true if the string is empty or all characters in the string are ASCII.
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isAscii() -> Bool {
    if self.elements.isEmpty {
      return false
    }

    return self.elements.allSatisfy(Self._isAscii(element:))
  }

  // MARK: - Digit

  /// Return true if all characters in the string are digits
  /// and there is at least one character.
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isDigit() -> Bool {
    if self.elements.isEmpty {
      return false
    }

    return self.elements.allSatisfy(Self._isDigit(element:))
  }

  // MARK: - Lower

  /// Return true if all cased characters 4 in the string are lowercase
  /// and there is at least one cased character.
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isLower() -> Bool {
    if self.elements.isEmpty {
      return false
    }

    return self.elements.allSatisfy(Self._isLower(element:))
  }

  // MARK: - Upper

  /// Return true if all cased characters 4 in the string are uppercase
  /// and there is at least one cased character.
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isUpper() -> Bool {
    if self.elements.isEmpty {
      return false
    }

    return self.elements.allSatisfy(Self._isUpper(element:))
  }

  // MARK: - Space

  /// Return true if there are only whitespace characters in the string
  /// and there is at least one character.
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isSpace() -> Bool {
    if self.elements.isEmpty {
      return false
    }

    return self.elements.allSatisfy(Self._isSpace(element:))
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

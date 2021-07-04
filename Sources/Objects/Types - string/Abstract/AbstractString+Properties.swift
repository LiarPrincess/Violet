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

    return self.elements.allSatisfy(Self._isWhitespace(element:))
  }

  // MARK: - Title

  /// Return true if the string is a title-cased string and there is at least
  /// one character.
  ///
  /// In a title-cased string, upper- and title-case characters may only
  /// follow uncased characters and lowercase characters only cased ones.
  /// https://docs.python.org/3/library/stdtypes.html#str.istitle
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _isTitle() -> Bool {
    func isUpperOrTitle(element: Element) -> Bool {
      return Self._isUpper(element: element) || Self._isTitle(element: element)
    }

    // Shortcut for single character strings
    if let first = self.elements.first, self.elements.count == 1 {
      return isUpperOrTitle(element: first)
    }

    var cased = false
    var isPreviousCased = false

    for element in self.elements {
      let isElementCased = Self._isCased(element: element)

      if isElementCased && Self._isLower(element: element) {
        if !isPreviousCased {
          return false
        }

        cased = true
        isPreviousCased = true
        continue
      }

      if isElementCased && isUpperOrTitle(element: element) {
        if isPreviousCased {
          return false
        }

        isPreviousCased = true
        cased = true
        continue
      }

      isPreviousCased = false
    }

    return cased
  }
}

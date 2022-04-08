extension AbstractString {

  // MARK: - Alpha numeric

  /// Return true if all characters in the string are alphanumeric
  /// and there is at least one character.
  internal static func abstractIsAlphaNumeric(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "isalnum")
    }

    let result = !zelf.isEmpty && zelf.elements.allSatisfy(Self.isAlphaNumeric(element:))
    return PyResult(py, result)
  }

  // MARK: - Alpha

  /// Return true if all characters in the string are alphabetic
  /// and there is at least one character.
  internal static func abstractIsAlpha(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "isalpha")
    }

    let result = !zelf.isEmpty && zelf.elements.allSatisfy(Self.isAlpha(element:))
    return PyResult(py, result)
  }

  // MARK: - ASCII

  /// Return true if the string is empty or all characters in the string are ASCII.
  internal static func abstractIsAscii(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "isascii")
    }

    let result = !zelf.isEmpty && zelf.elements.allSatisfy(Self.isAscii(element:))
    return PyResult(py, result)
  }

  // MARK: - Digit

  /// Return true if all characters in the string are digits
  /// and there is at least one character.
  internal static func abstractIsDigit(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "isdigit")
    }

    let result = !zelf.isEmpty && zelf.elements.allSatisfy(Self.isDigit(element:))
    return PyResult(py, result)
  }

  // MARK: - Lower

  /// Return true if all cased characters 4 in the string are lowercase
  /// and there is at least one cased character.
  internal static func abstractIsLower(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "islower")
    }

    let result = !zelf.isEmpty && zelf.elements.allSatisfy(Self.isLower(element:))
    return PyResult(py, result)
  }

  // MARK: - Upper

  /// Return true if all cased characters 4 in the string are uppercase
  /// and there is at least one cased character.
  internal static func abstractIsUpper(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "isupper")
    }

    let result = !zelf.isEmpty && zelf.elements.allSatisfy(Self.isUpper(element:))
    return PyResult(py, result)
  }

  // MARK: - Space

  /// Return true if there are only whitespace characters in the string
  /// and there is at least one character.
  internal static func abstractIsSpace(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "isspace")
    }

    let result = !zelf.isEmpty && zelf.elements.allSatisfy(Self.isWhitespace(element:))
    return PyResult(py, result)
  }

  // MARK: - Title

  /// Return true if the string is a title-cased string and there is at least
  /// one character.
  ///
  /// In a title-cased string, upper- and title-case characters may only
  /// follow uncased characters and lowercase characters only cased ones.
  /// https://docs.python.org/3/library/stdtypes.html#str.istitle
  internal static func abstractIsTitle(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "istitle")
    }

    // Shortcut for single character strings
    if let first = zelf.elements.first, zelf.count == 1 {
      let result = Self.isUpperOrTitle(element: first)
      return PyResult(py, result)
    }

    var cased = false
    var isPreviousCased = false

    for element in zelf.elements {
      let isElementCased = Self.isCased(element: element)

      if isElementCased && Self.isLower(element: element) {
        if !isPreviousCased {
          return PyResult(py, false)
        }

        cased = true
        isPreviousCased = true
        continue
      }

      if isElementCased && Self.isUpperOrTitle(element: element) {
        if isPreviousCased {
          return PyResult(py, false)
        }

        isPreviousCased = true
        cased = true
        continue
      }

      isPreviousCased = false
    }

    return PyResult(py, cased)
  }

  private static func isUpperOrTitle(element: Element) -> Bool {
    return Self.isUpper(element: element) || Self.isTitle(element: element)
  }
}

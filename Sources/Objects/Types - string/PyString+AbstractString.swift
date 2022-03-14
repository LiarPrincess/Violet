import UnicodeData

extension PyString {

  // MARK: - Types

  internal typealias Element = UnicodeScalar
  internal typealias Elements = String.UnicodeScalarView
  internal typealias Builder = UnicodeScalarBuilder
  internal typealias ElementSwiftType = PyString

  // MARK: - Defaults

  internal static let defaultFill: UnicodeScalar = " "
  internal static let zFill: UnicodeScalar = "0"

  // MARK: - To object

  internal static func newObject(_ py: Py, element: UnicodeScalar) -> Self {
    return py.newString(scalar: element)
  }

  internal static func newObject(_ py: Py, elements: String.UnicodeScalarView) -> Self {
    return py.newString(elements)
  }

  internal static func newObject(_ py: Py, elements: Substring.UnicodeScalarView) -> Self {
    return py.newString(elements)
  }

  internal static func newObject(_ py: Py, result: String) -> Self {
    return py.newString(result)
  }

  // MARK: - Get elements

  internal static func getElements(_ py: Py, object: PyObject) -> Elements? {
    if let string = Self.downcast(py, object) {
      return string.elements
    }

    return nil
  }

  internal static func getElementsForFindCountContainsIndexOf(
    _ py: Py,
    object: PyObject
  ) -> AbstractStringElementsForFindCountContainsIndexOf<Elements> {
    // Nothing special here, only 'str' can be used in 'find', 'count' etc… '.
    if let string = Self.downcast(py, object) {
      return .value(string.elements)
    }

    return .invalidObjectType
  }

  // MARK: - Whitespace

  /// A character is whitespace if in the Unicode character database:
  /// - its general category is Zs (“Separator, space”)
  /// - or its bidirectional class is one of WS, B, or S
  /// https://docs.python.org/3/library/stdtypes.html#str.isspace
  ///
  internal static func isWhitespace(element: UnicodeScalar) -> Bool {
    return UnicodeData.isWhitespace(element)
  }

  // MARK: - Line break

  /// This is not exposed to Python, but it is used in various methods
  /// (for example `splitlines`).
  ///
  internal static func isLineBreak(element: UnicodeScalar) -> Bool {
    return UnicodeData.isLineBreak(element)
  }

  // MARK: - Alpha numeric

  /// A character c is alphanumeric if one of the following returns True:
  /// c.isalpha(), c.isdecimal(), c.isdigit(), or c.isnumeric()
  /// https://docs.python.org/3/library/stdtypes.html#str.isalnum
  ///
  internal static func isAlphaNumeric(element: UnicodeScalar) -> Bool {
    return UnicodeData.isAlphaNumeric(element)
  }

  // MARK: - Alpha

  /// Alphabetic characters are those characters defined in the Unicode character
  /// database as “Letter”, i.e., those with general category property
  /// being one of “Lm”, “Lt”, “Lu”, “Ll”, or “Lo”.
  /// https://docs.python.org/3/library/stdtypes.html#str.isalpha
  ///
  internal static func isAlpha(element: UnicodeScalar) -> Bool {
    return UnicodeData.isAlpha(element)
  }

  // MARK: - ASCII

  /// ASCII characters have code points in the range U+0000-U+007F.
  /// https://docs.python.org/3/library/stdtypes.html#str.isascii
  ///
  internal static func isAscii(element: UnicodeScalar) -> Bool {
    return ASCIIData.isASCII(element)
  }

  // MARK: - Decimal

  /// Formally a decimal character is a character in the Unicode General
  /// Category “Nd”.
  /// https://docs.python.org/3/library/stdtypes.html#str.isdecimal
  ///
  internal static func isDecimal(element: UnicodeScalar) -> Bool {
    return UnicodeData.isDecimalDigit(element)
  }

  // MARK: - Digit

  /// Formally, a digit is a character that has the property value
  /// Numeric_Type=Digit or Numeric_Type=Decimal.
  /// https://docs.python.org/3/library/stdtypes.html#str.isdigit
  ///
  internal static func isDigit(element: UnicodeScalar) -> Bool {
    return UnicodeData.isDigit(element)
  }

  // MARK: - Lower

  /// https://docs.python.org/3/library/stdtypes.html#str.islower
  ///
  internal static func isLower(element: UnicodeScalar) -> Bool {
    // If a character does not have case then True, for example:
    // "a\u02B0b".islower() -> True
    return !UnicodeData.isCased(element) || UnicodeData.isLowercase(element)
  }

  internal static func lowercaseMapping(
    element: UnicodeScalar
  ) -> UnicodeData.CaseMapping {
    return UnicodeData.toLowercase(element)
  }

  // MARK: - Upper

  /// https://docs.python.org/3/library/stdtypes.html#str.isupper
  ///
  internal static func isUpper(element: UnicodeScalar) -> Bool {
    // If a character does not have case then True, for example:
    // "a\u02B0b".isupper() -> True
    return !UnicodeData.isCased(element) || UnicodeData.isUppercase(element)
  }

  internal static func uppercaseMapping(
    element: UnicodeScalar
  ) -> UnicodeData.CaseMapping {
    return UnicodeData.toUppercase(element)
  }

  // MARK: - Numeric

  /// Formally, numeric characters are those with the property value
  /// Numeric_Type=Digit, Numeric_Type=Decimal or Numeric_Type=Numeric.
  /// https://docs.python.org/3/library/stdtypes.html#str.isnumeric
  ///
  internal static func isNumeric(element: UnicodeScalar) -> Bool {
    return UnicodeData.isNumeric(element)
  }

  // MARK: - Title

  internal static func isTitle(element: UnicodeScalar) -> Bool {
    return UnicodeData.isTitlecase(element)
  }

  internal static func titlecaseMapping(
    element: UnicodeScalar
  ) -> UnicodeData.CaseMapping {
    return UnicodeData.toTitlecase(element)
  }

  // MARK: - Is cased

  internal static func isCased(element: UnicodeScalar) -> Bool {
    return UnicodeData.isCased(element)
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
  internal static func isPrintable(element: UnicodeScalar) -> Bool {
    return UnicodeData.isPrintable(element)
  }

  // MARK: - Specific characters

  /// Is this `+` or `-` (`0x2B` and `0x2D` in ASCII respectively).
  /// Used inside `zfill`.
  ///
  internal static func isPlusOrMinus(element: UnicodeScalar) -> Bool {
    let value = element.value
    return value == 0x2b || value == 0x2d
  }

  /// Is this `HT` (`0x09` in ASCII)?
  /// Used inside `expandTabs`.
  ///
  internal static func isHorizontalTab(element: UnicodeScalar) -> Bool {
    let value = element.value
    return value == 0x09
  }

  /// Is this `CR` (`0x0D` in ASCII)?
  /// Used inside `splitLines`.
  ///
  internal static func isCarriageReturn(element: UnicodeScalar) -> Bool {
    let value = element.value
    return value == 0x0d
  }

  /// Is this `LF` (`0x0A` in ASCII)?
  /// Used inside `splitLines`.
  ///
  internal static func isLineFeed(element: UnicodeScalar) -> Bool {
    let value = element.value
    return value == 0x0a
  }
}

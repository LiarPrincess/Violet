// In CPython:
// - Objects/unicodectype.c
// - Tools/unicode/makeunicodedata.py - generation script

public enum UnicodeData {

  private static func getTypeRecord(_ code: UInt32) -> Record {
    var index: Int

    if code >= 0x110000 {
      index = 0
    } else {
      let codeInt = Int(code)

      let fromIndex1 = index1[(codeInt >> SHIFT)]
      index = Int(fromIndex1)

      let fromIndex2 = index2[(index << SHIFT) + (codeInt & ((1 << SHIFT) - 1))]
      index = Int(fromIndex2)
    }

    return _PyUnicode_TypeRecords[index]
  }

  // MARK: - Lowercase

  /// Checks if Unicode character has category `Ll`.
  public static func isLowercase(_ ch: UnicodeScalar) -> Bool {
    let ctype = Self.getTypeRecord(ch.value)
    return ctype.isLower
  }

  /// Returns the lowercase Unicode characters corresponding to `ch` or just
  /// `ch` if no lowercase mapping is known.
  public static func toLowercase(_ ch: UnicodeScalar) -> CaseMapping {
    let ctype = Self.getTypeRecord(ch.value)

    if ctype.isExtendedCase {
      return _PyUnicode_ExtendedCase[ctype.lower]
    }

    let value = Int(ch.value) + ctype.lower
    return CaseMapping(value)
  }

  // MARK: - Uppercase

  /// Checks if Unicode character has category `Lu`.
  public static func isUppercase(_ ch: UnicodeScalar) -> Bool {
    let ctype = Self.getTypeRecord(ch.value)
    return ctype.isUpper
  }

  /// Returns the uppercase Unicode characters corresponding to `ch` or just
  /// `ch` if no uppercase mapping is known.
  public static func toUppercase(_ ch: UnicodeScalar) -> CaseMapping {
    let ctype = Self.getTypeRecord(ch.value)

    if ctype.isExtendedCase {
      return _PyUnicode_ExtendedCase[ctype.upper]
    }

    let value = Int(ch.value) + ctype.upper
    return CaseMapping(value)
  }

  // MARK: - Titlecase

  /// Checks if Unicode character has category `Lt`.
  public static func isTitlecase(_ ch: UnicodeScalar) -> Bool {
    let ctype = Self.getTypeRecord(ch.value)
    return ctype.isTitle
  }

  /// Returns the titlecase Unicode characters corresponding to `ch` or just
  /// `ch` if no titlecase mapping is known.
  public static func toTitlecase(_ ch: UnicodeScalar) -> CaseMapping {
    let ctype = Self.getTypeRecord(ch.value)

    if ctype.isExtendedCase {
      return _PyUnicode_ExtendedCase[ctype.title]
    }

    let value = Int(ch.value) + ctype.title
    return CaseMapping(value)
  }

  // MARK: - Casefold

  public static func toCasefold(_ ch: UnicodeScalar) -> CaseMapping {
    if let mapping = Unicode.caseFoldMapping[ch.value] {
      let scalars = Array(mapping.unicodeScalars)
      switch scalars.count {
      case 1: return CaseMapping(scalars[0])
      case 2: return CaseMapping(scalars[0], scalars[1])
      case 3: return CaseMapping(scalars[0], scalars[1], scalars[2])
      default: fatalError("Too long?")
      }
    }

    return CaseMapping(ch)
  }

  // MARK: - Cased/Case ignorable

  public static func isCased(_ ch: UnicodeScalar) -> Bool {
    let ctype = Self.getTypeRecord(ch.value)

    return ctype.isCased
  }

  public static func isCaseIgnorable(_ ch: UnicodeScalar) -> Bool {
    let ctype = Self.getTypeRecord(ch.value)
    return ctype.isCaseIgnorable
  }

  // MARK: - Alpha

  /// Checks if Unicode character has category `Ll`, `Lu`, `Lt`, `Lo` or `Lm`.
  public static func isAlpha(_ ch: UnicodeScalar) -> Bool {
    let ctype = Self.getTypeRecord(ch.value)
    return ctype.isAlpha
  }

  // MARK: - Alpha numeric

  public static func isAlphaNumeric(_ ch: UnicodeScalar) -> Bool {
//    #define Py_UNICODE_ISALNUM(ch) \
//           (Py_UNICODE_ISALPHA(ch) || \
//        Py_UNICODE_ISDECIMAL(ch) || \
//        Py_UNICODE_ISDIGIT(ch) || \
//        Py_UNICODE_ISNUMERIC(ch))
    let ctype = Self.getTypeRecord(ch.value)
    return ctype.isAlpha || ctype.isDecimal || ctype.isDigit || ctype.isNumeric
  }

  // MARK: - Whitespace

  public static func isWhitespace(_ ch: UnicodeScalar) -> Bool {
    return _PyUnicode_IsWhitespace(ch)
  }

  // MARK: - Line break

  public static func isLineBreak(_ ch: UnicodeScalar) -> Bool {
    return _PyUnicode_IsLineBreak(ch)
  }

  // MARK: - Id

  /// Checks if Unicode character has the `XID_Start` property.
  public static func isXidStart(_ ch: UnicodeScalar) -> Bool {
    let ctype = Self.getTypeRecord(ch.value)
    return ctype.isXidStart
  }

  /// Checks if Unicode character has the `XID_Continue` property.
  public static func isXidContinue(_ ch: UnicodeScalar) -> Bool {
    let ctype = Self.getTypeRecord(ch.value)
    return ctype.isXidContinue
  }

  // MARK: - Decimal digit

  public static func isDecimalDigit(_ ch: UnicodeScalar) -> Bool {
    let value = Self.toDecimalDigit(ch)
    return value != nil
  }

  /// Returns the integer decimal (0-9) for Unicode characters having this property.
  public static func toDecimalDigit(_ ch: UnicodeScalar) -> UInt8? {
    let ctype = Self.getTypeRecord(ch.value)
    return ctype.isDecimal ? ctype.decimal : nil
  }

  // MARK: - Digit

  public static func isDigit(_ ch: UnicodeScalar) -> Bool {
    let value = Self.toDigit(ch)
    return value != nil
  }

  /// Returns the integer digit (0-9) for Unicode characters having this property.
  public static func toDigit(_ ch: UnicodeScalar) -> UInt8? {
    let ctype = Self.getTypeRecord(ch.value)
    return ctype.isDigit ? ctype.digit : nil
  }

  // MARK: - Numeric

  public static func isNumeric(_ ch: UnicodeScalar) -> Bool {
    let ctype = Self.getTypeRecord(ch.value)
    return ctype.isNumeric
  }

  // MARK: - Printable

  /// Returns 1 for Unicode characters to be hex-escaped when repr()ed, 0 otherwise.
  ///
  /// All characters except those characters defined in the Unicode character
  /// database as following categories are considered printable.
  ///  * Cc (Other, Control)
  ///  * Cf (Other, Format)
  ///  * Cs (Other, Surrogate)
  ///  * Co (Other, Private Use)
  ///  * Cn (Other, Not Assigned)
  ///  * Zl Separator, Line ('\u2028', LINE SEPARATOR)
  ///  * Zp Separator, Paragraph ('\u2029', PARAGRAPH SEPARATOR)
  ///  * Zs (Separator, Space) other than ASCII space('\x20').
  public static func isPrintable(_ ch: UnicodeScalar) -> Bool {
    let ctype = Self.getTypeRecord(ch.value)
    return ctype.isPrintable
  }
}

// Use following code:
//
// if __name__ == '__main__':
//     b = bytearray(1)
//
//     group_start = None
//     previous = False
//     for i in range(0, 256):
//         b[0] = i
//         current = b.isalnum()
//
//         is_starting_series = current and not previous
//         is_inside_series = current and previous
//         is_ending_series = previous and not current
//
//         if is_starting_series:
//             assert not group_start
//             group_start = i
//         elif is_inside_series:
//             pass
//         elif is_ending_series:
//             group_end = i
//             has_single_member = group_start == (group_end - 1)
//
//             if has_single_member:
//                 print(f'element == {group_start}')
//             else:
//                 print(f'({group_start} <= element && element < {group_end})')
//
//             group_start = None
//         # else: in inside non-series, so whatever
//
//         previous = current
//
//     assert not group_start
public enum ASCIIData {

  // MARK: - Is

  public static func isASCII(_ ch: UInt8) -> Bool {
    return ch < 128
  }

  public static func isASCII(_ ch: UnicodeScalar) -> Bool {
    return ch.value < 128
  }

  // MARK: - To ASCII

  private static func toASCII(_ ch: UnicodeScalar) -> UInt8 {
    assert(Self.isASCII(ch), "'\(ch)' is not an ASCII character!")
    return UInt8(truncatingIfNeeded: ch.value)
  }

  // MARK: - Lowercase

  /// Checks if Unicode character has category `Ll`.
  public static func isLowercase(_ ch: UInt8) -> Bool {
    return 97 <= ch && ch < 123
  }

  /// Checks if Unicode character has category `Ll`.
  public static func isLowercase(_ ch: UnicodeScalar) -> Bool {
    return 97 <= ch.value && ch.value < 123
  }

  /// Returns the lowercase Unicode characters corresponding to `ch` or just
  /// `ch` if no lowercase mapping is known.
  public static func toLowercase(_ ch: UInt8) -> UInt8 {
    // == This is copied from Swift sources ==

    /// A "table" for which ASCII characters need to be lower cased.
    /// To determine which bit corresponds to which ASCII character, subtract 1
    /// from the ASCII value of that character and divide by 2. The bit is set iff
    /// that character is a upper case character.
    let _uppercaseTable: UInt64 =
      0b0000_0000_0000_0000_0001_1111_1111_1111 &<< 32

    // Lookup if it should be shifted in our ascii table, then we add 0x20 if
    // it should, 0x0 if not.
    // This code is equivalent to:
    // switch sourceX {
    // case let x where (x >= 0x41 && x <= 0x5a):
    //   return x &- 0x20
    // case let x:
    //   return x
    // }
    let isUpper = _uppercaseTable &>> UInt64(((ch &- 1) & 0b0111_1111) &>> 1)
    let toAdd = (isUpper & 0x1) &<< 5
    return ch &+ UInt8(truncatingIfNeeded: toAdd)
  }

  /// Returns the lowercase Unicode characters corresponding to `ch` or just
  /// `ch` if no lowercase mapping is known.
  public static func toLowercase(_ ch: UnicodeScalar) -> UnicodeScalar {
    let ascii = Self.toASCII(ch)
    let value = Self.toLowercase(ascii)
    return UnicodeScalar(value)
  }

  // MARK: - Uppercase

  /// Checks if Unicode character has category `Lu`.
  public static func isUppercase(_ ch: UInt8) -> Bool {
    return 65 <= ch && ch < 91
  }

  /// Checks if Unicode character has category `Lu`.
  public static func isUppercase(_ ch: UnicodeScalar) -> Bool {
    return 65 <= ch.value && ch.value < 91
  }

  public static func toUppercase(_ ch: UInt8) -> UInt8 {
    // == This is copied from Swift sources ==

    /// A "table" for which ASCII characters need to be upper cased.
    /// To determine which bit corresponds to which ASCII character, subtract 1
    /// from the ASCII value of that character and divide by 2. The bit is set iff
    /// that character is a lower case character.
    let _lowercaseTable: UInt64 =
      0b0001_1111_1111_1111_0000_0000_0000_0000 &<< 32

    // Lookup if it should be shifted in our ascii table, then we subtract 0x20 if
    // it should, 0x0 if not.
    // This code is equivalent to:
    // switch sourceX {
    // case let x where (x >= 0x41 && x <= 0x5a):
    //   return x &- 0x20
    // case let x:
    //   return x
    // }
    let isLower = _lowercaseTable &>> UInt64(((ch &- 1) & 0b0111_1111) &>> 1)
    let toSubtract = (isLower & 0x1) &<< 5
    return ch &- UInt8(truncatingIfNeeded: toSubtract)
  }

  /// Returns the uppercase Unicode characters corresponding to `ch` or just
  /// `ch` if no uppercase mapping is known.
  public static func toUppercase(_ ch: UnicodeScalar) -> UnicodeScalar {
    let ascii = Self.toASCII(ch)
    let value = Self.toUppercase(ascii)
    return UnicodeScalar(value)
  }

  // MARK: - Titlecase

  /// Checks if Unicode character has category `Lt`.
  public static func isTitlecase(_ ch: UInt8) -> Bool {
    return false
  }

  /// Checks if Unicode character has category `Lt`.
  public static func isTitlecase(_ ch: UnicodeScalar) -> Bool {
    return false
  }

  /// Returns the titlecase Unicode characters corresponding to `ch` or just
  /// `ch` if no titlecase mapping is known.
  public static func toTitlecase(_ ch: UInt8) -> UInt8 {
    return Self.toUppercase(ch)
  }

  /// Returns the titlecase Unicode characters corresponding to `ch` or just
  /// `ch` if no titlecase mapping is known.
  public static func toTitlecase(_ ch: UnicodeScalar) -> UnicodeScalar {
    return Self.toUppercase(ch)
  }

  // MARK: - Cased

  public static func isCased(_ ch: UInt8) -> Bool {
    return (65 <= ch && ch < 91) // uppercase
      || (97 <= ch && ch < 123) // lowercase
  }

  public static func isCased(_ ch: UnicodeScalar) -> Bool {
    let value = ch.value
    return (65 <= value && value < 91) // uppercase
      || (97 <= value && value < 123) // lowercase
  }

  // MARK: - Alpha

  /// Checks if Unicode character has category `Ll`, `Lu`, `Lt`, `Lo` or `Lm`.
  public static func isAlpha(_ ch: UInt8) -> Bool {
   return (65 <= ch && ch < 91) // uppercase
         || (97 <= ch && ch < 123) // lowercase
  }

  /// Checks if Unicode character has category `Ll`, `Lu`, `Lt`, `Lo` or `Lm`.
  public static func isAlpha(_ ch: UnicodeScalar) -> Bool {
   let value = ch.value
   return (65 <= value && value < 91) // uppercase
         || (97 <= value && value < 123) // lowercase
  }

  // MARK: - Alpha numeric

  public static func isAlphaNumeric(_ ch: UInt8) -> Bool {
    return (48 <= ch && ch < 58) // digits
          || (65 <= ch && ch < 91) // uppercase
          || (97 <= ch && ch < 123) // lowercase
  }

  public static func isAlphaNumeric(_ ch: UnicodeScalar) -> Bool {
    let value = ch.value
    return (48 <= value && value < 58) // digits
          || (65 <= value && value < 91) // uppercase
          || (97 <= value && value < 123) // lowercase
  }

  // MARK: - Whitespace

  public static func isWhitespace(_ ch: UInt8) -> Bool {
    // Modify the program with following:
    // b = bytearray(2)
    //
    // b[0] = i
    // b[1] = 65
    //
    // stripped = b.strip()
    // has_len_changed = len(b) != len(stripped)
    // current = has_len_changed

    // Horizontal Tab, Line Feed, Vertical Tab, Form Feed, Carriage Return
    // File separator, Group separator, Record separator, Unit separator, Space
    return (9 <= ch && ch < 14) || (28 <= ch && ch < 33)
  }

  public static func isWhitespace(_ ch: UnicodeScalar) -> Bool {
    // See 'UInt8' version for details.
    let value = ch.value
    return (9 <= value && value < 14) || (28 <= value && value < 33)
  }

  // MARK: - Line break

  public static func isLineBreak(_ ch: UInt8) -> Bool {
    // Modify the program with following:
    // b = bytearray(3)
    //
    // b[0] = 65
    // b[1] = i
    // b[2] = 66
    //
    // split = b.splitlines()
    // has_many_lines = len(split) != 1
    // current = has_many_lines

    // Line Feed, Vertical Tab, Form Feed, Carriage Return
    // File separator, Group separator, Record separator, Unit separator
    return (10 <= ch && ch < 14) || (28 <= ch && ch < 31)
  }

  public static func isLineBreak(_ ch: UnicodeScalar) -> Bool {
    // See 'UInt8' version for details.
    let value = ch.value
    return (10 <= value && value < 14) || (28 <= value && value < 31)
  }

  // MARK: - Decimal digit

  public static func isDecimalDigit(_ ch: UInt8) -> Bool {
    return Self.isDigit(ch)
  }

  public static func isDecimalDigit(_ ch: UnicodeScalar) -> Bool {
    return Self.isDigit(ch)
  }

  /// Returns the integer decimal (0-9) for Unicode characters having this property.
  public static func toDecimalDigit(_ ch: UInt8) -> UInt8? {
    return Self.toDigit(ch)
  }

  /// Returns the integer decimal (0-9) for Unicode characters having this property.
  public static func toDecimalDigit(_ ch: UnicodeScalar) -> UInt8? {
    return Self.toDigit(ch)
  }

  // MARK: - Digit

  public static func isDigit(_ ch: UInt8) -> Bool {
    return 48 <= ch && ch < 58
  }

  public static func isDigit(_ ch: UnicodeScalar) -> Bool {
    return 48 <= ch.value && ch.value < 58
  }

  /// Returns the integer digit (0-9) for Unicode characters having this property.
  public static func toDigit(_ ch: UInt8) -> UInt8? {
    return Self.isDigit(ch) ? UInt8(truncatingIfNeeded: ch) - 48 : nil
  }

  /// Returns the integer digit (0-9) for Unicode characters having this property.
  public static func toDigit(_ ch: UnicodeScalar) -> UInt8? {
    return Self.isDigit(ch) ? UInt8(truncatingIfNeeded: ch.value) - 48 : nil
  }
}

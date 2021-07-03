import Foundation
import VioletCore

// swiftlint:disable yoda_condition

extension Data {
  // This is safe and does not require heap allocation.
  fileprivate init(byte: UInt8) {
    self = Data(repeating: byte, count: 1)
  }
}

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
extension AbstractBytes {

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _asUnicodeScalar(element: UInt8) -> UnicodeScalar {
    return UnicodeScalar(element)
  }

  // MARK: - Whitespace

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _isWhitespace(element: UInt8) -> Bool {
    // Modify the program with following:
    // b = bytearray(2)
    //
    // b[0] = i
    // b[1] = 65
    //
    // stripped = b.strip()
    // has_len_changed = len(b) != len(stripped)
    // current = has_len_changed

    // Space
    // Horizontal Tab, Line Feed, Vertical Tab, Form Feed, Carriage Return
    return element == 32 || (9 <= element && element < 14)
  }

  // MARK: - Line break

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _isLineBreak(element: UInt8) -> Bool {
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
    return element == 10 || element == 13 // Line Feed, Carriage Return
  }

  // MARK: - AlphaNumeric

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _isAlphaNumeric(element: UInt8) -> Bool {
    return (48 <= element && element < 58)  // digits
      || (65 <= element && element < 91) // uppercase
      || (97 <= element && element < 123) // lowercase
  }

  // MARK: - Alpha

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _isAlpha(element: UInt8) -> Bool {
    return (65 <= element && element < 91) // uppercase
      || (97 <= element && element < 123) // lowercase
  }

  // MARK: - ASCII

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _isAscii(element: UInt8) -> Bool {
    return 0 <= element && element < 128
  }

  // MARK: - Digit

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _isDigit(element: UInt8) -> Bool {
    return 48 <= element && element < 58
  }

  // MARK: - Lower

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _isLower(element: UInt8) -> Bool {
    return 97 <= element && element < 123
  }

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _lowercaseMapping(element: UInt8) -> Data {
    if 65 <= element && element < 91 {
      let mapping = element + 32
      return Data(byte: mapping)
    }

    return Data(byte: element)
  }

  // MARK: - Upper

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _isUpper(element: UInt8) -> Bool {
    return 65 <= element && element < 91
  }

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _uppercaseMapping(element: UInt8) -> Data {
    if 97 <= element && element < 123 {
      let mapping = element - 32
      return Data(byte: mapping)
    }

    return Data(byte: element)
  }

  // MARK: - Title

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _titlecaseMapping(element: UInt8) -> Data {
    if 97 <= element && element < 123 {
      let mapping = element - 32
      return Data(byte: mapping)
    }

    return Data(byte: element)
  }

  // MARK: - Is cased

  internal static func _isCased(element: UInt8) -> Bool {
    return (65 <= element && element < 91) // uppercase
      || (97 <= element && element < 123) // lowercase
  }

  // MARK: - Case

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal func _titleCaseBytes() -> SwiftType {
    let string = self._titleCase()
    return self._encode(string)
  }

  private func _encode(_ string: String) -> SwiftType {
    let encoding = Py.sys.defaultEncoding
    if let data = encoding.encode(string: string) {
      let result = Self._toObject(result: data)
      return result
    }

    let msg = "Violet error: Sometimes we convert 'bytes' to 'string' and back " +
      "(mostly when we really need string, for example to check for whitespaces). " +
      "Normally it works, but this time conversion back to bytes failed."
    trap(msg)
  }
}

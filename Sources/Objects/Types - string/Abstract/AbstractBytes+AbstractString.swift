import Foundation
import UnicodeData
import VioletCore

// MARK: - ASCII

/// \t
private let ascii_horizontal_tab: UInt8 = 9
/// LF, \n
private let ascii_line_feed: UInt8 = 10
/// CR, \r
private let ascii_carriage_return: UInt8 = 13
/// '
private let ascii_apostrophe: UInt8 = 39
private let ascii_slash: UInt8 = 47
private let ascii_backslash: UInt8 = 92
private let ascii_space: UInt8 = 32
private let ascii_zero: UInt8 = 48
private let ascii_endIndex: UInt8 = 127

// MARK: - Data + byte init

extension Data {
  // This is safe and does not require heap allocation.
  fileprivate init(byte: UInt8) {
    self = Data(repeating: byte, count: 1)
  }
}

extension AbstractBytes {

  internal static var _pythonTypeName: String {
    return "bytes"
  }

  internal var count: Int {
    // 'self.elements' has 'Data' type, so it is O(1).
    return self.elements.count
  }

  // MARK: - Defaults

  internal static var _defaultFill: UInt8 { return ascii_space }
  internal static var _zFill: UInt8 { return ascii_zero }

  // MARK: - Get elements

  internal static func _getElements(object: PyObject) -> Data? {
    if let bytes = PyCast.asAnyBytes(object) {
      return bytes.elements
    }

    return nil
  }

  internal static func _getElementsForFindCountContainsIndexOf(
    object: PyObject
  ) -> AbstractString_ElementsForFindCountContainsIndexOf<Data> {
    if let bytes = PyCast.asAnyBytes(object) {
      return .value(bytes.elements)
    }

    // For example: `49 in b'123'`.
    if let pyInt = PyCast.asInt(object) {
      guard let byte = UInt8(exactly: pyInt.value) else {
        let msg = "byte must be in range(0, 256)"
        return .error(Py.newValueError(msg: msg))
      }

      let data = Data(byte: byte)
      return .value(data)
    }

    return .invalidObjectType
  }

  // MARK: - Whitespace

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _isWhitespace(element: UInt8) -> Bool {
    return ASCIIData.isWhitespace(element)
  }

  // MARK: - Line break

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _isLineBreak(element: UInt8) -> Bool {
    return ASCIIData.isLineBreak(element)
  }

  // MARK: - AlphaNumeric

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _isAlphaNumeric(element: UInt8) -> Bool {
    return ASCIIData.isAlphaNumeric(element)
  }

  // MARK: - Alpha

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _isAlpha(element: UInt8) -> Bool {
    return ASCIIData.isAlpha(element)
  }

  // MARK: - ASCII

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _isAscii(element: UInt8) -> Bool {
    return ASCIIData.isASCII(element)
  }

  // MARK: - Digit

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _isDigit(element: UInt8) -> Bool {
    return ASCIIData.isDigit(element)
  }

  // MARK: - Lower

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _isLower(element: UInt8) -> Bool {
    return ASCIIData.isLowercase(element)
  }

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _lowercaseMapping(element: UInt8) -> UInt8 {
    return ASCIIData.toLowercase(element)
  }

  // MARK: - Upper

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _isUpper(element: UInt8) -> Bool {
    return ASCIIData.isUppercase(element)
  }

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _uppercaseMapping(element: UInt8) -> UInt8 {
    return ASCIIData.toUppercase(element)
  }

  // MARK: - Title

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _isTitle(element: UInt8) -> Bool {
    return ASCIIData.isTitlecase(element)
  }

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _titlecaseMapping(element: UInt8) -> UInt8 {
    return ASCIIData.toTitlecase(element)
  }

  // MARK: - Is cased

  internal static func _isCased(element: UInt8) -> Bool {
    return ASCIIData.isCased(element)
  }

  // MARK: - Specific characters

  /// Is this `+` or `-` (`0x2B` and `0x2D` in ASCII respectively).
  /// Used inside `zfill`.
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func isPlusOrMinus(element: UInt8) -> Bool {
    return element == 0x2b || element == 0x2d
  }

  /// Is this `HT` (`0x09` in ASCII)?
  /// Used inside `expandTabs`.
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func isHorizontalTab(element: UInt8) -> Bool {
    return element == 0x09
  }

  /// Is this `CR` (`0x0D` in ASCII)?
  /// Used inside `splitLines`.
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func isCarriageReturn(element: UInt8) -> Bool {
    return element == 0x0d
  }

  /// Is this `LF` (`0x0A` in ASCII)?
  /// Used inside `splitLines`.
  ///
  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal static func isLineFeed(element: UInt8) -> Bool {
    return element == 0x0a
  }
}

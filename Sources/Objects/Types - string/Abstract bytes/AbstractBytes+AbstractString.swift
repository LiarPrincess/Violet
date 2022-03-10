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

  internal static var defaultFill: UInt8 { return ascii_space }
  internal static var zFill: UInt8 { return ascii_zero }

  // MARK: - Get elements

  internal static func getElements(_ py: Py, object: PyObject) -> Data? {
    if let bytes = py.cast.asAnyBytes(object) {
      return bytes.elements
    }

    return nil
  }

  internal static func getElementsForFindCountContainsIndexOf(
    _ py: Py,
    object: PyObject
  ) -> AbstractStringElementsForFindCountContainsIndexOf<Data> {
    if let bytes = py.cast.asAnyBytes(object) {
      return .value(bytes.elements)
    }

    // For example: `49 in b'123'`.
    if let pyInt = py.cast.asInt(object) {
      guard let byte = UInt8(exactly: pyInt.value) else {
        let error = py.newValueError(message: "byte must be in range(0, 256)")
        return .error(error.asBaseException)
      }

      let data = Data(byte: byte)
      return .value(data)
    }

    return .invalidObjectType
  }

  // MARK: - Whitespace

  internal static func isWhitespace(element: UInt8) -> Bool {
    return ASCIIData.isWhitespace(element)
  }

  // MARK: - Line break

  internal static func isLineBreak(element: UInt8) -> Bool {
    return ASCIIData.isLineBreak(element)
  }

  // MARK: - AlphaNumeric

  internal static func isAlphaNumeric(element: UInt8) -> Bool {
    return ASCIIData.isAlphaNumeric(element)
  }

  // MARK: - Alpha

  internal static func isAlpha(element: UInt8) -> Bool {
    return ASCIIData.isAlpha(element)
  }

  // MARK: - ASCII

  internal static func isAscii(element: UInt8) -> Bool {
    return ASCIIData.isASCII(element)
  }

  // MARK: - Digit

  internal static func isDigit(element: UInt8) -> Bool {
    return ASCIIData.isDigit(element)
  }

  // MARK: - Lower

  internal static func isLower(element: UInt8) -> Bool {
    return ASCIIData.isLowercase(element)
  }

  internal static func lowercaseMapping(element: UInt8) -> UInt8 {
    return ASCIIData.toLowercase(element)
  }

  // MARK: - Upper

  internal static func isUpper(element: UInt8) -> Bool {
    return ASCIIData.isUppercase(element)
  }

  internal static func uppercaseMapping(element: UInt8) -> UInt8 {
    return ASCIIData.toUppercase(element)
  }

  // MARK: - Title

  internal static func isTitle(element: UInt8) -> Bool {
    return ASCIIData.isTitlecase(element)
  }

  internal static func titlecaseMapping(element: UInt8) -> UInt8 {
    return ASCIIData.toTitlecase(element)
  }

  // MARK: - Is cased

  internal static func isCased(element: UInt8) -> Bool {
    return ASCIIData.isCased(element)
  }

  // MARK: - Specific characters

  /// Is this `+` or `-` (`0x2B` and `0x2D` in ASCII respectively).
  /// Used inside `zfill`.
  ///
  internal static func isPlusOrMinus(element: UInt8) -> Bool {
    return element == 0x2b || element == 0x2d
  }

  /// Is this `HT` (`0x09` in ASCII)?
  /// Used inside `expandTabs`.
  ///
  internal static func isHorizontalTab(element: UInt8) -> Bool {
    return element == 0x09
  }

  /// Is this `CR` (`0x0D` in ASCII)?
  /// Used inside `splitLines`.
  ///
  internal static func isCarriageReturn(element: UInt8) -> Bool {
    return element == 0x0d
  }

  /// Is this `LF` (`0x0A` in ASCII)?
  /// Used inside `splitLines`.
  ///
  internal static func isLineFeed(element: UInt8) -> Bool {
    return element == 0x0a
  }
}

import Foundation
import VioletCore
import UnicodeData

extension Data {
  // This is safe and does not require heap allocation.
  fileprivate init(byte: UInt8) {
    self = Data(repeating: byte, count: 1)
  }
}

extension AbstractBytes {

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _asUnicodeScalar(element: UInt8) -> UnicodeScalar {
    return UnicodeScalar(element)
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
  internal static func _lowercaseMapping(element: UInt8) -> Data {
    let mapping = ASCIIData.toLowercase(element)
    return Data(byte: mapping)
  }

  // MARK: - Upper

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _isUpper(element: UInt8) -> Bool {
    return ASCIIData.isUppercase(element)
  }

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _uppercaseMapping(element: UInt8) -> Data {
    let mapping = ASCIIData.toUppercase(element)
    return Data(byte: mapping)
  }

  // MARK: - Title

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _isTitle(element: UInt8) -> Bool {
    return ASCIIData.isTitlecase(element)
  }

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _titlecaseMapping(element: UInt8) -> Data {
    let mapping = ASCIIData.toTitlecase(element)
    return Data(byte: mapping)
  }

  // MARK: - Is cased

  internal static func _isCased(element: UInt8) -> Bool {
    return ASCIIData.isCased(element)
  }
}

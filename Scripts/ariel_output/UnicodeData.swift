=======================
=== ASCIIData.swift ===
=======================

public enum ASCIIData {
  public static func isASCII(_ ch: UInt8) -> Bool
  public static func isASCII(_ ch: UnicodeScalar) -> Bool
  public static func isLowercase(_ ch: UInt8) -> Bool
  public static func isLowercase(_ ch: UnicodeScalar) -> Bool
  public static func toLowercase(_ ch: UInt8) -> UInt8
  public static func toLowercase(_ ch: UnicodeScalar) -> UnicodeScalar
  public static func isUppercase(_ ch: UInt8) -> Bool
  public static func isUppercase(_ ch: UnicodeScalar) -> Bool
  public static func toUppercase(_ ch: UInt8) -> UInt8
  public static func toUppercase(_ ch: UnicodeScalar) -> UnicodeScalar
  public static func isTitlecase(_ ch: UInt8) -> Bool
  public static func isTitlecase(_ ch: UnicodeScalar) -> Bool
  public static func toTitlecase(_ ch: UInt8) -> UInt8
  public static func toTitlecase(_ ch: UnicodeScalar) -> UnicodeScalar
  public static func isCased(_ ch: UInt8) -> Bool
  public static func isCased(_ ch: UnicodeScalar) -> Bool
  public static func isAlpha(_ ch: UInt8) -> Bool
  public static func isAlpha(_ ch: UnicodeScalar) -> Bool
  public static func isAlphaNumeric(_ ch: UInt8) -> Bool
  public static func isAlphaNumeric(_ ch: UnicodeScalar) -> Bool
  public static func isWhitespace(_ ch: UInt8) -> Bool
  public static func isWhitespace(_ ch: UnicodeScalar) -> Bool
  public static func isLineBreak(_ ch: UInt8) -> Bool
  public static func isLineBreak(_ ch: UnicodeScalar) -> Bool
  public static func isDecimalDigit(_ ch: UInt8) -> Bool
  public static func isDecimalDigit(_ ch: UnicodeScalar) -> Bool
  public static func toDecimalDigit(_ ch: UInt8) -> UInt8?
  public static func toDecimalDigit(_ ch: UnicodeScalar) -> UInt8?
  public static func isDigit(_ ch: UInt8) -> Bool
  public static func isDigit(_ ch: UnicodeScalar) -> Bool
  public static func toDigit(_ ch: UInt8) -> UInt8?
  public static func toDigit(_ ch: UnicodeScalar) -> UInt8?
}

=====================================
=== UnicodeData+CaseMapping.swift ===
=====================================

extension UnicodeData {
  public struct CaseMapping: Sequence {
    public init(_ scalar0: UnicodeScalar)
    public init(_ scalar0: UnicodeScalar, _ scalar1: UnicodeScalar)
    public init(_ scalar0: UnicodeScalar, _ scalar1: UnicodeScalar, _ scalar2: UnicodeScalar)
    public typealias Element = UnicodeScalar
    public struct Iterator: IteratorProtocol {
      public typealias Element = UnicodeScalar
      public mutating func next() -> UnicodeScalar?
    }
    public func makeIterator() -> Iterator
  }
}

=========================
=== UnicodeData.swift ===
=========================

public enum UnicodeData {
  public static func isLowercase(_ ch: UnicodeScalar) -> Bool
  public static func toLowercase(_ ch: UnicodeScalar) -> CaseMapping
  public static func isUppercase(_ ch: UnicodeScalar) -> Bool
  public static func toUppercase(_ ch: UnicodeScalar) -> CaseMapping
  public static func isTitlecase(_ ch: UnicodeScalar) -> Bool
  public static func toTitlecase(_ ch: UnicodeScalar) -> CaseMapping
  public static func toCasefold(_ ch: UnicodeScalar) -> CaseMapping
  public static func isCased(_ ch: UnicodeScalar) -> Bool
  public static func isCaseIgnorable(_ ch: UnicodeScalar) -> Bool
  public static func isAlpha(_ ch: UnicodeScalar) -> Bool
  public static func isAlphaNumeric(_ ch: UnicodeScalar) -> Bool
  public static func isWhitespace(_ ch: UnicodeScalar) -> Bool
  public static func isLineBreak(_ ch: UnicodeScalar) -> Bool
  public static func isXidStart(_ ch: UnicodeScalar) -> Bool
  public static func isXidContinue(_ ch: UnicodeScalar) -> Bool
  public static func isDecimalDigit(_ ch: UnicodeScalar) -> Bool
  public static func toDecimalDigit(_ ch: UnicodeScalar) -> UInt8?
  public static func isDigit(_ ch: UnicodeScalar) -> Bool
  public static func toDigit(_ ch: UnicodeScalar) -> UInt8?
  public static func isNumeric(_ ch: UnicodeScalar) -> Bool
  public static func isPrintable(_ ch: UnicodeScalar) -> Bool
}


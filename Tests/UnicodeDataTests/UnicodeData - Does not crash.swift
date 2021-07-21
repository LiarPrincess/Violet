import XCTest
import UnicodeData

private let range = 0..<0x11_0000

class UnicodeDataDoesNotCrashTests: XCTestCase {

  func test_iterateAll() {
    for value in range {
      guard let scalar = UnicodeScalar(value) else {
        continue
      }

      _ = UnicodeData.isLowercase(scalar)
      _ = UnicodeData.toLowercase(scalar)
      _ = UnicodeData.isUppercase(scalar)
      _ = UnicodeData.toUppercase(scalar)
      _ = UnicodeData.isTitlecase(scalar)
      _ = UnicodeData.toTitlecase(scalar)
      _ = UnicodeData.toCasefold(scalar)
      _ = UnicodeData.isCased(scalar)
      _ = UnicodeData.isCaseIgnorable(scalar)
      _ = UnicodeData.isAlpha(scalar)
      _ = UnicodeData.isAlphaNumeric(scalar)
      _ = UnicodeData.isWhitespace(scalar)
      _ = UnicodeData.isLineBreak(scalar)
      _ = UnicodeData.isXidStart(scalar)
      _ = UnicodeData.isXidContinue(scalar)
      _ = UnicodeData.isDecimalDigit(scalar)
      _ = UnicodeData.toDecimalDigit(scalar)
      _ = UnicodeData.isDigit(scalar)
      _ = UnicodeData.toDigit(scalar)
      _ = UnicodeData.isNumeric(scalar)
      _ = UnicodeData.isPrintable(scalar)
    }
  }
}

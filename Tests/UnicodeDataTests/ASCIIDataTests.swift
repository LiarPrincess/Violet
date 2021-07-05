import XCTest
import UnicodeData

private let testData = (0..<128).map { value -> (UInt8, UnicodeScalar, String) in
  let uint8 = UInt8(value)
  let scalar = UnicodeScalar(uint8)
  let msg = "'\(scalar)' (value: \(value))"
  return (uint8, scalar, msg)
}

// MARK: - Asserts

private func XCTAssertEqual(_ value: UInt8,
                            _ mapping: UnicodeData.CaseMapping,
                            _ msg: String,
                            file: StaticString = #file,
                            line: UInt = #line) {
  let scalar = UnicodeScalar(value)
  XCTAssertEqual(scalar, mapping, msg, file: file, line: line)
}

private func XCTAssertEqual(_ scalar: UnicodeScalar,
                            _ mapping: UnicodeData.CaseMapping,
                            _ msg: String,
                            file: StaticString = #file,
                            line: UInt = #line) {
  let mappingArray = Array(mapping)
  assert(mappingArray.count == 1)

  let expected = mappingArray[0]
  XCTAssertEqual(scalar, expected, file: file, line: line)
}

// Just check if we are returning the same value as UnicodeData
class ASCIIDataTests: XCTestCase {

  // MARK: - Lower

  func test_lowercase() {
    for (value, scalar, msg) in testData {
      XCTAssertEqual(
        ASCIIData.isLowercase(value),
        UnicodeData.isLowercase(scalar),
        msg
      )

      XCTAssertEqual(
        ASCIIData.isLowercase(scalar),
        UnicodeData.isLowercase(scalar),
        msg
      )

      XCTAssertEqual(
        ASCIIData.toLowercase(value),
        UnicodeData.toLowercase(scalar),
        msg
      )

      XCTAssertEqual(
        ASCIIData.toLowercase(scalar),
        UnicodeData.toLowercase(scalar),
        msg
      )
    }
  }

  // MARK: - Upper

  func test_uppercase() {
    for (value, scalar, msg) in testData {
      XCTAssertEqual(
        ASCIIData.isUppercase(value),
        UnicodeData.isUppercase(scalar),
        msg
      )

      XCTAssertEqual(
        ASCIIData.isUppercase(scalar),
        UnicodeData.isUppercase(scalar),
        msg
      )

      XCTAssertEqual(
        ASCIIData.toUppercase(value),
        UnicodeData.toUppercase(scalar),
        msg
      )

      XCTAssertEqual(
        ASCIIData.toUppercase(scalar),
        UnicodeData.toUppercase(scalar),
        msg
      )
    }
  }

  // MARK: - Title

  func test_titlecase() {
    for (value, scalar, msg) in testData {
      XCTAssertEqual(
        ASCIIData.isTitlecase(value),
        UnicodeData.isTitlecase(scalar),
        msg
      )

      XCTAssertEqual(
        ASCIIData.isTitlecase(scalar),
        UnicodeData.isTitlecase(scalar),
        msg
      )

      XCTAssertEqual(
        ASCIIData.toTitlecase(value),
        UnicodeData.toTitlecase(scalar),
        msg
      )

      XCTAssertEqual(
        ASCIIData.toTitlecase(scalar),
        UnicodeData.toTitlecase(scalar),
        msg
      )
    }
  }

  // MARK: - Cased

  func test_isCased() {
    for (value, scalar, msg) in testData {
      XCTAssertEqual(
        ASCIIData.isCased(value),
        UnicodeData.isCased(scalar),
        msg
      )

      XCTAssertEqual(
        ASCIIData.isCased(scalar),
        UnicodeData.isCased(scalar),
        msg
      )
    }
  }

  // MARK: - Alpha

  func test_isAlpha() {
    for (value, scalar, msg) in testData {
      XCTAssertEqual(
        ASCIIData.isAlpha(value),
        UnicodeData.isAlpha(scalar),
        msg
      )

      XCTAssertEqual(
        ASCIIData.isAlpha(scalar),
        UnicodeData.isAlpha(scalar),
        msg
      )
    }
  }

  // MARK: - Alpha numeric

  func test_isAlphaNumeric() {
    for (value, scalar, msg) in testData {
      XCTAssertEqual(
        ASCIIData.isAlphaNumeric(value),
        UnicodeData.isAlphaNumeric(scalar),
        msg
      )

      XCTAssertEqual(
        ASCIIData.isAlphaNumeric(scalar),
        UnicodeData.isAlphaNumeric(scalar),
        msg
      )
    }
  }

  // MARK: - Whitespace

  func test_isWhitespace() {
    for (value, scalar, msg) in testData {
      XCTAssertEqual(
        ASCIIData.isWhitespace(value),
        UnicodeData.isWhitespace(scalar),
        msg
      )

      XCTAssertEqual(
        ASCIIData.isWhitespace(scalar),
        UnicodeData.isWhitespace(scalar),
        msg
      )
    }
  }

  func test_isLineBreak() {
    for (value, scalar, msg) in testData {
      XCTAssertEqual(
        ASCIIData.isLineBreak(value),
        UnicodeData.isLineBreak(scalar),
        msg
      )

      XCTAssertEqual(
        ASCIIData.isLineBreak(scalar),
        UnicodeData.isLineBreak(scalar),
        msg
      )
    }
  }

  // MARK: - Decimal digit

  func test_decimalDigit() {
    for (value, scalar, msg) in testData {
      XCTAssertEqual(
        ASCIIData.isDecimalDigit(value),
        UnicodeData.isDecimalDigit(scalar),
        msg
      )

      XCTAssertEqual(
        ASCIIData.isDecimalDigit(scalar),
        UnicodeData.isDecimalDigit(scalar),
        msg
      )

      XCTAssertEqual(
        ASCIIData.toDecimalDigit(value),
        UnicodeData.toDecimalDigit(scalar),
        msg
      )

      XCTAssertEqual(
        ASCIIData.toDecimalDigit(scalar),
        UnicodeData.toDecimalDigit(scalar),
        msg
      )
    }
  }

  // MARK: - Digit

  func test_digit() {
    for (value, scalar, msg) in testData {
      XCTAssertEqual(
        ASCIIData.isDigit(value),
        UnicodeData.isDigit(scalar),
        msg
      )

      XCTAssertEqual(
        ASCIIData.isDigit(scalar),
        UnicodeData.isDigit(scalar),
        msg
      )

      XCTAssertEqual(
        ASCIIData.toDigit(value),
        UnicodeData.toDigit(scalar),
        msg
      )

      XCTAssertEqual(
        ASCIIData.toDigit(scalar),
        UnicodeData.toDigit(scalar),
        msg
      )
    }
  }
}

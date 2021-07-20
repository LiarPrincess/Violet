import XCTest
import UnicodeData

// swiftlint:disable force_unwrapping

private let testData = (0..<128).map { value -> (UInt8, UnicodeScalar, String) in
  let uint8 = UInt8(value)
  let scalar = UnicodeScalar(uint8)
  let msg = "'\(scalar)' (value: \(value))"
  return (uint8, scalar, msg)
}

// MARK: - ASCII

private let digitRange: Range<UInt8> = 48..<58
private let lowercaseRange: Range<UInt8> = 97..<123
private let uppercaseRange: Range<UInt8> = 65..<91

/// HT/SK, HT, ␉, ^I, \t
private let horizontalTab = UnicodeScalar(9)!
/// LF, ␊, ^J, \n
private let lineFeed = UnicodeScalar(10)!
/// VTAB, VT, ␋, ^K, \v
private let verticalTab = UnicodeScalar(11)!
/// FF, ␌, ^L, \f
private let formFeed = UnicodeScalar(12)!
/// CR, ␍, ^M, \r
private let carriageReturn = UnicodeScalar(13)!
/// FS, ␜, ^\
private let fileSeparator = UnicodeScalar(28)!
/// GS, ␝, ^]
private let groupSeparator = UnicodeScalar(29)!
/// RS, ␞, ^^[k]
private let recordSeparator = UnicodeScalar(30)!
/// US, ␟, ^_
private let unitSeparator = UnicodeScalar(31)!

private let space = UnicodeScalar(32)!
private let underscore = UnicodeScalar(95)!
private let del = UnicodeScalar(127)!

// MARK: - Asserts

private func XCTAssertEqual(_ mapping: UnicodeData.CaseMapping,
                            _ expected: UInt8,
                            _ msg: String,
                            file: StaticString = #file,
                            line: UInt = #line) {
  let mappingArray = Array(mapping)
  XCTAssertEqual(mappingArray.count,
                 1,
                 "Count for: " + msg,
                 file: file,
                 line: line)

  let scalar = mappingArray[0]
  let expectedScalar = UnicodeScalar(expected)
  XCTAssertEqual(scalar,
                 expectedScalar,
                 msg,
                 file: file,
                 line: line)
}

class UnicodeDataASCIITests: XCTestCase {

  // MARK: - Lower

  func test_lowercase() {
    for (value, scalar, msg) in testData {
      let isLower = lowercaseRange.contains(value)
      let isResult = UnicodeData.isLowercase(scalar)
      XCTAssertEqual(isResult, isLower, msg)

      let isUpper = uppercaseRange.contains(value)
      let mappingExpected = isUpper ? value + 32 : value
      let mappingResult = UnicodeData.toLowercase(scalar)
      XCTAssertEqual(mappingResult, mappingExpected, msg)
    }
  }

  // MARK: - Upper

  func test_uppercase() {
    for (value, scalar, msg) in testData {
      let isUpper = uppercaseRange.contains(value)
      let isResult = UnicodeData.isUppercase(scalar)
      XCTAssertEqual(isResult, isUpper, msg)

      let isLower = lowercaseRange.contains(value)
      let mappingExpected = isLower ? value - 32 : value
      let mappingResult = UnicodeData.toUppercase(scalar)
      XCTAssertEqual(mappingResult, mappingExpected, msg)
    }
  }

  // MARK: - Title

  func test_titlecase() {
    for (value, scalar, msg) in testData {
      let isResult = UnicodeData.isTitlecase(scalar)
      XCTAssertFalse(isResult, msg)

      let isLower = lowercaseRange.contains(value)
      let mappingExpected = isLower ? value - 32 : value
      let mappingResult = UnicodeData.toTitlecase(scalar)
      XCTAssertEqual(mappingResult, mappingExpected, msg)
    }
  }

  // MARK: - Case fold

  func test_casefold() {
    for (value, scalar, msg) in testData {
      let isUpper = uppercaseRange.contains(value)
      let mappingExpected = isUpper ? value + 32 : value
      let mappingResult = UnicodeData.toCasefold(scalar)
      XCTAssertEqual(mappingResult, mappingExpected, msg)
    }
  }

  // MARK: - Cased, case ignorable

  func test_isCased() {
    for (value, scalar, msg) in testData {
      let isLower = lowercaseRange.contains(value)
      let isUpper = uppercaseRange.contains(value)
      let expected = isLower || isUpper

      let result = UnicodeData.isCased(scalar)
      XCTAssertEqual(result, expected, msg)
    }
  }

  func test_isCaseIgnorable() {
    let all: [UnicodeScalar] = ["'", ".", ":", "^", "`"]

    for (_, scalar, msg) in testData {
      let expected = all.contains(scalar)
      let result = UnicodeData.isCaseIgnorable(scalar)
      XCTAssertEqual(result, expected, msg)
    }
  }

  // MARK: - Alpha

  func test_isAlpha() {
    for (value, scalar, msg) in testData {
      let isLower = lowercaseRange.contains(value)
      let isUpper = uppercaseRange.contains(value)
      let expected = isLower || isUpper

      let result = UnicodeData.isAlpha(scalar)
      XCTAssertEqual(result, expected, msg)
    }
  }

  // MARK: - Alpha numeric

  func test_isAlphaNumeric() {
    for (value, scalar, msg) in testData {
      let isLower = lowercaseRange.contains(value)
      let isUpper = uppercaseRange.contains(value)
      let isDigit = digitRange.contains(value)
      let expected = isLower || isUpper || isDigit

      let result = UnicodeData.isAlphaNumeric(scalar)
      XCTAssertEqual(result, expected, msg)
    }
  }

  // MARK: - Whitespace

  func test_isWhitespace() {
    let all: [UnicodeScalar] = [
      horizontalTab,
      lineFeed,
      verticalTab,
      formFeed,
      carriageReturn,
      fileSeparator,
      groupSeparator,
      recordSeparator,
      unitSeparator,
      space
    ]

    for (_, scalar, msg) in testData {
      let expected = all.contains(scalar)
      let result = UnicodeData.isWhitespace(scalar)
      XCTAssertEqual(result, expected, msg)
    }
  }

  func test_isLineBreak() {
    let all: [UnicodeScalar] = [
      lineFeed,
      verticalTab,
      formFeed,
      carriageReturn,
      fileSeparator,
      groupSeparator,
      recordSeparator
    ]

    for (_, scalar, msg) in testData {
      let expected = all.contains(scalar)
      let result = UnicodeData.isLineBreak(scalar)
      XCTAssertEqual(result, expected, msg)
    }
  }

  // MARK: - Identifier

  func test_isXidStart() {
    for (value, scalar, msg) in testData {
      let isLower = lowercaseRange.contains(value)
      let isUpper = uppercaseRange.contains(value)
      let expected = isLower || isUpper

      let result = UnicodeData.isXidStart(scalar)
      XCTAssertEqual(result, expected, msg)
    }
  }

  func test_isXidContinue() {
    for (value, scalar, msg) in testData {
      let isLower = lowercaseRange.contains(value)
      let isUpper = uppercaseRange.contains(value)
      let isDigit = digitRange.contains(value)
      let isUnderscore = value == underscore.value
      let expected = isLower || isUpper || isDigit || isUnderscore

      let result = UnicodeData.isXidContinue(scalar)
      XCTAssertEqual(result, expected, msg)
    }
  }

  // MARK: - Decimal digit

  func test_decimalDigit() {
    for (value, scalar, msg) in testData {
      let isDecimalDigit = digitRange.contains(value)
      let isResult = UnicodeData.isDecimalDigit(scalar)
      XCTAssertEqual(isResult, isDecimalDigit, msg)

      let digit = UnicodeData.toDecimalDigit(scalar)
      let expectedDigit = isDecimalDigit ? value - 48 : nil
      XCTAssertEqual(digit, expectedDigit, msg)
    }
  }

  // MARK: - Digit

  func test_digit() {
    for (value, scalar, msg) in testData {
      let isDecimalDigit = digitRange.contains(value)
      let isResult = UnicodeData.isDigit(scalar)
      XCTAssertEqual(isResult, isDecimalDigit, msg)

      let digit = UnicodeData.toDigit(scalar)
      let expectedDigit = isDecimalDigit ? value - 48 : nil
      XCTAssertEqual(digit, expectedDigit, msg)
    }
  }

  // MARK: - Numeric

  func test_isNumeric() {
    for (value, scalar, msg) in testData {
      let isDecimalDigit = digitRange.contains(value)
      let result = UnicodeData.isNumeric(scalar)
      XCTAssertEqual(result, isDecimalDigit, msg)
    }
  }

  // MARK: - Printable

  func test_isPrintable() {
    for (value, scalar, msg) in testData {
      let isDel = value == del.value
      let expected = value >= space.value && !isDel

      let result = UnicodeData.isPrintable(scalar)
      XCTAssertEqual(result, expected, msg)
    }
  }
}

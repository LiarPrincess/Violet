import XCTest
import UnicodeData

// MARK: - ASCII

private let range = 0..<128
private let digitRange = 48..<58
private let lowercaseRange = 97..<123
private let uppercaseRange = 65..<91

///   HT/SK  HT  ␉  ^I  \t
private let horizontalTab = UnicodeScalar(9)!
///   LF  ␊  ^J  \n
private let lineFeed = UnicodeScalar(10)!
///   VTAB  VT  ␋  ^K  \v
private let verticalTab = UnicodeScalar(11)!
///   FF  ␌  ^L  \f
private let formFeed = UnicodeScalar(12)!
///   CR  ␍  ^M  \r
private let carriageReturn = UnicodeScalar(13)!
/// FS  ␜  ^\
private let fileSeparator = UnicodeScalar(28)!
/// GS  ␝  ^]
private let groupSeparator = UnicodeScalar(29)!
/// RS  ␞  ^^[k]
private let recordSeparator = UnicodeScalar(30)!
/// US  ␟  ^_
private let unitSeparator = UnicodeScalar(31)!
private let space = UnicodeScalar(32)!
private let underscore = UnicodeScalar(95)!
private let del = UnicodeScalar(127)!

class ASCII: XCTestCase {

  // MARK: - Lower, upper, title

  func test_lowercase() {
    for value in range {
      guard let scalar = UnicodeScalar(value) else {
        XCTFail("Unable to convert '\(value)'")
        continue
      }

      let isLower = lowercaseRange.contains(value)
      XCTAssertProperty(UnicodeData.isLowercase, for: scalar, expected: isLower)

      let isUpper = uppercaseRange.contains(value)
      let mapping = UnicodeData.toLowercase(scalar)
      let expectedMapping = isUpper ? value + 32 : value
      XCTAssertCase(mapping, expected: expectedMapping)
    }
  }

  func test_uppercase() {
    for value in range {
      guard let scalar = UnicodeScalar(value) else {
        XCTFail("Unable to convert '\(value)'")
        continue
      }

      let isUpper = uppercaseRange.contains(value)
      XCTAssertProperty(UnicodeData.isUppercase, for: scalar, expected: isUpper)

      let isLower = lowercaseRange.contains(value)
      let mapping = UnicodeData.toUppercase(scalar)
      let expectedMapping = isLower ? value - 32 : value
      XCTAssertCase(mapping, expected: expectedMapping)
    }
  }

  func test_titlecase() {
    for value in range {
      guard let scalar = UnicodeScalar(value) else {
        XCTFail("Unable to convert '\(value)'")
        continue
      }

      XCTAssertProperty(UnicodeData.isTitlecase, for: scalar, expected: false)

      let isLower = lowercaseRange.contains(value)
      let mapping = UnicodeData.toTitlecase(scalar)
      let expectedMapping = isLower ? value - 32 : value
      XCTAssertCase(mapping, expected: expectedMapping)
    }
  }

  // MARK: - Cased, case ignorable

  func test_isCased() {
    for value in range {
      guard let scalar = UnicodeScalar(value) else {
        XCTFail("Unable to convert '\(value)'")
        continue
      }

      let isLower = lowercaseRange.contains(value)
      let isUpper = uppercaseRange.contains(value)
      let expected = isLower || isUpper
      XCTAssertProperty(UnicodeData.isCased, for: scalar, expected: expected)
    }
  }

  func test_isCaseIgnorable() {
    let all: [UnicodeScalar] = ["'", ".", ":", "^", "`"]

    for value in range {
      guard let scalar = UnicodeScalar(value) else {
        XCTFail("Unable to convert '\(value)'")
        continue
      }

      let expected = all.contains(scalar)
      XCTAssertProperty(UnicodeData.isCaseIgnorable, for: scalar, expected: expected)
    }
  }

  // MARK: - Alpha

  func test_isAlpha() {
    for value in range {
      guard let scalar = UnicodeScalar(value) else {
        XCTFail("Unable to convert '\(value)'")
        continue
      }

      let isLower = lowercaseRange.contains(value)
      let isUpper = uppercaseRange.contains(value)
      let expected = isLower || isUpper
      XCTAssertProperty(UnicodeData.isAlpha, for: scalar, expected: expected)
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

    for value in range {
      guard let scalar = UnicodeScalar(value) else {
        XCTFail("Unable to convert '\(value)'")
        continue
      }

      let expected = all.contains(scalar)
      XCTAssertProperty(UnicodeData.isWhitespace, for: scalar, expected: expected)
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

    for value in range {
      guard let scalar = UnicodeScalar(value) else {
        XCTFail("Unable to convert '\(value)'")
        continue
      }

      let expected = all.contains(scalar)
      XCTAssertProperty(UnicodeData.isLineBreak, for: scalar, expected: expected)
    }
  }

  // MARK: - Identifier

  func test_isXidStart() {
    for value in range {
      guard let scalar = UnicodeScalar(value) else {
        XCTFail("Unable to convert '\(value)'")
        continue
      }

      let isLower = lowercaseRange.contains(value)
      let isUpper = uppercaseRange.contains(value)
      let expected = isLower || isUpper
      XCTAssertProperty(UnicodeData.isXidStart, for: scalar, expected: expected)
    }
  }

  func test_isXidContinue() {
    for value in range {
      guard let scalar = UnicodeScalar(value) else {
        XCTFail("Unable to convert '\(value)'")
        continue
      }

      let isLower = lowercaseRange.contains(value)
      let isUpper = uppercaseRange.contains(value)
      let isDigit = digitRange.contains(value)
      let isUnderscore = value == underscore.value
      let expected = isLower || isUpper || isDigit || isUnderscore
      XCTAssertProperty(UnicodeData.isXidContinue, for: scalar, expected: expected)
    }
  }

  // MARK: - Decimal digit

  func test_decimalDigit() {
    for value in range {
      guard let scalar = UnicodeScalar(value) else {
        XCTFail("Unable to convert '\(value)'")
        continue
      }

      let isDecimalDigit = digitRange.contains(value)
      XCTAssertProperty(UnicodeData.isDecimalDigit, for: scalar, expected: isDecimalDigit)

      let digit = UnicodeData.toDecimalDigit(scalar)
      let expectedDigit = isDecimalDigit ? value - 48 : nil
      XCTAssertDigit(digit, expected: expectedDigit)
    }
  }

  // MARK: - Digit

  func test_digit() {
    for value in range {
      guard let scalar = UnicodeScalar(value) else {
        XCTFail("Unable to convert '\(value)'")
        continue
      }

      let isDecimalDigit = digitRange.contains(value)
      XCTAssertProperty(UnicodeData.isDigit, for: scalar, expected: isDecimalDigit)

      let digit = UnicodeData.toDigit(scalar)
      let expectedDigit = isDecimalDigit ? value - 48 : nil
      XCTAssertDigit(digit, expected: expectedDigit)
    }
  }

  // MARK: - Numeric

  func test_isNumeric() {
    for value in range {
      guard let scalar = UnicodeScalar(value) else {
        XCTFail("Unable to convert '\(value)'")
        continue
      }

      let isDecimalDigit = digitRange.contains(value)
      XCTAssertProperty(UnicodeData.isNumeric, for: scalar, expected: isDecimalDigit)
    }
  }

  // MARK: - Printable

  func test_isPrintable() {
    for value in range {
      guard let scalar = UnicodeScalar(value) else {
        XCTFail("Unable to convert '\(value)'")
        continue
      }

      let isDel = value == del.value
      let expected = value >= space.value && !isDel
      XCTAssertProperty(UnicodeData.isPrintable, for: scalar, expected: expected)
    }
  }
}

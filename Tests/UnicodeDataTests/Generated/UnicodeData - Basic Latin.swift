// ================================================================
// Automatically generated from: /Scripts/unicode/generate-tests.py
// Use 'make unicode' in repository root to regenerate.
// DO NOT EDIT!
// ================================================================

import XCTest
import UnicodeData

// swiftlint:disable superfluous_disable_command
// swiftlint:disable xct_specific_matcher
// swiftlint:disable type_name
// swiftlint:disable file_length

/// Tests for: 0000..007f Basic Latin block
class UnicodeDataBasicLatinTests: XCTestCase {

  /// ' ' - SPACE (U+0020)
  func test_space() {
    let scalar: UnicodeScalar = " "

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), " ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), " ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), " ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), " ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), true)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '!' - EXCLAMATION MARK (U+0021)
  func test_exclamationMark() {
    let scalar: UnicodeScalar = "!"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "!")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "!")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "!")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "!")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '"' - QUOTATION MARK (U+0022)
  func test_quotationMark() {
    let scalar: UnicodeScalar = "\""

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "\"")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "\"")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "\"")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "\"")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '#' - NUMBER SIGN (U+0023)
  func test_numberSign() {
    let scalar: UnicodeScalar = "#"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "#")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "#")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "#")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "#")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '$' - DOLLAR SIGN (U+0024)
  func test_dollarSign() {
    let scalar: UnicodeScalar = "$"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "$")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "$")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "$")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "$")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '%' - PERCENT SIGN (U+0025)
  func test_percentSign() {
    let scalar: UnicodeScalar = "%"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "%")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "%")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "%")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "%")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '&' - AMPERSAND (U+0026)
  func test_ampersand() {
    let scalar: UnicodeScalar = "&"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "&")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "&")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "&")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "&")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// ''' - APOSTROPHE (U+0027)
  func test_apostrophe() {
    let scalar: UnicodeScalar = "'"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "'")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "'")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "'")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "'")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '(' - LEFT PARENTHESIS (U+0028)
  func test_leftParenthesis() {
    let scalar: UnicodeScalar = "("

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "(")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "(")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "(")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "(")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// ')' - RIGHT PARENTHESIS (U+0029)
  func test_rightParenthesis() {
    let scalar: UnicodeScalar = ")"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), ")")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), ")")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), ")")
    XCTAssertCase(UnicodeData.toCasefold(scalar), ")")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '*' - ASTERISK (U+002a)
  func test_asterisk() {
    let scalar: UnicodeScalar = "*"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "*")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "*")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "*")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "*")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '+' - PLUS SIGN (U+002b)
  func test_plusSign() {
    let scalar: UnicodeScalar = "+"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "+")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "+")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "+")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "+")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// ',' - COMMA (U+002c)
  func test_comma() {
    let scalar: UnicodeScalar = ","

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), ",")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), ",")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), ",")
    XCTAssertCase(UnicodeData.toCasefold(scalar), ",")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '-' - HYPHEN-MINUS (U+002d)
  func test_hyphen_minus() {
    let scalar: UnicodeScalar = "-"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "-")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "-")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "-")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "-")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '.' - FULL STOP (U+002e)
  func test_fullStop() {
    let scalar: UnicodeScalar = "."

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), ".")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), ".")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), ".")
    XCTAssertCase(UnicodeData.toCasefold(scalar), ".")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '/' - SOLIDUS (U+002f)
  func test_solidus() {
    let scalar: UnicodeScalar = "/"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "/")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "/")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "/")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "/")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '0' - DIGIT ZERO (U+0030)
  func test_digitZero() {
    let scalar: UnicodeScalar = "0"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "0")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "0")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "0")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "0")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), 0)
    XCTAssertEqual(UnicodeData.isDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDigit(scalar), 0)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '1' - DIGIT ONE (U+0031)
  func test_digitOne() {
    let scalar: UnicodeScalar = "1"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "1")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "1")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "1")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "1")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), 1)
    XCTAssertEqual(UnicodeData.isDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDigit(scalar), 1)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '2' - DIGIT TWO (U+0032)
  func test_digitTwo() {
    let scalar: UnicodeScalar = "2"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "2")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "2")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "2")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "2")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), 2)
    XCTAssertEqual(UnicodeData.isDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDigit(scalar), 2)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '3' - DIGIT THREE (U+0033)
  func test_digitThree() {
    let scalar: UnicodeScalar = "3"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "3")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "3")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "3")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "3")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), 3)
    XCTAssertEqual(UnicodeData.isDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDigit(scalar), 3)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '4' - DIGIT FOUR (U+0034)
  func test_digitFour() {
    let scalar: UnicodeScalar = "4"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "4")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "4")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "4")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "4")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), 4)
    XCTAssertEqual(UnicodeData.isDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDigit(scalar), 4)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '5' - DIGIT FIVE (U+0035)
  func test_digitFive() {
    let scalar: UnicodeScalar = "5"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "5")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "5")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "5")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "5")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), 5)
    XCTAssertEqual(UnicodeData.isDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDigit(scalar), 5)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '6' - DIGIT SIX (U+0036)
  func test_digitSix() {
    let scalar: UnicodeScalar = "6"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "6")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "6")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "6")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "6")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), 6)
    XCTAssertEqual(UnicodeData.isDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDigit(scalar), 6)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '7' - DIGIT SEVEN (U+0037)
  func test_digitSeven() {
    let scalar: UnicodeScalar = "7"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "7")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "7")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "7")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "7")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), 7)
    XCTAssertEqual(UnicodeData.isDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDigit(scalar), 7)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '8' - DIGIT EIGHT (U+0038)
  func test_digitEight() {
    let scalar: UnicodeScalar = "8"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "8")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "8")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "8")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "8")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), 8)
    XCTAssertEqual(UnicodeData.isDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDigit(scalar), 8)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '9' - DIGIT NINE (U+0039)
  func test_digitNine() {
    let scalar: UnicodeScalar = "9"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "9")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "9")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "9")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "9")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), 9)
    XCTAssertEqual(UnicodeData.isDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDigit(scalar), 9)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// ':' - COLON (U+003a)
  func test_colon() {
    let scalar: UnicodeScalar = ":"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), ":")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), ":")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), ":")
    XCTAssertCase(UnicodeData.toCasefold(scalar), ":")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// ';' - SEMICOLON (U+003b)
  func test_semicolon() {
    let scalar: UnicodeScalar = ";"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), ";")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), ";")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), ";")
    XCTAssertCase(UnicodeData.toCasefold(scalar), ";")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '<' - LESS-THAN SIGN (U+003c)
  func test_less_thanSign() {
    let scalar: UnicodeScalar = "<"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "<")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "<")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "<")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "<")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '=' - EQUALS SIGN (U+003d)
  func test_equalsSign() {
    let scalar: UnicodeScalar = "="

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "=")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "=")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "=")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "=")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '>' - GREATER-THAN SIGN (U+003e)
  func test_greater_thanSign() {
    let scalar: UnicodeScalar = ">"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), ">")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), ">")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), ">")
    XCTAssertCase(UnicodeData.toCasefold(scalar), ">")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '?' - QUESTION MARK (U+003f)
  func test_questionMark() {
    let scalar: UnicodeScalar = "?"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "?")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "?")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "?")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "?")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '@' - COMMERCIAL AT (U+0040)
  func test_commercialAt() {
    let scalar: UnicodeScalar = "@"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "@")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "@")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "@")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "@")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'A' - LATIN CAPITAL LETTER A (U+0041)
  func test_latinCapitalLetterA() {
    let scalar: UnicodeScalar = "A"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "a")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "A")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "A")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "a")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'B' - LATIN CAPITAL LETTER B (U+0042)
  func test_latinCapitalLetterB() {
    let scalar: UnicodeScalar = "B"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "b")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "B")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "B")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "b")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'C' - LATIN CAPITAL LETTER C (U+0043)
  func test_latinCapitalLetterC() {
    let scalar: UnicodeScalar = "C"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "c")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "C")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "C")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "c")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'D' - LATIN CAPITAL LETTER D (U+0044)
  func test_latinCapitalLetterD() {
    let scalar: UnicodeScalar = "D"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "d")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "D")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "D")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "d")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'E' - LATIN CAPITAL LETTER E (U+0045)
  func test_latinCapitalLetterE() {
    let scalar: UnicodeScalar = "E"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "e")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "E")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "E")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "e")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'F' - LATIN CAPITAL LETTER F (U+0046)
  func test_latinCapitalLetterF() {
    let scalar: UnicodeScalar = "F"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "f")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "F")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "F")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "f")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'G' - LATIN CAPITAL LETTER G (U+0047)
  func test_latinCapitalLetterG() {
    let scalar: UnicodeScalar = "G"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "g")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "G")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "G")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "g")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'H' - LATIN CAPITAL LETTER H (U+0048)
  func test_latinCapitalLetterH() {
    let scalar: UnicodeScalar = "H"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "h")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "H")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "H")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "h")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'I' - LATIN CAPITAL LETTER I (U+0049)
  func test_latinCapitalLetterI() {
    let scalar: UnicodeScalar = "I"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "i")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "I")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "I")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "i")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'J' - LATIN CAPITAL LETTER J (U+004a)
  func test_latinCapitalLetterJ() {
    let scalar: UnicodeScalar = "J"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "j")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "J")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "J")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "j")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'K' - LATIN CAPITAL LETTER K (U+004b)
  func test_latinCapitalLetterK() {
    let scalar: UnicodeScalar = "K"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "k")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "K")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "K")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "k")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'L' - LATIN CAPITAL LETTER L (U+004c)
  func test_latinCapitalLetterL() {
    let scalar: UnicodeScalar = "L"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "l")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "L")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "L")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "l")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'M' - LATIN CAPITAL LETTER M (U+004d)
  func test_latinCapitalLetterM() {
    let scalar: UnicodeScalar = "M"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "m")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "M")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "M")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "m")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'N' - LATIN CAPITAL LETTER N (U+004e)
  func test_latinCapitalLetterN() {
    let scalar: UnicodeScalar = "N"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "n")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "N")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "N")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "n")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'O' - LATIN CAPITAL LETTER O (U+004f)
  func test_latinCapitalLetterO() {
    let scalar: UnicodeScalar = "O"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "o")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "O")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "O")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "o")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'P' - LATIN CAPITAL LETTER P (U+0050)
  func test_latinCapitalLetterP() {
    let scalar: UnicodeScalar = "P"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "p")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "P")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "P")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "p")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Q' - LATIN CAPITAL LETTER Q (U+0051)
  func test_latinCapitalLetterQ() {
    let scalar: UnicodeScalar = "Q"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "q")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Q")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Q")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "q")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'R' - LATIN CAPITAL LETTER R (U+0052)
  func test_latinCapitalLetterR() {
    let scalar: UnicodeScalar = "R"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "r")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "R")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "R")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "r")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'S' - LATIN CAPITAL LETTER S (U+0053)
  func test_latinCapitalLetterS() {
    let scalar: UnicodeScalar = "S"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "s")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "S")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "S")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "s")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'T' - LATIN CAPITAL LETTER T (U+0054)
  func test_latinCapitalLetterT() {
    let scalar: UnicodeScalar = "T"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "t")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "T")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "T")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "t")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'U' - LATIN CAPITAL LETTER U (U+0055)
  func test_latinCapitalLetterU() {
    let scalar: UnicodeScalar = "U"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "u")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "U")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "U")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "u")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'V' - LATIN CAPITAL LETTER V (U+0056)
  func test_latinCapitalLetterV() {
    let scalar: UnicodeScalar = "V"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "v")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "V")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "V")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "v")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'W' - LATIN CAPITAL LETTER W (U+0057)
  func test_latinCapitalLetterW() {
    let scalar: UnicodeScalar = "W"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "w")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "W")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "W")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "w")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'X' - LATIN CAPITAL LETTER X (U+0058)
  func test_latinCapitalLetterX() {
    let scalar: UnicodeScalar = "X"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "x")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "X")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "X")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "x")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Y' - LATIN CAPITAL LETTER Y (U+0059)
  func test_latinCapitalLetterY() {
    let scalar: UnicodeScalar = "Y"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "y")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Y")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Y")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "y")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Z' - LATIN CAPITAL LETTER Z (U+005a)
  func test_latinCapitalLetterZ() {
    let scalar: UnicodeScalar = "Z"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "z")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Z")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Z")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "z")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '[' - LEFT SQUARE BRACKET (U+005b)
  func test_leftSquareBracket() {
    let scalar: UnicodeScalar = "["

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "[")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "[")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "[")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "[")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '\' - REVERSE SOLIDUS (U+005c)
  func test_reverseSolidus() {
    let scalar: UnicodeScalar = "\\"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "\\")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "\\")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "\\")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "\\")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// ']' - RIGHT SQUARE BRACKET (U+005d)
  func test_rightSquareBracket() {
    let scalar: UnicodeScalar = "]"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "]")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "]")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "]")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "]")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '^' - CIRCUMFLEX ACCENT (U+005e)
  func test_circumflexAccent() {
    let scalar: UnicodeScalar = "^"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "^")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "^")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "^")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "^")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '_' - LOW LINE (U+005f)
  func test_lowLine() {
    let scalar: UnicodeScalar = "_"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "_")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "_")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "_")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "_")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '`' - GRAVE ACCENT (U+0060)
  func test_graveAccent() {
    let scalar: UnicodeScalar = "`"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "`")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "`")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "`")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "`")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'a' - LATIN SMALL LETTER A (U+0061)
  func test_latinSmallLetterA() {
    let scalar: UnicodeScalar = "a"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "a")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "A")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "A")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "a")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'b' - LATIN SMALL LETTER B (U+0062)
  func test_latinSmallLetterB() {
    let scalar: UnicodeScalar = "b"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "b")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "B")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "B")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "b")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'c' - LATIN SMALL LETTER C (U+0063)
  func test_latinSmallLetterC() {
    let scalar: UnicodeScalar = "c"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "c")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "C")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "C")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "c")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'd' - LATIN SMALL LETTER D (U+0064)
  func test_latinSmallLetterD() {
    let scalar: UnicodeScalar = "d"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "d")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "D")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "D")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "d")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'e' - LATIN SMALL LETTER E (U+0065)
  func test_latinSmallLetterE() {
    let scalar: UnicodeScalar = "e"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "e")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "E")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "E")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "e")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'f' - LATIN SMALL LETTER F (U+0066)
  func test_latinSmallLetterF() {
    let scalar: UnicodeScalar = "f"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "f")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "F")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "F")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "f")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'g' - LATIN SMALL LETTER G (U+0067)
  func test_latinSmallLetterG() {
    let scalar: UnicodeScalar = "g"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "g")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "G")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "G")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "g")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'h' - LATIN SMALL LETTER H (U+0068)
  func test_latinSmallLetterH() {
    let scalar: UnicodeScalar = "h"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "h")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "H")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "H")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "h")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'i' - LATIN SMALL LETTER I (U+0069)
  func test_latinSmallLetterI() {
    let scalar: UnicodeScalar = "i"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "i")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "I")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "I")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "i")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'j' - LATIN SMALL LETTER J (U+006a)
  func test_latinSmallLetterJ() {
    let scalar: UnicodeScalar = "j"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "j")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "J")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "J")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "j")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'k' - LATIN SMALL LETTER K (U+006b)
  func test_latinSmallLetterK() {
    let scalar: UnicodeScalar = "k"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "k")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "K")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "K")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "k")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'l' - LATIN SMALL LETTER L (U+006c)
  func test_latinSmallLetterL() {
    let scalar: UnicodeScalar = "l"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "l")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "L")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "L")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "l")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'm' - LATIN SMALL LETTER M (U+006d)
  func test_latinSmallLetterM() {
    let scalar: UnicodeScalar = "m"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "m")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "M")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "M")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "m")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'n' - LATIN SMALL LETTER N (U+006e)
  func test_latinSmallLetterN() {
    let scalar: UnicodeScalar = "n"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "n")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "N")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "N")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "n")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'o' - LATIN SMALL LETTER O (U+006f)
  func test_latinSmallLetterO() {
    let scalar: UnicodeScalar = "o"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "o")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "O")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "O")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "o")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'p' - LATIN SMALL LETTER P (U+0070)
  func test_latinSmallLetterP() {
    let scalar: UnicodeScalar = "p"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "p")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "P")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "P")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "p")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'q' - LATIN SMALL LETTER Q (U+0071)
  func test_latinSmallLetterQ() {
    let scalar: UnicodeScalar = "q"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "q")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Q")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Q")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "q")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'r' - LATIN SMALL LETTER R (U+0072)
  func test_latinSmallLetterR() {
    let scalar: UnicodeScalar = "r"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "r")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "R")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "R")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "r")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 's' - LATIN SMALL LETTER S (U+0073)
  func test_latinSmallLetterS() {
    let scalar: UnicodeScalar = "s"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "s")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "S")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "S")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "s")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 't' - LATIN SMALL LETTER T (U+0074)
  func test_latinSmallLetterT() {
    let scalar: UnicodeScalar = "t"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "t")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "T")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "T")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "t")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'u' - LATIN SMALL LETTER U (U+0075)
  func test_latinSmallLetterU() {
    let scalar: UnicodeScalar = "u"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "u")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "U")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "U")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "u")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'v' - LATIN SMALL LETTER V (U+0076)
  func test_latinSmallLetterV() {
    let scalar: UnicodeScalar = "v"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "v")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "V")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "V")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "v")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'w' - LATIN SMALL LETTER W (U+0077)
  func test_latinSmallLetterW() {
    let scalar: UnicodeScalar = "w"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "w")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "W")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "W")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "w")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'x' - LATIN SMALL LETTER X (U+0078)
  func test_latinSmallLetterX() {
    let scalar: UnicodeScalar = "x"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "x")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "X")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "X")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "x")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'y' - LATIN SMALL LETTER Y (U+0079)
  func test_latinSmallLetterY() {
    let scalar: UnicodeScalar = "y"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "y")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Y")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Y")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "y")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'z' - LATIN SMALL LETTER Z (U+007a)
  func test_latinSmallLetterZ() {
    let scalar: UnicodeScalar = "z"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "z")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Z")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Z")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "z")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '{' - LEFT CURLY BRACKET (U+007b)
  func test_leftCurlyBracket() {
    let scalar: UnicodeScalar = "{"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "{")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "{")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "{")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "{")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '|' - VERTICAL LINE (U+007c)
  func test_verticalLine() {
    let scalar: UnicodeScalar = "|"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "|")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "|")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "|")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "|")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '}' - RIGHT CURLY BRACKET (U+007d)
  func test_rightCurlyBracket() {
    let scalar: UnicodeScalar = "}"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "}")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "}")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "}")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "}")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '~' - TILDE (U+007e)
  func test_tilde() {
    let scalar: UnicodeScalar = "~"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "~")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "~")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "~")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "~")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), true)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }
}

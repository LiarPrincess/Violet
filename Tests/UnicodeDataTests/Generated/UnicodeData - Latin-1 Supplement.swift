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

/// Tests for: 0080..00ff Latin-1 Supplement block
class UnicodeDataLatin1SupplementTests: XCTestCase {

  /// NO-BREAK SPACE (U+00a0)
  func test_no_breakSpace() {
    let scalar: UnicodeScalar = "\u{00a0}"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "\u{00a0}")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "\u{00a0}")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "\u{00a0}")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "\u{00a0}")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), true)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), false)
  }

  /// '¡' - INVERTED EXCLAMATION MARK (U+00a1)
  func test_invertedExclamationMark() {
    let scalar: UnicodeScalar = "¡"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "¡")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "¡")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "¡")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "¡")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '¢' - CENT SIGN (U+00a2)
  func test_centSign() {
    let scalar: UnicodeScalar = "¢"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "¢")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "¢")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "¢")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "¢")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '£' - POUND SIGN (U+00a3)
  func test_poundSign() {
    let scalar: UnicodeScalar = "£"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "£")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "£")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "£")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "£")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '¤' - CURRENCY SIGN (U+00a4)
  func test_currencySign() {
    let scalar: UnicodeScalar = "¤"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "¤")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "¤")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "¤")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "¤")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '¥' - YEN SIGN (U+00a5)
  func test_yenSign() {
    let scalar: UnicodeScalar = "¥"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "¥")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "¥")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "¥")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "¥")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '¦' - BROKEN BAR (U+00a6)
  func test_brokenBar() {
    let scalar: UnicodeScalar = "¦"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "¦")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "¦")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "¦")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "¦")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '§' - SECTION SIGN (U+00a7)
  func test_sectionSign() {
    let scalar: UnicodeScalar = "§"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "§")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "§")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "§")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "§")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '¨' - DIAERESIS (U+00a8)
  func test_diaeresis() {
    let scalar: UnicodeScalar = "¨"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "¨")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "¨")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "¨")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "¨")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '©' - COPYRIGHT SIGN (U+00a9)
  func test_copyrightSign() {
    let scalar: UnicodeScalar = "©"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "©")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "©")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "©")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "©")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ª' - FEMININE ORDINAL INDICATOR (U+00aa)
  func test_feminineOrdinalIndicator() {
    let scalar: UnicodeScalar = "ª"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ª")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ª")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ª")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ª")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '«' - LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00ab)
  func test_left_pointingDoubleAngleQuotationMark() {
    let scalar: UnicodeScalar = "«"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "«")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "«")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "«")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "«")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '¬' - NOT SIGN (U+00ac)
  func test_notSign() {
    let scalar: UnicodeScalar = "¬"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "¬")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "¬")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "¬")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "¬")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// SOFT HYPHEN (U+00ad)
  func test_softHyphen() {
    let scalar: UnicodeScalar = "\u{00ad}"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "\u{00ad}")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "\u{00ad}")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "\u{00ad}")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "\u{00ad}")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), false)
  }

  /// '®' - REGISTERED SIGN (U+00ae)
  func test_registeredSign() {
    let scalar: UnicodeScalar = "®"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "®")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "®")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "®")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "®")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '¯' - MACRON (U+00af)
  func test_macron() {
    let scalar: UnicodeScalar = "¯"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "¯")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "¯")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "¯")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "¯")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '°' - DEGREE SIGN (U+00b0)
  func test_degreeSign() {
    let scalar: UnicodeScalar = "°"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "°")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "°")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "°")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "°")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '±' - PLUS-MINUS SIGN (U+00b1)
  func test_plus_minusSign() {
    let scalar: UnicodeScalar = "±"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "±")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "±")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "±")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "±")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '²' - SUPERSCRIPT TWO (U+00b2)
  func test_superscriptTwo() {
    let scalar: UnicodeScalar = "²"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "²")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "²")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "²")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "²")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDigit(scalar), 2)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '³' - SUPERSCRIPT THREE (U+00b3)
  func test_superscriptThree() {
    let scalar: UnicodeScalar = "³"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "³")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "³")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "³")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "³")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDigit(scalar), 3)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '´' - ACUTE ACCENT (U+00b4)
  func test_acuteAccent() {
    let scalar: UnicodeScalar = "´"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "´")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "´")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "´")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "´")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'µ' - MICRO SIGN (U+00b5)
  func test_microSign() {
    let scalar: UnicodeScalar = "µ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "µ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Μ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Μ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "μ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '¶' - PILCROW SIGN (U+00b6)
  func test_pilcrowSign() {
    let scalar: UnicodeScalar = "¶"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "¶")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "¶")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "¶")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "¶")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '·' - MIDDLE DOT (U+00b7)
  func test_middleDot() {
    let scalar: UnicodeScalar = "·"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "·")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "·")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "·")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "·")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '¸' - CEDILLA (U+00b8)
  func test_cedilla() {
    let scalar: UnicodeScalar = "¸"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "¸")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "¸")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "¸")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "¸")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '¹' - SUPERSCRIPT ONE (U+00b9)
  func test_superscriptOne() {
    let scalar: UnicodeScalar = "¹"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "¹")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "¹")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "¹")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "¹")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), true)
    XCTAssertDigit(UnicodeData.toDigit(scalar), 1)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'º' - MASCULINE ORDINAL INDICATOR (U+00ba)
  func test_masculineOrdinalIndicator() {
    let scalar: UnicodeScalar = "º"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "º")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "º")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "º")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "º")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '»' - RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00bb)
  func test_right_pointingDoubleAngleQuotationMark() {
    let scalar: UnicodeScalar = "»"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "»")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "»")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "»")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "»")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '¼' - VULGAR FRACTION ONE QUARTER (U+00bc)
  func test_vulgarFractionOneQuarter() {
    let scalar: UnicodeScalar = "¼"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "¼")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "¼")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "¼")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "¼")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '½' - VULGAR FRACTION ONE HALF (U+00bd)
  func test_vulgarFractionOneHalf() {
    let scalar: UnicodeScalar = "½"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "½")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "½")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "½")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "½")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '¾' - VULGAR FRACTION THREE QUARTERS (U+00be)
  func test_vulgarFractionThreeQuarters() {
    let scalar: UnicodeScalar = "¾"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "¾")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "¾")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "¾")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "¾")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '¿' - INVERTED QUESTION MARK (U+00bf)
  func test_invertedQuestionMark() {
    let scalar: UnicodeScalar = "¿"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "¿")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "¿")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "¿")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "¿")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'À' - LATIN CAPITAL LETTER A WITH GRAVE (U+00c0)
  func test_latinCapitalLetterAWithGrave() {
    let scalar: UnicodeScalar = "À"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "à")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "À")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "À")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "à")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Á' - LATIN CAPITAL LETTER A WITH ACUTE (U+00c1)
  func test_latinCapitalLetterAWithAcute() {
    let scalar: UnicodeScalar = "Á"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "á")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Á")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Á")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "á")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Â' - LATIN CAPITAL LETTER A WITH CIRCUMFLEX (U+00c2)
  func test_latinCapitalLetterAWithCircumflex() {
    let scalar: UnicodeScalar = "Â"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "â")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Â")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Â")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "â")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Ã' - LATIN CAPITAL LETTER A WITH TILDE (U+00c3)
  func test_latinCapitalLetterAWithTilde() {
    let scalar: UnicodeScalar = "Ã"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ã")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ã")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ã")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ã")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Ä' - LATIN CAPITAL LETTER A WITH DIAERESIS (U+00c4)
  func test_latinCapitalLetterAWithDiaeresis() {
    let scalar: UnicodeScalar = "Ä"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ä")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ä")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ä")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ä")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Å' - LATIN CAPITAL LETTER A WITH RING ABOVE (U+00c5)
  func test_latinCapitalLetterAWithRingAbove() {
    let scalar: UnicodeScalar = "Å"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "å")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Å")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Å")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "å")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Æ' - LATIN CAPITAL LETTER AE (U+00c6)
  func test_latinCapitalLetterAe() {
    let scalar: UnicodeScalar = "Æ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "æ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Æ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Æ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "æ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Ç' - LATIN CAPITAL LETTER C WITH CEDILLA (U+00c7)
  func test_latinCapitalLetterCWithCedilla() {
    let scalar: UnicodeScalar = "Ç"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ç")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ç")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ç")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ç")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'È' - LATIN CAPITAL LETTER E WITH GRAVE (U+00c8)
  func test_latinCapitalLetterEWithGrave() {
    let scalar: UnicodeScalar = "È"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "è")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "È")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "È")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "è")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'É' - LATIN CAPITAL LETTER E WITH ACUTE (U+00c9)
  func test_latinCapitalLetterEWithAcute() {
    let scalar: UnicodeScalar = "É"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "é")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "É")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "É")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "é")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Ê' - LATIN CAPITAL LETTER E WITH CIRCUMFLEX (U+00ca)
  func test_latinCapitalLetterEWithCircumflex() {
    let scalar: UnicodeScalar = "Ê"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ê")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ê")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ê")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ê")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Ë' - LATIN CAPITAL LETTER E WITH DIAERESIS (U+00cb)
  func test_latinCapitalLetterEWithDiaeresis() {
    let scalar: UnicodeScalar = "Ë"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ë")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ë")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ë")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ë")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Ì' - LATIN CAPITAL LETTER I WITH GRAVE (U+00cc)
  func test_latinCapitalLetterIWithGrave() {
    let scalar: UnicodeScalar = "Ì"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ì")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ì")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ì")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ì")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Í' - LATIN CAPITAL LETTER I WITH ACUTE (U+00cd)
  func test_latinCapitalLetterIWithAcute() {
    let scalar: UnicodeScalar = "Í"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "í")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Í")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Í")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "í")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Î' - LATIN CAPITAL LETTER I WITH CIRCUMFLEX (U+00ce)
  func test_latinCapitalLetterIWithCircumflex() {
    let scalar: UnicodeScalar = "Î"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "î")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Î")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Î")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "î")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Ï' - LATIN CAPITAL LETTER I WITH DIAERESIS (U+00cf)
  func test_latinCapitalLetterIWithDiaeresis() {
    let scalar: UnicodeScalar = "Ï"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ï")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ï")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ï")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ï")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Ð' - LATIN CAPITAL LETTER ETH (U+00d0)
  func test_latinCapitalLetterEth() {
    let scalar: UnicodeScalar = "Ð"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ð")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ð")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ð")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ð")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Ñ' - LATIN CAPITAL LETTER N WITH TILDE (U+00d1)
  func test_latinCapitalLetterNWithTilde() {
    let scalar: UnicodeScalar = "Ñ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ñ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ñ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ñ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ñ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Ò' - LATIN CAPITAL LETTER O WITH GRAVE (U+00d2)
  func test_latinCapitalLetterOWithGrave() {
    let scalar: UnicodeScalar = "Ò"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ò")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ò")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ò")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ò")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Ó' - LATIN CAPITAL LETTER O WITH ACUTE (U+00d3)
  func test_latinCapitalLetterOWithAcute() {
    let scalar: UnicodeScalar = "Ó"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ó")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ó")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ó")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ó")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Ô' - LATIN CAPITAL LETTER O WITH CIRCUMFLEX (U+00d4)
  func test_latinCapitalLetterOWithCircumflex() {
    let scalar: UnicodeScalar = "Ô"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ô")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ô")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ô")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ô")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Õ' - LATIN CAPITAL LETTER O WITH TILDE (U+00d5)
  func test_latinCapitalLetterOWithTilde() {
    let scalar: UnicodeScalar = "Õ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "õ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Õ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Õ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "õ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Ö' - LATIN CAPITAL LETTER O WITH DIAERESIS (U+00d6)
  func test_latinCapitalLetterOWithDiaeresis() {
    let scalar: UnicodeScalar = "Ö"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ö")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ö")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ö")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ö")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '×' - MULTIPLICATION SIGN (U+00d7)
  func test_multiplicationSign() {
    let scalar: UnicodeScalar = "×"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "×")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "×")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "×")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "×")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Ø' - LATIN CAPITAL LETTER O WITH STROKE (U+00d8)
  func test_latinCapitalLetterOWithStroke() {
    let scalar: UnicodeScalar = "Ø"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ø")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ø")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ø")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ø")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Ù' - LATIN CAPITAL LETTER U WITH GRAVE (U+00d9)
  func test_latinCapitalLetterUWithGrave() {
    let scalar: UnicodeScalar = "Ù"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ù")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ù")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ù")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ù")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Ú' - LATIN CAPITAL LETTER U WITH ACUTE (U+00da)
  func test_latinCapitalLetterUWithAcute() {
    let scalar: UnicodeScalar = "Ú"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ú")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ú")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ú")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ú")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Û' - LATIN CAPITAL LETTER U WITH CIRCUMFLEX (U+00db)
  func test_latinCapitalLetterUWithCircumflex() {
    let scalar: UnicodeScalar = "Û"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "û")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Û")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Û")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "û")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Ü' - LATIN CAPITAL LETTER U WITH DIAERESIS (U+00dc)
  func test_latinCapitalLetterUWithDiaeresis() {
    let scalar: UnicodeScalar = "Ü"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ü")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ü")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ü")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ü")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Ý' - LATIN CAPITAL LETTER Y WITH ACUTE (U+00dd)
  func test_latinCapitalLetterYWithAcute() {
    let scalar: UnicodeScalar = "Ý"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ý")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ý")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ý")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ý")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'Þ' - LATIN CAPITAL LETTER THORN (U+00de)
  func test_latinCapitalLetterThorn() {
    let scalar: UnicodeScalar = "Þ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "þ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), true)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Þ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Þ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "þ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ß' - LATIN SMALL LETTER SHARP S (U+00df)
  func test_latinSmallLetterSharpS() {
    let scalar: UnicodeScalar = "ß"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ß")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "SS")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ss")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ss")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'à' - LATIN SMALL LETTER A WITH GRAVE (U+00e0)
  func test_latinSmallLetterAWithGrave() {
    let scalar: UnicodeScalar = "à"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "à")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "À")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "À")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "à")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'á' - LATIN SMALL LETTER A WITH ACUTE (U+00e1)
  func test_latinSmallLetterAWithAcute() {
    let scalar: UnicodeScalar = "á"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "á")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Á")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Á")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "á")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'â' - LATIN SMALL LETTER A WITH CIRCUMFLEX (U+00e2)
  func test_latinSmallLetterAWithCircumflex() {
    let scalar: UnicodeScalar = "â"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "â")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Â")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Â")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "â")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ã' - LATIN SMALL LETTER A WITH TILDE (U+00e3)
  func test_latinSmallLetterAWithTilde() {
    let scalar: UnicodeScalar = "ã"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ã")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ã")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ã")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ã")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ä' - LATIN SMALL LETTER A WITH DIAERESIS (U+00e4)
  func test_latinSmallLetterAWithDiaeresis() {
    let scalar: UnicodeScalar = "ä"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ä")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ä")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ä")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ä")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'å' - LATIN SMALL LETTER A WITH RING ABOVE (U+00e5)
  func test_latinSmallLetterAWithRingAbove() {
    let scalar: UnicodeScalar = "å"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "å")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Å")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Å")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "å")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'æ' - LATIN SMALL LETTER AE (U+00e6)
  func test_latinSmallLetterAe() {
    let scalar: UnicodeScalar = "æ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "æ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Æ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Æ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "æ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ç' - LATIN SMALL LETTER C WITH CEDILLA (U+00e7)
  func test_latinSmallLetterCWithCedilla() {
    let scalar: UnicodeScalar = "ç"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ç")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ç")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ç")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ç")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'è' - LATIN SMALL LETTER E WITH GRAVE (U+00e8)
  func test_latinSmallLetterEWithGrave() {
    let scalar: UnicodeScalar = "è"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "è")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "È")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "È")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "è")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'é' - LATIN SMALL LETTER E WITH ACUTE (U+00e9)
  func test_latinSmallLetterEWithAcute() {
    let scalar: UnicodeScalar = "é"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "é")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "É")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "É")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "é")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ê' - LATIN SMALL LETTER E WITH CIRCUMFLEX (U+00ea)
  func test_latinSmallLetterEWithCircumflex() {
    let scalar: UnicodeScalar = "ê"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ê")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ê")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ê")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ê")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ë' - LATIN SMALL LETTER E WITH DIAERESIS (U+00eb)
  func test_latinSmallLetterEWithDiaeresis() {
    let scalar: UnicodeScalar = "ë"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ë")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ë")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ë")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ë")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ì' - LATIN SMALL LETTER I WITH GRAVE (U+00ec)
  func test_latinSmallLetterIWithGrave() {
    let scalar: UnicodeScalar = "ì"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ì")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ì")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ì")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ì")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'í' - LATIN SMALL LETTER I WITH ACUTE (U+00ed)
  func test_latinSmallLetterIWithAcute() {
    let scalar: UnicodeScalar = "í"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "í")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Í")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Í")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "í")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'î' - LATIN SMALL LETTER I WITH CIRCUMFLEX (U+00ee)
  func test_latinSmallLetterIWithCircumflex() {
    let scalar: UnicodeScalar = "î"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "î")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Î")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Î")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "î")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ï' - LATIN SMALL LETTER I WITH DIAERESIS (U+00ef)
  func test_latinSmallLetterIWithDiaeresis() {
    let scalar: UnicodeScalar = "ï"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ï")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ï")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ï")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ï")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ð' - LATIN SMALL LETTER ETH (U+00f0)
  func test_latinSmallLetterEth() {
    let scalar: UnicodeScalar = "ð"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ð")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ð")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ð")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ð")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ñ' - LATIN SMALL LETTER N WITH TILDE (U+00f1)
  func test_latinSmallLetterNWithTilde() {
    let scalar: UnicodeScalar = "ñ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ñ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ñ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ñ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ñ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ò' - LATIN SMALL LETTER O WITH GRAVE (U+00f2)
  func test_latinSmallLetterOWithGrave() {
    let scalar: UnicodeScalar = "ò"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ò")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ò")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ò")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ò")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ó' - LATIN SMALL LETTER O WITH ACUTE (U+00f3)
  func test_latinSmallLetterOWithAcute() {
    let scalar: UnicodeScalar = "ó"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ó")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ó")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ó")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ó")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ô' - LATIN SMALL LETTER O WITH CIRCUMFLEX (U+00f4)
  func test_latinSmallLetterOWithCircumflex() {
    let scalar: UnicodeScalar = "ô"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ô")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ô")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ô")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ô")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'õ' - LATIN SMALL LETTER O WITH TILDE (U+00f5)
  func test_latinSmallLetterOWithTilde() {
    let scalar: UnicodeScalar = "õ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "õ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Õ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Õ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "õ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ö' - LATIN SMALL LETTER O WITH DIAERESIS (U+00f6)
  func test_latinSmallLetterOWithDiaeresis() {
    let scalar: UnicodeScalar = "ö"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ö")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ö")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ö")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ö")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '÷' - DIVISION SIGN (U+00f7)
  func test_divisionSign() {
    let scalar: UnicodeScalar = "÷"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "÷")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "÷")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "÷")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "÷")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), false)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), false)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), false)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ø' - LATIN SMALL LETTER O WITH STROKE (U+00f8)
  func test_latinSmallLetterOWithStroke() {
    let scalar: UnicodeScalar = "ø"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ø")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ø")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ø")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ø")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ù' - LATIN SMALL LETTER U WITH GRAVE (U+00f9)
  func test_latinSmallLetterUWithGrave() {
    let scalar: UnicodeScalar = "ù"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ù")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ù")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ù")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ù")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ú' - LATIN SMALL LETTER U WITH ACUTE (U+00fa)
  func test_latinSmallLetterUWithAcute() {
    let scalar: UnicodeScalar = "ú"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ú")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ú")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ú")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ú")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'û' - LATIN SMALL LETTER U WITH CIRCUMFLEX (U+00fb)
  func test_latinSmallLetterUWithCircumflex() {
    let scalar: UnicodeScalar = "û"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "û")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Û")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Û")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "û")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ü' - LATIN SMALL LETTER U WITH DIAERESIS (U+00fc)
  func test_latinSmallLetterUWithDiaeresis() {
    let scalar: UnicodeScalar = "ü"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ü")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ü")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ü")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ü")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ý' - LATIN SMALL LETTER Y WITH ACUTE (U+00fd)
  func test_latinSmallLetterYWithAcute() {
    let scalar: UnicodeScalar = "ý"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ý")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ý")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ý")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ý")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'þ' - LATIN SMALL LETTER THORN (U+00fe)
  func test_latinSmallLetterThorn() {
    let scalar: UnicodeScalar = "þ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "þ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Þ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Þ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "þ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ÿ' - LATIN SMALL LETTER Y WITH DIAERESIS (U+00ff)
  func test_latinSmallLetterYWithDiaeresis() {
    let scalar: UnicodeScalar = "ÿ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ÿ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ÿ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ÿ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ÿ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }
}

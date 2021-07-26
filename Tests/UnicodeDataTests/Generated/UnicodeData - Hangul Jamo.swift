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

/// Tests for: 1100..11ff Hangul Jamo block
class UnicodeDataHangulJamoTests: XCTestCase {

  /// 'ᄀ' - HANGUL CHOSEONG KIYEOK (U+1100)
  func test_hangulChoseongKiyeok() {
    let scalar: UnicodeScalar = "ᄀ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄀ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄀ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄀ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄀ")

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

  /// 'ᄁ' - HANGUL CHOSEONG SSANGKIYEOK (U+1101)
  func test_hangulChoseongSsangkiyeok() {
    let scalar: UnicodeScalar = "ᄁ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄁ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄁ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄁ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄁ")

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

  /// 'ᄂ' - HANGUL CHOSEONG NIEUN (U+1102)
  func test_hangulChoseongNieun() {
    let scalar: UnicodeScalar = "ᄂ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄂ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄂ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄂ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄂ")

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

  /// 'ᄃ' - HANGUL CHOSEONG TIKEUT (U+1103)
  func test_hangulChoseongTikeut() {
    let scalar: UnicodeScalar = "ᄃ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄃ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄃ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄃ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄃ")

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

  /// 'ᄄ' - HANGUL CHOSEONG SSANGTIKEUT (U+1104)
  func test_hangulChoseongSsangtikeut() {
    let scalar: UnicodeScalar = "ᄄ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄄ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄄ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄄ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄄ")

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

  /// 'ᄅ' - HANGUL CHOSEONG RIEUL (U+1105)
  func test_hangulChoseongRieul() {
    let scalar: UnicodeScalar = "ᄅ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄅ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄅ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄅ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄅ")

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

  /// 'ᄆ' - HANGUL CHOSEONG MIEUM (U+1106)
  func test_hangulChoseongMieum() {
    let scalar: UnicodeScalar = "ᄆ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄆ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄆ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄆ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄆ")

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

  /// 'ᄇ' - HANGUL CHOSEONG PIEUP (U+1107)
  func test_hangulChoseongPieup() {
    let scalar: UnicodeScalar = "ᄇ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄇ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄇ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄇ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄇ")

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

  /// 'ᄈ' - HANGUL CHOSEONG SSANGPIEUP (U+1108)
  func test_hangulChoseongSsangpieup() {
    let scalar: UnicodeScalar = "ᄈ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄈ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄈ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄈ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄈ")

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

  /// 'ᄉ' - HANGUL CHOSEONG SIOS (U+1109)
  func test_hangulChoseongSios() {
    let scalar: UnicodeScalar = "ᄉ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄉ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄉ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄉ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄉ")

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

  /// 'ᄊ' - HANGUL CHOSEONG SSANGSIOS (U+110a)
  func test_hangulChoseongSsangsios() {
    let scalar: UnicodeScalar = "ᄊ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄊ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄊ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄊ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄊ")

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

  /// 'ᄋ' - HANGUL CHOSEONG IEUNG (U+110b)
  func test_hangulChoseongIeung() {
    let scalar: UnicodeScalar = "ᄋ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄋ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄋ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄋ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄋ")

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

  /// 'ᄌ' - HANGUL CHOSEONG CIEUC (U+110c)
  func test_hangulChoseongCieuc() {
    let scalar: UnicodeScalar = "ᄌ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄌ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄌ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄌ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄌ")

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

  /// 'ᄍ' - HANGUL CHOSEONG SSANGCIEUC (U+110d)
  func test_hangulChoseongSsangcieuc() {
    let scalar: UnicodeScalar = "ᄍ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄍ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄍ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄍ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄍ")

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

  /// 'ᄎ' - HANGUL CHOSEONG CHIEUCH (U+110e)
  func test_hangulChoseongChieuch() {
    let scalar: UnicodeScalar = "ᄎ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄎ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄎ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄎ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄎ")

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

  /// 'ᄏ' - HANGUL CHOSEONG KHIEUKH (U+110f)
  func test_hangulChoseongKhieukh() {
    let scalar: UnicodeScalar = "ᄏ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄏ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄏ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄏ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄏ")

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

  /// 'ᄐ' - HANGUL CHOSEONG THIEUTH (U+1110)
  func test_hangulChoseongThieuth() {
    let scalar: UnicodeScalar = "ᄐ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄐ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄐ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄐ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄐ")

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

  /// 'ᄑ' - HANGUL CHOSEONG PHIEUPH (U+1111)
  func test_hangulChoseongPhieuph() {
    let scalar: UnicodeScalar = "ᄑ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄑ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄑ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄑ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄑ")

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

  /// 'ᄒ' - HANGUL CHOSEONG HIEUH (U+1112)
  func test_hangulChoseongHieuh() {
    let scalar: UnicodeScalar = "ᄒ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄒ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄒ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄒ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄒ")

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

  /// 'ᄓ' - HANGUL CHOSEONG NIEUN-KIYEOK (U+1113)
  func test_hangulChoseongNieun_kiyeok() {
    let scalar: UnicodeScalar = "ᄓ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄓ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄓ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄓ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄓ")

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

  /// 'ᄔ' - HANGUL CHOSEONG SSANGNIEUN (U+1114)
  func test_hangulChoseongSsangnieun() {
    let scalar: UnicodeScalar = "ᄔ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄔ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄔ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄔ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄔ")

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

  /// 'ᄕ' - HANGUL CHOSEONG NIEUN-TIKEUT (U+1115)
  func test_hangulChoseongNieun_tikeut() {
    let scalar: UnicodeScalar = "ᄕ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄕ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄕ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄕ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄕ")

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

  /// 'ᄖ' - HANGUL CHOSEONG NIEUN-PIEUP (U+1116)
  func test_hangulChoseongNieun_pieup() {
    let scalar: UnicodeScalar = "ᄖ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄖ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄖ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄖ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄖ")

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

  /// 'ᄗ' - HANGUL CHOSEONG TIKEUT-KIYEOK (U+1117)
  func test_hangulChoseongTikeut_kiyeok() {
    let scalar: UnicodeScalar = "ᄗ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄗ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄗ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄗ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄗ")

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

  /// 'ᄘ' - HANGUL CHOSEONG RIEUL-NIEUN (U+1118)
  func test_hangulChoseongRieul_nieun() {
    let scalar: UnicodeScalar = "ᄘ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄘ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄘ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄘ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄘ")

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

  /// 'ᄙ' - HANGUL CHOSEONG SSANGRIEUL (U+1119)
  func test_hangulChoseongSsangrieul() {
    let scalar: UnicodeScalar = "ᄙ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄙ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄙ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄙ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄙ")

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

  /// 'ᄚ' - HANGUL CHOSEONG RIEUL-HIEUH (U+111a)
  func test_hangulChoseongRieul_hieuh() {
    let scalar: UnicodeScalar = "ᄚ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄚ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄚ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄚ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄚ")

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

  /// 'ᄛ' - HANGUL CHOSEONG KAPYEOUNRIEUL (U+111b)
  func test_hangulChoseongKapyeounrieul() {
    let scalar: UnicodeScalar = "ᄛ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄛ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄛ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄛ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄛ")

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

  /// 'ᄜ' - HANGUL CHOSEONG MIEUM-PIEUP (U+111c)
  func test_hangulChoseongMieum_pieup() {
    let scalar: UnicodeScalar = "ᄜ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄜ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄜ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄜ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄜ")

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

  /// 'ᄝ' - HANGUL CHOSEONG KAPYEOUNMIEUM (U+111d)
  func test_hangulChoseongKapyeounmieum() {
    let scalar: UnicodeScalar = "ᄝ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄝ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄝ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄝ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄝ")

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

  /// 'ᄞ' - HANGUL CHOSEONG PIEUP-KIYEOK (U+111e)
  func test_hangulChoseongPieup_kiyeok() {
    let scalar: UnicodeScalar = "ᄞ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄞ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄞ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄞ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄞ")

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

  /// 'ᄟ' - HANGUL CHOSEONG PIEUP-NIEUN (U+111f)
  func test_hangulChoseongPieup_nieun() {
    let scalar: UnicodeScalar = "ᄟ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄟ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄟ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄟ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄟ")

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

  /// 'ᄠ' - HANGUL CHOSEONG PIEUP-TIKEUT (U+1120)
  func test_hangulChoseongPieup_tikeut() {
    let scalar: UnicodeScalar = "ᄠ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄠ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄠ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄠ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄠ")

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

  /// 'ᄡ' - HANGUL CHOSEONG PIEUP-SIOS (U+1121)
  func test_hangulChoseongPieup_sios() {
    let scalar: UnicodeScalar = "ᄡ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄡ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄡ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄡ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄡ")

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

  /// 'ᄢ' - HANGUL CHOSEONG PIEUP-SIOS-KIYEOK (U+1122)
  func test_hangulChoseongPieup_sios_kiyeok() {
    let scalar: UnicodeScalar = "ᄢ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄢ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄢ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄢ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄢ")

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

  /// 'ᄣ' - HANGUL CHOSEONG PIEUP-SIOS-TIKEUT (U+1123)
  func test_hangulChoseongPieup_sios_tikeut() {
    let scalar: UnicodeScalar = "ᄣ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄣ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄣ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄣ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄣ")

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

  /// 'ᄤ' - HANGUL CHOSEONG PIEUP-SIOS-PIEUP (U+1124)
  func test_hangulChoseongPieup_sios_pieup() {
    let scalar: UnicodeScalar = "ᄤ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄤ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄤ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄤ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄤ")

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

  /// 'ᄥ' - HANGUL CHOSEONG PIEUP-SSANGSIOS (U+1125)
  func test_hangulChoseongPieup_ssangsios() {
    let scalar: UnicodeScalar = "ᄥ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄥ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄥ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄥ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄥ")

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

  /// 'ᄦ' - HANGUL CHOSEONG PIEUP-SIOS-CIEUC (U+1126)
  func test_hangulChoseongPieup_sios_cieuc() {
    let scalar: UnicodeScalar = "ᄦ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄦ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄦ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄦ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄦ")

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

  /// 'ᄧ' - HANGUL CHOSEONG PIEUP-CIEUC (U+1127)
  func test_hangulChoseongPieup_cieuc() {
    let scalar: UnicodeScalar = "ᄧ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄧ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄧ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄧ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄧ")

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

  /// 'ᄨ' - HANGUL CHOSEONG PIEUP-CHIEUCH (U+1128)
  func test_hangulChoseongPieup_chieuch() {
    let scalar: UnicodeScalar = "ᄨ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄨ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄨ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄨ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄨ")

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

  /// 'ᄩ' - HANGUL CHOSEONG PIEUP-THIEUTH (U+1129)
  func test_hangulChoseongPieup_thieuth() {
    let scalar: UnicodeScalar = "ᄩ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄩ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄩ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄩ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄩ")

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

  /// 'ᄪ' - HANGUL CHOSEONG PIEUP-PHIEUPH (U+112a)
  func test_hangulChoseongPieup_phieuph() {
    let scalar: UnicodeScalar = "ᄪ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄪ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄪ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄪ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄪ")

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

  /// 'ᄫ' - HANGUL CHOSEONG KAPYEOUNPIEUP (U+112b)
  func test_hangulChoseongKapyeounpieup() {
    let scalar: UnicodeScalar = "ᄫ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄫ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄫ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄫ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄫ")

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

  /// 'ᄬ' - HANGUL CHOSEONG KAPYEOUNSSANGPIEUP (U+112c)
  func test_hangulChoseongKapyeounssangpieup() {
    let scalar: UnicodeScalar = "ᄬ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄬ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄬ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄬ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄬ")

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

  /// 'ᄭ' - HANGUL CHOSEONG SIOS-KIYEOK (U+112d)
  func test_hangulChoseongSios_kiyeok() {
    let scalar: UnicodeScalar = "ᄭ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄭ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄭ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄭ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄭ")

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

  /// 'ᄮ' - HANGUL CHOSEONG SIOS-NIEUN (U+112e)
  func test_hangulChoseongSios_nieun() {
    let scalar: UnicodeScalar = "ᄮ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄮ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄮ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄮ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄮ")

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

  /// 'ᄯ' - HANGUL CHOSEONG SIOS-TIKEUT (U+112f)
  func test_hangulChoseongSios_tikeut() {
    let scalar: UnicodeScalar = "ᄯ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄯ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄯ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄯ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄯ")

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

  /// 'ᄰ' - HANGUL CHOSEONG SIOS-RIEUL (U+1130)
  func test_hangulChoseongSios_rieul() {
    let scalar: UnicodeScalar = "ᄰ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄰ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄰ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄰ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄰ")

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

  /// 'ᄱ' - HANGUL CHOSEONG SIOS-MIEUM (U+1131)
  func test_hangulChoseongSios_mieum() {
    let scalar: UnicodeScalar = "ᄱ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄱ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄱ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄱ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄱ")

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

  /// 'ᄲ' - HANGUL CHOSEONG SIOS-PIEUP (U+1132)
  func test_hangulChoseongSios_pieup() {
    let scalar: UnicodeScalar = "ᄲ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄲ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄲ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄲ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄲ")

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

  /// 'ᄳ' - HANGUL CHOSEONG SIOS-PIEUP-KIYEOK (U+1133)
  func test_hangulChoseongSios_pieup_kiyeok() {
    let scalar: UnicodeScalar = "ᄳ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄳ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄳ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄳ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄳ")

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

  /// 'ᄴ' - HANGUL CHOSEONG SIOS-SSANGSIOS (U+1134)
  func test_hangulChoseongSios_ssangsios() {
    let scalar: UnicodeScalar = "ᄴ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄴ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄴ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄴ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄴ")

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

  /// 'ᄵ' - HANGUL CHOSEONG SIOS-IEUNG (U+1135)
  func test_hangulChoseongSios_ieung() {
    let scalar: UnicodeScalar = "ᄵ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄵ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄵ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄵ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄵ")

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

  /// 'ᄶ' - HANGUL CHOSEONG SIOS-CIEUC (U+1136)
  func test_hangulChoseongSios_cieuc() {
    let scalar: UnicodeScalar = "ᄶ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄶ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄶ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄶ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄶ")

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

  /// 'ᄷ' - HANGUL CHOSEONG SIOS-CHIEUCH (U+1137)
  func test_hangulChoseongSios_chieuch() {
    let scalar: UnicodeScalar = "ᄷ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄷ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄷ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄷ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄷ")

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

  /// 'ᄸ' - HANGUL CHOSEONG SIOS-KHIEUKH (U+1138)
  func test_hangulChoseongSios_khieukh() {
    let scalar: UnicodeScalar = "ᄸ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄸ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄸ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄸ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄸ")

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

  /// 'ᄹ' - HANGUL CHOSEONG SIOS-THIEUTH (U+1139)
  func test_hangulChoseongSios_thieuth() {
    let scalar: UnicodeScalar = "ᄹ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄹ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄹ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄹ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄹ")

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

  /// 'ᄺ' - HANGUL CHOSEONG SIOS-PHIEUPH (U+113a)
  func test_hangulChoseongSios_phieuph() {
    let scalar: UnicodeScalar = "ᄺ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄺ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄺ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄺ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄺ")

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

  /// 'ᄻ' - HANGUL CHOSEONG SIOS-HIEUH (U+113b)
  func test_hangulChoseongSios_hieuh() {
    let scalar: UnicodeScalar = "ᄻ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄻ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄻ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄻ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄻ")

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

  /// 'ᄼ' - HANGUL CHOSEONG CHITUEUMSIOS (U+113c)
  func test_hangulChoseongChitueumsios() {
    let scalar: UnicodeScalar = "ᄼ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄼ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄼ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄼ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄼ")

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

  /// 'ᄽ' - HANGUL CHOSEONG CHITUEUMSSANGSIOS (U+113d)
  func test_hangulChoseongChitueumssangsios() {
    let scalar: UnicodeScalar = "ᄽ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄽ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄽ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄽ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄽ")

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

  /// 'ᄾ' - HANGUL CHOSEONG CEONGCHIEUMSIOS (U+113e)
  func test_hangulChoseongCeongchieumsios() {
    let scalar: UnicodeScalar = "ᄾ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄾ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄾ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄾ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄾ")

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

  /// 'ᄿ' - HANGUL CHOSEONG CEONGCHIEUMSSANGSIOS (U+113f)
  func test_hangulChoseongCeongchieumssangsios() {
    let scalar: UnicodeScalar = "ᄿ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᄿ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᄿ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᄿ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᄿ")

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

  /// 'ᅀ' - HANGUL CHOSEONG PANSIOS (U+1140)
  func test_hangulChoseongPansios() {
    let scalar: UnicodeScalar = "ᅀ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅀ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅀ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅀ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅀ")

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

  /// 'ᅁ' - HANGUL CHOSEONG IEUNG-KIYEOK (U+1141)
  func test_hangulChoseongIeung_kiyeok() {
    let scalar: UnicodeScalar = "ᅁ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅁ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅁ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅁ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅁ")

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

  /// 'ᅂ' - HANGUL CHOSEONG IEUNG-TIKEUT (U+1142)
  func test_hangulChoseongIeung_tikeut() {
    let scalar: UnicodeScalar = "ᅂ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅂ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅂ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅂ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅂ")

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

  /// 'ᅃ' - HANGUL CHOSEONG IEUNG-MIEUM (U+1143)
  func test_hangulChoseongIeung_mieum() {
    let scalar: UnicodeScalar = "ᅃ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅃ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅃ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅃ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅃ")

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

  /// 'ᅄ' - HANGUL CHOSEONG IEUNG-PIEUP (U+1144)
  func test_hangulChoseongIeung_pieup() {
    let scalar: UnicodeScalar = "ᅄ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅄ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅄ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅄ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅄ")

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

  /// 'ᅅ' - HANGUL CHOSEONG IEUNG-SIOS (U+1145)
  func test_hangulChoseongIeung_sios() {
    let scalar: UnicodeScalar = "ᅅ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅅ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅅ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅅ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅅ")

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

  /// 'ᅆ' - HANGUL CHOSEONG IEUNG-PANSIOS (U+1146)
  func test_hangulChoseongIeung_pansios() {
    let scalar: UnicodeScalar = "ᅆ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅆ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅆ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅆ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅆ")

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

  /// 'ᅇ' - HANGUL CHOSEONG SSANGIEUNG (U+1147)
  func test_hangulChoseongSsangieung() {
    let scalar: UnicodeScalar = "ᅇ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅇ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅇ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅇ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅇ")

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

  /// 'ᅈ' - HANGUL CHOSEONG IEUNG-CIEUC (U+1148)
  func test_hangulChoseongIeung_cieuc() {
    let scalar: UnicodeScalar = "ᅈ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅈ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅈ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅈ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅈ")

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

  /// 'ᅉ' - HANGUL CHOSEONG IEUNG-CHIEUCH (U+1149)
  func test_hangulChoseongIeung_chieuch() {
    let scalar: UnicodeScalar = "ᅉ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅉ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅉ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅉ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅉ")

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

  /// 'ᅊ' - HANGUL CHOSEONG IEUNG-THIEUTH (U+114a)
  func test_hangulChoseongIeung_thieuth() {
    let scalar: UnicodeScalar = "ᅊ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅊ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅊ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅊ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅊ")

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

  /// 'ᅋ' - HANGUL CHOSEONG IEUNG-PHIEUPH (U+114b)
  func test_hangulChoseongIeung_phieuph() {
    let scalar: UnicodeScalar = "ᅋ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅋ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅋ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅋ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅋ")

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

  /// 'ᅌ' - HANGUL CHOSEONG YESIEUNG (U+114c)
  func test_hangulChoseongYesieung() {
    let scalar: UnicodeScalar = "ᅌ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅌ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅌ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅌ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅌ")

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

  /// 'ᅍ' - HANGUL CHOSEONG CIEUC-IEUNG (U+114d)
  func test_hangulChoseongCieuc_ieung() {
    let scalar: UnicodeScalar = "ᅍ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅍ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅍ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅍ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅍ")

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

  /// 'ᅎ' - HANGUL CHOSEONG CHITUEUMCIEUC (U+114e)
  func test_hangulChoseongChitueumcieuc() {
    let scalar: UnicodeScalar = "ᅎ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅎ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅎ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅎ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅎ")

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

  /// 'ᅏ' - HANGUL CHOSEONG CHITUEUMSSANGCIEUC (U+114f)
  func test_hangulChoseongChitueumssangcieuc() {
    let scalar: UnicodeScalar = "ᅏ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅏ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅏ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅏ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅏ")

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

  /// 'ᅐ' - HANGUL CHOSEONG CEONGCHIEUMCIEUC (U+1150)
  func test_hangulChoseongCeongchieumcieuc() {
    let scalar: UnicodeScalar = "ᅐ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅐ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅐ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅐ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅐ")

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

  /// 'ᅑ' - HANGUL CHOSEONG CEONGCHIEUMSSANGCIEUC (U+1151)
  func test_hangulChoseongCeongchieumssangcieuc() {
    let scalar: UnicodeScalar = "ᅑ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅑ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅑ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅑ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅑ")

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

  /// 'ᅒ' - HANGUL CHOSEONG CHIEUCH-KHIEUKH (U+1152)
  func test_hangulChoseongChieuch_khieukh() {
    let scalar: UnicodeScalar = "ᅒ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅒ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅒ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅒ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅒ")

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

  /// 'ᅓ' - HANGUL CHOSEONG CHIEUCH-HIEUH (U+1153)
  func test_hangulChoseongChieuch_hieuh() {
    let scalar: UnicodeScalar = "ᅓ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅓ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅓ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅓ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅓ")

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

  /// 'ᅔ' - HANGUL CHOSEONG CHITUEUMCHIEUCH (U+1154)
  func test_hangulChoseongChitueumchieuch() {
    let scalar: UnicodeScalar = "ᅔ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅔ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅔ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅔ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅔ")

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

  /// 'ᅕ' - HANGUL CHOSEONG CEONGCHIEUMCHIEUCH (U+1155)
  func test_hangulChoseongCeongchieumchieuch() {
    let scalar: UnicodeScalar = "ᅕ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅕ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅕ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅕ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅕ")

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

  /// 'ᅖ' - HANGUL CHOSEONG PHIEUPH-PIEUP (U+1156)
  func test_hangulChoseongPhieuph_pieup() {
    let scalar: UnicodeScalar = "ᅖ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅖ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅖ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅖ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅖ")

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

  /// 'ᅗ' - HANGUL CHOSEONG KAPYEOUNPHIEUPH (U+1157)
  func test_hangulChoseongKapyeounphieuph() {
    let scalar: UnicodeScalar = "ᅗ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅗ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅗ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅗ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅗ")

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

  /// 'ᅘ' - HANGUL CHOSEONG SSANGHIEUH (U+1158)
  func test_hangulChoseongSsanghieuh() {
    let scalar: UnicodeScalar = "ᅘ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅘ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅘ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅘ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅘ")

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

  /// 'ᅙ' - HANGUL CHOSEONG YEORINHIEUH (U+1159)
  func test_hangulChoseongYeorinhieuh() {
    let scalar: UnicodeScalar = "ᅙ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅙ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅙ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅙ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅙ")

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

  /// 'ᅚ' - HANGUL CHOSEONG KIYEOK-TIKEUT (U+115a)
  func test_hangulChoseongKiyeok_tikeut() {
    let scalar: UnicodeScalar = "ᅚ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅚ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅚ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅚ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅚ")

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

  /// 'ᅛ' - HANGUL CHOSEONG NIEUN-SIOS (U+115b)
  func test_hangulChoseongNieun_sios() {
    let scalar: UnicodeScalar = "ᅛ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅛ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅛ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅛ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅛ")

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

  /// 'ᅜ' - HANGUL CHOSEONG NIEUN-CIEUC (U+115c)
  func test_hangulChoseongNieun_cieuc() {
    let scalar: UnicodeScalar = "ᅜ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅜ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅜ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅜ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅜ")

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

  /// 'ᅝ' - HANGUL CHOSEONG NIEUN-HIEUH (U+115d)
  func test_hangulChoseongNieun_hieuh() {
    let scalar: UnicodeScalar = "ᅝ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅝ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅝ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅝ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅝ")

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

  /// 'ᅞ' - HANGUL CHOSEONG TIKEUT-RIEUL (U+115e)
  func test_hangulChoseongTikeut_rieul() {
    let scalar: UnicodeScalar = "ᅞ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅞ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅞ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅞ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅞ")

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

  /// 'ᅟ' - HANGUL CHOSEONG FILLER (U+115f)
  func test_hangulChoseongFiller() {
    let scalar: UnicodeScalar = "ᅟ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅟ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅟ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅟ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅟ")

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

  /// 'ᅠ' - HANGUL JUNGSEONG FILLER (U+1160)
  func test_hangulJungseongFiller() {
    let scalar: UnicodeScalar = "ᅠ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅠ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅠ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅠ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅠ")

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

  /// 'ᅡ' - HANGUL JUNGSEONG A (U+1161)
  func test_hangulJungseongA() {
    let scalar: UnicodeScalar = "ᅡ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅡ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅡ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅡ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅡ")

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

  /// 'ᅢ' - HANGUL JUNGSEONG AE (U+1162)
  func test_hangulJungseongAe() {
    let scalar: UnicodeScalar = "ᅢ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅢ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅢ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅢ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅢ")

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

  /// 'ᅣ' - HANGUL JUNGSEONG YA (U+1163)
  func test_hangulJungseongYa() {
    let scalar: UnicodeScalar = "ᅣ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅣ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅣ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅣ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅣ")

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

  /// 'ᅤ' - HANGUL JUNGSEONG YAE (U+1164)
  func test_hangulJungseongYae() {
    let scalar: UnicodeScalar = "ᅤ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅤ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅤ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅤ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅤ")

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

  /// 'ᅥ' - HANGUL JUNGSEONG EO (U+1165)
  func test_hangulJungseongEo() {
    let scalar: UnicodeScalar = "ᅥ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅥ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅥ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅥ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅥ")

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

  /// 'ᅦ' - HANGUL JUNGSEONG E (U+1166)
  func test_hangulJungseongE() {
    let scalar: UnicodeScalar = "ᅦ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅦ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅦ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅦ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅦ")

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

  /// 'ᅧ' - HANGUL JUNGSEONG YEO (U+1167)
  func test_hangulJungseongYeo() {
    let scalar: UnicodeScalar = "ᅧ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅧ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅧ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅧ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅧ")

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

  /// 'ᅨ' - HANGUL JUNGSEONG YE (U+1168)
  func test_hangulJungseongYe() {
    let scalar: UnicodeScalar = "ᅨ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅨ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅨ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅨ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅨ")

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

  /// 'ᅩ' - HANGUL JUNGSEONG O (U+1169)
  func test_hangulJungseongO() {
    let scalar: UnicodeScalar = "ᅩ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅩ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅩ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅩ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅩ")

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

  /// 'ᅪ' - HANGUL JUNGSEONG WA (U+116a)
  func test_hangulJungseongWa() {
    let scalar: UnicodeScalar = "ᅪ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅪ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅪ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅪ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅪ")

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

  /// 'ᅫ' - HANGUL JUNGSEONG WAE (U+116b)
  func test_hangulJungseongWae() {
    let scalar: UnicodeScalar = "ᅫ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅫ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅫ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅫ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅫ")

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

  /// 'ᅬ' - HANGUL JUNGSEONG OE (U+116c)
  func test_hangulJungseongOe() {
    let scalar: UnicodeScalar = "ᅬ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅬ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅬ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅬ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅬ")

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

  /// 'ᅭ' - HANGUL JUNGSEONG YO (U+116d)
  func test_hangulJungseongYo() {
    let scalar: UnicodeScalar = "ᅭ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅭ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅭ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅭ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅭ")

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

  /// 'ᅮ' - HANGUL JUNGSEONG U (U+116e)
  func test_hangulJungseongU() {
    let scalar: UnicodeScalar = "ᅮ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅮ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅮ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅮ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅮ")

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

  /// 'ᅯ' - HANGUL JUNGSEONG WEO (U+116f)
  func test_hangulJungseongWeo() {
    let scalar: UnicodeScalar = "ᅯ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅯ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅯ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅯ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅯ")

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

  /// 'ᅰ' - HANGUL JUNGSEONG WE (U+1170)
  func test_hangulJungseongWe() {
    let scalar: UnicodeScalar = "ᅰ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅰ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅰ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅰ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅰ")

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

  /// 'ᅱ' - HANGUL JUNGSEONG WI (U+1171)
  func test_hangulJungseongWi() {
    let scalar: UnicodeScalar = "ᅱ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅱ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅱ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅱ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅱ")

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

  /// 'ᅲ' - HANGUL JUNGSEONG YU (U+1172)
  func test_hangulJungseongYu() {
    let scalar: UnicodeScalar = "ᅲ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅲ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅲ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅲ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅲ")

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

  /// 'ᅳ' - HANGUL JUNGSEONG EU (U+1173)
  func test_hangulJungseongEu() {
    let scalar: UnicodeScalar = "ᅳ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅳ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅳ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅳ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅳ")

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

  /// 'ᅴ' - HANGUL JUNGSEONG YI (U+1174)
  func test_hangulJungseongYi() {
    let scalar: UnicodeScalar = "ᅴ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅴ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅴ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅴ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅴ")

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

  /// 'ᅵ' - HANGUL JUNGSEONG I (U+1175)
  func test_hangulJungseongI() {
    let scalar: UnicodeScalar = "ᅵ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅵ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅵ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅵ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅵ")

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

  /// 'ᅶ' - HANGUL JUNGSEONG A-O (U+1176)
  func test_hangulJungseongA_o() {
    let scalar: UnicodeScalar = "ᅶ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅶ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅶ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅶ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅶ")

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

  /// 'ᅷ' - HANGUL JUNGSEONG A-U (U+1177)
  func test_hangulJungseongA_u() {
    let scalar: UnicodeScalar = "ᅷ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅷ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅷ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅷ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅷ")

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

  /// 'ᅸ' - HANGUL JUNGSEONG YA-O (U+1178)
  func test_hangulJungseongYa_o() {
    let scalar: UnicodeScalar = "ᅸ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅸ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅸ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅸ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅸ")

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

  /// 'ᅹ' - HANGUL JUNGSEONG YA-YO (U+1179)
  func test_hangulJungseongYa_yo() {
    let scalar: UnicodeScalar = "ᅹ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅹ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅹ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅹ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅹ")

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

  /// 'ᅺ' - HANGUL JUNGSEONG EO-O (U+117a)
  func test_hangulJungseongEo_o() {
    let scalar: UnicodeScalar = "ᅺ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅺ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅺ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅺ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅺ")

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

  /// 'ᅻ' - HANGUL JUNGSEONG EO-U (U+117b)
  func test_hangulJungseongEo_u() {
    let scalar: UnicodeScalar = "ᅻ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅻ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅻ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅻ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅻ")

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

  /// 'ᅼ' - HANGUL JUNGSEONG EO-EU (U+117c)
  func test_hangulJungseongEo_eu() {
    let scalar: UnicodeScalar = "ᅼ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅼ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅼ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅼ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅼ")

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

  /// 'ᅽ' - HANGUL JUNGSEONG YEO-O (U+117d)
  func test_hangulJungseongYeo_o() {
    let scalar: UnicodeScalar = "ᅽ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅽ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅽ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅽ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅽ")

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

  /// 'ᅾ' - HANGUL JUNGSEONG YEO-U (U+117e)
  func test_hangulJungseongYeo_u() {
    let scalar: UnicodeScalar = "ᅾ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅾ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅾ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅾ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅾ")

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

  /// 'ᅿ' - HANGUL JUNGSEONG O-EO (U+117f)
  func test_hangulJungseongO_eo() {
    let scalar: UnicodeScalar = "ᅿ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᅿ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᅿ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᅿ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᅿ")

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

  /// 'ᆀ' - HANGUL JUNGSEONG O-E (U+1180)
  func test_hangulJungseongO_e() {
    let scalar: UnicodeScalar = "ᆀ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆀ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆀ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆀ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆀ")

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

  /// 'ᆁ' - HANGUL JUNGSEONG O-YE (U+1181)
  func test_hangulJungseongO_ye() {
    let scalar: UnicodeScalar = "ᆁ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆁ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆁ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆁ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆁ")

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

  /// 'ᆂ' - HANGUL JUNGSEONG O-O (U+1182)
  func test_hangulJungseongO_o() {
    let scalar: UnicodeScalar = "ᆂ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆂ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆂ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆂ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆂ")

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

  /// 'ᆃ' - HANGUL JUNGSEONG O-U (U+1183)
  func test_hangulJungseongO_u() {
    let scalar: UnicodeScalar = "ᆃ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆃ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆃ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆃ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆃ")

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

  /// 'ᆄ' - HANGUL JUNGSEONG YO-YA (U+1184)
  func test_hangulJungseongYo_ya() {
    let scalar: UnicodeScalar = "ᆄ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆄ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆄ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆄ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆄ")

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

  /// 'ᆅ' - HANGUL JUNGSEONG YO-YAE (U+1185)
  func test_hangulJungseongYo_yae() {
    let scalar: UnicodeScalar = "ᆅ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆅ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆅ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆅ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆅ")

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

  /// 'ᆆ' - HANGUL JUNGSEONG YO-YEO (U+1186)
  func test_hangulJungseongYo_yeo() {
    let scalar: UnicodeScalar = "ᆆ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆆ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆆ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆆ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆆ")

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

  /// 'ᆇ' - HANGUL JUNGSEONG YO-O (U+1187)
  func test_hangulJungseongYo_o() {
    let scalar: UnicodeScalar = "ᆇ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆇ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆇ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆇ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆇ")

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

  /// 'ᆈ' - HANGUL JUNGSEONG YO-I (U+1188)
  func test_hangulJungseongYo_i() {
    let scalar: UnicodeScalar = "ᆈ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆈ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆈ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆈ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆈ")

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

  /// 'ᆉ' - HANGUL JUNGSEONG U-A (U+1189)
  func test_hangulJungseongU_a() {
    let scalar: UnicodeScalar = "ᆉ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆉ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆉ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆉ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆉ")

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

  /// 'ᆊ' - HANGUL JUNGSEONG U-AE (U+118a)
  func test_hangulJungseongU_ae() {
    let scalar: UnicodeScalar = "ᆊ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆊ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆊ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆊ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆊ")

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

  /// 'ᆋ' - HANGUL JUNGSEONG U-EO-EU (U+118b)
  func test_hangulJungseongU_eo_eu() {
    let scalar: UnicodeScalar = "ᆋ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆋ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆋ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆋ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆋ")

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

  /// 'ᆌ' - HANGUL JUNGSEONG U-YE (U+118c)
  func test_hangulJungseongU_ye() {
    let scalar: UnicodeScalar = "ᆌ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆌ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆌ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆌ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆌ")

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

  /// 'ᆍ' - HANGUL JUNGSEONG U-U (U+118d)
  func test_hangulJungseongU_u() {
    let scalar: UnicodeScalar = "ᆍ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆍ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆍ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆍ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆍ")

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

  /// 'ᆎ' - HANGUL JUNGSEONG YU-A (U+118e)
  func test_hangulJungseongYu_a() {
    let scalar: UnicodeScalar = "ᆎ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆎ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆎ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆎ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆎ")

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

  /// 'ᆏ' - HANGUL JUNGSEONG YU-EO (U+118f)
  func test_hangulJungseongYu_eo() {
    let scalar: UnicodeScalar = "ᆏ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆏ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆏ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆏ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆏ")

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

  /// 'ᆐ' - HANGUL JUNGSEONG YU-E (U+1190)
  func test_hangulJungseongYu_e() {
    let scalar: UnicodeScalar = "ᆐ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆐ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆐ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆐ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆐ")

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

  /// 'ᆑ' - HANGUL JUNGSEONG YU-YEO (U+1191)
  func test_hangulJungseongYu_yeo() {
    let scalar: UnicodeScalar = "ᆑ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆑ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆑ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆑ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆑ")

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

  /// 'ᆒ' - HANGUL JUNGSEONG YU-YE (U+1192)
  func test_hangulJungseongYu_ye() {
    let scalar: UnicodeScalar = "ᆒ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆒ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆒ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆒ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆒ")

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

  /// 'ᆓ' - HANGUL JUNGSEONG YU-U (U+1193)
  func test_hangulJungseongYu_u() {
    let scalar: UnicodeScalar = "ᆓ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆓ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆓ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆓ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆓ")

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

  /// 'ᆔ' - HANGUL JUNGSEONG YU-I (U+1194)
  func test_hangulJungseongYu_i() {
    let scalar: UnicodeScalar = "ᆔ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆔ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆔ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆔ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆔ")

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

  /// 'ᆕ' - HANGUL JUNGSEONG EU-U (U+1195)
  func test_hangulJungseongEu_u() {
    let scalar: UnicodeScalar = "ᆕ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆕ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆕ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆕ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆕ")

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

  /// 'ᆖ' - HANGUL JUNGSEONG EU-EU (U+1196)
  func test_hangulJungseongEu_eu() {
    let scalar: UnicodeScalar = "ᆖ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆖ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆖ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆖ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆖ")

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

  /// 'ᆗ' - HANGUL JUNGSEONG YI-U (U+1197)
  func test_hangulJungseongYi_u() {
    let scalar: UnicodeScalar = "ᆗ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆗ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆗ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆗ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆗ")

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

  /// 'ᆘ' - HANGUL JUNGSEONG I-A (U+1198)
  func test_hangulJungseongI_a() {
    let scalar: UnicodeScalar = "ᆘ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆘ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆘ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆘ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆘ")

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

  /// 'ᆙ' - HANGUL JUNGSEONG I-YA (U+1199)
  func test_hangulJungseongI_ya() {
    let scalar: UnicodeScalar = "ᆙ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆙ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆙ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆙ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆙ")

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

  /// 'ᆚ' - HANGUL JUNGSEONG I-O (U+119a)
  func test_hangulJungseongI_o() {
    let scalar: UnicodeScalar = "ᆚ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆚ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆚ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆚ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆚ")

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

  /// 'ᆛ' - HANGUL JUNGSEONG I-U (U+119b)
  func test_hangulJungseongI_u() {
    let scalar: UnicodeScalar = "ᆛ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆛ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆛ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆛ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆛ")

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

  /// 'ᆜ' - HANGUL JUNGSEONG I-EU (U+119c)
  func test_hangulJungseongI_eu() {
    let scalar: UnicodeScalar = "ᆜ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆜ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆜ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆜ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆜ")

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

  /// 'ᆝ' - HANGUL JUNGSEONG I-ARAEA (U+119d)
  func test_hangulJungseongI_araea() {
    let scalar: UnicodeScalar = "ᆝ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆝ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆝ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆝ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆝ")

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

  /// 'ᆞ' - HANGUL JUNGSEONG ARAEA (U+119e)
  func test_hangulJungseongAraea() {
    let scalar: UnicodeScalar = "ᆞ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆞ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆞ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆞ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆞ")

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

  /// 'ᆟ' - HANGUL JUNGSEONG ARAEA-EO (U+119f)
  func test_hangulJungseongAraea_eo() {
    let scalar: UnicodeScalar = "ᆟ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆟ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆟ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆟ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆟ")

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

  /// 'ᆠ' - HANGUL JUNGSEONG ARAEA-U (U+11a0)
  func test_hangulJungseongAraea_u() {
    let scalar: UnicodeScalar = "ᆠ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆠ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆠ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆠ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆠ")

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

  /// 'ᆡ' - HANGUL JUNGSEONG ARAEA-I (U+11a1)
  func test_hangulJungseongAraea_i() {
    let scalar: UnicodeScalar = "ᆡ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆡ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆡ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆡ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆡ")

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

  /// 'ᆢ' - HANGUL JUNGSEONG SSANGARAEA (U+11a2)
  func test_hangulJungseongSsangaraea() {
    let scalar: UnicodeScalar = "ᆢ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆢ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆢ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆢ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆢ")

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

  /// 'ᆣ' - HANGUL JUNGSEONG A-EU (U+11a3)
  func test_hangulJungseongA_eu() {
    let scalar: UnicodeScalar = "ᆣ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆣ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆣ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆣ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆣ")

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

  /// 'ᆤ' - HANGUL JUNGSEONG YA-U (U+11a4)
  func test_hangulJungseongYa_u() {
    let scalar: UnicodeScalar = "ᆤ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆤ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆤ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆤ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆤ")

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

  /// 'ᆥ' - HANGUL JUNGSEONG YEO-YA (U+11a5)
  func test_hangulJungseongYeo_ya() {
    let scalar: UnicodeScalar = "ᆥ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆥ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆥ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆥ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆥ")

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

  /// 'ᆦ' - HANGUL JUNGSEONG O-YA (U+11a6)
  func test_hangulJungseongO_ya() {
    let scalar: UnicodeScalar = "ᆦ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆦ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆦ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆦ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆦ")

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

  /// 'ᆧ' - HANGUL JUNGSEONG O-YAE (U+11a7)
  func test_hangulJungseongO_yae() {
    let scalar: UnicodeScalar = "ᆧ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆧ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆧ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆧ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆧ")

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

  /// 'ᆨ' - HANGUL JONGSEONG KIYEOK (U+11a8)
  func test_hangulJongseongKiyeok() {
    let scalar: UnicodeScalar = "ᆨ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆨ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆨ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆨ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆨ")

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

  /// 'ᆩ' - HANGUL JONGSEONG SSANGKIYEOK (U+11a9)
  func test_hangulJongseongSsangkiyeok() {
    let scalar: UnicodeScalar = "ᆩ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆩ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆩ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆩ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆩ")

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

  /// 'ᆪ' - HANGUL JONGSEONG KIYEOK-SIOS (U+11aa)
  func test_hangulJongseongKiyeok_sios() {
    let scalar: UnicodeScalar = "ᆪ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆪ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆪ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆪ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆪ")

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

  /// 'ᆫ' - HANGUL JONGSEONG NIEUN (U+11ab)
  func test_hangulJongseongNieun() {
    let scalar: UnicodeScalar = "ᆫ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆫ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆫ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆫ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆫ")

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

  /// 'ᆬ' - HANGUL JONGSEONG NIEUN-CIEUC (U+11ac)
  func test_hangulJongseongNieun_cieuc() {
    let scalar: UnicodeScalar = "ᆬ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆬ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆬ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆬ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆬ")

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

  /// 'ᆭ' - HANGUL JONGSEONG NIEUN-HIEUH (U+11ad)
  func test_hangulJongseongNieun_hieuh() {
    let scalar: UnicodeScalar = "ᆭ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆭ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆭ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆭ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆭ")

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

  /// 'ᆮ' - HANGUL JONGSEONG TIKEUT (U+11ae)
  func test_hangulJongseongTikeut() {
    let scalar: UnicodeScalar = "ᆮ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆮ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆮ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆮ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆮ")

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

  /// 'ᆯ' - HANGUL JONGSEONG RIEUL (U+11af)
  func test_hangulJongseongRieul() {
    let scalar: UnicodeScalar = "ᆯ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆯ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆯ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆯ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆯ")

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

  /// 'ᆰ' - HANGUL JONGSEONG RIEUL-KIYEOK (U+11b0)
  func test_hangulJongseongRieul_kiyeok() {
    let scalar: UnicodeScalar = "ᆰ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆰ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆰ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆰ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆰ")

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

  /// 'ᆱ' - HANGUL JONGSEONG RIEUL-MIEUM (U+11b1)
  func test_hangulJongseongRieul_mieum() {
    let scalar: UnicodeScalar = "ᆱ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆱ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆱ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆱ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆱ")

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

  /// 'ᆲ' - HANGUL JONGSEONG RIEUL-PIEUP (U+11b2)
  func test_hangulJongseongRieul_pieup() {
    let scalar: UnicodeScalar = "ᆲ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆲ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆲ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆲ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆲ")

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

  /// 'ᆳ' - HANGUL JONGSEONG RIEUL-SIOS (U+11b3)
  func test_hangulJongseongRieul_sios() {
    let scalar: UnicodeScalar = "ᆳ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆳ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆳ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆳ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆳ")

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

  /// 'ᆴ' - HANGUL JONGSEONG RIEUL-THIEUTH (U+11b4)
  func test_hangulJongseongRieul_thieuth() {
    let scalar: UnicodeScalar = "ᆴ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆴ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆴ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆴ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆴ")

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

  /// 'ᆵ' - HANGUL JONGSEONG RIEUL-PHIEUPH (U+11b5)
  func test_hangulJongseongRieul_phieuph() {
    let scalar: UnicodeScalar = "ᆵ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆵ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆵ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆵ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆵ")

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

  /// 'ᆶ' - HANGUL JONGSEONG RIEUL-HIEUH (U+11b6)
  func test_hangulJongseongRieul_hieuh() {
    let scalar: UnicodeScalar = "ᆶ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆶ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆶ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆶ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆶ")

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

  /// 'ᆷ' - HANGUL JONGSEONG MIEUM (U+11b7)
  func test_hangulJongseongMieum() {
    let scalar: UnicodeScalar = "ᆷ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆷ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆷ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆷ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆷ")

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

  /// 'ᆸ' - HANGUL JONGSEONG PIEUP (U+11b8)
  func test_hangulJongseongPieup() {
    let scalar: UnicodeScalar = "ᆸ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆸ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆸ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆸ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆸ")

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

  /// 'ᆹ' - HANGUL JONGSEONG PIEUP-SIOS (U+11b9)
  func test_hangulJongseongPieup_sios() {
    let scalar: UnicodeScalar = "ᆹ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆹ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆹ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆹ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆹ")

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

  /// 'ᆺ' - HANGUL JONGSEONG SIOS (U+11ba)
  func test_hangulJongseongSios() {
    let scalar: UnicodeScalar = "ᆺ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆺ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆺ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆺ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆺ")

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

  /// 'ᆻ' - HANGUL JONGSEONG SSANGSIOS (U+11bb)
  func test_hangulJongseongSsangsios() {
    let scalar: UnicodeScalar = "ᆻ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆻ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆻ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆻ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆻ")

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

  /// 'ᆼ' - HANGUL JONGSEONG IEUNG (U+11bc)
  func test_hangulJongseongIeung() {
    let scalar: UnicodeScalar = "ᆼ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆼ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆼ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆼ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆼ")

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

  /// 'ᆽ' - HANGUL JONGSEONG CIEUC (U+11bd)
  func test_hangulJongseongCieuc() {
    let scalar: UnicodeScalar = "ᆽ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆽ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆽ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆽ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆽ")

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

  /// 'ᆾ' - HANGUL JONGSEONG CHIEUCH (U+11be)
  func test_hangulJongseongChieuch() {
    let scalar: UnicodeScalar = "ᆾ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆾ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆾ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆾ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆾ")

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

  /// 'ᆿ' - HANGUL JONGSEONG KHIEUKH (U+11bf)
  func test_hangulJongseongKhieukh() {
    let scalar: UnicodeScalar = "ᆿ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᆿ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᆿ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᆿ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᆿ")

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

  /// 'ᇀ' - HANGUL JONGSEONG THIEUTH (U+11c0)
  func test_hangulJongseongThieuth() {
    let scalar: UnicodeScalar = "ᇀ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇀ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇀ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇀ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇀ")

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

  /// 'ᇁ' - HANGUL JONGSEONG PHIEUPH (U+11c1)
  func test_hangulJongseongPhieuph() {
    let scalar: UnicodeScalar = "ᇁ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇁ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇁ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇁ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇁ")

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

  /// 'ᇂ' - HANGUL JONGSEONG HIEUH (U+11c2)
  func test_hangulJongseongHieuh() {
    let scalar: UnicodeScalar = "ᇂ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇂ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇂ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇂ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇂ")

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

  /// 'ᇃ' - HANGUL JONGSEONG KIYEOK-RIEUL (U+11c3)
  func test_hangulJongseongKiyeok_rieul() {
    let scalar: UnicodeScalar = "ᇃ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇃ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇃ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇃ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇃ")

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

  /// 'ᇄ' - HANGUL JONGSEONG KIYEOK-SIOS-KIYEOK (U+11c4)
  func test_hangulJongseongKiyeok_sios_kiyeok() {
    let scalar: UnicodeScalar = "ᇄ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇄ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇄ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇄ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇄ")

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

  /// 'ᇅ' - HANGUL JONGSEONG NIEUN-KIYEOK (U+11c5)
  func test_hangulJongseongNieun_kiyeok() {
    let scalar: UnicodeScalar = "ᇅ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇅ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇅ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇅ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇅ")

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

  /// 'ᇆ' - HANGUL JONGSEONG NIEUN-TIKEUT (U+11c6)
  func test_hangulJongseongNieun_tikeut() {
    let scalar: UnicodeScalar = "ᇆ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇆ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇆ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇆ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇆ")

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

  /// 'ᇇ' - HANGUL JONGSEONG NIEUN-SIOS (U+11c7)
  func test_hangulJongseongNieun_sios() {
    let scalar: UnicodeScalar = "ᇇ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇇ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇇ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇇ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇇ")

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

  /// 'ᇈ' - HANGUL JONGSEONG NIEUN-PANSIOS (U+11c8)
  func test_hangulJongseongNieun_pansios() {
    let scalar: UnicodeScalar = "ᇈ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇈ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇈ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇈ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇈ")

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

  /// 'ᇉ' - HANGUL JONGSEONG NIEUN-THIEUTH (U+11c9)
  func test_hangulJongseongNieun_thieuth() {
    let scalar: UnicodeScalar = "ᇉ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇉ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇉ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇉ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇉ")

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

  /// 'ᇊ' - HANGUL JONGSEONG TIKEUT-KIYEOK (U+11ca)
  func test_hangulJongseongTikeut_kiyeok() {
    let scalar: UnicodeScalar = "ᇊ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇊ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇊ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇊ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇊ")

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

  /// 'ᇋ' - HANGUL JONGSEONG TIKEUT-RIEUL (U+11cb)
  func test_hangulJongseongTikeut_rieul() {
    let scalar: UnicodeScalar = "ᇋ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇋ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇋ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇋ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇋ")

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

  /// 'ᇌ' - HANGUL JONGSEONG RIEUL-KIYEOK-SIOS (U+11cc)
  func test_hangulJongseongRieul_kiyeok_sios() {
    let scalar: UnicodeScalar = "ᇌ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇌ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇌ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇌ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇌ")

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

  /// 'ᇍ' - HANGUL JONGSEONG RIEUL-NIEUN (U+11cd)
  func test_hangulJongseongRieul_nieun() {
    let scalar: UnicodeScalar = "ᇍ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇍ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇍ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇍ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇍ")

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

  /// 'ᇎ' - HANGUL JONGSEONG RIEUL-TIKEUT (U+11ce)
  func test_hangulJongseongRieul_tikeut() {
    let scalar: UnicodeScalar = "ᇎ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇎ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇎ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇎ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇎ")

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

  /// 'ᇏ' - HANGUL JONGSEONG RIEUL-TIKEUT-HIEUH (U+11cf)
  func test_hangulJongseongRieul_tikeut_hieuh() {
    let scalar: UnicodeScalar = "ᇏ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇏ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇏ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇏ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇏ")

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

  /// 'ᇐ' - HANGUL JONGSEONG SSANGRIEUL (U+11d0)
  func test_hangulJongseongSsangrieul() {
    let scalar: UnicodeScalar = "ᇐ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇐ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇐ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇐ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇐ")

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

  /// 'ᇑ' - HANGUL JONGSEONG RIEUL-MIEUM-KIYEOK (U+11d1)
  func test_hangulJongseongRieul_mieum_kiyeok() {
    let scalar: UnicodeScalar = "ᇑ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇑ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇑ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇑ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇑ")

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

  /// 'ᇒ' - HANGUL JONGSEONG RIEUL-MIEUM-SIOS (U+11d2)
  func test_hangulJongseongRieul_mieum_sios() {
    let scalar: UnicodeScalar = "ᇒ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇒ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇒ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇒ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇒ")

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

  /// 'ᇓ' - HANGUL JONGSEONG RIEUL-PIEUP-SIOS (U+11d3)
  func test_hangulJongseongRieul_pieup_sios() {
    let scalar: UnicodeScalar = "ᇓ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇓ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇓ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇓ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇓ")

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

  /// 'ᇔ' - HANGUL JONGSEONG RIEUL-PIEUP-HIEUH (U+11d4)
  func test_hangulJongseongRieul_pieup_hieuh() {
    let scalar: UnicodeScalar = "ᇔ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇔ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇔ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇔ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇔ")

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

  /// 'ᇕ' - HANGUL JONGSEONG RIEUL-KAPYEOUNPIEUP (U+11d5)
  func test_hangulJongseongRieul_kapyeounpieup() {
    let scalar: UnicodeScalar = "ᇕ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇕ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇕ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇕ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇕ")

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

  /// 'ᇖ' - HANGUL JONGSEONG RIEUL-SSANGSIOS (U+11d6)
  func test_hangulJongseongRieul_ssangsios() {
    let scalar: UnicodeScalar = "ᇖ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇖ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇖ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇖ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇖ")

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

  /// 'ᇗ' - HANGUL JONGSEONG RIEUL-PANSIOS (U+11d7)
  func test_hangulJongseongRieul_pansios() {
    let scalar: UnicodeScalar = "ᇗ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇗ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇗ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇗ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇗ")

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

  /// 'ᇘ' - HANGUL JONGSEONG RIEUL-KHIEUKH (U+11d8)
  func test_hangulJongseongRieul_khieukh() {
    let scalar: UnicodeScalar = "ᇘ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇘ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇘ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇘ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇘ")

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

  /// 'ᇙ' - HANGUL JONGSEONG RIEUL-YEORINHIEUH (U+11d9)
  func test_hangulJongseongRieul_yeorinhieuh() {
    let scalar: UnicodeScalar = "ᇙ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇙ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇙ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇙ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇙ")

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

  /// 'ᇚ' - HANGUL JONGSEONG MIEUM-KIYEOK (U+11da)
  func test_hangulJongseongMieum_kiyeok() {
    let scalar: UnicodeScalar = "ᇚ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇚ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇚ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇚ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇚ")

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

  /// 'ᇛ' - HANGUL JONGSEONG MIEUM-RIEUL (U+11db)
  func test_hangulJongseongMieum_rieul() {
    let scalar: UnicodeScalar = "ᇛ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇛ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇛ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇛ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇛ")

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

  /// 'ᇜ' - HANGUL JONGSEONG MIEUM-PIEUP (U+11dc)
  func test_hangulJongseongMieum_pieup() {
    let scalar: UnicodeScalar = "ᇜ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇜ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇜ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇜ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇜ")

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

  /// 'ᇝ' - HANGUL JONGSEONG MIEUM-SIOS (U+11dd)
  func test_hangulJongseongMieum_sios() {
    let scalar: UnicodeScalar = "ᇝ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇝ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇝ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇝ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇝ")

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

  /// 'ᇞ' - HANGUL JONGSEONG MIEUM-SSANGSIOS (U+11de)
  func test_hangulJongseongMieum_ssangsios() {
    let scalar: UnicodeScalar = "ᇞ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇞ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇞ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇞ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇞ")

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

  /// 'ᇟ' - HANGUL JONGSEONG MIEUM-PANSIOS (U+11df)
  func test_hangulJongseongMieum_pansios() {
    let scalar: UnicodeScalar = "ᇟ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇟ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇟ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇟ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇟ")

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

  /// 'ᇠ' - HANGUL JONGSEONG MIEUM-CHIEUCH (U+11e0)
  func test_hangulJongseongMieum_chieuch() {
    let scalar: UnicodeScalar = "ᇠ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇠ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇠ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇠ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇠ")

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

  /// 'ᇡ' - HANGUL JONGSEONG MIEUM-HIEUH (U+11e1)
  func test_hangulJongseongMieum_hieuh() {
    let scalar: UnicodeScalar = "ᇡ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇡ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇡ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇡ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇡ")

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

  /// 'ᇢ' - HANGUL JONGSEONG KAPYEOUNMIEUM (U+11e2)
  func test_hangulJongseongKapyeounmieum() {
    let scalar: UnicodeScalar = "ᇢ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇢ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇢ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇢ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇢ")

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

  /// 'ᇣ' - HANGUL JONGSEONG PIEUP-RIEUL (U+11e3)
  func test_hangulJongseongPieup_rieul() {
    let scalar: UnicodeScalar = "ᇣ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇣ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇣ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇣ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇣ")

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

  /// 'ᇤ' - HANGUL JONGSEONG PIEUP-PHIEUPH (U+11e4)
  func test_hangulJongseongPieup_phieuph() {
    let scalar: UnicodeScalar = "ᇤ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇤ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇤ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇤ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇤ")

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

  /// 'ᇥ' - HANGUL JONGSEONG PIEUP-HIEUH (U+11e5)
  func test_hangulJongseongPieup_hieuh() {
    let scalar: UnicodeScalar = "ᇥ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇥ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇥ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇥ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇥ")

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

  /// 'ᇦ' - HANGUL JONGSEONG KAPYEOUNPIEUP (U+11e6)
  func test_hangulJongseongKapyeounpieup() {
    let scalar: UnicodeScalar = "ᇦ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇦ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇦ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇦ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇦ")

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

  /// 'ᇧ' - HANGUL JONGSEONG SIOS-KIYEOK (U+11e7)
  func test_hangulJongseongSios_kiyeok() {
    let scalar: UnicodeScalar = "ᇧ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇧ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇧ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇧ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇧ")

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

  /// 'ᇨ' - HANGUL JONGSEONG SIOS-TIKEUT (U+11e8)
  func test_hangulJongseongSios_tikeut() {
    let scalar: UnicodeScalar = "ᇨ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇨ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇨ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇨ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇨ")

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

  /// 'ᇩ' - HANGUL JONGSEONG SIOS-RIEUL (U+11e9)
  func test_hangulJongseongSios_rieul() {
    let scalar: UnicodeScalar = "ᇩ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇩ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇩ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇩ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇩ")

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

  /// 'ᇪ' - HANGUL JONGSEONG SIOS-PIEUP (U+11ea)
  func test_hangulJongseongSios_pieup() {
    let scalar: UnicodeScalar = "ᇪ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇪ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇪ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇪ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇪ")

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

  /// 'ᇫ' - HANGUL JONGSEONG PANSIOS (U+11eb)
  func test_hangulJongseongPansios() {
    let scalar: UnicodeScalar = "ᇫ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇫ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇫ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇫ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇫ")

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

  /// 'ᇬ' - HANGUL JONGSEONG IEUNG-KIYEOK (U+11ec)
  func test_hangulJongseongIeung_kiyeok() {
    let scalar: UnicodeScalar = "ᇬ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇬ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇬ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇬ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇬ")

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

  /// 'ᇭ' - HANGUL JONGSEONG IEUNG-SSANGKIYEOK (U+11ed)
  func test_hangulJongseongIeung_ssangkiyeok() {
    let scalar: UnicodeScalar = "ᇭ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇭ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇭ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇭ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇭ")

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

  /// 'ᇮ' - HANGUL JONGSEONG SSANGIEUNG (U+11ee)
  func test_hangulJongseongSsangieung() {
    let scalar: UnicodeScalar = "ᇮ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇮ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇮ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇮ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇮ")

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

  /// 'ᇯ' - HANGUL JONGSEONG IEUNG-KHIEUKH (U+11ef)
  func test_hangulJongseongIeung_khieukh() {
    let scalar: UnicodeScalar = "ᇯ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇯ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇯ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇯ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇯ")

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

  /// 'ᇰ' - HANGUL JONGSEONG YESIEUNG (U+11f0)
  func test_hangulJongseongYesieung() {
    let scalar: UnicodeScalar = "ᇰ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇰ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇰ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇰ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇰ")

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

  /// 'ᇱ' - HANGUL JONGSEONG YESIEUNG-SIOS (U+11f1)
  func test_hangulJongseongYesieung_sios() {
    let scalar: UnicodeScalar = "ᇱ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇱ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇱ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇱ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇱ")

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

  /// 'ᇲ' - HANGUL JONGSEONG YESIEUNG-PANSIOS (U+11f2)
  func test_hangulJongseongYesieung_pansios() {
    let scalar: UnicodeScalar = "ᇲ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇲ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇲ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇲ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇲ")

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

  /// 'ᇳ' - HANGUL JONGSEONG PHIEUPH-PIEUP (U+11f3)
  func test_hangulJongseongPhieuph_pieup() {
    let scalar: UnicodeScalar = "ᇳ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇳ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇳ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇳ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇳ")

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

  /// 'ᇴ' - HANGUL JONGSEONG KAPYEOUNPHIEUPH (U+11f4)
  func test_hangulJongseongKapyeounphieuph() {
    let scalar: UnicodeScalar = "ᇴ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇴ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇴ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇴ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇴ")

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

  /// 'ᇵ' - HANGUL JONGSEONG HIEUH-NIEUN (U+11f5)
  func test_hangulJongseongHieuh_nieun() {
    let scalar: UnicodeScalar = "ᇵ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇵ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇵ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇵ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇵ")

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

  /// 'ᇶ' - HANGUL JONGSEONG HIEUH-RIEUL (U+11f6)
  func test_hangulJongseongHieuh_rieul() {
    let scalar: UnicodeScalar = "ᇶ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇶ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇶ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇶ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇶ")

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

  /// 'ᇷ' - HANGUL JONGSEONG HIEUH-MIEUM (U+11f7)
  func test_hangulJongseongHieuh_mieum() {
    let scalar: UnicodeScalar = "ᇷ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇷ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇷ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇷ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇷ")

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

  /// 'ᇸ' - HANGUL JONGSEONG HIEUH-PIEUP (U+11f8)
  func test_hangulJongseongHieuh_pieup() {
    let scalar: UnicodeScalar = "ᇸ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇸ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇸ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇸ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇸ")

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

  /// 'ᇹ' - HANGUL JONGSEONG YEORINHIEUH (U+11f9)
  func test_hangulJongseongYeorinhieuh() {
    let scalar: UnicodeScalar = "ᇹ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇹ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇹ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇹ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇹ")

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

  /// 'ᇺ' - HANGUL JONGSEONG KIYEOK-NIEUN (U+11fa)
  func test_hangulJongseongKiyeok_nieun() {
    let scalar: UnicodeScalar = "ᇺ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇺ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇺ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇺ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇺ")

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

  /// 'ᇻ' - HANGUL JONGSEONG KIYEOK-PIEUP (U+11fb)
  func test_hangulJongseongKiyeok_pieup() {
    let scalar: UnicodeScalar = "ᇻ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇻ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇻ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇻ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇻ")

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

  /// 'ᇼ' - HANGUL JONGSEONG KIYEOK-CHIEUCH (U+11fc)
  func test_hangulJongseongKiyeok_chieuch() {
    let scalar: UnicodeScalar = "ᇼ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇼ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇼ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇼ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇼ")

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

  /// 'ᇽ' - HANGUL JONGSEONG KIYEOK-KHIEUKH (U+11fd)
  func test_hangulJongseongKiyeok_khieukh() {
    let scalar: UnicodeScalar = "ᇽ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇽ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇽ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇽ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇽ")

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

  /// 'ᇾ' - HANGUL JONGSEONG KIYEOK-HIEUH (U+11fe)
  func test_hangulJongseongKiyeok_hieuh() {
    let scalar: UnicodeScalar = "ᇾ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇾ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇾ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇾ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇾ")

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

  /// 'ᇿ' - HANGUL JONGSEONG SSANGNIEUN (U+11ff)
  func test_hangulJongseongSsangnieun() {
    let scalar: UnicodeScalar = "ᇿ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ᇿ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ᇿ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ᇿ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ᇿ")

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

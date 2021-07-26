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

/// Tests for: 3040..309f Hiragana block
class UnicodeDataHiraganaTests: XCTestCase {

  /// 'ぁ' - HIRAGANA LETTER SMALL A (U+3041)
  func test_hiraganaLetterSmallA() {
    let scalar: UnicodeScalar = "ぁ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ぁ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ぁ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ぁ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ぁ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'あ' - HIRAGANA LETTER A (U+3042)
  func test_hiraganaLetterA() {
    let scalar: UnicodeScalar = "あ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "あ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "あ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "あ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "あ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ぃ' - HIRAGANA LETTER SMALL I (U+3043)
  func test_hiraganaLetterSmallI() {
    let scalar: UnicodeScalar = "ぃ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ぃ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ぃ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ぃ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ぃ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'い' - HIRAGANA LETTER I (U+3044)
  func test_hiraganaLetterI() {
    let scalar: UnicodeScalar = "い"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "い")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "い")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "い")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "い")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ぅ' - HIRAGANA LETTER SMALL U (U+3045)
  func test_hiraganaLetterSmallU() {
    let scalar: UnicodeScalar = "ぅ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ぅ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ぅ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ぅ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ぅ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'う' - HIRAGANA LETTER U (U+3046)
  func test_hiraganaLetterU() {
    let scalar: UnicodeScalar = "う"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "う")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "う")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "う")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "う")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ぇ' - HIRAGANA LETTER SMALL E (U+3047)
  func test_hiraganaLetterSmallE() {
    let scalar: UnicodeScalar = "ぇ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ぇ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ぇ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ぇ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ぇ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'え' - HIRAGANA LETTER E (U+3048)
  func test_hiraganaLetterE() {
    let scalar: UnicodeScalar = "え"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "え")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "え")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "え")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "え")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ぉ' - HIRAGANA LETTER SMALL O (U+3049)
  func test_hiraganaLetterSmallO() {
    let scalar: UnicodeScalar = "ぉ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ぉ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ぉ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ぉ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ぉ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'お' - HIRAGANA LETTER O (U+304a)
  func test_hiraganaLetterO() {
    let scalar: UnicodeScalar = "お"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "お")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "お")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "お")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "お")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'か' - HIRAGANA LETTER KA (U+304b)
  func test_hiraganaLetterKa() {
    let scalar: UnicodeScalar = "か"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "か")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "か")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "か")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "か")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'が' - HIRAGANA LETTER GA (U+304c)
  func test_hiraganaLetterGa() {
    let scalar: UnicodeScalar = "が"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "が")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "が")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "が")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "が")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'き' - HIRAGANA LETTER KI (U+304d)
  func test_hiraganaLetterKi() {
    let scalar: UnicodeScalar = "き"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "き")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "き")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "き")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "き")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ぎ' - HIRAGANA LETTER GI (U+304e)
  func test_hiraganaLetterGi() {
    let scalar: UnicodeScalar = "ぎ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ぎ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ぎ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ぎ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ぎ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'く' - HIRAGANA LETTER KU (U+304f)
  func test_hiraganaLetterKu() {
    let scalar: UnicodeScalar = "く"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "く")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "く")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "く")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "く")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ぐ' - HIRAGANA LETTER GU (U+3050)
  func test_hiraganaLetterGu() {
    let scalar: UnicodeScalar = "ぐ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ぐ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ぐ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ぐ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ぐ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'け' - HIRAGANA LETTER KE (U+3051)
  func test_hiraganaLetterKe() {
    let scalar: UnicodeScalar = "け"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "け")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "け")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "け")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "け")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'げ' - HIRAGANA LETTER GE (U+3052)
  func test_hiraganaLetterGe() {
    let scalar: UnicodeScalar = "げ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "げ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "げ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "げ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "げ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'こ' - HIRAGANA LETTER KO (U+3053)
  func test_hiraganaLetterKo() {
    let scalar: UnicodeScalar = "こ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "こ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "こ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "こ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "こ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ご' - HIRAGANA LETTER GO (U+3054)
  func test_hiraganaLetterGo() {
    let scalar: UnicodeScalar = "ご"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ご")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ご")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ご")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ご")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'さ' - HIRAGANA LETTER SA (U+3055)
  func test_hiraganaLetterSa() {
    let scalar: UnicodeScalar = "さ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "さ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "さ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "さ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "さ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ざ' - HIRAGANA LETTER ZA (U+3056)
  func test_hiraganaLetterZa() {
    let scalar: UnicodeScalar = "ざ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ざ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ざ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ざ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ざ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'し' - HIRAGANA LETTER SI (U+3057)
  func test_hiraganaLetterSi() {
    let scalar: UnicodeScalar = "し"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "し")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "し")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "し")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "し")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'じ' - HIRAGANA LETTER ZI (U+3058)
  func test_hiraganaLetterZi() {
    let scalar: UnicodeScalar = "じ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "じ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "じ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "じ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "じ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'す' - HIRAGANA LETTER SU (U+3059)
  func test_hiraganaLetterSu() {
    let scalar: UnicodeScalar = "す"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "す")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "す")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "す")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "す")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ず' - HIRAGANA LETTER ZU (U+305a)
  func test_hiraganaLetterZu() {
    let scalar: UnicodeScalar = "ず"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ず")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ず")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ず")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ず")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'せ' - HIRAGANA LETTER SE (U+305b)
  func test_hiraganaLetterSe() {
    let scalar: UnicodeScalar = "せ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "せ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "せ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "せ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "せ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ぜ' - HIRAGANA LETTER ZE (U+305c)
  func test_hiraganaLetterZe() {
    let scalar: UnicodeScalar = "ぜ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ぜ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ぜ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ぜ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ぜ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'そ' - HIRAGANA LETTER SO (U+305d)
  func test_hiraganaLetterSo() {
    let scalar: UnicodeScalar = "そ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "そ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "そ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "そ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "そ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ぞ' - HIRAGANA LETTER ZO (U+305e)
  func test_hiraganaLetterZo() {
    let scalar: UnicodeScalar = "ぞ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ぞ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ぞ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ぞ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ぞ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'た' - HIRAGANA LETTER TA (U+305f)
  func test_hiraganaLetterTa() {
    let scalar: UnicodeScalar = "た"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "た")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "た")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "た")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "た")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'だ' - HIRAGANA LETTER DA (U+3060)
  func test_hiraganaLetterDa() {
    let scalar: UnicodeScalar = "だ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "だ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "だ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "だ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "だ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ち' - HIRAGANA LETTER TI (U+3061)
  func test_hiraganaLetterTi() {
    let scalar: UnicodeScalar = "ち"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ち")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ち")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ち")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ち")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ぢ' - HIRAGANA LETTER DI (U+3062)
  func test_hiraganaLetterDi() {
    let scalar: UnicodeScalar = "ぢ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ぢ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ぢ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ぢ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ぢ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'っ' - HIRAGANA LETTER SMALL TU (U+3063)
  func test_hiraganaLetterSmallTu() {
    let scalar: UnicodeScalar = "っ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "っ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "っ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "っ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "っ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'つ' - HIRAGANA LETTER TU (U+3064)
  func test_hiraganaLetterTu() {
    let scalar: UnicodeScalar = "つ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "つ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "つ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "つ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "つ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'づ' - HIRAGANA LETTER DU (U+3065)
  func test_hiraganaLetterDu() {
    let scalar: UnicodeScalar = "づ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "づ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "づ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "づ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "づ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'て' - HIRAGANA LETTER TE (U+3066)
  func test_hiraganaLetterTe() {
    let scalar: UnicodeScalar = "て"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "て")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "て")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "て")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "て")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'で' - HIRAGANA LETTER DE (U+3067)
  func test_hiraganaLetterDe() {
    let scalar: UnicodeScalar = "で"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "で")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "で")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "で")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "で")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'と' - HIRAGANA LETTER TO (U+3068)
  func test_hiraganaLetterTo() {
    let scalar: UnicodeScalar = "と"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "と")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "と")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "と")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "と")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ど' - HIRAGANA LETTER DO (U+3069)
  func test_hiraganaLetterDo() {
    let scalar: UnicodeScalar = "ど"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ど")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ど")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ど")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ど")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'な' - HIRAGANA LETTER NA (U+306a)
  func test_hiraganaLetterNa() {
    let scalar: UnicodeScalar = "な"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "な")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "な")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "な")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "な")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'に' - HIRAGANA LETTER NI (U+306b)
  func test_hiraganaLetterNi() {
    let scalar: UnicodeScalar = "に"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "に")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "に")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "に")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "に")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ぬ' - HIRAGANA LETTER NU (U+306c)
  func test_hiraganaLetterNu() {
    let scalar: UnicodeScalar = "ぬ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ぬ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ぬ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ぬ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ぬ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ね' - HIRAGANA LETTER NE (U+306d)
  func test_hiraganaLetterNe() {
    let scalar: UnicodeScalar = "ね"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ね")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ね")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ね")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ね")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'の' - HIRAGANA LETTER NO (U+306e)
  func test_hiraganaLetterNo() {
    let scalar: UnicodeScalar = "の"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "の")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "の")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "の")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "の")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'は' - HIRAGANA LETTER HA (U+306f)
  func test_hiraganaLetterHa() {
    let scalar: UnicodeScalar = "は"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "は")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "は")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "は")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "は")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ば' - HIRAGANA LETTER BA (U+3070)
  func test_hiraganaLetterBa() {
    let scalar: UnicodeScalar = "ば"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ば")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ば")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ば")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ば")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ぱ' - HIRAGANA LETTER PA (U+3071)
  func test_hiraganaLetterPa() {
    let scalar: UnicodeScalar = "ぱ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ぱ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ぱ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ぱ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ぱ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ひ' - HIRAGANA LETTER HI (U+3072)
  func test_hiraganaLetterHi() {
    let scalar: UnicodeScalar = "ひ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ひ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ひ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ひ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ひ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'び' - HIRAGANA LETTER BI (U+3073)
  func test_hiraganaLetterBi() {
    let scalar: UnicodeScalar = "び"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "び")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "び")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "び")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "び")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ぴ' - HIRAGANA LETTER PI (U+3074)
  func test_hiraganaLetterPi() {
    let scalar: UnicodeScalar = "ぴ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ぴ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ぴ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ぴ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ぴ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ふ' - HIRAGANA LETTER HU (U+3075)
  func test_hiraganaLetterHu() {
    let scalar: UnicodeScalar = "ふ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ふ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ふ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ふ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ふ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ぶ' - HIRAGANA LETTER BU (U+3076)
  func test_hiraganaLetterBu() {
    let scalar: UnicodeScalar = "ぶ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ぶ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ぶ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ぶ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ぶ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ぷ' - HIRAGANA LETTER PU (U+3077)
  func test_hiraganaLetterPu() {
    let scalar: UnicodeScalar = "ぷ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ぷ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ぷ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ぷ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ぷ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'へ' - HIRAGANA LETTER HE (U+3078)
  func test_hiraganaLetterHe() {
    let scalar: UnicodeScalar = "へ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "へ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "へ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "へ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "へ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'べ' - HIRAGANA LETTER BE (U+3079)
  func test_hiraganaLetterBe() {
    let scalar: UnicodeScalar = "べ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "べ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "べ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "べ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "べ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ぺ' - HIRAGANA LETTER PE (U+307a)
  func test_hiraganaLetterPe() {
    let scalar: UnicodeScalar = "ぺ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ぺ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ぺ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ぺ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ぺ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ほ' - HIRAGANA LETTER HO (U+307b)
  func test_hiraganaLetterHo() {
    let scalar: UnicodeScalar = "ほ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ほ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ほ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ほ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ほ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ぼ' - HIRAGANA LETTER BO (U+307c)
  func test_hiraganaLetterBo() {
    let scalar: UnicodeScalar = "ぼ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ぼ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ぼ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ぼ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ぼ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ぽ' - HIRAGANA LETTER PO (U+307d)
  func test_hiraganaLetterPo() {
    let scalar: UnicodeScalar = "ぽ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ぽ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ぽ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ぽ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ぽ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ま' - HIRAGANA LETTER MA (U+307e)
  func test_hiraganaLetterMa() {
    let scalar: UnicodeScalar = "ま"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ま")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ま")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ま")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ま")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'み' - HIRAGANA LETTER MI (U+307f)
  func test_hiraganaLetterMi() {
    let scalar: UnicodeScalar = "み"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "み")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "み")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "み")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "み")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'む' - HIRAGANA LETTER MU (U+3080)
  func test_hiraganaLetterMu() {
    let scalar: UnicodeScalar = "む"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "む")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "む")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "む")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "む")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'め' - HIRAGANA LETTER ME (U+3081)
  func test_hiraganaLetterMe() {
    let scalar: UnicodeScalar = "め"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "め")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "め")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "め")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "め")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'も' - HIRAGANA LETTER MO (U+3082)
  func test_hiraganaLetterMo() {
    let scalar: UnicodeScalar = "も"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "も")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "も")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "も")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "も")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ゃ' - HIRAGANA LETTER SMALL YA (U+3083)
  func test_hiraganaLetterSmallYa() {
    let scalar: UnicodeScalar = "ゃ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ゃ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ゃ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ゃ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ゃ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'や' - HIRAGANA LETTER YA (U+3084)
  func test_hiraganaLetterYa() {
    let scalar: UnicodeScalar = "や"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "や")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "や")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "や")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "や")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ゅ' - HIRAGANA LETTER SMALL YU (U+3085)
  func test_hiraganaLetterSmallYu() {
    let scalar: UnicodeScalar = "ゅ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ゅ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ゅ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ゅ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ゅ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ゆ' - HIRAGANA LETTER YU (U+3086)
  func test_hiraganaLetterYu() {
    let scalar: UnicodeScalar = "ゆ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ゆ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ゆ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ゆ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ゆ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ょ' - HIRAGANA LETTER SMALL YO (U+3087)
  func test_hiraganaLetterSmallYo() {
    let scalar: UnicodeScalar = "ょ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ょ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ょ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ょ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ょ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'よ' - HIRAGANA LETTER YO (U+3088)
  func test_hiraganaLetterYo() {
    let scalar: UnicodeScalar = "よ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "よ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "よ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "よ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "よ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ら' - HIRAGANA LETTER RA (U+3089)
  func test_hiraganaLetterRa() {
    let scalar: UnicodeScalar = "ら"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ら")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ら")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ら")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ら")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'り' - HIRAGANA LETTER RI (U+308a)
  func test_hiraganaLetterRi() {
    let scalar: UnicodeScalar = "り"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "り")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "り")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "り")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "り")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'る' - HIRAGANA LETTER RU (U+308b)
  func test_hiraganaLetterRu() {
    let scalar: UnicodeScalar = "る"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "る")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "る")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "る")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "る")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'れ' - HIRAGANA LETTER RE (U+308c)
  func test_hiraganaLetterRe() {
    let scalar: UnicodeScalar = "れ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "れ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "れ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "れ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "れ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ろ' - HIRAGANA LETTER RO (U+308d)
  func test_hiraganaLetterRo() {
    let scalar: UnicodeScalar = "ろ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ろ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ろ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ろ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ろ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ゎ' - HIRAGANA LETTER SMALL WA (U+308e)
  func test_hiraganaLetterSmallWa() {
    let scalar: UnicodeScalar = "ゎ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ゎ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ゎ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ゎ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ゎ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'わ' - HIRAGANA LETTER WA (U+308f)
  func test_hiraganaLetterWa() {
    let scalar: UnicodeScalar = "わ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "わ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "わ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "わ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "わ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ゐ' - HIRAGANA LETTER WI (U+3090)
  func test_hiraganaLetterWi() {
    let scalar: UnicodeScalar = "ゐ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ゐ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ゐ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ゐ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ゐ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ゑ' - HIRAGANA LETTER WE (U+3091)
  func test_hiraganaLetterWe() {
    let scalar: UnicodeScalar = "ゑ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ゑ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ゑ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ゑ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ゑ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'を' - HIRAGANA LETTER WO (U+3092)
  func test_hiraganaLetterWo() {
    let scalar: UnicodeScalar = "を"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "を")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "を")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "を")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "を")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ん' - HIRAGANA LETTER N (U+3093)
  func test_hiraganaLetterN() {
    let scalar: UnicodeScalar = "ん"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ん")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ん")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ん")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ん")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ゔ' - HIRAGANA LETTER VU (U+3094)
  func test_hiraganaLetterVu() {
    let scalar: UnicodeScalar = "ゔ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ゔ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ゔ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ゔ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ゔ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ゕ' - HIRAGANA LETTER SMALL KA (U+3095)
  func test_hiraganaLetterSmallKa() {
    let scalar: UnicodeScalar = "ゕ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ゕ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ゕ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ゕ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ゕ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ゖ' - HIRAGANA LETTER SMALL KE (U+3096)
  func test_hiraganaLetterSmallKe() {
    let scalar: UnicodeScalar = "ゖ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ゖ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ゖ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ゖ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ゖ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// '◌゙' - COMBINING KATAKANA-HIRAGANA VOICED SOUND MARK (U+3099)
  func test_combiningKatakana_hiraganaVoicedSoundMark() {
    let scalar: UnicodeScalar = "゙"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "゙")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "゙")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "゙")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "゙")

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

  /// '◌゚' - COMBINING KATAKANA-HIRAGANA SEMI-VOICED SOUND MARK (U+309a)
  func test_combiningKatakana_hiraganaSemi_voicedSoundMark() {
    let scalar: UnicodeScalar = "゚"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "゚")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "゚")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "゚")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "゚")

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

  /// '゛' - KATAKANA-HIRAGANA VOICED SOUND MARK (U+309b)
  func test_katakana_hiraganaVoicedSoundMark() {
    let scalar: UnicodeScalar = "゛"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "゛")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "゛")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "゛")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "゛")

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

  /// '゜' - KATAKANA-HIRAGANA SEMI-VOICED SOUND MARK (U+309c)
  func test_katakana_hiraganaSemi_voicedSoundMark() {
    let scalar: UnicodeScalar = "゜"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "゜")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "゜")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "゜")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "゜")

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

  /// 'ゝ' - HIRAGANA ITERATION MARK (U+309d)
  func test_hiraganaIterationMark() {
    let scalar: UnicodeScalar = "ゝ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ゝ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ゝ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ゝ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ゝ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ゞ' - HIRAGANA VOICED ITERATION MARK (U+309e)
  func test_hiraganaVoicedIterationMark() {
    let scalar: UnicodeScalar = "ゞ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ゞ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ゞ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ゞ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ゞ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
    XCTAssertEqual(UnicodeData.isAlpha(scalar), true)
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), true)
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), false)
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), false)
    XCTAssertEqual(UnicodeData.isXidStart(scalar), true)
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), true)
    XCTAssertEqual(UnicodeData.isNumeric(scalar), false)
    XCTAssertEqual(UnicodeData.isPrintable(scalar), true)
  }

  /// 'ゟ' - HIRAGANA DIGRAPH YORI (U+309f)
  func test_hiraganaDigraphYori() {
    let scalar: UnicodeScalar = "ゟ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ゟ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ゟ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ゟ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ゟ")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), nil)
    XCTAssertEqual(UnicodeData.isDigit(scalar), false)
    XCTAssertDigit(UnicodeData.toDigit(scalar), nil)

    XCTAssertEqual(ASCIIData.isASCII(scalar), false)
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

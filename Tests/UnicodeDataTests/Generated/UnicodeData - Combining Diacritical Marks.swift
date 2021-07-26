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

/// Tests for: 0300..036f Combining Diacritical Marks block
class UnicodeDataCombiningDiacriticalMarksTests: XCTestCase {

  /// '◌̀' - COMBINING GRAVE ACCENT (U+0300)
  func test_combiningGraveAccent() {
    let scalar: UnicodeScalar = "̀"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̀")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̀")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̀")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̀")

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

  /// '◌́' - COMBINING ACUTE ACCENT (U+0301)
  func test_combiningAcuteAccent() {
    let scalar: UnicodeScalar = "́"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "́")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "́")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "́")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "́")

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

  /// '◌̂' - COMBINING CIRCUMFLEX ACCENT (U+0302)
  func test_combiningCircumflexAccent() {
    let scalar: UnicodeScalar = "̂"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̂")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̂")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̂")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̂")

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

  /// '◌̃' - COMBINING TILDE (U+0303)
  func test_combiningTilde() {
    let scalar: UnicodeScalar = "̃"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̃")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̃")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̃")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̃")

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

  /// '◌̄' - COMBINING MACRON (U+0304)
  func test_combiningMacron() {
    let scalar: UnicodeScalar = "̄"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̄")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̄")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̄")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̄")

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

  /// '◌̅' - COMBINING OVERLINE (U+0305)
  func test_combiningOverline() {
    let scalar: UnicodeScalar = "̅"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̅")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̅")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̅")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̅")

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

  /// '◌̆' - COMBINING BREVE (U+0306)
  func test_combiningBreve() {
    let scalar: UnicodeScalar = "̆"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̆")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̆")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̆")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̆")

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

  /// '◌̇' - COMBINING DOT ABOVE (U+0307)
  func test_combiningDotAbove() {
    let scalar: UnicodeScalar = "̇"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̇")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̇")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̇")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̇")

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

  /// '◌̈' - COMBINING DIAERESIS (U+0308)
  func test_combiningDiaeresis() {
    let scalar: UnicodeScalar = "̈"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̈")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̈")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̈")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̈")

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

  /// '◌̉' - COMBINING HOOK ABOVE (U+0309)
  func test_combiningHookAbove() {
    let scalar: UnicodeScalar = "̉"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̉")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̉")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̉")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̉")

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

  /// '◌̊' - COMBINING RING ABOVE (U+030a)
  func test_combiningRingAbove() {
    let scalar: UnicodeScalar = "̊"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̊")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̊")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̊")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̊")

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

  /// '◌̋' - COMBINING DOUBLE ACUTE ACCENT (U+030b)
  func test_combiningDoubleAcuteAccent() {
    let scalar: UnicodeScalar = "̋"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̋")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̋")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̋")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̋")

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

  /// '◌̌' - COMBINING CARON (U+030c)
  func test_combiningCaron() {
    let scalar: UnicodeScalar = "̌"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̌")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̌")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̌")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̌")

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

  /// '◌̍' - COMBINING VERTICAL LINE ABOVE (U+030d)
  func test_combiningVerticalLineAbove() {
    let scalar: UnicodeScalar = "̍"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̍")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̍")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̍")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̍")

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

  /// '◌̎' - COMBINING DOUBLE VERTICAL LINE ABOVE (U+030e)
  func test_combiningDoubleVerticalLineAbove() {
    let scalar: UnicodeScalar = "̎"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̎")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̎")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̎")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̎")

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

  /// '◌̏' - COMBINING DOUBLE GRAVE ACCENT (U+030f)
  func test_combiningDoubleGraveAccent() {
    let scalar: UnicodeScalar = "̏"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̏")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̏")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̏")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̏")

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

  /// '◌̐' - COMBINING CANDRABINDU (U+0310)
  func test_combiningCandrabindu() {
    let scalar: UnicodeScalar = "̐"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̐")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̐")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̐")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̐")

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

  /// '◌̑' - COMBINING INVERTED BREVE (U+0311)
  func test_combiningInvertedBreve() {
    let scalar: UnicodeScalar = "̑"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̑")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̑")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̑")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̑")

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

  /// '◌̒' - COMBINING TURNED COMMA ABOVE (U+0312)
  func test_combiningTurnedCommaAbove() {
    let scalar: UnicodeScalar = "̒"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̒")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̒")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̒")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̒")

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

  /// '◌̓' - COMBINING COMMA ABOVE (U+0313)
  func test_combiningCommaAbove() {
    let scalar: UnicodeScalar = "̓"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̓")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̓")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̓")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̓")

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

  /// '◌̔' - COMBINING REVERSED COMMA ABOVE (U+0314)
  func test_combiningReversedCommaAbove() {
    let scalar: UnicodeScalar = "̔"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̔")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̔")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̔")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̔")

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

  /// '◌̕' - COMBINING COMMA ABOVE RIGHT (U+0315)
  func test_combiningCommaAboveRight() {
    let scalar: UnicodeScalar = "̕"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̕")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̕")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̕")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̕")

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

  /// '◌̖' - COMBINING GRAVE ACCENT BELOW (U+0316)
  func test_combiningGraveAccentBelow() {
    let scalar: UnicodeScalar = "̖"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̖")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̖")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̖")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̖")

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

  /// '◌̗' - COMBINING ACUTE ACCENT BELOW (U+0317)
  func test_combiningAcuteAccentBelow() {
    let scalar: UnicodeScalar = "̗"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̗")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̗")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̗")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̗")

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

  /// '◌̘' - COMBINING LEFT TACK BELOW (U+0318)
  func test_combiningLeftTackBelow() {
    let scalar: UnicodeScalar = "̘"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̘")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̘")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̘")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̘")

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

  /// '◌̙' - COMBINING RIGHT TACK BELOW (U+0319)
  func test_combiningRightTackBelow() {
    let scalar: UnicodeScalar = "̙"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̙")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̙")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̙")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̙")

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

  /// '◌̚' - COMBINING LEFT ANGLE ABOVE (U+031a)
  func test_combiningLeftAngleAbove() {
    let scalar: UnicodeScalar = "̚"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̚")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̚")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̚")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̚")

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

  /// '◌̛' - COMBINING HORN (U+031b)
  func test_combiningHorn() {
    let scalar: UnicodeScalar = "̛"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̛")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̛")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̛")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̛")

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

  /// '◌̜' - COMBINING LEFT HALF RING BELOW (U+031c)
  func test_combiningLeftHalfRingBelow() {
    let scalar: UnicodeScalar = "̜"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̜")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̜")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̜")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̜")

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

  /// '◌̝' - COMBINING UP TACK BELOW (U+031d)
  func test_combiningUpTackBelow() {
    let scalar: UnicodeScalar = "̝"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̝")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̝")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̝")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̝")

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

  /// '◌̞' - COMBINING DOWN TACK BELOW (U+031e)
  func test_combiningDownTackBelow() {
    let scalar: UnicodeScalar = "̞"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̞")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̞")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̞")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̞")

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

  /// '◌̟' - COMBINING PLUS SIGN BELOW (U+031f)
  func test_combiningPlusSignBelow() {
    let scalar: UnicodeScalar = "̟"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̟")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̟")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̟")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̟")

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

  /// '◌̠' - COMBINING MINUS SIGN BELOW (U+0320)
  func test_combiningMinusSignBelow() {
    let scalar: UnicodeScalar = "̠"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̠")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̠")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̠")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̠")

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

  /// '◌̡' - COMBINING PALATALIZED HOOK BELOW (U+0321)
  func test_combiningPalatalizedHookBelow() {
    let scalar: UnicodeScalar = "̡"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̡")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̡")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̡")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̡")

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

  /// '◌̢' - COMBINING RETROFLEX HOOK BELOW (U+0322)
  func test_combiningRetroflexHookBelow() {
    let scalar: UnicodeScalar = "̢"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̢")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̢")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̢")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̢")

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

  /// '◌̣' - COMBINING DOT BELOW (U+0323)
  func test_combiningDotBelow() {
    let scalar: UnicodeScalar = "̣"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̣")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̣")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̣")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̣")

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

  /// '◌̤' - COMBINING DIAERESIS BELOW (U+0324)
  func test_combiningDiaeresisBelow() {
    let scalar: UnicodeScalar = "̤"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̤")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̤")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̤")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̤")

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

  /// '◌̥' - COMBINING RING BELOW (U+0325)
  func test_combiningRingBelow() {
    let scalar: UnicodeScalar = "̥"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̥")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̥")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̥")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̥")

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

  /// '◌̦' - COMBINING COMMA BELOW (U+0326)
  func test_combiningCommaBelow() {
    let scalar: UnicodeScalar = "̦"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̦")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̦")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̦")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̦")

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

  /// '◌̧' - COMBINING CEDILLA (U+0327)
  func test_combiningCedilla() {
    let scalar: UnicodeScalar = "̧"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̧")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̧")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̧")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̧")

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

  /// '◌̨' - COMBINING OGONEK (U+0328)
  func test_combiningOgonek() {
    let scalar: UnicodeScalar = "̨"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̨")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̨")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̨")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̨")

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

  /// '◌̩' - COMBINING VERTICAL LINE BELOW (U+0329)
  func test_combiningVerticalLineBelow() {
    let scalar: UnicodeScalar = "̩"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̩")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̩")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̩")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̩")

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

  /// '◌̪' - COMBINING BRIDGE BELOW (U+032a)
  func test_combiningBridgeBelow() {
    let scalar: UnicodeScalar = "̪"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̪")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̪")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̪")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̪")

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

  /// '◌̫' - COMBINING INVERTED DOUBLE ARCH BELOW (U+032b)
  func test_combiningInvertedDoubleArchBelow() {
    let scalar: UnicodeScalar = "̫"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̫")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̫")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̫")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̫")

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

  /// '◌̬' - COMBINING CARON BELOW (U+032c)
  func test_combiningCaronBelow() {
    let scalar: UnicodeScalar = "̬"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̬")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̬")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̬")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̬")

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

  /// '◌̭' - COMBINING CIRCUMFLEX ACCENT BELOW (U+032d)
  func test_combiningCircumflexAccentBelow() {
    let scalar: UnicodeScalar = "̭"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̭")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̭")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̭")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̭")

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

  /// '◌̮' - COMBINING BREVE BELOW (U+032e)
  func test_combiningBreveBelow() {
    let scalar: UnicodeScalar = "̮"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̮")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̮")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̮")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̮")

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

  /// '◌̯' - COMBINING INVERTED BREVE BELOW (U+032f)
  func test_combiningInvertedBreveBelow() {
    let scalar: UnicodeScalar = "̯"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̯")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̯")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̯")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̯")

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

  /// '◌̰' - COMBINING TILDE BELOW (U+0330)
  func test_combiningTildeBelow() {
    let scalar: UnicodeScalar = "̰"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̰")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̰")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̰")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̰")

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

  /// '◌̱' - COMBINING MACRON BELOW (U+0331)
  func test_combiningMacronBelow() {
    let scalar: UnicodeScalar = "̱"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̱")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̱")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̱")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̱")

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

  /// '◌̲' - COMBINING LOW LINE (U+0332)
  func test_combiningLowLine() {
    let scalar: UnicodeScalar = "̲"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̲")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̲")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̲")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̲")

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

  /// '◌̳' - COMBINING DOUBLE LOW LINE (U+0333)
  func test_combiningDoubleLowLine() {
    let scalar: UnicodeScalar = "̳"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̳")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̳")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̳")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̳")

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

  /// '◌̴' - COMBINING TILDE OVERLAY (U+0334)
  func test_combiningTildeOverlay() {
    let scalar: UnicodeScalar = "̴"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̴")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̴")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̴")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̴")

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

  /// '◌̵' - COMBINING SHORT STROKE OVERLAY (U+0335)
  func test_combiningShortStrokeOverlay() {
    let scalar: UnicodeScalar = "̵"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̵")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̵")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̵")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̵")

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

  /// '◌̶' - COMBINING LONG STROKE OVERLAY (U+0336)
  func test_combiningLongStrokeOverlay() {
    let scalar: UnicodeScalar = "̶"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̶")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̶")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̶")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̶")

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

  /// '◌̷' - COMBINING SHORT SOLIDUS OVERLAY (U+0337)
  func test_combiningShortSolidusOverlay() {
    let scalar: UnicodeScalar = "̷"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̷")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̷")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̷")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̷")

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

  /// '◌̸' - COMBINING LONG SOLIDUS OVERLAY (U+0338)
  func test_combiningLongSolidusOverlay() {
    let scalar: UnicodeScalar = "̸"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̸")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̸")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̸")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̸")

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

  /// '◌̹' - COMBINING RIGHT HALF RING BELOW (U+0339)
  func test_combiningRightHalfRingBelow() {
    let scalar: UnicodeScalar = "̹"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̹")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̹")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̹")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̹")

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

  /// '◌̺' - COMBINING INVERTED BRIDGE BELOW (U+033a)
  func test_combiningInvertedBridgeBelow() {
    let scalar: UnicodeScalar = "̺"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̺")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̺")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̺")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̺")

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

  /// '◌̻' - COMBINING SQUARE BELOW (U+033b)
  func test_combiningSquareBelow() {
    let scalar: UnicodeScalar = "̻"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̻")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̻")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̻")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̻")

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

  /// '◌̼' - COMBINING SEAGULL BELOW (U+033c)
  func test_combiningSeagullBelow() {
    let scalar: UnicodeScalar = "̼"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̼")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̼")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̼")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̼")

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

  /// '◌̽' - COMBINING X ABOVE (U+033d)
  func test_combiningXAbove() {
    let scalar: UnicodeScalar = "̽"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̽")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̽")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̽")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̽")

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

  /// '◌̾' - COMBINING VERTICAL TILDE (U+033e)
  func test_combiningVerticalTilde() {
    let scalar: UnicodeScalar = "̾"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̾")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̾")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̾")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̾")

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

  /// '◌̿' - COMBINING DOUBLE OVERLINE (U+033f)
  func test_combiningDoubleOverline() {
    let scalar: UnicodeScalar = "̿"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̿")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̿")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̿")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̿")

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

  /// '◌̀' - COMBINING GRAVE TONE MARK (U+0340)
  func test_combiningGraveToneMark() {
    let scalar: UnicodeScalar = "̀"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̀")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̀")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̀")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̀")

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

  /// '◌́' - COMBINING ACUTE TONE MARK (U+0341)
  func test_combiningAcuteToneMark() {
    let scalar: UnicodeScalar = "́"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "́")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "́")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "́")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "́")

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

  /// '◌͂' - COMBINING GREEK PERISPOMENI (U+0342)
  func test_combiningGreekPerispomeni() {
    let scalar: UnicodeScalar = "͂"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͂")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͂")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͂")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͂")

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

  /// '◌̓' - COMBINING GREEK KORONIS (U+0343)
  func test_combiningGreekKoronis() {
    let scalar: UnicodeScalar = "̓"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̓")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̓")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̓")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̓")

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

  /// '◌̈́' - COMBINING GREEK DIALYTIKA TONOS (U+0344)
  func test_combiningGreekDialytikaTonos() {
    let scalar: UnicodeScalar = "̈́"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "̈́")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "̈́")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "̈́")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "̈́")

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

  /// '◌ͅ' - COMBINING GREEK YPOGEGRAMMENI (U+0345)
  func test_combiningGreekYpogegrammeni() {
    let scalar: UnicodeScalar = "ͅ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), true)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ͅ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "Ι")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "Ι")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ι")

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

  /// '◌͆' - COMBINING BRIDGE ABOVE (U+0346)
  func test_combiningBridgeAbove() {
    let scalar: UnicodeScalar = "͆"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͆")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͆")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͆")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͆")

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

  /// '◌͇' - COMBINING EQUALS SIGN BELOW (U+0347)
  func test_combiningEqualsSignBelow() {
    let scalar: UnicodeScalar = "͇"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͇")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͇")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͇")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͇")

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

  /// '◌͈' - COMBINING DOUBLE VERTICAL LINE BELOW (U+0348)
  func test_combiningDoubleVerticalLineBelow() {
    let scalar: UnicodeScalar = "͈"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͈")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͈")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͈")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͈")

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

  /// '◌͉' - COMBINING LEFT ANGLE BELOW (U+0349)
  func test_combiningLeftAngleBelow() {
    let scalar: UnicodeScalar = "͉"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͉")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͉")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͉")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͉")

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

  /// '◌͊' - COMBINING NOT TILDE ABOVE (U+034a)
  func test_combiningNotTildeAbove() {
    let scalar: UnicodeScalar = "͊"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͊")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͊")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͊")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͊")

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

  /// '◌͋' - COMBINING HOMOTHETIC ABOVE (U+034b)
  func test_combiningHomotheticAbove() {
    let scalar: UnicodeScalar = "͋"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͋")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͋")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͋")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͋")

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

  /// '◌͌' - COMBINING ALMOST EQUAL TO ABOVE (U+034c)
  func test_combiningAlmostEqualToAbove() {
    let scalar: UnicodeScalar = "͌"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͌")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͌")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͌")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͌")

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

  /// '◌͍' - COMBINING LEFT RIGHT ARROW BELOW (U+034d)
  func test_combiningLeftRightArrowBelow() {
    let scalar: UnicodeScalar = "͍"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͍")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͍")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͍")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͍")

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

  /// '◌͎' - COMBINING UPWARDS ARROW BELOW (U+034e)
  func test_combiningUpwardsArrowBelow() {
    let scalar: UnicodeScalar = "͎"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͎")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͎")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͎")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͎")

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

  /// '◌͏' - COMBINING GRAPHEME JOINER (U+034f)
  func test_combiningGraphemeJoiner() {
    let scalar: UnicodeScalar = "͏"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͏")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͏")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͏")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͏")

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

  /// '◌͐' - COMBINING RIGHT ARROWHEAD ABOVE (U+0350)
  func test_combiningRightArrowheadAbove() {
    let scalar: UnicodeScalar = "͐"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͐")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͐")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͐")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͐")

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

  /// '◌͑' - COMBINING LEFT HALF RING ABOVE (U+0351)
  func test_combiningLeftHalfRingAbove() {
    let scalar: UnicodeScalar = "͑"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͑")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͑")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͑")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͑")

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

  /// '◌͒' - COMBINING FERMATA (U+0352)
  func test_combiningFermata() {
    let scalar: UnicodeScalar = "͒"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͒")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͒")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͒")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͒")

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

  /// '◌͓' - COMBINING X BELOW (U+0353)
  func test_combiningXBelow() {
    let scalar: UnicodeScalar = "͓"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͓")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͓")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͓")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͓")

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

  /// '◌͔' - COMBINING LEFT ARROWHEAD BELOW (U+0354)
  func test_combiningLeftArrowheadBelow() {
    let scalar: UnicodeScalar = "͔"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͔")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͔")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͔")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͔")

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

  /// '◌͕' - COMBINING RIGHT ARROWHEAD BELOW (U+0355)
  func test_combiningRightArrowheadBelow() {
    let scalar: UnicodeScalar = "͕"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͕")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͕")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͕")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͕")

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

  /// '◌͖' - COMBINING RIGHT ARROWHEAD AND UP ARROWHEAD BELOW (U+0356)
  func test_combiningRightArrowheadAndUpArrowheadBelow() {
    let scalar: UnicodeScalar = "͖"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͖")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͖")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͖")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͖")

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

  /// '◌͗' - COMBINING RIGHT HALF RING ABOVE (U+0357)
  func test_combiningRightHalfRingAbove() {
    let scalar: UnicodeScalar = "͗"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͗")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͗")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͗")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͗")

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

  /// '◌͘' - COMBINING DOT ABOVE RIGHT (U+0358)
  func test_combiningDotAboveRight() {
    let scalar: UnicodeScalar = "͘"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͘")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͘")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͘")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͘")

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

  /// '◌͙' - COMBINING ASTERISK BELOW (U+0359)
  func test_combiningAsteriskBelow() {
    let scalar: UnicodeScalar = "͙"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͙")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͙")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͙")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͙")

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

  /// '◌͚' - COMBINING DOUBLE RING BELOW (U+035a)
  func test_combiningDoubleRingBelow() {
    let scalar: UnicodeScalar = "͚"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͚")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͚")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͚")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͚")

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

  /// '◌͛' - COMBINING ZIGZAG ABOVE (U+035b)
  func test_combiningZigzagAbove() {
    let scalar: UnicodeScalar = "͛"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͛")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͛")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͛")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͛")

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

  /// '◌͜' - COMBINING DOUBLE BREVE BELOW (U+035c)
  func test_combiningDoubleBreveBelow() {
    let scalar: UnicodeScalar = "͜"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͜")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͜")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͜")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͜")

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

  /// '◌͝' - COMBINING DOUBLE BREVE (U+035d)
  func test_combiningDoubleBreve() {
    let scalar: UnicodeScalar = "͝"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͝")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͝")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͝")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͝")

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

  /// '◌͞' - COMBINING DOUBLE MACRON (U+035e)
  func test_combiningDoubleMacron() {
    let scalar: UnicodeScalar = "͞"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͞")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͞")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͞")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͞")

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

  /// '◌͟' - COMBINING DOUBLE MACRON BELOW (U+035f)
  func test_combiningDoubleMacronBelow() {
    let scalar: UnicodeScalar = "͟"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͟")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͟")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͟")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͟")

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

  /// '◌͠' - COMBINING DOUBLE TILDE (U+0360)
  func test_combiningDoubleTilde() {
    let scalar: UnicodeScalar = "͠"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͠")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͠")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͠")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͠")

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

  /// '◌͡' - COMBINING DOUBLE INVERTED BREVE (U+0361)
  func test_combiningDoubleInvertedBreve() {
    let scalar: UnicodeScalar = "͡"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͡")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͡")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͡")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͡")

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

  /// '◌͢' - COMBINING DOUBLE RIGHTWARDS ARROW BELOW (U+0362)
  func test_combiningDoubleRightwardsArrowBelow() {
    let scalar: UnicodeScalar = "͢"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "͢")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "͢")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "͢")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "͢")

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

  /// '◌ͣ' - COMBINING LATIN SMALL LETTER A (U+0363)
  func test_combiningLatinSmallLetterA() {
    let scalar: UnicodeScalar = "ͣ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ͣ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ͣ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ͣ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ͣ")

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

  /// '◌ͤ' - COMBINING LATIN SMALL LETTER E (U+0364)
  func test_combiningLatinSmallLetterE() {
    let scalar: UnicodeScalar = "ͤ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ͤ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ͤ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ͤ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ͤ")

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

  /// '◌ͥ' - COMBINING LATIN SMALL LETTER I (U+0365)
  func test_combiningLatinSmallLetterI() {
    let scalar: UnicodeScalar = "ͥ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ͥ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ͥ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ͥ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ͥ")

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

  /// '◌ͦ' - COMBINING LATIN SMALL LETTER O (U+0366)
  func test_combiningLatinSmallLetterO() {
    let scalar: UnicodeScalar = "ͦ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ͦ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ͦ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ͦ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ͦ")

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

  /// '◌ͧ' - COMBINING LATIN SMALL LETTER U (U+0367)
  func test_combiningLatinSmallLetterU() {
    let scalar: UnicodeScalar = "ͧ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ͧ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ͧ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ͧ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ͧ")

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

  /// '◌ͨ' - COMBINING LATIN SMALL LETTER C (U+0368)
  func test_combiningLatinSmallLetterC() {
    let scalar: UnicodeScalar = "ͨ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ͨ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ͨ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ͨ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ͨ")

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

  /// '◌ͩ' - COMBINING LATIN SMALL LETTER D (U+0369)
  func test_combiningLatinSmallLetterD() {
    let scalar: UnicodeScalar = "ͩ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ͩ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ͩ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ͩ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ͩ")

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

  /// '◌ͪ' - COMBINING LATIN SMALL LETTER H (U+036a)
  func test_combiningLatinSmallLetterH() {
    let scalar: UnicodeScalar = "ͪ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ͪ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ͪ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ͪ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ͪ")

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

  /// '◌ͫ' - COMBINING LATIN SMALL LETTER M (U+036b)
  func test_combiningLatinSmallLetterM() {
    let scalar: UnicodeScalar = "ͫ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ͫ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ͫ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ͫ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ͫ")

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

  /// '◌ͬ' - COMBINING LATIN SMALL LETTER R (U+036c)
  func test_combiningLatinSmallLetterR() {
    let scalar: UnicodeScalar = "ͬ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ͬ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ͬ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ͬ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ͬ")

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

  /// '◌ͭ' - COMBINING LATIN SMALL LETTER T (U+036d)
  func test_combiningLatinSmallLetterT() {
    let scalar: UnicodeScalar = "ͭ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ͭ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ͭ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ͭ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ͭ")

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

  /// '◌ͮ' - COMBINING LATIN SMALL LETTER V (U+036e)
  func test_combiningLatinSmallLetterV() {
    let scalar: UnicodeScalar = "ͮ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ͮ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ͮ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ͮ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ͮ")

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

  /// '◌ͯ' - COMBINING LATIN SMALL LETTER X (U+036f)
  func test_combiningLatinSmallLetterX() {
    let scalar: UnicodeScalar = "ͯ"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), false)
    XCTAssertCase(UnicodeData.toLowercase(scalar), "ͯ")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), false)
    XCTAssertCase(UnicodeData.toUppercase(scalar), "ͯ")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), false)
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "ͯ")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "ͯ")

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
}

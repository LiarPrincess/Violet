//===--- InitFromStringTests.swift ----------------------------*- swift -*-===//
//
// This source file is part of the Swift Numerics open source project
//
// Copyright (c) 2023 Apple Inc. and the Swift Numerics project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

import XCTest
@testable import BigInt

private typealias TestSuite = StringTestCases.TestSuite
private typealias TestCase = StringTestCases.TestCase
private typealias BinaryTestCases = StringTestCases.Binary
private typealias QuinaryTestCases = StringTestCases.Quinary
private typealias OctalTestCases = StringTestCases.Octal
private typealias DecimalTestCases = StringTestCases.Decimal
private typealias HexTestCases = StringTestCases.Hex

class InitFromStringTests: XCTestCase {

  // MARK: - Empty

  func test_empty_fails() {
    for radix in [2, 4, 7, 32] {
      let n = self.create(string: "", radix: radix)
      XCTAssertNil(n, "Got: \(String(describing: n)), radix: \(radix)")
    }
  }

  func test_onlySign_withoutDigits_plus_fails() {
    for radix in [2, 4, 7, 32] {
      let n = self.create(string: "+", radix: radix)
      XCTAssertNil(n, "Got: \(String(describing: n)), radix: \(radix)")
    }
  }

  func test_onlySign_withoutDigits_minus_fails() {
    for radix in [2, 4, 7, 32] {
      let n = self.create(string: "-", radix: radix)
      XCTAssertNil(n, "Got: \(String(describing: n)), radix: \(radix)")
    }
  }

  // MARK: - Zero

  func test_zero_single() {
    let zero = BigInt()

    for radix in [2, 4, 7, 32] {
      let n = self.create(string: "0", radix: radix)
      XCTAssertEqual(n, zero, "Radix: \(radix)")
    }
  }

  func test_zero_single_plus() {
    let zero = BigInt()

    for radix in [2, 4, 7, 32] {
      let n = self.create(string: "+0", radix: radix)
      XCTAssertEqual(n, zero, "Radix: \(radix)")
    }
  }

  func test_zero_single_minus() {
    let zero = BigInt()

    for radix in [2, 4, 7, 32] {
      let n = self.create(string: "-0", radix: radix)
      XCTAssertEqual(n, zero, "Radix: \(radix)")
    }
  }

  func test_zero_multiple() {
    let zero = BigInt()
    let input = String(repeating: "0", count: 42)

    for radix in [2, 4, 7, 32] {
      let n = self.create(string: input, radix: radix)
      XCTAssertEqual(n, zero)
    }
  }

  // MARK: - Int -> String -> BigInt

  func test_int_toString_toBigInt_binary() {
    self.int_toString_toBigInt(radix: 2)
  }

  func test_int_toString_toBigInt_decimal() {
    self.int_toString_toBigInt(radix: 10)
  }

  func test_int_toString_toBigInt_hex() {
    self.int_toString_toBigInt(radix: 16)
  }

  func int_toString_toBigInt(radix: Int,
                             file: StaticString = #file,
                             line: UInt = #line) {
    for int in generateInts(approximateCount: 100) {
      let expected = BigInt(int)

      let lowercase = String(int, radix: radix, uppercase: false)
      let lowercaseResult = self.create(string: lowercase, radix: radix)
      XCTAssertEqual(lowercaseResult,
                     expected,
                     "\(int), lowercase",
                     file: file,
                     line: line)

      let uppercase = String(int, radix: radix, uppercase: true)
      let uppercaseResult = self.create(string: uppercase, radix: radix)
      XCTAssertEqual(uppercaseResult,
                     expected,
                     "\(int), uppercase",
                     file: file,
                     line: line)
    }
  }

  // MARK: - Binary

  func test_binary_singleWord() {
    self.run(suite: BinaryTestCases.singleWord)
  }

  func test_binary_twoWords() {
    self.run(suite: BinaryTestCases.twoWords)
  }

  // MARK: - Quinary

  func test_quinary_singleWord() {
    self.run(suite: QuinaryTestCases.singleWord)
  }

  func test_quinary_twoWords() {
    self.run(suite: QuinaryTestCases.twoWords)
  }

  // MARK: - Octal

  func test_octal_singleWord() {
    self.run(suite: OctalTestCases.singleWord)
  }

  func test_octal_twoWords() {
    self.run(suite: OctalTestCases.twoWords)
  }

  func test_octal_threeWords() {
    self.run(suite: OctalTestCases.threeWords)
  }

  // MARK: - Decimal

  func test_decimal_singleWord() {
    self.run(suite: DecimalTestCases.singleWord)
  }

  func test_decimal_twoWords() {
    self.run(suite: DecimalTestCases.twoWords)
  }

  func test_decimal_threeWords() {
    self.run(suite: DecimalTestCases.threeWords)
  }

  func test_decimal_fourWords() {
    self.run(suite: DecimalTestCases.fourWords)
  }

  // MARK: - Hex

  func test_hex_singleWord() {
    self.run(suite: HexTestCases.singleWord)
  }

  func test_hex_twoWords() {
    self.run(suite: HexTestCases.twoWords)
  }

  func test_hex_threeWords() {
    self.run(suite: HexTestCases.threeWords)
  }

  // MARK: - Underscore

  func test_underscore_binary_fails() {
    self.runUnderscore(suite: BinaryTestCases.twoWords)
  }

  func test_underscore_decimal_fails() {
    self.runUnderscore(suite: DecimalTestCases.twoWords)
  }

  private func runUnderscore(suite: TestSuite,
                             file: StaticString = #file,
                             line: UInt = #line) {
    for testCase in suite.cases {
      let s = testCase.stringWithUnderscores
      let n = self.create(string: s, radix: suite.radix)
      XCTAssertNil(n, s)
    }
  }

  // MARK: - Underscore placement

  func test_underscore_prefix_withoutSign_fails() {
    for radix in [2, 4, 7, 32] {
      let n = self.create(string: "_0101", radix: radix)
      XCTAssertNil(n, "Got: \(String(describing: n)), radix: \(radix)")
    }
  }

  func test_underscore_before_plusSign_fails() {
    for radix in [2, 4, 7, 32] {
      let n = self.create(string: "_+0101", radix: radix)
      XCTAssertNil(n, "Got: \(String(describing: n)), radix: \(radix)")
    }
  }

  func test_underscore_before_minusSign_fails() {
    for radix in [2, 4, 7, 32] {
      let n = self.create(string: "_+0101", radix: radix)
      XCTAssertNil(n, "Got: \(String(describing: n)), radix: \(radix)")
    }
  }

  func test_underscore_after_plusSign_fails() {
    for radix in [2, 4, 7, 32] {
      let n = self.create(string: "+_0101", radix: radix)
      XCTAssertNil(n, "Got: \(String(describing: n)), radix: \(radix)")
    }
  }

  func test_underscore_after_minusSign_fails() {
    for radix in [2, 4, 7, 32] {
      let n = self.create(string: "-_0101", radix: radix)
      XCTAssertNil(n, "Got: \(String(describing: n)), radix: \(radix)")
    }
  }

  func test_underscore_suffix_fails() {
    for radix in [2, 4, 7, 32] {
      let n = self.create(string: "0101_", radix: radix)
      XCTAssertNil(n, "Got: \(String(describing: n)), radix: \(radix)")
    }
  }

  func test_underscore_double_fails() {
    for radix in [2, 4, 7, 32] {
      let n = self.create(string: "01__01", radix: radix)
      XCTAssertNil(n, "Got: \(String(describing: n)), radix: \(radix)")
    }
  }

  // MARK: - Invalid digit

  func test_invalidDigit_emoji_fails() {
    let emoji = "😊"

    for radix in [2, 4, 7, 32] {
      let n = self.create(string: "01\(emoji)01", radix: radix)
      XCTAssertNil(n, "Got: \(String(describing: n)), radix: \(radix)")
    }
  }

  func test_invalidDigit_biggerThanRadix_fails() {
    let cases: [(Int, UnicodeScalar)] = [
      (2, "2"),
      (4, "4"),
      (7, "7"),
      (10, "a"),
      (16, "g")
    ]

    for (radix, biggerThanRadix) in cases {
      let n = self.create(string: "01\(biggerThanRadix)01", radix: radix)
      XCTAssertNil(n, "Got: \(String(describing: n)), radix: \(radix)")
    }
  }

  // MARK: - Helpers

  /// Abstraction over `BigInt.init(_:radix:)`.
  private func create(string: String, radix: Int) -> BigInt? {
    return BigInt(string, radix: radix)
  }

  private func run(suite: TestSuite,
                   file: StaticString = #file,
                   line: UInt = #line) {
    let radix = suite.radix

    for testCase in suite.cases {
      let input = testCase.string
      let expected = testCase.create()
      let expectedNegative = testCase.create(sign: .negative)

      let lowercased = self.create(string: input.lowercased(), radix: radix)
      XCTAssertEqual(lowercased, expected, "LOWERCASE " + input, file: file, line: line)

      let uppercased = self.create(string: input.uppercased(), radix: radix)
      XCTAssertEqual(uppercased, expected, "UPPERCASE " + input, file: file, line: line)

      let plusSign = self.create(string: "+" + input, radix: radix)
      XCTAssertEqual(plusSign, expected, "PLUS " + input, file: file, line: line)

      assert(!testCase.isZero, "-0 should be handled differently")
      let minusSign = self.create(string: "-" + input, radix: radix)
      XCTAssertEqual(minusSign, expectedNegative, "MINUS " + input, file: file, line: line)
    }
  }
}

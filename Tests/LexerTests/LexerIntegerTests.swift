// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import Lexer

/// Use 'python3 -m tokenize -e file.py' for python reference.
class LexerIntegerTests: XCTestCase, LexerTest {

  // MARK: - Decimal integer

  func test_decimal_zero_isLexed() {
    let s = "0"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .int(0))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_decimal_zero_withUnderscores_isLexed() {
    let s = "0_000_000"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .int(0))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 9))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
  func test_decimal_isLexed() {
    let s = "2147483647"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .int(2_147_483_647))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 10))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
  func test_decimal_withUnderscores_isLexed() {
    let s = "100_000_000_000"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .int(100_000_000_000))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 15))
    }
  }

  func test_decimal_maxInt64_isLexed() {
    let s = "9223372036854775807"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .int(9_223_372_036_854_775_807))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 19))
    }
  }

  // MARK: - Binary integer

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
  func test_binary_isLexed() {
    let s = "0b100110111"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .int(0b100110111))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 11))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
  func test_binary_withUnderscores_isLexed() {
    let s = "0b_1110_0101"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .int(0b1110_0101))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 12))
    }
  }

  // MARK: - Octal integer

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
  func test_octal_isLexed() {
    let s = "0o177"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .int(0o177))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 5))
    }
  }

  /// Test case from (I added underscores):
  /// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
  func test_octal_withUnderscores_isLexed() {
    let s = "0o_37_7"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .int(0o377))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 7))
    }
  }

  // MARK: - Hex integer

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
  func test_hex_isLexed() {
    let s = "0xdeadBEEF"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .int(0xdeadbeef))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 10))
    }
  }

  func test_hex_withUnderscores_isLexed() {
    let s = "0x_01_23_45_67_89_ac"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .int(0x01_23_45_67_89_ac))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 20))
    }
  }

  func test_hex_zero_isLexed() {
    let s = "0x0"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .int(0x0))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  // TODO: Fix 'test_hex_lastUnderscore_isNotAPartOfTheNumber' test
  func test_hex_lastUnderscore_isNotAPartOfTheNumber() {
    let s = "0x123_"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let error = self.numberError(&lexer) {
//      XCTAssertEqual(token.kind, .int(0x123))
//      XCTAssertEqual(error.location, SourceLocation(line: 1, column: 0))
//      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 5))
    }
  }
}

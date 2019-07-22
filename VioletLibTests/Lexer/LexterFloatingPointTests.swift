// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import VioletLib

/// Use 'python3 -m tokenize -e file.py' for python reference.
class LexterFloatingPointTests: XCTestCase, LexerTest {

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#floating-point-literals
  func test_zero_isLexed() {
    let s = "0.0"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .float(0.0))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#floating-point-literals
  func test_zero_asExponent_isLexed() {
    let s = "0e0"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .float(0.0))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#floating-point-literals
  func test_number_isLexed() {
    let s = "3.14"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .float(3.14))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 4))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#floating-point-literals
  func test_number_withUnderscores_isLexed() {
    let s = "3.14_15_93"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .float(3.141_593))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 10))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#floating-point-literals
  func test_number_withoutFractions_isLexed() {
    // trivia: glibc calss this 'american style' number

    let s = "10."
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .float(10))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#floating-point-literals
  func test_number_withoutWhole_isLexed() {
    let s = ".001"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .float(0.001))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 4))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#floating-point-literals
  func test_number_withExponent_isLexed() {
    let s = "1e100"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .float(1e100))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 5))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#floating-point-literals
  /// 'For example, 077e010 is legal, and denotes the same number as 77e10.'
  func test_number_withExponent_isLexed2() {
    let s = "077e010"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .float(77e010))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 7))
    }
  }

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#floating-point-literals
  func test_number_withFraction_andExponent_isLexed() {
    let s = "3.14e-10"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .float(3.14e-10))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 8))
    }
  }
}

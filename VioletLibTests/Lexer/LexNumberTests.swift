// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import VioletLib

/// Use 'python3 -m tokenize -e file.py' for python reference.
class LexerNumberTests: XCTestCase {

  // MARK: - Decimal integer

  //  3
  //  7
  //  2147483647
  //  79228162514264337593543950336
  //  100_000_000_000

  // 0, max

  // MARK: - Binary integer

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
  func test_binaryInteger_isLexed() {
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
  func test_binaryInteger_withUnderscores_isLexed() {
    let s = "0b_1110_0101"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .int(0b1110_0101))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 12))
    }
  }

  func test_binaryInteger_zero_isLexed() {
    let s = "0b0"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .int(0b0))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 3))
    }
  }

  // MARK: - Octal integer

  /// Test case from:
  /// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
  func test_octalInteger_isLexed() {
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
  func test_octalInteger_withUnderscores_isLexed() {
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
  func test_hexInteger_isLexed() {
    let s = "0xdeadBEEF"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .int(0xdeadbeef))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 10))
    }
  }

  func test_hexInteger_withUnderscores_isLexed() {
    let s = "0x_01_23_45_67_89_ac"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.number(&lexer) {
      XCTAssertEqual(token.kind, .int(0x01_23_45_67_89_ac))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 20))
    }
  }

  // MARK: - Helpers

  // TODO: move to XCTestCase extension
  private func number(_ lexer: inout Lexer,
                      file:     StaticString = #file,
                      line:     UInt = #line) -> Token? {
    do {
      return try lexer.number()
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }

  private func error(_ lexer: inout Lexer,
                     file:     StaticString = #file,
                     line:     UInt = #line) -> LexerError? {
    do {
      let result = try lexer.number()
      XCTAssert(false, "Got token: \(result)", file: file, line: line)
      return nil
    } catch let error as LexerError {
      return error
    } catch {
      XCTAssert(false, "Invalid error: \(error)", file: file, line: line)
      return nil
    }
  }
}

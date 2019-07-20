// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import VioletLib

/// Use 'python3 -m tokenize -e file.py' for python reference
/// and https://www.stlyrics.com/lyrics/classicdisney/partofyourworld.htm
/// for song reference.
class LexerStringTest: XCTestCase {

  // MARK: - Empty

  func test_emptyString_isLexed() {
    let s = ""
    let stream = StringStream(self.quote(s))
    var lexer  = Lexer(stream: stream)

    if let token = self.string(&lexer) {
      XCTAssertEqual(token.kind, .string(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  // MARK: - Double quotes

  /// py: "Look at this stuff. Isnt it neat?"
  func test_doubleQuote_simple() {
    let s = "Look at this stuff. Isnt it neat?"
    let stream = StringStream(self.quote(s))
    var lexer  = Lexer(stream: stream)

    if let token = self.string(&lexer) {
      XCTAssertEqual(token.kind, .string(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 35))
    }
  }

  /// Test (in this order): \\, \', \", \n, \t
  /// py: "Wouldnt\\you\'think\"my\ncollections\tcomplete?"
  func test_doubleQuote_withEscapes() {
    let s = "Wouldnt\\\\you\\\'think\\\"my\\ncollections\\tcomplete?"
    let expected = "Wouldnt\\you'think\"my\ncollections\tcomplete?"

    let stream = StringStream(self.quote(s))
    var lexer  = Lexer(stream: stream)

    if let token = self.string(&lexer) {
      XCTAssertEqual(token.kind, .string(expected))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 49))
    }
  }

  /// py (1st line escapes newline, so we can continue in 2nd):
  /// "Wouldnt you think Im the girl\
  /// The girl who has everything?"
  func test_doubleQuote_withLineEscapes() {
    let s = "Wouldnt you think Im the girl\\\nThe girl who has everything?"
    let expected = "Wouldnt you think Im the girlThe girl who has everything?"

    let stream = StringStream(self.quote(s))
    var lexer  = Lexer(stream: stream)

    if let token = self.string(&lexer) {
      XCTAssertEqual(token.kind, .string(expected))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 2, column: 29))
    }
  }

  /// Test (in this order): 2 digit octal, 3 digit octal, x, U
  /// py: "Wanderin\47 free \055 wish \x49 could be Part of that \U0001F30D"
  func test_doubleQuote_withNumericEscapes() {
    let s = "Wanderin\\47 free \\055 wish \\x49 could be Part of that \\U0001F30D"
    let expected = "Wanderin' free - wish I could be Part of that 🌍"

    let stream = StringStream(self.quote(s))
    var lexer  = Lexer(stream: stream)

    if let token = self.string(&lexer) {
      XCTAssertEqual(token.kind, .string(expected))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 66))
    }
  }

  /// Test mixing text and emoji in single string (emoji at start/middle/end)
  /// py: "🧜‍♀️: I wanna be where the people are, I wanna 👀, wanna 👀 em 💃"
  func test_doubleQuote_emoji() {
    let s = "🧜‍♀️: I wanna be where the people are, I wanna 👀, wanna 👀 em 💃"
    let stream = StringStream(self.quote(s))
    var lexer  = Lexer(stream: stream)

    if let token = self.string(&lexer) {
      XCTAssertEqual(token.kind, .string(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 64))
    }
  }

  /// py: "c: 小美人鱼 j: リトルマーメイド k: 인어 공주"
  func test_doubleQuote_cjk() {
    let s = "c: 小美人鱼 j: リトルマーメイド k: 인어 공주"
    let stream = StringStream(self.quote(s))
    var lexer  = Lexer(stream: stream)

    if let token = self.string(&lexer) {
      XCTAssertEqual(token.kind, .string(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 30))
    }
  }

  /// Single quote, without closing.
  /// py: "Ive got gadgets and gizmos a-plenty
  func test_doubleQuote_withoutEnd_throws() {
    let stream = StringStream("\"Ive got gadgets and gizmos a-plenty\n")
    var lexer = Lexer(stream: stream)

    if let error = self.error(&lexer) {
      XCTAssertEqual(error.type, LexerErrorType.eols)
      XCTAssertEqual(error.location, SourceLocation(line: 1, column: 36))
    }
  }

  // MARK: - Triple quotes

  /// py: """Ive got whozits and whatzits galore"""
  func test_tripleQuote_simple() {
    let s = "Ive got whozits and whatzits galore"
    let stream = StringStream(self.tripleQuote(s))
    var lexer  = Lexer(stream: stream)

    if let token = self.string(&lexer) {
      XCTAssertEqual(token.kind, .string(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 41))
    }
  }

  /// py: """You want thingamabobs?"I've got twenty!"""
  func test_tripleQuote_singleQuotes_doNotEnd() {
    let s = "You want thingamabobs?\"I've got twenty!"
    let stream = StringStream(self.tripleQuote(s))
    var lexer  = Lexer(stream: stream)

    if let token = self.string(&lexer) {
      XCTAssertEqual(token.kind, .string(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 45))
    }
  }

  /// py:
  /// """But who cares?
  /// No big deal
  /// I want more"""
  func test_tripleQuote_multilineString() {
    let s = "But who cares?\nNo big deal\nI want more"
    let stream = StringStream(self.tripleQuote(s))
    var lexer  = Lexer(stream: stream)

    if let token = self.string(&lexer) {
      XCTAssertEqual(token.kind, .string(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 3, column: 14))
    }
  }

  // MARK: - Helpers

  private func quote(_ s: String) -> String {
    return "\"\(s)\""
  }

  private func tripleQuote(_ s: String) -> String {
    return "\"\"\"\(s)\"\"\""
  }

  private func string(_ lexer: inout Lexer,
                      file:     StaticString = #file,
                      line:     UInt = #line) -> Token? {
    do {
      return try lexer.string()
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }

  private func error(_ lexer: inout Lexer,
                     file:     StaticString = #file,
                     line:     UInt = #line) -> LexerError? {
    do {
      let result = try lexer.string()
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

// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import VioletLib

/// Use 'python3 -m tokenize -e text.py' for reference.
class LexerStringTest: XCTestCase {

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

  // MARK: - Single quotes

  func test_string_inQuotes_isLexed() {
    // py: "Look at this stuff. Isnt it neat?"
    let s = "Look at this stuff. Isnt it neat?"
    let stream = StringStream(self.quote(s))
    var lexer  = Lexer(stream: stream)

    if let token = self.string(&lexer) {
      XCTAssertEqual(token.kind, .string(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 35))
    }
  }

  func test_string_inQuotes_withEscapes_isLexed() {
    // we test (in this order): \\, \', \", \n, \t

    // py: "Wouldnt\\you\'think\"my\ncollections\tcomplete?"
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

  func test_string_inQuotes_withLineEscape_isLexed() {
    // py (1st line escapes newline, so we can continue in 2nd):
    // "Little\
    // Mermaid"

    let s = "Little\\\nMermaid"
    let expected = "LittleMermaid"

    let stream = StringStream(self.quote(s))
    var lexer  = Lexer(stream: stream)

    if let token = self.string(&lexer) {
      XCTAssertEqual(token.kind, .string(expected))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 2, column: 8))
    }
  }

  func test_emoji_inQuotes_areLexed() {
    // test mixing text and emoji in single string (emoji at start/middle/end)

    // py: "🧜‍♀️: I wanna be where the people are, I wanna 👀, wanna 👀 em 💃"
    let s = "🧜‍♀️: I wanna be where the people are, I wanna 👀, wanna 👀 em 💃"
    let stream = StringStream(self.quote(s))
    var lexer  = Lexer(stream: stream)

    if let token = self.string(&lexer) {
      XCTAssertEqual(token.kind, .string(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 64))
    }
  }

  func test_cjk_inQuotes_areLexed() {
    // py: "c: 小美人鱼 j: リトルマーメイド k: 인어 공주"
    let s = "c: 小美人鱼 j: リトルマーメイド k: 인어 공주"
    let stream = StringStream(self.quote(s))
    var lexer  = Lexer(stream: stream)

    if let token = self.string(&lexer) {
      XCTAssertEqual(token.kind, .string(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 30))
    }
  }

  func test_string_inQuotes_withoutEnd_fails() {
    // py: "Ive got gadgets and gizmos a-plenty
    let stream = StringStream("\"Ive got gadgets and gizmos a-plenty\n")
    var lexer = Lexer(stream: stream)

    if let error = self.error(&lexer) {
      XCTAssertEqual(error.type, LexerErrorType.eols)
      XCTAssertEqual(error.location, SourceLocation(line: 1, column: 36))
    }
  }

  // MARK: - Triple quotes

  func test_string_inTripleQuotes_isLexed() {
    // py: """Ive got whozits and whatzits galore"""
    let s = "Ive got whozits and whatzits galore"
    let stream = StringStream(self.tripleQuote(s))
    var lexer  = Lexer(stream: stream)

    if let token = self.string(&lexer) {
      XCTAssertEqual(token.kind, .string(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 41))
    }
  }

  func test_string_inTripleQuotes_singleQuotes_doNotEnd() {
    // py: """You want thingamabobs?"I've got twenty!"""
    let s = "You want thingamabobs?\"I've got twenty!"
    let stream = StringStream(self.tripleQuote(s))
    var lexer  = Lexer(stream: stream)

    if let token = self.string(&lexer) {
      XCTAssertEqual(token.kind, .string(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 45))
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

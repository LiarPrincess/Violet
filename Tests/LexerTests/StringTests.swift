import XCTest
import VioletCore
@testable import VioletLexer

// swiftformat:disable consecutiveSpaces

// cSpell:ignore isnt wouldnt wanderin
// cSpell:ignore you\'think you'think you'want
// cSpell:ignore whozits whatzits

/// Use 'python3 -m tokenize -e file.py' for python reference
/// and https://www.youtube.com/watch?v=t6Ol7VsZGk4 for song reference.
class StringTests: XCTestCase {

  // MARK: - Empty

  func test_emptyString() {
    let s = ""
    let lexer = createLexer(for: singleQuote(s))

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .string(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 2))
    }
  }

  // MARK: - Double quotes

  /// py: "Look at this stuff. Isnt it neat?"
  func test_doubleQuote_simple() {
    let s = "Look at this stuff. Isnt it neat?"
    let lexer = createLexer(for: singleQuote(s))

    if let token = getToken(lexer) {
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

    let lexer = createLexer(for: singleQuote(s))

    if let token = getToken(lexer) {
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

    let lexer = createLexer(for: singleQuote(s))

    if let token = getToken(lexer) {
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

    let lexer = createLexer(for: singleQuote(s))

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .string(expected))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 66))
    }
  }

  /// py: "Wouldn't I love, love to exp\lore that shore up above?"
  func test_doubleQuote_withUnrecognizedEscape_warns() {
    let s = "Wouldn't I love, love to exp\\lore that shore up above?"
    let lexer = createLexer(for: singleQuote(s))

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .string(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 56))
    }
  }

  /// Test mixing text and emoji in single string (emoji at start/middle/end)
  /// py: "🧜‍♀️: I wanna be where the people are, I wanna 👀, wanna 👀 em 💃"
  func test_doubleQuote_emoji() {
    let s = "🧜‍♀️: I wanna be where the people are, I wanna 👀, wanna 👀 em 💃"
    let lexer = createLexer(for: singleQuote(s))

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .string(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 64))
    }
  }

  /// py: "c: 小美人鱼 j: リトルマーメイド k: 인어 공주"
  func test_doubleQuote_CJK() {
    let s = "c: 小美人鱼 j: リトルマーメイド k: 인어 공주"
    let lexer = createLexer(for: singleQuote(s))

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .string(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 30))
    }
  }

  /// Quote, without closing.
  /// py: "Ive got gadgets and gizmos aplenty
  func test_doubleQuote_withoutEnd_throws() {
    let lexer = createLexer(for: "\"Ive got gadgets and gizmos aplenty\n")

    if let error = getError(lexer) {
      XCTAssertEqual(error.kind, .unfinishedShortString)
      XCTAssertEqual(error.location, SourceLocation(line: 1, column: 35))
    }
  }

  // MARK: - Single quote

  /// Basically we assume, that if double quotes are working then single too.
  /// py: 'Look at this stuff. Isnt it neat?'
  func test_singleQuote_simple() {
    let s = "Look at this stuff. Isnt it neat?"
    let lexer = createLexer(for: singleQuote(s, quote: "'"))

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .string(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 35))
    }
  }

  // MARK: - Triple quotes

  /// py: """Ive got whozits and whatzits galore"""
  func test_tripleQuote_simple() {
    let s = "Ive got whozits and whatzits galore"
    let lexer = createLexer(for: tripleQuote(s))

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .string(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 41))
    }
  }

  /// py: """You'want"thingamabobs?""I got twenty!"""
  func test_tripleQuote_singleQuotes_doNotEnd() {
    let s = "You'want\"thingamabobs?\"\"I got twenty!"
    let lexer = createLexer(for: tripleQuote(s))

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .string(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 43))
    }
  }

  /// py:
  /// """But who cares?
  /// No big deal
  /// I want more"""
  func test_tripleQuote_multilineString() {
    let s = "But who cares?\nNo big deal\nI want more"
    let lexer = createLexer(for: tripleQuote(s))

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .string(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 3, column: 14))
    }
  }

  /// py:
  /// """But who cares?
  /// No big deal
  /// I want more"
  func test_tripleQuote_withoutEnd_throws() {
    let lexer = createLexer(for: "\"\"\"But who cares?\nNo big deal\nI want more\"")

    if let error = getError(lexer) {
      XCTAssertEqual(error.kind,  .unfinishedLongString)
      XCTAssertEqual(error.location, SourceLocation(line: 3, column: 12))
    }
  }

  // MARK: - Raw string

  func test_rawString() {
    let s = "r\"\\\\\\\\\""
    let lexer = createLexer(for: s)

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .string("\\\\\\\\"))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 7))
    }
  }

  // MARK: - Bytes

  func test_bytes() {
    let rawData = (UInt8.min..<UInt8.max)
    let s = rawData
    .map { x -> String in
      let hex = String(x, radix: 16, uppercase: false)
      let pad = hex.count < 2 ? "0" : ""
      return "\\x\(pad)\(hex)"
    }
    .joined()

    let lexer = createLexer(for: "b" + singleQuote(s))

    if let token = getToken(lexer) {
      let data = Data(rawData)
      XCTAssertEqual(token.kind, .bytes(data))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1_023))
    }
  }
}

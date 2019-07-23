// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import Lexer

/// Use 'python3 -m tokenize -e file.py' for python reference
/// and https://www.stlyrics.com/lyrics/classicdisney/kissthegirl.htm
/// for song reference.
class IdentifierTests: XCTestCase, Common {

  // MARK: - String

  /// py: f"Kiss The Girl"
  func test_prefixedString_shouldBeLexedAsString() {
    let s = "Kiss The Girl"
    var lexer = Lexer(string: "f" + self.shortQuote(s))

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .formatString(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 16))
    }
  }

  // MARK: - Keywords

  func test_allKeywords_shouldBeRecognized() {
    for (keyword, value) in keywords {
      var lexer = Lexer(string: keyword)

      if let token = self.getToken(&lexer) {
        XCTAssertEqual(token.kind, .keyword(value), keyword)
        XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0), keyword)
        XCTAssertEqual(token.end,   SourceLocation(line: 1, column: keyword.count), keyword)
      }
    }
  }

  // MARK: - Identifiers

  /// py: shaLaLaLaLaLa
  func test_identifier_simple_isValid() {
    let s = "shaLaLaLaLaLa"
    var lexer = Lexer(string: s)

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .identifier(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 13))
    }
  }

  /// py: _lookAtTheBoyTooShy
  func test_identifier_startingWithUnderscore_isValid() {
    let s = "_lookAtTheBoyTooShy"
    var lexer = Lexer(string: s)

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .identifier(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 19))
    }
  }

  /// https://docs.python.org/3/reference/lexical_analysis.html#reserved-classes-of-identifiers
  func test_identifier_fromReservedClass_isValid() {
    let reserved = ["_", "__x__", "__x"]

    for identifier in reserved {
      var lexer = Lexer(string: identifier)

      if let token = self.getToken(&lexer) {
        XCTAssertEqual(token.kind, .identifier(identifier), identifier)
        XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0), identifier)
        XCTAssertEqual(token.end,   SourceLocation(line: 1, column: identifier.count), identifier)
      }
    }
  }

  /// py: 齀words
  func test_identifier_startingWithCJK_isValid() {
    let s = "齀words"
    var lexer = Lexer(string: s)

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .identifier(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 6))
    }
  }

  // py: win齀ds
  func test_identifier_containingCJK_isValid() {
    let s = "win齀ds"
    var lexer = Lexer(string: s)

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .identifier(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 6))
    }
  }

  /// py: 🎤withMeNow
  func test_identifier_startingWithEmoji_isNotValid() {
    var lexer = Lexer(string: "🎤withMeNow")

    if let error = self.error(&lexer) {
      XCTAssertEqual(error.kind,  LexerErrorKind.identifier)
      XCTAssertEqual(error.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(error.end,   SourceLocation(line: 1, column: 0))
    }
  }

  // py: no⏱️WillBeBetter
  func test_identifier_containingEmoji_isNotValid() {
    var lexer = Lexer(string: "no⏱️WillBeBetter")

    if let error = self.error(&lexer) {
      XCTAssertEqual(error.kind,  LexerErrorKind.identifier)
      XCTAssertEqual(error.start, SourceLocation(line: 1, column: 2))
      XCTAssertEqual(error.end,   SourceLocation(line: 1, column: 2))
    }
  }
}

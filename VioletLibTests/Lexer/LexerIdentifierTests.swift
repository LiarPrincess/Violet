// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import VioletLib

/// Use 'python3 -m tokenize -e file.py' for python reference
/// and https://www.stlyrics.com/lyrics/classicdisney/kissthegirl.htm
/// for song reference.
class LexerIdentifierTests: XCTestCase {

  // MARK: - String

  /// py: f"Kiss The Girl"
  func test_prefixedString_shouldBeLexedAsString() {
    let s = "Kiss The Girl"
    let stream = StringStream("f\"\(s)\"")
    var lexer  = Lexer(stream: stream)

    if let token = self.identifierOrString(&lexer) {
      XCTAssertEqual(token.kind, .formatString(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 16))
    }
  }

  // MARK: - Keywords

  func test_allKeywords_shouldBeRecognized() {
    for (keyword, tokenKind) in Lexer.keywords {
      let stream = StringStream(keyword)
      var lexer  = Lexer(stream: stream)

      if let token = self.identifierOrString(&lexer) {
        XCTAssertEqual(token.kind, tokenKind, keyword)
        XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0), keyword)
        XCTAssertEqual(token.end,   SourceLocation(line: 1, column: keyword.count), keyword)
      }
    }
  }

  // MARK: - Identifiers

  /// py: shaLaLaLaLaLa
  func test_identifier_simple_isValid() {
    let s = "shaLaLaLaLaLa"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.identifierOrString(&lexer) {
      XCTAssertEqual(token.kind, .identifier(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 13))
    }
  }

  /// py: _lookAtTheBoyTooShy
  func test_identifier_startingWithUnderscore_isValid() {
    let s = "_lookAtTheBoyTooShy"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.identifierOrString(&lexer) {
      XCTAssertEqual(token.kind, .identifier(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 19))
    }
  }

  /// https://docs.python.org/3/reference/lexical_analysis.html#reserved-classes-of-identifiers
  func test_identifier_fromReservedClass_isValid() {
    let reserved = ["_", "__x__", "__x"]

    for identifier in reserved {
      let stream = StringStream(identifier)
      var lexer  = Lexer(stream: stream)

      if let token = self.identifierOrString(&lexer) {
        XCTAssertEqual(token.kind, .identifier(identifier), identifier)
        XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0), identifier)
        XCTAssertEqual(token.end,   SourceLocation(line: 1, column: identifier.count), identifier)
      }
    }
  }

  /// py: 齀words
  func test_identifier_startingWithCJK_isValid() {
    let s = "齀words"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.identifierOrString(&lexer) {
      XCTAssertEqual(token.kind, .identifier(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 6))
    }
  }

  // py: win齀ds
  func test_identifier_containingCJK_isValid() {
    let s = "win齀ds"
    let stream = StringStream(s)
    var lexer  = Lexer(stream: stream)

    if let token = self.identifierOrString(&lexer) {
      XCTAssertEqual(token.kind, .identifier(s))
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 6))
    }
  }

  /// py: 🎤withMeNow
  func test_identifier_startingWithEmoji_isNotValid() {
    let stream = StringStream("🎤withMeNow")
    var lexer  = Lexer(stream: stream)

    if let error = self.error(&lexer) {
      XCTAssertEqual(error.type, LexerErrorType.identifier)
      XCTAssertEqual(error.location, SourceLocation(line: 1, column: 0))
    }
  }

  // py: no⏱️WillBeBetter
  func test_identifier_containingEmoji_isNotValid() {
    let stream = StringStream("no⏱️WillBeBetter")
    var lexer  = Lexer(stream: stream)

    if let error = self.error(&lexer) {
      XCTAssertEqual(error.type, LexerErrorType.identifier)
      XCTAssertEqual(error.location, SourceLocation(line: 1, column: 2))
    }
  }

  // MARK: - Helpers

  private func identifierOrString(_ lexer: inout Lexer,
                                  file:     StaticString = #file,
                                  line:     UInt = #line) -> Token? {
    do {
      return try lexer.identifierOrString()
    } catch {
      XCTAssert(false, "\(error)", file: file, line: line)
      return nil
    }
  }

  private func error(_ lexer: inout Lexer,
                     file:     StaticString = #file,
                     line:     UInt = #line) -> LexerError? {
    do {
      let result = try lexer.identifierOrString()
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

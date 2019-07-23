// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import Lexer

/// Use 'python3 -m tokenize -e file.py' for python reference
class IndentTabTests: XCTestCase, Common {

  /// py (lex correct, grammar incorrect):
  ///   Beauty | indent
  ///   Beast  | equal
  func test_indent_equal() {
    let s = """
    \tBeauty
    \tBeast
    """

    var lexer = Lexer(string: s)

    if let indent = self.getToken(&lexer) {
      XCTAssertEqual(indent.kind, .indent)
      XCTAssertEqual(indent.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(indent.end,   SourceLocation(line: 1, column: 1))
    }

    self.getIdentifier(&lexer, value: "Beauty")
    self.getNewLine(&lexer)

    // no indent
    self.getIdentifier(&lexer, value: "Beast")
    self.getEOF(&lexer)
  }

  /// py (lex correct, grammar incorrect):
  ///   Little | indent
  /// Mermaid  | dedent
  func test_indent_dedent() {
    let s = """
    \tLittle
    Mermaid
    """

    var lexer = Lexer(string: s)

    if let indent = self.getToken(&lexer) {
      XCTAssertEqual(indent.kind, .indent)
      XCTAssertEqual(indent.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(indent.end,   SourceLocation(line: 1, column: 1))
    }

    self.getIdentifier(&lexer, value: "Little")
    self.getNewLine(&lexer)

    if let dedent = self.getToken(&lexer) {
      XCTAssertEqual(dedent.kind, .dedent)
      XCTAssertEqual(dedent.start, SourceLocation(line: 2, column: 0))
      XCTAssertEqual(dedent.end,   SourceLocation(line: 2, column: 0))
    }

    self.getIdentifier(&lexer, value: "Mermaid")
    self.getEOF(&lexer)
  }

  /// py (lex correct, grammar incorrect):
  ///   Gaston | indent1
  ///     Best | indent2
  /// Waifu    | dedent1 dedent2
  // swiftlint:disable:next function_body_length
  func test_indent_indent_doubleDedent() {
    let s = """
    \tGaston
    \t\tBest
    Waifu
    """

    var lexer = Lexer(string: s)

    if let indent1 = self.getToken(&lexer) {
      XCTAssertEqual(indent1.kind, .indent)
      XCTAssertEqual(indent1.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(indent1.end,   SourceLocation(line: 1, column: 1))
    }

    self.getIdentifier(&lexer, value: "Gaston")
    self.getNewLine(&lexer)

    if let indent2 = self.getToken(&lexer) {
      XCTAssertEqual(indent2.kind, .indent)
      XCTAssertEqual(indent2.start, SourceLocation(line: 2, column: 0))
      XCTAssertEqual(indent2.end,   SourceLocation(line: 2, column: 2))
    }

    self.getIdentifier(&lexer, value: "Best")
    self.getNewLine(&lexer)

    if let dedent1 = self.getToken(&lexer) {
      XCTAssertEqual(dedent1.kind, .dedent)
      XCTAssertEqual(dedent1.start, SourceLocation(line: 3, column: 0))
      XCTAssertEqual(dedent1.end,   SourceLocation(line: 3, column: 0))
    }

    if let dedent2 = self.getToken(&lexer) {
      XCTAssertEqual(dedent2.kind, .dedent)
      XCTAssertEqual(dedent2.start, SourceLocation(line: 3, column: 0))
      XCTAssertEqual(dedent2.end,   SourceLocation(line: 3, column: 0))
    }

    self.getIdentifier(&lexer, value: "Waifu")
    self.getEOF(&lexer)
  }

  /// py (lex incorrect, grammar incorrect):
  ///     Prince | indent
  ///   Charming | error
  func test_doubleIndent_dedent_isIncorrect() {
    let s = """
    \t\tPrince
    \tCharming
    """

    var lexer = Lexer(string: s)

    if let indent = self.getToken(&lexer) {
      XCTAssertEqual(indent.kind, .indent)
      XCTAssertEqual(indent.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(indent.end,   SourceLocation(line: 1, column: 2))
    }

    self.getIdentifier(&lexer, value: "Prince")
    self.getNewLine(&lexer)

    if let error = self.error(&lexer) {
      XCTAssertEqual(error.kind, .dedent)
      XCTAssertEqual(error.start, SourceLocation(line: 2, column: 0))
      XCTAssertEqual(error.end,   SourceLocation(line: 2, column: 0))
    }
  }
}

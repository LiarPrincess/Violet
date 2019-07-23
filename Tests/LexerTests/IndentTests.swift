// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import Lexer

/// Use 'python3 -m tokenize -e file.py' for python reference
class IndentTests: XCTestCase, Common {

  // MARK: - No indent

  /// py: Ariel
  func test_noIndent_isLexed() {
    let s = "Ariel"
    var lexer = Lexer(string: s)

    self.getIdentifier(&lexer, value: "Ariel")
    self.getEOF(&lexer)
  }

  // MARK: - Empty line, comment

  /// py (lex correct, grammar incorrect):
  /// Prince
  /// (4 spaces)
  /// Charming
  func test_emptyLine_doesNotIndent() {
    let s = "Prince\n    \nCharming"

    var lexer = Lexer(string: s)

    self.getIdentifier(&lexer, value: "Prince")
    self.getNewLine(&lexer)
    self.getNewLine(&lexer)
    self.getIdentifier(&lexer, value: "Charming")
    self.getEOF(&lexer)
  }

  /// py (lex correct, grammar incorrect):
  /// Gaston
  /// (4 spaces)# Best
  /// Waifu
  func test_lineWithOnlyComment_doesNotIndent() {
    let s = "Gaston\n    #Best\nWaifu"

    var lexer = Lexer(string: s)

    self.getIdentifier(&lexer, value: "Gaston")
    self.getNewLine(&lexer)
    self.getNewLine(&lexer)
    self.getIdentifier(&lexer, value: "Waifu")
    self.getEOF(&lexer)
  }

  // MARK: - Brackets

  /// py (lex correct, grammar incorrect):
  /// (
  ///   Little
  ///      Mermaid
  /// )
  func test_braces_doNotIndent() {
    let s = """
    (
      Little
        Mermaid
    )
    """

    var lexer = Lexer(string: s)

    while let token = self.getToken(&lexer), token.kind != .eof {
      XCTAssertNotEqual(token.kind, .indent, token.description)
      XCTAssertNotEqual(token.kind, .dedent, token.description)
    }
  }

  // MARK: - Mixing tabs and spaces

  /// py (lex correct, grammar incorrect):
  /// \tBeauty      | indent
  ///         Beast | equal (8 spaces)
  func test_1tab_equals_8spaces() {
    let s = """
    \tBeauty
            Beast
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
}

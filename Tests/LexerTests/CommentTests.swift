// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Core
@testable import Lexer

/// Use 'python3 -m tokenize -e file.py' for python reference
/// and https://disney.fandom.com/wiki/Gaston_(song) for song reference.
/// As a vim user I have to say that emacs encoding declaration is more popular,
/// so we will test it more (btw. it is 1 letter shorter than vims).
class CommentTests: XCTestCase, Common {

  // MARK: - Comment

  func test_comment_isNotLexed() {
    var lexer = Lexer(string: "# No one's slick as Gaston\n")

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .newLine)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 26))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 27))
    }
  }

  func test_comment_afterCode_isNotLexed() {
    var lexer = Lexer(string: "Gaston # No one's quick as Gaston\n")

    if let codeToken = self.getToken(&lexer) {
      XCTAssertEqual(codeToken.kind, .identifier("Gaston"))
      XCTAssertEqual(codeToken.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(codeToken.end,   SourceLocation(line: 1, column: 6))
    }

    if let newLineToken = self.getToken(&lexer) {
      XCTAssertEqual(newLineToken.kind, .newLine)
      XCTAssertEqual(newLineToken.start, SourceLocation(line: 1, column: 33))
      XCTAssertEqual(newLineToken.end,   SourceLocation(line: 1, column: 34))
    }
  }

  func test_comment_inLastLine_isNotLexed() {
    var lexer = Lexer(string: "# No one's neck's as incredibly thick as Gaston")

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .eof)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 47))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 48))
    }
  }

  // MARK: - Encoding

  private let validEncoding = "utf-8"
  private let invalidEncoding = "latin-1"

  /// py: # -*- coding: utf-8 -*-
  func test_emacs_validEncoding_inFirstline_isAccepted() {
    let s = "\(self.emacsEncoding(validEncoding))"
    var lexer = Lexer(string: s)

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .eof)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 23))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 24))
    }
  }

  /// py: # -*- coding: latin-1 -*-
  func test_emacs_invalidEncoding_inFirstline_throws() {
    let s = "\(self.emacsEncoding(invalidEncoding))"
    var lexer = Lexer(string: s)

    if let error = self.notImplemented(&lexer) {
      XCTAssertEncoding(error, invalidEncoding)
    }
  }

  /// py:     # -*- coding: latin-1 -*-
  func test_emacs_invalidEncoding_inFirstline_withIndent_throws() {
    // we can have spaces before encoding
    let s = "    \(self.emacsEncoding(invalidEncoding))"
    var lexer = Lexer(string: s)

    if let error = self.notImplemented(&lexer) {
      XCTAssertEncoding(error, invalidEncoding)
    }
  }

  /// py: Gaston # -*- coding: latin-1 -*-
  func test_emacs_invalidEncoding_inFirstline_withSomethingBefore_isIgnored() {
    let s = "Gaston \(self.emacsEncoding(invalidEncoding))\n"
    var lexer = Lexer(string: s)

    if let codeToken = self.getToken(&lexer) {
      XCTAssertEqual(codeToken.kind, .identifier("Gaston"))
      XCTAssertEqual(codeToken.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(codeToken.end,   SourceLocation(line: 1, column: 6))
    }

    if let newLineToken = self.getToken(&lexer) {
      XCTAssertEqual(newLineToken.kind, .newLine)
      XCTAssertEqual(newLineToken.start, SourceLocation(line: 1, column: 32))
      XCTAssertEqual(newLineToken.end,   SourceLocation(line: 1, column: 33))
    }
  }

  /// py:
  /// # No one fights like Gaston
  ///  # -*- coding: latin-1 -*-
  func test_emacs_invalidEncoding_inSecondline_throws() {
    let s = "# No one fights like Gaston\n \(self.emacsEncoding(invalidEncoding))"
    print(s)
    var lexer = Lexer(string: s)

    if let firstLine = self.getToken(&lexer) {
      XCTAssertEqual(firstLine.kind, .newLine)
      XCTAssertEqual(firstLine.start, SourceLocation(line: 1, column: 27))
      XCTAssertEqual(firstLine.end,   SourceLocation(line: 1, column: 28))
    }

    if let error = self.notImplemented(&lexer) {
      XCTAssertEncoding(error, invalidEncoding)
    }
  }
}

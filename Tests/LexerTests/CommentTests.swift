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

  func test_comment() {
    var lexer = Lexer(string: "# No one's slick as Gaston\n")

    if let comment = self.getToken(&lexer) {
      XCTAssertEqual(comment.kind, .comment("# No one's slick as Gaston"))
      XCTAssertEqual(comment.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(comment.end,   SourceLocation(line: 1, column: 26))
    }

    self.getNewLine(&lexer)
    self.getEOF(&lexer)
  }

  func test_comment_afterCode() {
    var lexer = Lexer(string: "Gaston # No one's quick as Gaston\n")

    self.getIdentifier(&lexer, value: "Gaston")

    if let comment = self.getToken(&lexer) {
      XCTAssertEqual(comment.kind, .comment("# No one's quick as Gaston"))
      XCTAssertEqual(comment.start, SourceLocation(line: 1, column: 7))
      XCTAssertEqual(comment.end,   SourceLocation(line: 1, column: 33))
    }

    self.getNewLine(&lexer)
    self.getEOF(&lexer)
  }

  func test_comment_inLastLine() {
    let s = "# No one's neck's as incredibly thick as Gaston"
    var lexer = Lexer(string: s)

    if let comment = self.getToken(&lexer) {
      XCTAssertEqual(comment.kind, .comment(s))
      XCTAssertEqual(comment.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(comment.end,   SourceLocation(line: 1, column: 47))
    }

    self.getEOF(&lexer)
  }

  // MARK: - Encoding

  private let validEncoding = "utf-8"
  private let invalidEncoding = "latin-1"

  /// py: # -*- coding: utf-8 -*-
  func test_emacs_validEncoding_inFirstLine_isAccepted() {
    let s = "# -*- coding: \(validEncoding) -*-"
    var lexer = Lexer(string: s + "\n")

    if let comment = self.getToken(&lexer) {
      XCTAssertEqual(comment.kind, .comment(s))
      XCTAssertEqual(comment.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(comment.end,   SourceLocation(line: 1, column: 23))
    }

    self.getNewLine(&lexer)
    self.getEOF(&lexer)
  }

  /// py: # -*- coding: latin-1 -*-
  func test_emacs_invalidEncoding_inFirstLine_throws() {
    let s = "# -*- coding: \(invalidEncoding) -*-"
    var lexer = Lexer(string: s)

    if let error = self.notImplemented(&lexer) {
      XCTAssertEncoding(error, invalidEncoding)
    }
  }

  /// py:     # -*- coding: latin-1 -*-
  func test_emacs_invalidEncoding_inFirstLine_withIndent_throws() {
    // we can have spaces before encoding
    let s = "    # -*- coding: \(invalidEncoding) -*-"
    var lexer = Lexer(string: s)

    if let error = self.notImplemented(&lexer) {
      XCTAssertEncoding(error, invalidEncoding)
    }
  }

  /// py: Gaston # -*- coding: latin-1 -*-
  func test_emacs_invalidEncoding_inFirstLine_withSomethingBefore_isIgnored() {
    let e = "# -*- coding: \(invalidEncoding) -*-"
    var lexer = Lexer(string: "Gaston \(e)\n")

    self.getIdentifier(&lexer, value: "Gaston")

    if let comment = self.getToken(&lexer) {
      XCTAssertEqual(comment.kind, .comment(e))
      XCTAssertEqual(comment.start, SourceLocation(line: 1, column: 7))
      XCTAssertEqual(comment.end,   SourceLocation(line: 1, column: 32))
    }

    self.getNewLine(&lexer)
    self.getEOF(&lexer)
  }

  /// py:
  /// # No one fights like Gaston
  ///  # -*- coding: latin-1 -*-
  func test_emacs_invalidEncoding_inSecondLine_throws() {
    let s = "# No one fights like Gaston\n # -*- coding: \(invalidEncoding) -*-"
    print(s)
    var lexer = Lexer(string: s)

    if let comment = self.getToken(&lexer) {
      XCTAssertEqual(comment.kind, .comment("# No one fights like Gaston"))
      XCTAssertEqual(comment.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(comment.end,   SourceLocation(line: 1, column: 27))
    }

    self.getNewLine(&lexer)

    if let error = self.notImplemented(&lexer) {
      XCTAssertEncoding(error, invalidEncoding)
    }
  }
}

import XCTest
import VioletCore
@testable import VioletLexer

// swiftformat:disable consecutiveSpaces

/// Use 'python3 -m tokenize -e file.py' for python reference
/// and https://disney.fandom.com/wiki/Gaston_(song) for song reference.
/// As a vim user I have to say that emacs encoding declaration is more popular,
/// so we will test it more (btw. it is 1 letter shorter than vims).
class CommentTests: XCTestCase {

  // MARK: - Comment

  func test_comment() {
    let lexer = createLexer(for: "# No one's slick as Gaston\n")

    if let comment = getToken(lexer) {
      XCTAssertEqual(comment.kind, .comment("# No one's slick as Gaston"))
      XCTAssertEqual(comment.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(comment.end,   SourceLocation(line: 1, column: 26))
    }

    getNewLine(lexer)
    getEOF(lexer)
  }

  func test_comment_afterCode() {
    let lexer = createLexer(for: "Gaston # No one's quick as Gaston\n")

    getIdentifier(lexer, value: "Gaston")

    if let comment = getToken(lexer) {
      XCTAssertEqual(comment.kind, .comment("# No one's quick as Gaston"))
      XCTAssertEqual(comment.start, SourceLocation(line: 1, column: 7))
      XCTAssertEqual(comment.end,   SourceLocation(line: 1, column: 33))
    }

    getNewLine(lexer)
    getEOF(lexer)
  }

  func test_comment_inLastLine() {
    let s = "# No one's neck's as incredibly thick as Gaston"
    let lexer = createLexer(for: s)

    if let comment = getToken(lexer) {
      XCTAssertEqual(comment.kind, .comment(s))
      XCTAssertEqual(comment.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(comment.end,   SourceLocation(line: 1, column: 47))
    }

    getEOF(lexer)
  }

  // MARK: - Encoding

  private let validEncoding = "utf-8"
  private let invalidEncoding = "latin-1"

  /// py: # -*- coding: utf-8 -*-
  func test_emacs_validEncoding_inFirstLine_isAccepted() {
    let s = "# -*- coding: \(validEncoding) -*-"
    let lexer = createLexer(for: s + "\n")

    if let comment = getToken(lexer) {
      XCTAssertEqual(comment.kind, .comment(s))
      XCTAssertEqual(comment.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(comment.end,   SourceLocation(line: 1, column: 23))
    }

    getNewLine(lexer)
    getEOF(lexer)
  }

  /// py: # -*- coding: latin-1 -*-
  func test_emacs_invalidEncoding_inFirstLine_throws() {
    let s = "# -*- coding: \(invalidEncoding) -*-"
    let lexer = createLexer(for: s)

    if let error = getUnimplemented(lexer) {
      XCTAssertEncoding(error, self.invalidEncoding)
    }
  }

  /// py:     # -*- coding: latin-1 -*-
  func test_emacs_invalidEncoding_inFirstLine_withIndent_throws() {
    // we can have spaces before encoding
    let s = "    # -*- coding: \(invalidEncoding) -*-"
    let lexer = createLexer(for: s)

    if let error = getUnimplemented(lexer) {
      XCTAssertEncoding(error, self.invalidEncoding)
    }
  }

  /// py: Gaston # -*- coding: latin-1 -*-
  func test_emacs_invalidEncoding_inFirstLine_withSomethingBefore_isIgnored() {
    let e = "# -*- coding: \(invalidEncoding) -*-"
    let lexer = createLexer(for: "Gaston \(e)\n")

    getIdentifier(lexer, value: "Gaston")

    if let comment = getToken(lexer) {
      XCTAssertEqual(comment.kind, .comment(e))
      XCTAssertEqual(comment.start, SourceLocation(line: 1, column: 7))
      XCTAssertEqual(comment.end,   SourceLocation(line: 1, column: 32))
    }

    getNewLine(lexer)
    getEOF(lexer)
  }

  /// py:
  /// # No one fights like Gaston
  ///  # -*- coding: latin-1 -*-
  func test_emacs_invalidEncoding_inSecondLine_throws() {
    let s = "# No one fights like Gaston\n # -*- coding: \(invalidEncoding) -*-"
    let lexer = createLexer(for: s)

    if let comment = getToken(lexer) {
      XCTAssertEqual(comment.kind, .comment("# No one fights like Gaston"))
      XCTAssertEqual(comment.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(comment.end,   SourceLocation(line: 1, column: 27))
    }

    getNewLine(lexer)

    if let error = getUnimplemented(lexer) {
      XCTAssertEncoding(error, self.invalidEncoding)
    }
  }
}

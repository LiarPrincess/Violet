import XCTest
import VioletCore
@testable import VioletLexer

/// Use 'python3 -m tokenize -e file.py' for python reference
class IndentSpaceTests: XCTestCase, Common {

  /// Not valid Python code, but it does not matter for lexer:
  ///    Beauty | indent (3 spaces)
  ///    Beast  | equal
  /// (artificial new line + dedent, before EOF)
  func test_indent_equal() {
    let s = """
       Beauty
       Beast
    """

    let lexer = self.createLexer(for: s)

    if let indent = self.getToken(lexer) {
      XCTAssertEqual(indent.kind, .indent)
      XCTAssertEqual(indent.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(indent.end,   SourceLocation(line: 1, column: 3))
    }

    self.getIdentifier(lexer, value: "Beauty")
    self.getNewLine(lexer)

    // no indent
    self.getIdentifier(lexer, value: "Beast")
    self.getNewLine(lexer) // artificial new line

    if let dedent = self.getToken(lexer) {
      XCTAssertEqual(dedent.kind, .dedent)
      XCTAssertEqual(dedent.start, SourceLocation(line: 2, column: 8))
      XCTAssertEqual(dedent.end,   SourceLocation(line: 2, column: 8))
    }

    self.getEOF(lexer)
  }

  /// Not valid Python code, but it does not matter for lexer:
  ///   Little | indent (2 spaces)
  /// Mermaid  | dedent
  func test_indent_dedent() {
    let s = """
      Little
    Mermaid
    """

    let lexer = self.createLexer(for: s)

    if let indent = self.getToken(lexer) {
      XCTAssertEqual(indent.kind, .indent)
      XCTAssertEqual(indent.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(indent.end,   SourceLocation(line: 1, column: 2))
    }

    self.getIdentifier(lexer, value: "Little")
    self.getNewLine(lexer)

    if let dedent = self.getToken(lexer) {
      XCTAssertEqual(dedent.kind, .dedent)
      XCTAssertEqual(dedent.start, SourceLocation(line: 2, column: 0))
      XCTAssertEqual(dedent.end,   SourceLocation(line: 2, column: 0))
    }

    self.getIdentifier(lexer, value: "Mermaid")
    self.getEOF(lexer)
  }

  /// Not valid Python code, but it does not matter for lexer:
  ///   Gaston    | indent1 (2 spaces)
  ///        Best | indent2 (7 spaces)
  /// Waifu       | dedent1 dedent2
  func test_indent_indent_doubleDedent() {
    let s = """
      Gaston
           Best
    Waifu
    """

    let lexer = self.createLexer(for: s)

    if let indent1 = self.getToken(lexer) {
      XCTAssertEqual(indent1.kind, .indent)
      XCTAssertEqual(indent1.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(indent1.end,   SourceLocation(line: 1, column: 2))
    }

    self.getIdentifier(lexer, value: "Gaston")
    self.getNewLine(lexer)

    if let indent2 = self.getToken(lexer) {
      XCTAssertEqual(indent2.kind, .indent)
      XCTAssertEqual(indent2.start, SourceLocation(line: 2, column: 0))
      XCTAssertEqual(indent2.end,   SourceLocation(line: 2, column: 7))
    }

    self.getIdentifier(lexer, value: "Best")
    self.getNewLine(lexer)

    if let dedent1 = self.getToken(lexer) {
      XCTAssertEqual(dedent1.kind, .dedent)
      XCTAssertEqual(dedent1.start, SourceLocation(line: 3, column: 0))
      XCTAssertEqual(dedent1.end,   SourceLocation(line: 3, column: 0))
    }

    if let dedent2 = self.getToken(lexer) {
      XCTAssertEqual(dedent2.kind, .dedent)
      XCTAssertEqual(dedent2.start, SourceLocation(line: 3, column: 0))
      XCTAssertEqual(dedent2.end,   SourceLocation(line: 3, column: 0))
    }

    self.getIdentifier(lexer, value: "Waifu")
    self.getEOF(lexer)
  }

  /// py (lex incorrect, grammar incorrect):
  ///      Prince | indent (5 spaces)
  ///  Charming   | error
  func test_doubleIndent_dedent_isIncorrect() {
    let s = """
         Prince
     Charming
    """

    let lexer = self.createLexer(for: s)

    if let indent = self.getToken(lexer) {
      XCTAssertEqual(indent.kind, .indent)
      XCTAssertEqual(indent.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(indent.end,   SourceLocation(line: 1, column: 5))
    }

    self.getIdentifier(lexer, value: "Prince")
    self.getNewLine(lexer)

    if let error = self.error(lexer) {
      XCTAssertEqual(error.kind, .noMatchingDedent)
      XCTAssertEqual(error.location, SourceLocation(line: 2, column: 0))
    }
  }
}

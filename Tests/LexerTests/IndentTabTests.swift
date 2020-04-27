import XCTest
import VioletCore
@testable import VioletLexer

/// Use 'python3 -m tokenize -e file.py' for python reference
class IndentTabTests: XCTestCase, Common {

  /// Not valid Python code, but it does not matter for lexer:
  ///   Beauty | indent
  ///   Beast  | equal
  /// (artificial new line + dedent, before EOF)
  func test_indent_equal() {
    let s = """
    \tBeauty
    \tBeast
    """

    let lexer = self.createLexer(for: s)

    if let indent = self.getToken(lexer) {
      XCTAssertEqual(indent.kind, .indent)
      XCTAssertEqual(indent.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(indent.end,   SourceLocation(line: 1, column: 1))
    }

    self.getIdentifier(lexer, value: "Beauty")
    self.getNewLine(lexer)

    // no indent
    self.getIdentifier(lexer, value: "Beast")
    self.getNewLine(lexer) // artificial new line

    if let dedent = self.getToken(lexer) {
      XCTAssertEqual(dedent.kind, .dedent)
      XCTAssertEqual(dedent.start, SourceLocation(line: 2, column: 6))
      XCTAssertEqual(dedent.end,   SourceLocation(line: 2, column: 6))
    }

    self.getEOF(lexer)
  }

  /// Not valid Python code, but it does not matter for lexer:
  ///   Little | indent
  /// Mermaid  | dedent
  func test_indent_dedent() {
    let s = """
    \tLittle
    Mermaid
    """

    let lexer = self.createLexer(for: s)

    if let indent = self.getToken(lexer) {
      XCTAssertEqual(indent.kind, .indent)
      XCTAssertEqual(indent.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(indent.end,   SourceLocation(line: 1, column: 1))
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
  ///   Gaston | indent1
  ///     Best | indent2
  /// Waifu    | dedent1 dedent2
  func test_indent_indent_doubleDedent() {
    let s = """
    \tGaston
    \t\tBest
    Waifu
    """

    let lexer = self.createLexer(for: s)

    if let indent1 = self.getToken(lexer) {
      XCTAssertEqual(indent1.kind, .indent)
      XCTAssertEqual(indent1.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(indent1.end,   SourceLocation(line: 1, column: 1))
    }

    self.getIdentifier(lexer, value: "Gaston")
    self.getNewLine(lexer)

    if let indent2 = self.getToken(lexer) {
      XCTAssertEqual(indent2.kind, .indent)
      XCTAssertEqual(indent2.start, SourceLocation(line: 2, column: 0))
      XCTAssertEqual(indent2.end,   SourceLocation(line: 2, column: 2))
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
  ///     Prince | indent
  ///   Charming | error
  func test_doubleIndent_dedent_isIncorrect() {
    let s = """
    \t\tPrince
    \tCharming
    """

    let lexer = self.createLexer(for: s)

    if let indent = self.getToken(lexer) {
      XCTAssertEqual(indent.kind, .indent)
      XCTAssertEqual(indent.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(indent.end,   SourceLocation(line: 1, column: 2))
    }

    self.getIdentifier(lexer, value: "Prince")
    self.getNewLine(lexer)

    if let error = self.error(lexer) {
      XCTAssertEqual(error.kind, .noMatchingDedent)
      XCTAssertEqual(error.location, SourceLocation(line: 2, column: 0))
    }
  }
}

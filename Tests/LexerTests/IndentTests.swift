import XCTest
import Core
@testable import Lexer

/// Use 'python3 -m tokenize -e file.py' for python reference
class IndentTests: XCTestCase, Common {

  // MARK: - No indent

  /// py: Ariel
  func test_noIndent() {
    let s = "Ariel"
    let lexer = self.createLexer(for: s)

    self.getIdentifier(lexer, value: "Ariel")
    self.getEOF(lexer)
  }

  // MARK: - Empty line, comment

  /// Not valid Python code, but it does not matter for lexer:
  /// Prince
  /// (4 spaces)
  /// Charming
  func test_emptyLine_doesNotIndent() {
    let s = "Prince\n    \nCharming"
    let lexer = self.createLexer(for: s)

    self.getIdentifier(lexer, value: "Prince")
    self.getNewLine(lexer)
    self.getNewLine(lexer)
    self.getIdentifier(lexer, value: "Charming")
    self.getEOF(lexer)
  }

  /// Not valid Python code, but it does not matter for lexer:
  /// Gaston
  /// (4 spaces)# Best
  /// Waifu
  func test_lineWithOnlyComment_doesNotIndent() {
    let s = "Gaston\n    #Best\nWaifu"
    let lexer = self.createLexer(for: s)

    self.getIdentifier(lexer, value: "Gaston")
    self.getNewLine(lexer)
    self.getComment(lexer, value: "#Best")
    self.getNewLine(lexer)
    self.getIdentifier(lexer, value: "Waifu")
    self.getEOF(lexer)
  }

  // MARK: - Brackets

  /// Not valid Python code, but it does not matter for lexer:
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

    let lexer = self.createLexer(for: s)

    while let token = self.getToken(lexer), token.kind != .eof {
      XCTAssertNotEqual(token.kind, .indent, token.description)
      XCTAssertNotEqual(token.kind, .dedent, token.description)
    }
  }

  // MARK: - Mixing tabs and spaces

  /// Not valid Python code, but it does not matter for lexer:
  /// \tBeauty      | indent
  ///         Beast | equal (8 spaces)
  /// (artificial new line + dedent before EOF)
  func test_1tab_equals_8spaces() {
    let s = """
    \tBeauty
            Beast
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
      XCTAssertEqual(dedent.start, SourceLocation(line: 2, column: 13))
      XCTAssertEqual(dedent.end,   SourceLocation(line: 2, column: 13))
    }

    self.getEOF(lexer)
  }

  // MARK: - Dedent on EOF

  /// Not valid Python code, but it does not matter for lexer:
  /// Beauty  |
  ///   Beast | indent
  /// (artificial new line + dedent before EOF)
  func test_emitsMissingDedents_onEOF_1() {
    let s =
      "Beauty\n" +
      "  Beast" // no new line! just eof (we will add artificial)

    let lexer = self.createLexer(for: s)

    self.getIdentifier(lexer, value: "Beauty")
    self.getNewLine(lexer)

    if let indent = self.getToken(lexer) {
      XCTAssertEqual(indent.kind, .indent)
      XCTAssertEqual(indent.start, SourceLocation(line: 2, column: 0))
      XCTAssertEqual(indent.end,   SourceLocation(line: 2, column: 2))
    }

    self.getIdentifier(lexer, value: "Beast")
    self.getNewLine(lexer) // artificial new line

    if let dedent = self.getToken(lexer) {
      XCTAssertEqual(dedent.kind, .dedent)
      XCTAssertEqual(dedent.start, SourceLocation(line: 2, column: 7))
      XCTAssertEqual(dedent.end,   SourceLocation(line: 2, column: 7))
    }

    self.getEOF(lexer)
  }

  /// Not valid Python code, but it does not matter for lexer:
  /// Beauty     |
  ///   Beast    | indent
  ///     Castle | indent
  /// (artificial new line + 2x dedent before EOF)
  func test_emitsMissingDedents_onEOF_2() {
    let s =
      "Beauty\n" +
      "  Beast\n" +
      "    Castle" // no new line! just eof (we will add artificial)

    let lexer = self.createLexer(for: s)

    self.getIdentifier(lexer, value: "Beauty")
    self.getNewLine(lexer)

    if let indent = self.getToken(lexer) {
      XCTAssertEqual(indent.kind, .indent)
      XCTAssertEqual(indent.start, SourceLocation(line: 2, column: 0))
      XCTAssertEqual(indent.end,   SourceLocation(line: 2, column: 2))
    }

    self.getIdentifier(lexer, value: "Beast")
    self.getNewLine(lexer)

    if let indent = self.getToken(lexer) {
      XCTAssertEqual(indent.kind, .indent)
      XCTAssertEqual(indent.start, SourceLocation(line: 3, column: 0))
      XCTAssertEqual(indent.end,   SourceLocation(line: 3, column: 4))
    }

    self.getIdentifier(lexer, value: "Castle")
    self.getNewLine(lexer) // artificial new line

    if let dedent = self.getToken(lexer) {
      XCTAssertEqual(dedent.kind, .dedent)
      XCTAssertEqual(dedent.start, SourceLocation(line: 3, column: 10))
      XCTAssertEqual(dedent.end,   SourceLocation(line: 3, column: 10))
    }

    if let dedent = self.getToken(lexer) {
      XCTAssertEqual(dedent.kind, .dedent)
      XCTAssertEqual(dedent.start, SourceLocation(line: 3, column: 10))
      XCTAssertEqual(dedent.end,   SourceLocation(line: 3, column: 10))
    }

    self.getEOF(lexer)
  }
}

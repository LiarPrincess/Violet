import XCTest
import VioletCore
@testable import VioletLexer

// swiftformat:disable consecutiveSpaces

/// Use 'python3 -m tokenize -e file.py' for python reference
class IndentTests: XCTestCase {

  // MARK: - No indent

  /// py: Ariel
  func test_noIndent() {
    let s = "Ariel"
    let lexer = createLexer(for: s)

    getIdentifier(lexer, value: "Ariel")
    getEOF(lexer)
  }

  // MARK: - Empty line, comment

  /// Not valid Python code, but it does not matter for lexer:
  /// Prince
  /// (4 spaces)
  /// Charming
  func test_emptyLine_doesNotIndent() {
    let s = "Prince\n    \nCharming"
    let lexer = createLexer(for: s)

    getIdentifier(lexer, value: "Prince")
    getNewLine(lexer)
    getNewLine(lexer)
    getIdentifier(lexer, value: "Charming")
    getEOF(lexer)
  }

  /// Not valid Python code, but it does not matter for lexer:
  /// Gaston
  /// (4 spaces)# Best
  /// Waifu
  func test_lineWithOnlyComment_doesNotIndent() {
    let s = "Gaston\n    #Best\nWaifu"
    let lexer = createLexer(for: s)

    getIdentifier(lexer, value: "Gaston")
    getNewLine(lexer)
    getComment(lexer, value: "#Best")
    getNewLine(lexer)
    getIdentifier(lexer, value: "Waifu")
    getEOF(lexer)
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

    let lexer = createLexer(for: s)

    while let token = getToken(lexer), token.kind != .eof {
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

    let lexer = createLexer(for: s)

    if let indent = getToken(lexer) {
      XCTAssertEqual(indent.kind, .indent)
      XCTAssertEqual(indent.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(indent.end,   SourceLocation(line: 1, column: 1))
    }

    getIdentifier(lexer, value: "Beauty")
    getNewLine(lexer)

    // no indent
    getIdentifier(lexer, value: "Beast")
    getNewLine(lexer) // artificial new line

    if let dedent = getToken(lexer) {
      XCTAssertEqual(dedent.kind, .dedent)
      XCTAssertEqual(dedent.start, SourceLocation(line: 2, column: 13))
      XCTAssertEqual(dedent.end,   SourceLocation(line: 2, column: 13))
    }

    getEOF(lexer)
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

    let lexer = createLexer(for: s)

    getIdentifier(lexer, value: "Beauty")
    getNewLine(lexer)

    if let indent = getToken(lexer) {
      XCTAssertEqual(indent.kind, .indent)
      XCTAssertEqual(indent.start, SourceLocation(line: 2, column: 0))
      XCTAssertEqual(indent.end,   SourceLocation(line: 2, column: 2))
    }

    getIdentifier(lexer, value: "Beast")
    getNewLine(lexer) // artificial new line

    if let dedent = getToken(lexer) {
      XCTAssertEqual(dedent.kind, .dedent)
      XCTAssertEqual(dedent.start, SourceLocation(line: 2, column: 7))
      XCTAssertEqual(dedent.end,   SourceLocation(line: 2, column: 7))
    }

    getEOF(lexer)
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

    let lexer = createLexer(for: s)

    getIdentifier(lexer, value: "Beauty")
    getNewLine(lexer)

    if let indent = getToken(lexer) {
      XCTAssertEqual(indent.kind, .indent)
      XCTAssertEqual(indent.start, SourceLocation(line: 2, column: 0))
      XCTAssertEqual(indent.end,   SourceLocation(line: 2, column: 2))
    }

    getIdentifier(lexer, value: "Beast")
    getNewLine(lexer)

    if let indent = getToken(lexer) {
      XCTAssertEqual(indent.kind, .indent)
      XCTAssertEqual(indent.start, SourceLocation(line: 3, column: 0))
      XCTAssertEqual(indent.end,   SourceLocation(line: 3, column: 4))
    }

    getIdentifier(lexer, value: "Castle")
    getNewLine(lexer) // artificial new line

    if let dedent = getToken(lexer) {
      XCTAssertEqual(dedent.kind, .dedent)
      XCTAssertEqual(dedent.start, SourceLocation(line: 3, column: 10))
      XCTAssertEqual(dedent.end,   SourceLocation(line: 3, column: 10))
    }

    if let dedent = getToken(lexer) {
      XCTAssertEqual(dedent.kind, .dedent)
      XCTAssertEqual(dedent.start, SourceLocation(line: 3, column: 10))
      XCTAssertEqual(dedent.end,   SourceLocation(line: 3, column: 10))
    }

    getEOF(lexer)
  }
}

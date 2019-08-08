import XCTest
@testable import Lexer

/// Use 'python3 -m tokenize -e file.py' for python reference
class IndentTests: XCTestCase, Common {

  // MARK: - No indent

  /// py: Ariel
  func test_noIndent() {
    let s = "Ariel"
    var lexer = Lexer(for: s)

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
    var lexer = Lexer(for: s)

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
    var lexer = Lexer(for: s)

    self.getIdentifier(&lexer, value: "Gaston")
    self.getNewLine(&lexer)
    self.getComment(&lexer, value: "#Best")
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

    var lexer = Lexer(for: s)

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

    var lexer = Lexer(for: s)

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

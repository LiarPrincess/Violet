import XCTest
import VioletCore
@testable import VioletLexer

/// Use 'python3 -m tokenize -e file.py' for python reference
class OtherTests: XCTestCase, Common {

  // MARK: - EOF

  func test_eof() {
    let lexer = self.createLexer(for: "")

    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .eof)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  // MARK: - New line

  func test_newLine_CR() {
    let lexer = self.createLexer(for: "\(CR)")

    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .newLine)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }

    self.getEOF(lexer)
  }

  func test_newLine_LF() {
    let lexer = self.createLexer(for: "\(LF)")

    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .newLine)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }

    self.getEOF(lexer)
  }

  func test_newLine_CRLF() {
    let lexer = self.createLexer(for: "\(CR)\(LF)")

    if let token = self.getToken(lexer) {
      XCTAssertEqual(token.kind, .newLine)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }

    self.getEOF(lexer)
  }

  func test_newLine_LFCR() {
    let lexer = self.createLexer(for: "\(LF)\(CR)")

    if let token1 = self.getToken(lexer) {
      XCTAssertEqual(token1.kind, .newLine)
      XCTAssertEqual(token1.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token1.end,   SourceLocation(line: 1, column: 1))
    }

    if let token2 = self.getToken(lexer) {
      XCTAssertEqual(token2.kind, .newLine)
      XCTAssertEqual(token2.start, SourceLocation(line: 2, column: 0))
      XCTAssertEqual(token2.end,   SourceLocation(line: 2, column: 1))
    }

    self.getEOF(lexer)
  }

  func test_newLine_escape() {
    let lexer = self.createLexer(for: "Elsa\\\n   Anna")

    if let token1 = self.getToken(lexer) {
      XCTAssertEqual(token1.kind, .identifier("Elsa"))
      XCTAssertEqual(token1.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token1.end,   SourceLocation(line: 1, column: 4))
    }

    if let token2 = self.getToken(lexer) {
      XCTAssertEqual(token2.kind, .identifier("Anna"))
      XCTAssertEqual(token2.start, SourceLocation(line: 2, column: 3))
      XCTAssertEqual(token2.end,   SourceLocation(line: 2, column: 7))
    }

    self.getEOF(lexer)
  }

  func test_newLine_escape_withoutNewLine_throws() {
    let lexer = self.createLexer(for: "Elsa\\Anna")

    self.getIdentifier(lexer, value: "Elsa")

    if let error = self.error(lexer) {
      XCTAssertEqual(error.kind, LexerErrorKind.missingNewLineAfterBackslashEscape)
      XCTAssertEqual(error.location, SourceLocation(line: 1, column: 5))
    }
  }
}

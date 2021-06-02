import XCTest
import VioletCore
@testable import VioletLexer

// swiftformat:disable consecutiveSpaces

/// Use 'python3 -m tokenize -e file.py' for python reference
class OtherTests: XCTestCase {

  // MARK: - EOF

  func test_eof() {
    let lexer = createLexer(for: "")

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .eof)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  // MARK: - New line

  func test_newLine_CR() {
    let lexer = createLexer(for: "\(CR)")

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .newLine)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }

    getEOF(lexer)
  }

  func test_newLine_LF() {
    let lexer = createLexer(for: "\(LF)")

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .newLine)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }

    getEOF(lexer)
  }

  func test_newLine_CRLF() {
    let lexer = createLexer(for: "\(CR)\(LF)")

    if let token = getToken(lexer) {
      XCTAssertEqual(token.kind, .newLine)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }

    getEOF(lexer)
  }

  func test_newLine_LF_CR() {
    let lexer = createLexer(for: "\(LF)\(CR)")

    if let token1 = getToken(lexer) {
      XCTAssertEqual(token1.kind, .newLine)
      XCTAssertEqual(token1.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token1.end,   SourceLocation(line: 1, column: 1))
    }

    if let token2 = getToken(lexer) {
      XCTAssertEqual(token2.kind, .newLine)
      XCTAssertEqual(token2.start, SourceLocation(line: 2, column: 0))
      XCTAssertEqual(token2.end,   SourceLocation(line: 2, column: 1))
    }

    getEOF(lexer)
  }

  func test_newLine_escape() {
    let lexer = createLexer(for: "Elsa\\\n   Anna")

    if let token1 = getToken(lexer) {
      XCTAssertEqual(token1.kind, .identifier("Elsa"))
      XCTAssertEqual(token1.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token1.end,   SourceLocation(line: 1, column: 4))
    }

    if let token2 = getToken(lexer) {
      XCTAssertEqual(token2.kind, .identifier("Anna"))
      XCTAssertEqual(token2.start, SourceLocation(line: 2, column: 3))
      XCTAssertEqual(token2.end,   SourceLocation(line: 2, column: 7))
    }

    getEOF(lexer)
  }

  func test_newLine_escape_withoutNewLine_throws() {
    let lexer = createLexer(for: "Elsa\\Anna")

    getIdentifier(lexer, value: "Elsa")

    if let error = getError(lexer) {
      XCTAssertEqual(error.kind, .missingNewLineAfterBackslashEscape)
      XCTAssertEqual(error.location, SourceLocation(line: 1, column: 5))
    }
  }
}

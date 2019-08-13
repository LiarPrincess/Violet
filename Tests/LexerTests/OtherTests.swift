import XCTest
import Core
@testable import Lexer

/// Use 'python3 -m tokenize -e file.py' for python reference
class OtherTests: XCTestCase, Common {

  // MARK: - EOF

  func test_eof() {
    var lexer = Lexer(for: "")

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .eof)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  // MARK: - New line

  func test_newLine_CR() {
    var lexer = Lexer(for: "\(CR)")

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .newLine)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }

    self.getEOF(&lexer)
  }

  func test_newLine_LF() {
    var lexer = Lexer(for: "\(LF)")

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .newLine)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }

    self.getEOF(&lexer)
  }

  func test_newLine_CRLF() {
    var lexer = Lexer(for: "\(CR)\(LF)")

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .newLine)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }

    self.getEOF(&lexer)
  }

  func test_newLine_LFCR() {
    var lexer = Lexer(for: "\(LF)\(CR)")

    if let token1 = self.getToken(&lexer) {
      XCTAssertEqual(token1.kind, .newLine)
      XCTAssertEqual(token1.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token1.end,   SourceLocation(line: 1, column: 1))
    }

    if let token2 = self.getToken(&lexer) {
      XCTAssertEqual(token2.kind, .newLine)
      XCTAssertEqual(token2.start, SourceLocation(line: 2, column: 0))
      XCTAssertEqual(token2.end,   SourceLocation(line: 2, column: 1))
    }

    self.getEOF(&lexer)
  }
}

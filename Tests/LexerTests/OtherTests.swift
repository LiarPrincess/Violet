// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import Lexer

/// Use 'python3 -m tokenize -e file.py' for python reference
class OtherTests: XCTestCase, Common {

  // MARK: - EOF

  func test_eof() {
    var lexer = Lexer(string: "")

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .eof)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  // MARK: - New line

  func test_newLine_CR() {
    var lexer = Lexer(string: "\(CR)")

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .newLine)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }

    self.getEOF(&lexer)
  }

  func test_newLine_LF() {
    var lexer = Lexer(string: "\(LF)")

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .newLine)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }

    self.getEOF(&lexer)
  }

  func test_newLine_CRLF() {
    var lexer = Lexer(string: "\(CRLF)")

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .newLine)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }

    self.getEOF(&lexer)
  }
}

// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import Lexer

/// Use 'python3 -m tokenize -e file.py' for python reference
class OtherTests: XCTestCase, Common {

  // MARK: - New line

  func test_newline_unix_isLexed() {
    var lexer = Lexer(string: "\n")

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .newLine)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_newline_windows_isLexed() {
    var lexer = Lexer(string: "\n\r")

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .newLine)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }

  func test_newline_oldMac_isLexed() {
    var lexer = Lexer(string: "\r")

    if let token = self.getToken(&lexer) {
      XCTAssertEqual(token.kind, .newLine)
      XCTAssertEqual(token.start, SourceLocation(line: 1, column: 0))
      XCTAssertEqual(token.end,   SourceLocation(line: 1, column: 1))
    }
  }
}

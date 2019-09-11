import XCTest
import Core
import Lexer
@testable import Parser

class ParsePass: XCTestCase, Common, StatementMatcher {

  /// pass
  func test_pass() {
    var parser = self.createStmtParser(
      self.token(.pass, start: loc0, end: loc1)
    )

    if let stmt = self.parseStmt(&parser) {
      XCTAssertEqual(stmt.kind, .pass)
      XCTAssertStatement(stmt, "(pass)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc1)
    }
  }
}

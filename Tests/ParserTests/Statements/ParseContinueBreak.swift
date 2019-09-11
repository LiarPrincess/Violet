import XCTest
import Core
import Lexer
@testable import Parser

class ParseContinueBreak: XCTestCase, Common, StatementMatcher {

  /// break
  func test_break() {
    var parser = self.createStmtParser(
      self.token(.break, start: loc0, end: loc1)
    )

    if let stmt = self.parseStmt(&parser) {
      XCTAssertEqual(stmt.kind, .break)
      XCTAssertStatement(stmt, "(break)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc1)
    }
  }

  /// continue
  func test_continue() {
    var parser = self.createStmtParser(
      self.token(.continue, start: loc0, end: loc1)
    )

    if let stmt = self.parseStmt(&parser) {
      XCTAssertEqual(stmt.kind, .continue)
      XCTAssertStatement(stmt, "(continue)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc1)
    }
  }
}

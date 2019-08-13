import XCTest
import Core
import Lexer
@testable import Parser

// Use this for reference:
// https://www.youtube.com/watch?v=TVcLIfSC4OE

class TryStatementTests: XCTestCase,
  Common,
  DestructStatementKind,
  DestructExpressionKind,
  DestructStringGroup {

  /*
  /// while a: "Since the morning that we came"
  func test_while() {
    let s = "Since the morning that we came"

    var parser = self.createStmtParser(
      self.token(.while,           start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.string(s),       start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructWhile(stmt) else { return }

      XCTAssertExpression(d.test, "a")
      XCTAssertEqual(d.orElse, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Since the ...\"")

      XCTAssertStatement(stmt, "(while a \"Since the ...\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }
*/
}

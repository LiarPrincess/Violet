import XCTest
import Core
import Lexer
@testable import Parser

class ParseExpressionStatement: XCTestCase,
  Common, ExpressionMatcher, StatementMatcher, StringMatcher {

  /// "Ariel+Eric"
  func test_expression() {
    var parser = self.createStmtParser(
      self.token(.string("Ariel+Eric"), start: loc0, end: loc1)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let expr = self.matchExpr(stmt) else { return }
      guard let group = self.matchString(expr) else { return }
      guard let string = self.matchStringLiteral(group) else { return }

      XCTAssertEqual(string, "Ariel+Eric")

      XCTAssertStatement(stmt, "'Ariel+Eric'")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc1)
    }
  }
}

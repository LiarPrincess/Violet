import XCTest
import Core
import Lexer
@testable import Parser

class ParseAssert: XCTestCase, Common, StatementMatcher {

  /// assert Aladdin
  func test_simple() {
    var parser = self.createStmtParser(
      self.token(.assert,                start: loc0, end: loc1),
      self.token(.identifier("Aladdin"), start: loc2, end: loc3)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchAssert(stmt) else { return }

      XCTAssertExpression(d.test, "Aladdin")
      XCTAssertNil(d.msg)

      XCTAssertStatement(stmt, "(assert Aladdin)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc3)
    }
  }

  /// assert Aladdin, Jasmine
  func test_withMessage() {
    var parser = self.createStmtParser(
      self.token(.assert,                start: loc0, end: loc1),
      self.token(.identifier("Aladdin"), start: loc2, end: loc3),
      self.token(.comma,                 start: loc4, end: loc5),
      self.token(.identifier("Jasmine"), start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchAssert(stmt) else { return }

      XCTAssertExpression(d.test, "Aladdin")
      XCTAssertExpression(d.msg,  "Jasmine")

      XCTAssertStatement(stmt, "(assert Aladdin msg: Jasmine)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }
}

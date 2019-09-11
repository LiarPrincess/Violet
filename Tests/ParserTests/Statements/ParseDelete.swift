import XCTest
import Core
import Lexer
@testable import Parser

class ParseDelete: XCTestCase, Common, StatementMatcher {

  /// del Jafar
  func test_simple() {
    var parser = self.createStmtParser(
      self.token(.del,                 start: loc0, end: loc1),
      self.token(.identifier("Jafar"), start: loc2, end: loc3)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchDelete(stmt) else { return }

      XCTAssertEqual(d.count, 1)
      guard d.count == 1 else { return }

      XCTAssertExpression(d[0], "Jafar")

      XCTAssertStatement(stmt, "(del Jafar)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc3)
    }
  }

  // del Jafar,
  func test_withCommaAfter() {
    var parser = self.createStmtParser(
      self.token(.del,             start: loc0, end: loc1),
      self.token(.identifier("Jafar"), start: loc2, end: loc3),
      self.token(.comma,           start: loc4, end: loc5)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchDelete(stmt) else { return }

      XCTAssertEqual(d.count, 1)
      guard d.count == 1 else { return }

      XCTAssertExpression(d[0], "Jafar")

      XCTAssertStatement(stmt, "(del Jafar)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc5)
    }
  }

  // del Jafar, Iago, Lamp
  func test_multiple() {
    var parser = self.createStmtParser(
      self.token(.del,                 start: loc0, end: loc1),
      self.token(.identifier("Jafar"), start: loc2, end: loc3),
      self.token(.comma,               start: loc4, end: loc5),
      self.token(.identifier("Iago"),  start: loc6, end: loc7),
      self.token(.comma,               start: loc8, end: loc9),
      self.token(.identifier("Lamp"),  start: loc10, end: loc11)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchDelete(stmt) else { return }

      XCTAssertEqual(d.count, 3)
      guard d.count == 3 else { return }

      XCTAssertExpression(d[0], "Jafar")
      XCTAssertExpression(d[1], "Iago")
      XCTAssertExpression(d[2], "Lamp")

      XCTAssertStatement(stmt, "(del Jafar Iago Lamp)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc11)
    }
  }
}

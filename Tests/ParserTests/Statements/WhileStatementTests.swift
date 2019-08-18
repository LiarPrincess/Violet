import XCTest
import Core
import Lexer
@testable import Parser

class WhileStatementTests: XCTestCase,
  Common, DestructStatementKind, DestructExpressionKind {

  /// while Frollo: "Quasimodo"
  func test_while() {
    var parser = self.createStmtParser(
      self.token(.while,                start: loc0, end: loc1),
      self.token(.identifier("Frollo"), start: loc2, end: loc3),
      self.token(.colon,                start: loc4, end: loc5),
      self.token(.string("Quasimodo"),  start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructWhile(stmt) else { return }

      XCTAssertExpression(d.test, "Frollo")
      XCTAssertEqual(d.orElse, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "'Quasimodo'")

      XCTAssertStatement(stmt, "(while Frollo do: 'Quasimodo')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  /// while Frollo: "Quasimodo"
  /// else: "Esmeralda"
  func test_while_withElse() {
    var parser = self.createStmtParser(
      self.token(.while,                start: loc0, end: loc1),
      self.token(.identifier("Frollo"), start: loc2, end: loc3),
      self.token(.colon,                start: loc4, end: loc5),
      self.token(.string("Quasimodo"),  start: loc6, end: loc7),
      self.token(.newLine,              start: loc8, end: loc9),
      self.token(.else,                 start: loc10, end: loc11),
      self.token(.colon,                start: loc12, end: loc13),
      self.token(.string("Esmeralda"),  start: loc14, end: loc15)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructWhile(stmt) else { return }

      XCTAssertExpression(d.test, "Frollo")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "'Quasimodo'")

      XCTAssertEqual(d.orElse.count, 1)
      guard d.orElse.count == 1 else { return }
      XCTAssertStatement(d.orElse[0], "'Esmeralda'")

      XCTAssertStatement(stmt, "(while Frollo do: 'Quasimodo' else: 'Esmeralda')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc15)
    }
  }
}

import XCTest
import Core
import Lexer
@testable import Parser

class ParseReturn: XCTestCase, Common, StatementMatcher {

  /// return
  func test_withoutValue() {
    var parser = self.createStmtParser(
      self.token(.return, start: loc0, end: loc1)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchReturn(stmt) else { return }

      XCTAssertEqual(d, nil)

      XCTAssertStatement(stmt, "return")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc1)
    }
  }

  /// return Megara
  func test_value() {
    var parser = self.createStmtParser(
      self.token(.return,               start: loc0, end: loc1),
      self.token(.identifier("Megara"), start: loc2, end: loc3)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchReturn(stmt) else { return }

      XCTAssertNotNil(d)
      XCTAssertExpression(d, "Megara")

      XCTAssertStatement(stmt, "(return Megara)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc3)
    }
  }

  /// return Megara,
  func test_withCommaAfter_returnsTuple() {
    var parser = self.createStmtParser(
      self.token(.return,               start: loc0, end: loc1),
      self.token(.identifier("Megara"), start: loc2, end: loc3),
      self.token(.comma,                start: loc4, end: loc5)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchReturn(stmt) else { return }

      XCTAssertNotNil(d)
      XCTAssertExpression(d, "(Megara)")

      XCTAssertStatement(stmt, "(return (Megara))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc5)
    }
  }

  /// return Calliope, Melpomene, Terpsichore
  /// Those are the names of the muses (Thalia and Clio are missing)
  func test_multiple() {
    var parser = self.createStmtParser(
      self.token(.return,                    start: loc0, end: loc1),
      self.token(.identifier("Calliope"),    start: loc2, end: loc3),
      self.token(.comma,                     start: loc4, end: loc5),
      self.token(.identifier("Melpomene"),   start: loc6, end: loc7),
      self.token(.comma,                     start: loc8, end: loc9),
      self.token(.identifier("Terpsichore"), start: loc10, end: loc11)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchReturn(stmt) else { return }

      XCTAssertNotNil(d)
      XCTAssertExpression(d, "(Calliope Melpomene Terpsichore)")

      XCTAssertStatement(stmt, "(return (Calliope Melpomene Terpsichore))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc11)
    }
  }
}

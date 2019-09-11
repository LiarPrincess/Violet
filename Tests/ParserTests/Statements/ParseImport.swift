import XCTest
import Core
import Lexer
@testable import Parser

class ParseImport: XCTestCase, Common, StatementMatcher {

  /// import Rapunzel
  func test_simple() {
    var parser = self.createStmtParser(
      self.token(.import,                 start: loc0, end: loc1),
      self.token(.identifier("Rapunzel"), start: loc2, end: loc3)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchImport(stmt) else { return }

      XCTAssertEqual(d.count, 1)
      guard d.count == 1 else { return }

      XCTAssertEqual(d[0].name, "Rapunzel")
      XCTAssertNil(d[0].asName)

      XCTAssertStatement(stmt, "(import Rapunzel)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc3)
    }
  }

  /// import Tangled.Rapunzel
  func test_nested() {
    var parser = self.createStmtParser(
      self.token(.import,                 start: loc0, end: loc1),
      self.token(.identifier("Tangled"),  start: loc2, end: loc3),
      self.token(.dot,                    start: loc4, end: loc5),
      self.token(.identifier("Rapunzel"), start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchImport(stmt) else { return }

      XCTAssertEqual(d.count, 1)
      guard d.count == 1 else { return }

      XCTAssertEqual(d[0].name, "Tangled.Rapunzel")
      XCTAssertNil(d[0].asName)

      XCTAssertStatement(stmt, "(import Tangled.Rapunzel)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  /// import Rapunzel as Daughter
  func test_withAlias() {
    var parser = self.createStmtParser(
      self.token(.import,                 start: loc0, end: loc1),
      self.token(.identifier("Rapunzel"), start: loc2, end: loc3),
      self.token(.as,                     start: loc4, end: loc5),
      self.token(.identifier("Daughter"), start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchImport(stmt) else { return }

      XCTAssertEqual(d.count, 1)
      guard d.count == 1 else { return }

      XCTAssertEqual(d[0].name, "Rapunzel")
      XCTAssertEqual(d[0].asName, "Daughter")

      XCTAssertStatement(stmt, "(import (Rapunzel as: Daughter))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  /// import Rapunzel as Daughter, Pascal
  func test_multiple() {
    var parser = self.createStmtParser(
      self.token(.import,                 start: loc0, end: loc1),
      self.token(.identifier("Rapunzel"), start: loc2, end: loc3),
      self.token(.as,                     start: loc4, end: loc5),
      self.token(.identifier("Daughter"), start: loc6, end: loc7),
      self.token(.comma,                  start: loc8, end: loc9),
      self.token(.identifier("Pascal"),   start: loc10, end: loc11)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchImport(stmt) else { return }

      XCTAssertEqual(d.count, 2)
      guard d.count == 2 else { return }

      XCTAssertEqual(d[0].name, "Rapunzel")
      XCTAssertEqual(d[0].asName, "Daughter")

      XCTAssertEqual(d[1].name, "Pascal")
      XCTAssertNil(d[1].asName)

      XCTAssertStatement(stmt, "(import (Rapunzel as: Daughter) Pascal)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc11)
    }
  }
}

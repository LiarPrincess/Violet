import XCTest
import Core
import Lexer
@testable import Parser

class SmallStatementTests: XCTestCase, Common, StatementMatcher {

  // MARK: - del

  /// del Jafar
  func test_del() {
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
  func test_del_withCommaAfter() {
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
  func test_del_multiple() {
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

  // MARK: - pass

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

  // MARK: - global

  /// global Aladdin
  func test_global() {
    var parser = self.createStmtParser(
      self.token(.global,                start: loc0, end: loc1),
      self.token(.identifier("Aladdin"), start: loc2, end: loc3)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchGlobal(stmt) else { return }

      XCTAssertEqual(d, ["Aladdin"])

      XCTAssertStatement(stmt, "(global Aladdin)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc3)
    }
  }

  /// global Aladdin, Jasmine
  func test_global_multiple() {
    var parser = self.createStmtParser(
      self.token(.global,                start: loc0, end: loc1),
      self.token(.identifier("Aladdin"), start: loc2, end: loc3),
      self.token(.comma,                 start: loc4, end: loc5),
      self.token(.identifier("Jasmine"), start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchGlobal(stmt) else { return }

      XCTAssertEqual(d, ["Aladdin", "Jasmine"])

      XCTAssertStatement(stmt, "(global Aladdin Jasmine)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  // MARK: - nonlocal

  /// nonlocal Genie
  func test_nonlocal() {
    var parser = self.createStmtParser(
      self.token(.nonlocal,            start: loc0, end: loc1),
      self.token(.identifier("Genie"), start: loc2, end: loc3)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchNonlocal(stmt) else { return }

      XCTAssertEqual(d, ["Genie"])

      XCTAssertStatement(stmt, "(nonlocal Genie)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc3)
    }
  }

  /// nonlocal Genie, MagicCarpet
  func test_nonlocal_multiple() {
    var parser = self.createStmtParser(
      self.token(.nonlocal,                  start: loc0, end: loc1),
      self.token(.identifier("Genie"),       start: loc2, end: loc3),
      self.token(.comma,                     start: loc4, end: loc5),
      self.token(.identifier("MagicCarpet"), start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchNonlocal(stmt) else { return }

      XCTAssertEqual(d, ["Genie", "MagicCarpet"])

      XCTAssertStatement(stmt, "(nonlocal Genie MagicCarpet)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  // MARK: - assert

  /// assert Aladdin
  func test_assert() {
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
  func test_assert_withMessage() {
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

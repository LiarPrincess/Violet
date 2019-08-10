import XCTest
import Core
import Lexer
@testable import Parser

class SmallStatementTests: XCTestCase, Common, DestructStatementKind {

  // MARK: - del

  /// del a
  func test_del() {
    var parser = self.createStmtParser(
      self.token(.del,             start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructDelete(stmt) else { return }

      XCTAssertEqual(d.count, 1)
      guard d.count == 1 else { return }

      XCTAssertExpression(d[0], "a")

      XCTAssertStatement(stmt, "(del a)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc3)
    }
  }

  // del a,
  func test_del_withCommaAfter() {
    var parser = self.createStmtParser(
      self.token(.del,             start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.comma,           start: loc4, end: loc5)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructDelete(stmt) else { return }

      XCTAssertEqual(d.count, 1)
      guard d.count == 1 else { return }

      XCTAssertExpression(d[0], "a")

      XCTAssertStatement(stmt, "(del a)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc5)
    }
  }

  // del a,b,c
  func test_del_multiple() {
    var parser = self.createStmtParser(
      self.token(.del,             start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.comma,           start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7),
      self.token(.comma,           start: loc8, end: loc9),
      self.token(.identifier("c"), start: loc10, end: loc11)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructDelete(stmt) else { return }

      XCTAssertEqual(d.count, 3)
      guard d.count == 3 else { return }

      XCTAssertExpression(d[0], "a")
      XCTAssertExpression(d[1], "b")
      XCTAssertExpression(d[2], "c")

      XCTAssertStatement(stmt, "(del a b c)")
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

  /// global a
  func test_global() {
    var parser = self.createStmtParser(
      self.token(.global,          start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructGlobal(stmt) else { return }

      XCTAssertEqual(d, ["a"])

      XCTAssertStatement(stmt, "(global a)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc3)
    }
  }

  /// global a, b
  func test_global_multiple() {
    var parser = self.createStmtParser(
      self.token(.global,          start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.comma,           start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructGlobal(stmt) else { return }

      XCTAssertEqual(d, ["a", "b"])

      XCTAssertStatement(stmt, "(global a b)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  // MARK: - nonlocal

  /// nonlocal a
  func test_nonlocal() {
    var parser = self.createStmtParser(
      self.token(.nonlocal,        start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructNonlocal(stmt) else { return }

      XCTAssertEqual(d, ["a"])

      XCTAssertStatement(stmt, "(nonlocal a)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc3)
    }
  }

  /// nonlocal a, b
  func test_nonlocal_multiple() {
    var parser = self.createStmtParser(
      self.token(.nonlocal,        start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.comma,           start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructNonlocal(stmt) else { return }

      XCTAssertEqual(d, ["a", "b"])

      XCTAssertStatement(stmt, "(nonlocal a b)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  // MARK: - assert

  /// assert a
  func test_assert() {
    var parser = self.createStmtParser(
      self.token(.assert,          start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAssert(stmt) else { return }

      XCTAssertExpression(d.test, "a")
      XCTAssertNil(d.msg)

      XCTAssertStatement(stmt, "(assert a)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc3)
    }
  }

  /// assert a, b
  func test_assert_withMessage() {
    var parser = self.createStmtParser(
      self.token(.assert,        start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.comma,           start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAssert(stmt) else { return }

      XCTAssertExpression(d.test, "a")
      XCTAssertExpression(d.msg,  "b")

      XCTAssertStatement(stmt, "(assert a msg: b)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }
}

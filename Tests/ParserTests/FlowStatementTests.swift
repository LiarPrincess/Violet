import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length

class FlowStatementTests: XCTestCase, Common, DestructStatementKind {

  // MARK: - Break

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

  // MARK: - Continue

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

  // MARK: - Return

  /// return
  func test_return() {
    var parser = self.createStmtParser(
      self.token(.return, start: loc0, end: loc1)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructReturn(stmt) else { return }

      XCTAssertEqual(d, nil)

      XCTAssertStatement(stmt, "(return)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc1)
    }
  }

  /// return a
  func test_return_withValue() {
    var parser = self.createStmtParser(
      self.token(.return,          start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructReturn(stmt) else { return }

      XCTAssertNotNil(d)
      XCTAssertExpression(d, "a")

      XCTAssertStatement(stmt, "(return a)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc3)
    }
  }

  // return a,
  func test_return_withCommaAfter_returnsTuple() {
    var parser = self.createStmtParser(
      self.token(.return,          start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.comma,           start: loc4, end: loc5)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructReturn(stmt) else { return }

      XCTAssertNotNil(d)
      XCTAssertExpression(d, "(a)")

      XCTAssertStatement(stmt, "(return (a))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc5)
    }
  }

  // return a,b,c
  func test_return_multiple() {
    var parser = self.createStmtParser(
      self.token(.return,          start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.comma,           start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7),
      self.token(.comma,           start: loc8, end: loc9),
      self.token(.identifier("c"), start: loc10, end: loc11)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructReturn(stmt) else { return }

      XCTAssertNotNil(d)
      XCTAssertExpression(d, "(a b c)")

      XCTAssertStatement(stmt, "(return (a b c))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc11)
    }
  }

  // MARK: - Raise

  /// raise
  func test_raise() {
    var parser = self.createStmtParser(
      self.token(.raise, start: loc0, end: loc1)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructRaise(stmt) else { return }

      XCTAssertNil(d.exc)
      XCTAssertNil(d.cause)

      XCTAssertStatement(stmt, "(raise)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc1)
    }
  }

  /// raise e
  func test_raise_exception() {
    var parser = self.createStmtParser(
      self.token(.raise,           start: loc0, end: loc1),
      self.token(.identifier("e"), start: loc2, end: loc3)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructRaise(stmt) else { return }

      XCTAssertExpression(d.exc, "e")
      XCTAssertNil(d.cause)

      XCTAssertStatement(stmt, "(raise e)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc3)
    }
  }

  /// raise e from f
  func test_raise_from() {
    var parser = self.createStmtParser(
      self.token(.raise,           start: loc0, end: loc1),
      self.token(.identifier("e"), start: loc2, end: loc3),
      self.token(.from,            start: loc4, end: loc5),
      self.token(.identifier("f"), start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructRaise(stmt) else { return }

      XCTAssertExpression(d.exc, "e")
      XCTAssertExpression(d.cause, "f")

      XCTAssertStatement(stmt, "(raise e from: f)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  // MARK: - Yield

  /// yield
  func test_yield() {
    var parser = self.createStmtParser(
      self.token(.yield, start: loc0, end: loc1)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructExpr(stmt) else { return }

      XCTAssertExpression(d, "(yield)")

      XCTAssertStatement(stmt, "(yield)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc1)
    }
  }

  /// yield a
  func test_yield_value() {
    var parser = self.createStmtParser(
      self.token(.yield,           start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructExpr(stmt) else { return }

      XCTAssertExpression(d, "(yield a)")

      XCTAssertStatement(stmt, "(yield a)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc3)
    }
  }

  /// yield a,
  func test_yield_value_withCommaAfter_yieldsTuple() {
    var parser = self.createStmtParser(
      self.token(.yield,           start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.comma,           start: loc4, end: loc5)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructExpr(stmt) else { return }

      XCTAssertExpression(d, "(yield (a))")

      XCTAssertStatement(stmt, "(yield (a))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc5)
    }
  }

  /// yield a,b
  func test_yield_multiple() {
    var parser = self.createStmtParser(
      self.token(.yield,           start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.comma,           start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructExpr(stmt) else { return }

      XCTAssertExpression(d, "(yield (a b))")

      XCTAssertStatement(stmt, "(yield (a b))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  /// yield from a
  func test_yield_from() {
    var parser = self.createStmtParser(
      self.token(.yield,           start: loc0, end: loc1),
      self.token(.from,            start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructExpr(stmt) else { return }

      XCTAssertExpression(d, "(yieldFrom a)")

      XCTAssertStatement(stmt, "(yieldFrom a)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc5)
    }
  }
}

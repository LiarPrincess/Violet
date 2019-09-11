import XCTest
import Core
import Lexer
@testable import Parser

class ParseYield: XCTestCase, Common, StatementMatcher {

  // MARK: - Yield

  /// yield
  func test_yield() {
    var parser = self.createStmtParser(
      self.token(.yield, start: loc0, end: loc1)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchExpr(stmt) else { return }

      XCTAssertExpression(d, "(yield)")

      XCTAssertStatement(stmt, "(yield)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc1)
    }
  }

  /// yield Megara
  func test_yield_value() {
    var parser = self.createStmtParser(
      self.token(.yield,                start: loc0, end: loc1),
      self.token(.identifier("Megara"), start: loc2, end: loc3)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchExpr(stmt) else { return }

      XCTAssertExpression(d, "(yield Megara)")

      XCTAssertStatement(stmt, "(yield Megara)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc3)
    }
  }

  /// yield Megara,
  func test_yield_value_withCommaAfter_yieldsTuple() {
    var parser = self.createStmtParser(
      self.token(.yield,                start: loc0, end: loc1),
      self.token(.identifier("Megara"), start: loc2, end: loc3),
      self.token(.comma,                start: loc4, end: loc5)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchExpr(stmt) else { return }

      XCTAssertExpression(d, "(yield (Megara))")

      XCTAssertStatement(stmt, "(yield (Megara))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc5)
    }
  }

  /// yield Pain, Panic
  func test_yield_multiple() {
    var parser = self.createStmtParser(
      self.token(.yield,           start: loc0, end: loc1),
      self.token(.identifier("Pain"), start: loc2, end: loc3),
      self.token(.comma,           start: loc4, end: loc5),
      self.token(.identifier("Panic"), start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchExpr(stmt) else { return }

      XCTAssertExpression(d, "(yield (Pain Panic))")

      XCTAssertStatement(stmt, "(yield (Pain Panic))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  /// yield from Olympus
  func test_yield_from() {
    var parser = self.createStmtParser(
      self.token(.yield,                 start: loc0, end: loc1),
      self.token(.from,                  start: loc2, end: loc3),
      self.token(.identifier("Olympus"), start: loc4, end: loc5)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchExpr(stmt) else { return }

      XCTAssertExpression(d, "(yieldFrom Olympus)")

      XCTAssertStatement(stmt, "(yieldFrom Olympus)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc5)
    }
  }
}

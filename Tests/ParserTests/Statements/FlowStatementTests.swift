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

  /// return Megara
  func test_return_withValue() {
    var parser = self.createStmtParser(
      self.token(.return,               start: loc0, end: loc1),
      self.token(.identifier("Megara"), start: loc2, end: loc3)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructReturn(stmt) else { return }

      XCTAssertNotNil(d)
      XCTAssertExpression(d, "Megara")

      XCTAssertStatement(stmt, "(return Megara)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc3)
    }
  }

  /// return Megara,
  func test_return_withCommaAfter_returnsTuple() {
    var parser = self.createStmtParser(
      self.token(.return,               start: loc0, end: loc1),
      self.token(.identifier("Megara"), start: loc2, end: loc3),
      self.token(.comma,                start: loc4, end: loc5)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructReturn(stmt) else { return }

      XCTAssertNotNil(d)
      XCTAssertExpression(d, "(Megara)")

      XCTAssertStatement(stmt, "(return (Megara))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc5)
    }
  }

  /// return Calliope, Melpomene, Terpsichore
  /// Those are the names of the muses (Thalia and Clio are missing)
  func test_return_multiple() {
    var parser = self.createStmtParser(
      self.token(.return,                    start: loc0, end: loc1),
      self.token(.identifier("Calliope"),    start: loc2, end: loc3),
      self.token(.comma,                     start: loc4, end: loc5),
      self.token(.identifier("Melpomene"),   start: loc6, end: loc7),
      self.token(.comma,                     start: loc8, end: loc9),
      self.token(.identifier("Terpsichore"), start: loc10, end: loc11)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructReturn(stmt) else { return }

      XCTAssertNotNil(d)
      XCTAssertExpression(d, "(Calliope Melpomene Terpsichore)")

      XCTAssertStatement(stmt, "(return (Calliope Melpomene Terpsichore))")
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

  /// raise Hades
  func test_raise_exception() {
    var parser = self.createStmtParser(
      self.token(.raise,               start: loc0, end: loc1),
      self.token(.identifier("Hades"), start: loc2, end: loc3)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructRaise(stmt) else { return }

      XCTAssertExpression(d.exc, "Hades")
      XCTAssertNil(d.cause)

      XCTAssertStatement(stmt, "(raise Hades)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc3)
    }
  }

  /// raise Hercules from Olympus
  func test_raise_from() {
    var parser = self.createStmtParser(
      self.token(.raise,                start: loc0, end: loc1),
      self.token(.identifier("Hercules"), start: loc2, end: loc3),
      self.token(.from,                 start: loc4, end: loc5),
      self.token(.identifier("Olympus"),   start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructRaise(stmt) else { return }

      XCTAssertExpression(d.exc, "Hercules")
      XCTAssertExpression(d.cause, "Olympus")

      XCTAssertStatement(stmt, "(raise Hercules from: Olympus)")
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

  /// yield Megara
  func test_yield_value() {
    var parser = self.createStmtParser(
      self.token(.yield,                start: loc0, end: loc1),
      self.token(.identifier("Megara"), start: loc2, end: loc3)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructExpr(stmt) else { return }

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
      guard let d = self.destructExpr(stmt) else { return }

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
      guard let d = self.destructExpr(stmt) else { return }

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
      guard let d = self.destructExpr(stmt) else { return }

      XCTAssertExpression(d, "(yieldFrom Olympus)")

      XCTAssertStatement(stmt, "(yieldFrom Olympus)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc5)
    }
  }
}

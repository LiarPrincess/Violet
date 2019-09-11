import XCTest
import Core
import Lexer
@testable import Parser

class ParseRaise: XCTestCase, Common, StatementMatcher {

  /// raise
  func test_reRaise() {
    var parser = self.createStmtParser(
      self.token(.raise, start: loc0, end: loc1)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchRaise(stmt) else { return }

      XCTAssertNil(d.exception)
      XCTAssertNil(d.cause)

      XCTAssertStatement(stmt, "(raise)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc1)
    }
  }

  /// raise Hades
  func test_exception() {
    var parser = self.createStmtParser(
      self.token(.raise,               start: loc0, end: loc1),
      self.token(.identifier("Hades"), start: loc2, end: loc3)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchRaise(stmt) else { return }

      XCTAssertExpression(d.exception, "Hades")
      XCTAssertNil(d.cause)

      XCTAssertStatement(stmt, "(raise Hades)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc3)
    }
  }

  /// raise Hercules from Olympus
  func test_exception_from() {
    var parser = self.createStmtParser(
      self.token(.raise,                start: loc0, end: loc1),
      self.token(.identifier("Hercules"), start: loc2, end: loc3),
      self.token(.from,                 start: loc4, end: loc5),
      self.token(.identifier("Olympus"),   start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchRaise(stmt) else { return }

      XCTAssertExpression(d.exception, "Hercules")
      XCTAssertExpression(d.cause, "Olympus")

      XCTAssertStatement(stmt, "(raise Hercules from: Olympus)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }
}

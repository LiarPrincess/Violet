import XCTest
import Core
import Lexer
@testable import Parser

class ParseAssign: XCTestCase,
Common, ExpressionMatcher, StatementMatcher, StringMatcher {

  // MARK: - Normal assignment

  /// Ariel = "Princess"
  func test_simple() {
    var parser = self.createStmtParser(
      self.token(.identifier("Ariel"), start: loc0, end: loc1),
      self.token(.equal,               start: loc2, end: loc3),
      self.token(.string("Princess"),  start: loc4, end: loc5)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchAssign(stmt) else { return }

      XCTAssertEqual(d.targets.count, 1)
      guard d.targets.count == 1 else { return }

      XCTAssertExpression(d.targets[0], "Ariel")
      XCTAssertExpression(d.value, "'Princess'")

      XCTAssertStatement(stmt, "(Ariel = 'Princess')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc5)
    }
  }

  /// Ariel, Eric = "couple"
  func test_toTuple() {
    var parser = self.createStmtParser(
      self.token(.identifier("Ariel"), start: loc0, end: loc1),
      self.token(.comma,               start: loc2, end: loc3),
      self.token(.identifier("Eric"),  start: loc4, end: loc5),
      self.token(.equal,               start: loc6, end: loc7),
      self.token(.string("couple"),    start: loc8, end: loc9)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchAssign(stmt) else { return }

      XCTAssertEqual(d.targets.count, 1)
      guard d.targets.count == 1 else { return }

      XCTAssertExpression(d.targets[0], "(Ariel Eric)")
      XCTAssertExpression(d.value, "'couple'")

      XCTAssertStatement(stmt, "((Ariel Eric) = 'couple')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc9)
    }
  }

  /// Ariel, = "Princess"
  func test_withComma_isTuple() {
    var parser = self.createStmtParser(
      self.token(.identifier("Ariel"), start: loc0, end: loc1),
      self.token(.comma,               start: loc2, end: loc3),
      self.token(.equal,               start: loc4, end: loc5),
      self.token(.string("Princess"),  start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchAssign(stmt) else { return }

      XCTAssertEqual(d.targets.count, 1)
      guard d.targets.count == 1 else { return }

      XCTAssertExpression(d.targets[0], "(Ariel)")
      XCTAssertExpression(d.value, "'Princess'")

      XCTAssertStatement(stmt, "((Ariel) = 'Princess')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  /// Sebastian = Flounder = "Friend"
  func test_multiple() {
    var parser = self.createStmtParser(
      self.token(.identifier("Sebastian"), start: loc0, end: loc1),
      self.token(.equal,                   start: loc2, end: loc3),
      self.token(.identifier("Flounder"),  start: loc4, end: loc5),
      self.token(.equal,                   start: loc6, end: loc7),
      self.token(.string("Friend"),        start: loc8, end: loc9)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchAssign(stmt) else { return }

      XCTAssertEqual(d.targets.count, 2)
      guard d.targets.count == 2 else { return }

      XCTAssertExpression(d.targets[0], "Sebastian")
      XCTAssertExpression(d.targets[1], "Flounder")
      XCTAssertExpression(d.value, "'Friend'")

      XCTAssertStatement(stmt, "(Sebastian = Flounder = 'Friend')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc9)
    }
  }

  /// Ariel = yield "Princess"
  func test_yieldValue() {
    var parser = self.createStmtParser(
      self.token(.identifier("Ariel"), start: loc0, end: loc1),
      self.token(.equal,               start: loc2, end: loc3),
      self.token(.yield,               start: loc4, end: loc5),
      self.token(.string("Princess"),  start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchAssign(stmt) else { return }

      XCTAssertEqual(d.targets.count, 1)
      guard d.targets.count == 1 else { return }

      XCTAssertExpression(d.targets[0], "Ariel")
      XCTAssertExpression(d.value, "(yield 'Princess')")

      XCTAssertStatement(stmt, "(Ariel = (yield 'Princess'))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  /// Ariel = yield Eric = "couple"
  /// If we used 'yield a = xxx' then it is 'yield stmt' by grammar
  func test_yieldTarget() {
    var parser = self.createStmtParser(
      self.token(.identifier("Ariel"), start: loc0, end: loc1),
      self.token(.equal,               start: loc2, end: loc3),
      self.token(.yield,               start: loc4, end: loc5),
      self.token(.identifier("Eric"),  start: loc6, end: loc7),
      self.token(.equal,               start: loc8, end: loc9),
      self.token(.string("couple"),    start: loc10, end: loc11)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .assignmentToYield)
      XCTAssertEqual(error.location, loc4)
    }
  }
}

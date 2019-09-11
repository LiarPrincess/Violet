import XCTest
import Core
import Lexer
@testable import Parser

class ParseFor: XCTestCase, Common, StatementMatcher, ExpressionMatcher {

  /// for person in castle: "becomeItem"
  func test_simple() {
    var parser = self.createStmtParser(
      self.token(.for,                   start: loc0, end: loc1),
      self.token(.identifier("person"),  start: loc2, end: loc3),
      self.token(.in,                    start: loc4, end: loc5),
      self.token(.identifier("castle"),  start: loc6, end: loc7),
      self.token(.colon,                 start: loc8, end: loc9),
      self.token(.string("becomeItem"),  start: loc10, end: loc11)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchFor(stmt) else { return }

      XCTAssertExpression(d.target, "person")
      XCTAssertExpression(d.iter, "castle")
      XCTAssertEqual(d.orElse, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "'becomeItem'")

      XCTAssertStatement(stmt, "(for person in: castle do: 'becomeItem')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc11)
    }
  }

  /// for Gaston, in village: "evil"
  func test_withCommaAfterTarget_isTuple() {
    var parser = self.createStmtParser(
      self.token(.for,                   start: loc0, end: loc1),
      self.token(.identifier("Gaston"),  start: loc2, end: loc3),
      self.token(.comma,                 start: loc4, end: loc5),
      self.token(.in,                    start: loc6, end: loc7),
      self.token(.identifier("village"), start: loc8, end: loc9),
      self.token(.colon,                 start: loc10, end: loc11),
      self.token(.string("evil"),        start: loc12, end: loc13)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchFor(stmt) else { return }

      XCTAssertExpression(d.target, "(Gaston)")
      XCTAssertExpression(d.iter, "village")
      XCTAssertEqual(d.orElse, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "'evil'")

      XCTAssertStatement(stmt, "(for (Gaston) in: village do: 'evil')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc13)
    }
  }

  /// for Gaston, LeFou in village: "evil"
  /// LeFou is Gaston sidekick
  func test_withCommaTargetTuple() {
    var parser = self.createStmtParser(
      self.token(.for,                   start: loc0, end: loc1),
      self.token(.identifier("Gaston"),  start: loc2, end: loc3),
      self.token(.comma,                 start: loc4, end: loc5),
      self.token(.identifier("LeFou"),   start: loc6, end: loc7),
      self.token(.in,                    start: loc8, end: loc9),
      self.token(.identifier("village"), start: loc10, end: loc11),
      self.token(.colon,                 start: loc12, end: loc13),
      self.token(.string("evil"),        start: loc14, end: loc15)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchFor(stmt) else { return }

      XCTAssertExpression(d.target, "(Gaston LeFou)")
      XCTAssertExpression(d.iter, "village")
      XCTAssertEqual(d.orElse, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "'evil'")

      XCTAssertStatement(stmt, "(for (Gaston LeFou) in: village do: 'evil')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc15)
    }
  }

  /// for person in Belle, Maurice: "go castle"
  /// Maurice is Belle father
  func test_withIterTuple() {
    var parser = self.createStmtParser(
      self.token(.for,                   start: loc0, end: loc1),
      self.token(.identifier("person"),  start: loc2, end: loc3),
      self.token(.in,                    start: loc4, end: loc5),
      self.token(.identifier("Belle"),   start: loc6, end: loc7),
      self.token(.comma,                 start: loc8, end: loc9),
      self.token(.identifier("Maurice"), start: loc10, end: loc11),
      self.token(.colon,                 start: loc12, end: loc13),
      self.token(.string("go castle"),   start: loc14, end: loc15)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchFor(stmt) else { return }

      XCTAssertExpression(d.target, "person")
      XCTAssertExpression(d.iter, "(Belle Maurice)")
      XCTAssertEqual(d.orElse, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "'go castle'")

      XCTAssertStatement(stmt, "(for person in: (Belle Maurice) do: 'go castle')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc15)
    }
  }

  /// for person in Belle: "Husband"
  /// else: "Beast"
  func test_withElse() {
    var parser = self.createStmtParser(
      self.token(.for,                  start: loc0, end: loc1),
      self.token(.identifier("person"), start: loc2, end: loc3),
      self.token(.in,                   start: loc4, end: loc5),
      self.token(.identifier("Belle"),  start: loc6, end: loc7),
      self.token(.colon,                start: loc8, end: loc9),
      self.token(.string("Husband"),    start: loc10, end: loc11),
      self.token(.newLine,              start: loc12, end: loc13),
      self.token(.else,                 start: loc14, end: loc15),
      self.token(.colon,                start: loc16, end: loc17),
      self.token(.string("Beast"),      start: loc18, end: loc19)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchFor(stmt) else { return }

      XCTAssertExpression(d.target, "person")
      XCTAssertExpression(d.iter, "Belle")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "'Husband'")

      XCTAssertEqual(d.orElse.count, 1)
      guard d.orElse.count == 1 else { return }
      XCTAssertStatement(d.orElse[0], "'Beast'")

      XCTAssertStatement(stmt, "(for person in: Belle do: 'Husband' else: 'Beast')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc19)
    }
  }
}

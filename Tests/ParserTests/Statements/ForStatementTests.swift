import XCTest
import Core
import Lexer
@testable import Parser

class ForStatementTests: XCTestCase,
  Common, DestructStatementKind, DestructExpressionKind, DestructStringGroup {

  /// for person in village: "Beast"
  func test_for() {
    var parser = self.createStmtParser(
      self.token(.for,                   start: loc0, end: loc1),
      self.token(.identifier("person"),  start: loc2, end: loc3),
      self.token(.in,                    start: loc4, end: loc5),
      self.token(.identifier("village"), start: loc6, end: loc7),
      self.token(.colon,                 start: loc8, end: loc9),
      self.token(.string("Beast"),       start: loc10, end: loc11)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFor(stmt) else { return }

      XCTAssertExpression(d.target, "person")
      XCTAssertExpression(d.iter, "village")
      XCTAssertEqual(d.orElse, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Beast\"")

      XCTAssertStatement(stmt, "(for person in: village do: \"Beast\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc11)
    }
  }

  /// for Gaston, in village: "Beast"
  func test_for_withCommaAfterTarget_isTuple() {
    var parser = self.createStmtParser(
      self.token(.for,                   start: loc0, end: loc1),
      self.token(.identifier("Gaston"),  start: loc2, end: loc3),
      self.token(.comma,                 start: loc4, end: loc5),
      self.token(.in,                    start: loc6, end: loc7),
      self.token(.identifier("village"), start: loc8, end: loc9),
      self.token(.colon,                 start: loc10, end: loc11),
      self.token(.string("Beast"),       start: loc12, end: loc13)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFor(stmt) else { return }

      XCTAssertExpression(d.target, "(Gaston)")
      XCTAssertExpression(d.iter, "village")
      XCTAssertEqual(d.orElse, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Beast\"")

      XCTAssertStatement(stmt, "(for (Gaston) in: village do: \"Beast\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc13)
    }
  }

  /// for Gaston, LeFou in village: "Beast"
  /// LeFou is Gaston sidekick
  func test_for_withCommaTargetTuple() {
    var parser = self.createStmtParser(
      self.token(.for,                   start: loc0, end: loc1),
      self.token(.identifier("Gaston"),  start: loc2, end: loc3),
      self.token(.comma,                 start: loc4, end: loc5),
      self.token(.identifier("LeFou"),   start: loc6, end: loc7),
      self.token(.in,                    start: loc8, end: loc9),
      self.token(.identifier("village"), start: loc10, end: loc11),
      self.token(.colon,                 start: loc12, end: loc13),
      self.token(.string("Beast"),       start: loc14, end: loc15)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFor(stmt) else { return }

      XCTAssertExpression(d.target, "(Gaston LeFou)")
      XCTAssertExpression(d.iter, "village")
      XCTAssertEqual(d.orElse, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Beast\"")

      XCTAssertStatement(stmt, "(for (Gaston LeFou) in: village do: \"Beast\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc15)
    }
  }

  /// for person in Belle, Maurice: "Prince"
  /// Maurice is Belle father
  func test_for_withIterTuple() {
    var parser = self.createStmtParser(
      self.token(.for,                   start: loc0, end: loc1),
      self.token(.identifier("person"),  start: loc2, end: loc3),
      self.token(.in,                    start: loc4, end: loc5),
      self.token(.identifier("Belle"),   start: loc6, end: loc7),
      self.token(.comma,                 start: loc8, end: loc9),
      self.token(.identifier("Maurice"), start: loc10, end: loc11),
      self.token(.colon,                 start: loc12, end: loc13),
      self.token(.string("Prince"),      start: loc14, end: loc15)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFor(stmt) else { return }

      XCTAssertExpression(d.target, "person")
      XCTAssertExpression(d.iter, "(Belle Maurice)")
      XCTAssertEqual(d.orElse, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Prince\"")

      XCTAssertStatement(stmt, "(for person in: (Belle Maurice) do: \"Prince\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc15)
    }
  }

  /// for person in Belle: "Husband"
  /// else: "Beast"
  func test_for_withElse() {
    var parser = self.createStmtParser(
      self.token(.for,                  start: loc0, end: loc1),
      self.token(.identifier("person"), start: loc2, end: loc3),
      self.token(.in,                   start: loc4, end: loc5),
      self.token(.identifier("Belle"),  start: loc6, end: loc7),
      self.token(.colon,                start: loc8, end: loc9),
      self.token(.string("Husband"),    start: loc10, end: loc11),
      self.token(.else,                 start: loc12, end: loc13),
      self.token(.colon,                start: loc14, end: loc15),
      self.token(.string("Beast"),      start: loc16, end: loc17)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFor(stmt) else { return }

      XCTAssertExpression(d.target, "person")
      XCTAssertExpression(d.iter, "Belle")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Husband\"")

      XCTAssertEqual(d.orElse.count, 1)
      guard d.orElse.count == 1 else { return }
      XCTAssertStatement(d.orElse[0], "\"Beast\"")

      XCTAssertStatement(stmt, "(for person in: Belle do: \"Husband\" else: \"Beast\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc17)
    }
  }
}

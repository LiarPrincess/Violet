import XCTest
import Core
import Lexer
@testable import Parser

// Use this for reference:
// https://www.youtube.com/watch?v=tTUZswZHsWQ
// (First part of the song is in 'if' tests)

class LoopStatementTests: XCTestCase, Common,
                                    DestructStatementKind,
                                    DestructExpressionKind,
                                    DestructStringGroup {
  // MARK: - While

  /// while a: "Since the morning that we came"
  func test_while() {
    let s = "Since the morning that we came"

    var parser = self.createStmtParser(
      self.token(.while,           start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.string(s),       start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructWhile(stmt) else { return }

      XCTAssertExpression(d.test, "a")
      XCTAssertEqual(d.orElse, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Since the ...\"")

      XCTAssertStatement(stmt, "(while a \"Since the ...\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  /// while a: "Since the morning that we came"
  /// else:    "Good morning, Belle!"
  func test_while_withElse() {
    let s0 = "Good morning, Belle!"
    let s1 = "Good morning, Monsieur."

    var parser = self.createStmtParser(
      self.token(.while,           start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.string(s0),      start: loc6, end: loc7),
      self.token(.else,            start: loc8, end: loc9),
      self.token(.colon,           start: loc10, end: loc11),
      self.token(.string(s1),      start: loc12, end: loc13)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructWhile(stmt) else { return }

      XCTAssertExpression(d.test, "a")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Good morni...\"")

      XCTAssertEqual(d.orElse.count, 1)
      guard d.orElse.count == 1 else { return }
      XCTAssertStatement(d.orElse[0], "\"Good morni...\"")

      XCTAssertStatement(stmt, "(while a \"Good morni...\" else: \"Good morni...\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc13)
    }
  }

  // MARK: - For

  /// for a in b: "Where are you off to?"
  func test_for() {
    let s = "Where are you off to?"

    var parser = self.createStmtParser(
      self.token(.for,             start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.in,              start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7),
      self.token(.colon,           start: loc8, end: loc9),
      self.token(.string(s),       start: loc10, end: loc11)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFor(stmt) else { return }

      XCTAssertExpression(d.target, "a")
      XCTAssertExpression(d.iter, "b")
      XCTAssertEqual(d.orElse, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Where are ...\"")

      XCTAssertStatement(stmt, "(for a in: b do: \"Where are ...\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc11)
    }
  }

  /// for a, in b: "The bookshop! I just finished the most wonderful story..."
  func test_for_withCommaAfterTarget_isTuple() {
    let s = "The bookshop! I just finished the most wonderful story..."

    var parser = self.createStmtParser(
      self.token(.for,             start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.comma,           start: loc4, end: loc5),
      self.token(.in,              start: loc6, end: loc7),
      self.token(.identifier("b"), start: loc8, end: loc9),
      self.token(.colon,           start: loc10, end: loc11),
      self.token(.string(s),       start: loc12, end: loc13)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFor(stmt) else { return }

      XCTAssertExpression(d.target, "(a)")
      XCTAssertExpression(d.iter, "b")
      XCTAssertEqual(d.orElse, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"The booksh...\"")

      XCTAssertStatement(stmt, "(for (a) in: b do: \"The booksh...\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc13)
    }
  }

  /// for a, b in c: "That's nice. Marie! The baguettes! Hurry up!"
  func test_for_withCommaTargetTuple() {
    let s = "That's nice. Marie! The baguettes! Hurry up!"

    var parser = self.createStmtParser(
      self.token(.for,             start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.comma,           start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7),
      self.token(.in,              start: loc8, end: loc9),
      self.token(.identifier("c"), start: loc10, end: loc11),
      self.token(.colon,           start: loc12, end: loc13),
      self.token(.string(s),       start: loc14, end: loc15)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFor(stmt) else { return }

      XCTAssertExpression(d.target, "(a b)")
      XCTAssertExpression(d.iter, "c")
      XCTAssertEqual(d.orElse, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"That's nic...\"")

      XCTAssertStatement(stmt, "(for (a b) in: c do: \"That's nic...\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc15)
    }
  }

  /// for a in b, c: "Look there she goes, that girl is strange, no question"
  func test_for_withIterTuple() {
    let s = "Look there she goes, that girl is strange, no question"

    var parser = self.createStmtParser(
      self.token(.for,             start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.in,              start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7),
      self.token(.comma,           start: loc8, end: loc9),
      self.token(.identifier("c"), start: loc10, end: loc11),
      self.token(.colon,           start: loc12, end: loc13),
      self.token(.string(s),       start: loc14, end: loc15)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFor(stmt) else { return }

      XCTAssertExpression(d.target, "a")
      XCTAssertExpression(d.iter, "(b c)")
      XCTAssertEqual(d.orElse, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Look there...\"")

      XCTAssertStatement(stmt, "(for a in: (b c) do: \"Look there...\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc15)
    }
  }

  //  Barber: Cause her head's up on some cloud
  //  Townsfolk: No denying she's a funny girl that Belle

  /// for a in b: "Dazed and distracted, can't you tell?"
  /// else:       "Never part of any crowd"
  func test_for_withElse() {
    let s0 = "Dazed and distracted, can't you tell?"
    let s1 = "Never part of any crowd"

    var parser = self.createStmtParser(
      self.token(.for,             start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.in,              start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7),
      self.token(.colon,           start: loc8, end: loc9),
      self.token(.string(s0),      start: loc10, end: loc11),
      self.token(.else,            start: loc12, end: loc13),
      self.token(.colon,           start: loc14, end: loc15),
      self.token(.string(s1),      start: loc16, end: loc17)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructFor(stmt) else { return }

      XCTAssertExpression(d.target, "a")
      XCTAssertExpression(d.iter, "b")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Dazed and ...\"")

      XCTAssertEqual(d.orElse.count, 1)
      guard d.orElse.count == 1 else { return }
      XCTAssertStatement(d.orElse[0], "\"Never part...\"")

      XCTAssertStatement(stmt, "(for a in: b do: \"Dazed and ...\" else: \"Never part...\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc17)
    }
  }
}

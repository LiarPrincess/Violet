import XCTest
import Core
import Lexer
@testable import Parser

// Use this for reference:
// https://www.youtube.com/watch?v=tTUZswZHsWQ
// (In this file we start the song and continue in 'loop' tests)

// swiftlint:disable function_body_length

class IfStatementTests: XCTestCase, Common,
                                    DestructStatementKind,
                                    DestructExpressionKind,
                                    DestructStringGroup {

  /// if a: "Little town, it's a quiet village"
  func test_if() {
    let s = "Little town, it's a quiet village"

    var parser = self.createStmtParser(
      self.token(.if,              start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.string(s),       start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructIf(stmt) else { return }

      XCTAssertExpression(d.test, "a")
      XCTAssertEqual(d.orElse, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Little tow...\"")

      XCTAssertStatement(stmt, "(if a then: \"Little tow...\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  /// if a: "Every day like the one before"
  /// else: "Little town, full of little people"
  func test_if_withElse() {
    let s0 = "Every day like the one before"
    let s1 = "Little town, full of little people"

    var parser = self.createStmtParser(
      self.token(.if,              start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.string(s0),      start: loc6, end: loc7),
      self.token(.else,            start: loc8, end: loc9),
      self.token(.colon,           start: loc10, end: loc11),
      self.token(.string(s1),      start: loc12, end: loc13)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructIf(stmt) else { return }

      XCTAssertExpression(d.test, "a")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Every day ...\"")

      XCTAssertEqual(d.orElse.count, 1)
      guard d.orElse.count == 1 else { return }
      XCTAssertStatement(d.orElse[0], "\"Little tow...\"")

      XCTAssertStatement(stmt, "(if a then: \"Every day ...\" else: \"Little tow...\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc13)
    }
  }

  /// if a: "Waking up to say"
  /// elif b: "Bonjour!"
  /// Expected:
  /// ```
  /// If0
  ///   test: a
  ///   body: Waking up to say
  ///   orelse:
  ///     If1
  ///       test: b
  ///       body: Bonjour!
  ///       orelse: empty
  /// ```
  func test_if_withElif() {
    let s0 = "Waking up to say"
    let s1 = "Bonjour!"

    var parser = self.createStmtParser(
      self.token(.if,              start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.string(s0),      start: loc6, end: loc7),
      self.token(.elif,            start: loc8, end: loc9),
      self.token(.identifier("b"), start: loc10, end: loc11),
      self.token(.colon,           start: loc12, end: loc13),
      self.token(.string(s1),      start: loc14, end: loc15)
    )

    if let stmt = self.parseStmt(&parser) {
      // first if
      guard let if0 = self.destructIf(stmt) else { return }
      XCTAssertExpression(if0.test, "a")

      XCTAssertEqual(if0.body.count, 1)
      guard if0.body.count == 1 else { return }
      XCTAssertStatement(if0.body[0], "\"Waking up ...\"")

      XCTAssertEqual(if0.orElse.count, 1)
      guard if0.orElse.count == 1 else { return }

      // nested if
      guard let if1 = self.destructIf(if0.orElse[0]) else { return }

      XCTAssertExpression(if1.test, "b")
      XCTAssertEqual(if1.orElse, [])

      XCTAssertEqual(if1.body.count, 1)
      guard if1.body.count == 1 else { return }
      XCTAssertStatement(if1.body[0], "\"Bonjour!\"")

      // general
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc15)
    }
  }

  /// if a:   "There goes the baker with his tray, like always"
  /// elif b: "The same old bread and rolls to sell"
  /// else:   "Every morning just the same"
  /// Expected AST is similiar to the one in `test_if_withElif`.
  func test_if_withElif_andElse() {
    let s0 = "There goes the baker with his tray, like always"
    let s1 = "The same old bread and rolls to sell"
    let s2 = "Every morning just the same"

    var parser = self.createStmtParser(
      self.token(.if,              start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.string(s0),      start: loc6, end: loc7),
      self.token(.elif,            start: loc8, end: loc9),
      self.token(.identifier("b"), start: loc10, end: loc11),
      self.token(.colon,           start: loc12, end: loc13),
      self.token(.string(s1),      start: loc14, end: loc15),
      self.token(.else,            start: loc16, end: loc17),
      self.token(.colon,           start: loc18, end: loc19),
      self.token(.string(s2),      start: loc20, end: loc21)
    )

    if let stmt = self.parseStmt(&parser) {
      // first if
      guard let if0 = self.destructIf(stmt) else { return }
      XCTAssertExpression(if0.test, "a")

      XCTAssertEqual(if0.body.count, 1)
      guard if0.body.count == 1 else { return }
      XCTAssertStatement(if0.body[0], "\"There goes...\"")

      XCTAssertEqual(if0.orElse.count, 1)
      guard if0.orElse.count == 1 else { return }

      // nested if
      guard let if1 = self.destructIf(if0.orElse[0]) else { return }
      XCTAssertExpression(if1.test, "b")

      XCTAssertEqual(if1.body.count, 1)
      guard if1.body.count == 1 else { return }
      XCTAssertStatement(if1.body[0], "\"The same o...\"")

      XCTAssertEqual(if1.orElse.count, 1)
      guard if1.orElse.count == 1 else { return }
      XCTAssertStatement(if1.orElse[0], "\"Every morn...\"")

      // general
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc21)
    }
  }

  // TODO: if - big suite
}

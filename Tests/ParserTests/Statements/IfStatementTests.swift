import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable function_body_length

class IfStatementTests: XCTestCase,
  Common, DestructStatementKind, DestructExpressionKind, DestructStringGroup {

  /// if Pooh: "Honey"
  func test_if() {
    var parser = self.createStmtParser(
      self.token(.if,                 start: loc0, end: loc1),
      self.token(.identifier("Pooh"), start: loc2, end: loc3),
      self.token(.colon,              start: loc4, end: loc5),
      self.token(.string("Honey"),    start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructIf(stmt) else { return }

      XCTAssertExpression(d.test, "Pooh")
      XCTAssertEqual(d.orElse, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "'Honey'")

      XCTAssertStatement(stmt, "(if Pooh then: 'Honey')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  /// if Pooh: "Honey"
  /// else: "More honey"
  func test_if_withElse() {
    var parser = self.createStmtParser(
      self.token(.if,                   start: loc0, end: loc1),
      self.token(.identifier("Pooh"),   start: loc2, end: loc3),
      self.token(.colon,                start: loc4, end: loc5),
      self.token(.string("Honey"),      start: loc6, end: loc7),
      self.token(.newLine,              start: loc8, end: loc9),
      self.token(.else,                 start: loc10, end: loc11),
      self.token(.colon,                start: loc12, end: loc13),
      self.token(.string("More honey"), start: loc14, end: loc15)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructIf(stmt) else { return }

      XCTAssertExpression(d.test, "Pooh")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "'Honey'")

      XCTAssertEqual(d.orElse.count, 1)
      guard d.orElse.count == 1 else { return }
      XCTAssertStatement(d.orElse[0], "'More honey'")

      XCTAssertStatement(stmt, "(if Pooh then: 'Honey' else: 'More honey')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc15)
    }
  }

  /// if Pooh: "Honey"
  /// elif Tigger: "Bouncing"
  /// Expected:
  /// ```
  /// If0
  ///   test: Pooh
  ///   body: Honey
  ///   orelse:
  ///     If1
  ///       test: Tigger
  ///       body: Bouncing
  ///       orelse: empty
  /// ```
  func test_if_withElif() {
    var parser = self.createStmtParser(
      self.token(.if,                   start: loc0, end: loc1),
      self.token(.identifier("Pooh"),   start: loc2, end: loc3),
      self.token(.colon,                start: loc4, end: loc5),
      self.token(.string("Honey"),      start: loc6, end: loc7),
      self.token(.newLine,              start: loc8, end: loc9),
      self.token(.elif,                 start: loc10, end: loc11),
      self.token(.identifier("Tigger"), start: loc12, end: loc13),
      self.token(.colon,                start: loc14, end: loc15),
      self.token(.string("Bouncing"),   start: loc16, end: loc17)
    )

    if let stmt = self.parseStmt(&parser) {
      // first if
      guard let if0 = self.destructIf(stmt) else { return }
      XCTAssertExpression(if0.test, "Pooh")

      XCTAssertEqual(if0.body.count, 1)
      guard if0.body.count == 1 else { return }
      XCTAssertStatement(if0.body[0], "'Honey'")

      XCTAssertEqual(if0.orElse.count, 1)
      guard if0.orElse.count == 1 else { return }

      // nested if
      guard let if1 = self.destructIf(if0.orElse[0]) else { return }

      XCTAssertExpression(if1.test, "Tigger")
      XCTAssertEqual(if1.orElse, [])

      XCTAssertEqual(if1.body.count, 1)
      guard if1.body.count == 1 else { return }
      XCTAssertStatement(if1.body[0], "'Bouncing'")

      // general
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc17)
    }
  }

  /// if Pooh:     "Honey"
  /// elif Tigger: "Bouncing"
  /// else:        "Carrots?"
  /// Expected AST is similiar to the one in `test_if_withElif`.
  func test_if_withElif_andElse() {
    var parser = self.createStmtParser(
      self.token(.if,                   start: loc0, end: loc1),
      self.token(.identifier("Pooh"),   start: loc2, end: loc3),
      self.token(.colon,                start: loc4, end: loc5),
      self.token(.string("Honey"),      start: loc6, end: loc7),
      self.token(.newLine,              start: loc8, end: loc9),
      self.token(.elif,                 start: loc10, end: loc11),
      self.token(.identifier("Tigger"), start: loc12, end: loc13),
      self.token(.colon,                start: loc14, end: loc15),
      self.token(.string("Bouncing"),   start: loc16, end: loc17),
      self.token(.newLine,              start: loc18, end: loc19),
      self.token(.else,                 start: loc20, end: loc21),
      self.token(.colon,                start: loc22, end: loc23),
      self.token(.string("Carrots?"),   start: loc24, end: loc25)
    )

    if let stmt = self.parseStmt(&parser) {
      // first if
      guard let if0 = self.destructIf(stmt) else { return }
      XCTAssertExpression(if0.test, "Pooh")

      XCTAssertEqual(if0.body.count, 1)
      guard if0.body.count == 1 else { return }
      XCTAssertStatement(if0.body[0], "'Honey'")

      XCTAssertEqual(if0.orElse.count, 1)
      guard if0.orElse.count == 1 else { return }

      // nested if
      guard let if1 = self.destructIf(if0.orElse[0]) else { return }
      XCTAssertExpression(if1.test, "Tigger")

      XCTAssertEqual(if1.body.count, 1)
      guard if1.body.count == 1 else { return }
      XCTAssertStatement(if1.body[0], "'Bouncing'")

      XCTAssertEqual(if1.orElse.count, 1)
      guard if1.orElse.count == 1 else { return }
      XCTAssertStatement(if1.orElse[0], "'Carrots?'")

      // general
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc25)
    }
  }
}

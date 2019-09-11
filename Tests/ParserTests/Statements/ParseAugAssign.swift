import XCTest
import Core
import Lexer
@testable import Parser

class ParseAugAssign: XCTestCase,
Common, ExpressionMatcher, StatementMatcher, StringMatcher {

  // MARK: - Augumented assignment

  /// Ariel += "legs"
  func test_simple() {
    // swiftlint:disable:previous function_body_length

    let augAssign: [TokenKind:BinaryOperator] = [
      .plusEqual: .add, // +=
      .minusEqual: .sub, // -=
      .starEqual: .mul, // *=
      .atEqual: .matMul, // @=
      .slashEqual: .div, // /=
      .percentEqual: .modulo, // %=

      .amperEqual: .bitAnd, // &=
      .vbarEqual: .bitOr, // |=
      .circumflexEqual: .bitXor, // ^=

      .leftShiftEqual: .leftShift, // <<=
      .rightShiftEqual: .rightShift, // >>=
      .starStarEqual: .pow, // **=
      .slashSlashEqual: .floorDiv // //=
    ]

    for (tokenKind, op) in augAssign {
      var parser = self.createStmtParser(
        self.token(.identifier("Ariel"), start: loc0, end: loc1),
        self.token(tokenKind,            start: loc2, end: loc3),
        self.token(.string("legs"),      start: loc4, end: loc5)
      )

      if let stmt = self.parseStmt(&parser) {
        let msg = "for: \(tokenKind)"
        guard let d = self.matchAugAssign(stmt) else { return }

        XCTAssertExpression(d.target, "Ariel", msg)
        XCTAssertEqual(d.op, op, msg)
        XCTAssertExpression(d.value, "'legs'", msg)

        XCTAssertStatement(stmt, "(Ariel \(op)= 'legs')", msg)
        XCTAssertEqual(stmt.start, loc0)
        XCTAssertEqual(stmt.end,   loc5)
      }
    }
  }

  /// sea.cavern += "Gizmos"
  func test_toAttribute() {
    var parser = self.createStmtParser(
      self.token(.identifier("sea"),    start: loc0, end: loc1),
      self.token(.dot,                  start: loc2, end: loc3),
      self.token(.identifier("cavern"), start: loc4, end: loc5),
      self.token(.plusEqual,            start: loc6, end: loc7),
      self.token(.string("Gizmos"),     start: loc8, end: loc9)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchAugAssign(stmt) else { return }

      XCTAssertExpression(d.target, "sea.cavern")
      XCTAssertEqual(d.op, .add)
      XCTAssertExpression(d.value, "'Gizmos'")

      XCTAssertStatement(stmt, "(sea.cavern += 'Gizmos')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc9)
    }
  }

  /// sea[cavern] += "Gizmos"
  func test_toSubscript() {
    var parser = self.createStmtParser(
      self.token(.identifier("sea"),    start: loc0, end: loc1),
      self.token(.leftSqb,              start: loc2, end: loc3),
      self.token(.identifier("cavern"), start: loc4, end: loc5),
      self.token(.rightSqb,             start: loc6, end: loc7),
      self.token(.plusEqual,            start: loc8, end: loc9),
      self.token(.string("Gizmos"),     start: loc10, end: loc11)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchAugAssign(stmt) else { return }

      XCTAssertExpression(d.target, "sea[cavern]")
      XCTAssertEqual(d.op, .add)
      XCTAssertExpression(d.value, "'Gizmos'")

      XCTAssertStatement(stmt, "(sea[cavern] += 'Gizmos')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc11)
    }
  }

  /// 3 += "Ursula"
  func test_toConstants_throws() {
    var parser = self.createStmtParser(
      self.token(.int(BigInt(3)),    start: loc0, end: loc1),
      self.token(.plusEqual,         start: loc2, end: loc3),
      self.token(.string("Ursula"),  start: loc4, end: loc5)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .illegalAugAssignmentTarget)
      XCTAssertEqual(error.location, loc0)
    }
  }

  /// Ariel += yield "legs"
  func test_yield() {
    var parser = self.createStmtParser(
      self.token(.identifier("Ariel"), start: loc0, end: loc1),
      self.token(.plusEqual,           start: loc2, end: loc3),
      self.token(.yield,               start: loc4, end: loc5),
      self.token(.string("legs"),      start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.matchAugAssign(stmt) else { return }

      XCTAssertExpression(d.target, "Ariel")
      XCTAssertEqual(d.op, .add)
      XCTAssertExpression(d.value, "(yield 'legs')")

      XCTAssertStatement(stmt, "(Ariel += (yield 'legs'))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }
}

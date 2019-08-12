import XCTest
import Core
import Lexer
@testable import Parser

// Use this for reference:
// https://www.youtube.com/watch?v=tTuwo_TqlhQ
// (we start with Flynn lines)

// swiftlint:disable file_length
// swiftlint:disable type_body_length

class ExpressionStatementTests: XCTestCase, Common,
  DestructStatementKind,
  DestructExpressionKind,
  DestructStringGroup {

  // MARK: - Just expression

  /// "I have dreams, like you -- no, really!"
  func test_expression() {
    let s = "I have dreams, like you -- no, really!"

    var parser = self.createStmtParser(
      self.token(.string(s), start: loc0, end: loc1)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let expr = self.destructExpr(stmt) else { return }
      guard let group = self.destructString(expr) else { return }
      guard let string = self.destructStringSimple(group) else { return }

      XCTAssertEqual(string, s)

      XCTAssertStatement(stmt, "\"I have dre...\"")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc1)
    }
  }

  // MARK: - Augumented assignment

  /// a += "Just much less touchy-feely"
  // swiftlint:disable:next function_body_length
  func test_augAssign() {
    let s = "Just much less touchy-feely"

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
        self.token(.identifier("a"), start: loc0, end: loc1),
        self.token(tokenKind,        start: loc2, end: loc3),
        self.token(.string(s),       start: loc4, end: loc5)
      )

      if let stmt = self.parseStmt(&parser) {
        let msg = "for: \(tokenKind)"
        guard let d = self.destructAugAssign(stmt) else { return }

        XCTAssertExpression(d.target, "a", msg)
        XCTAssertEqual(d.op, op, msg)
        XCTAssertExpression(d.value, "\"Just much ...\"", msg)

        XCTAssertStatement(stmt, "(\(op)= a \"Just much ...\")", msg)
        XCTAssertEqual(stmt.start, loc0)
        XCTAssertEqual(stmt.end,   loc5)
      }
    }
  }

  /// a.b += "They mainly happen somewhere warm and sunny"
  func test_augAssign_toAttribute() {
    let s = "They mainly happen somewhere warm and sunny"

    var parser = self.createStmtParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.dot,             start: loc2, end: loc3),
      self.token(.identifier("b"), start: loc4, end: loc5),
      self.token(.plusEqual,       start: loc6, end: loc7),
      self.token(.string(s),       start: loc8, end: loc9)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAugAssign(stmt) else { return }

      XCTAssertExpression(d.target, "a.b")
      XCTAssertEqual(d.op, .add)
      XCTAssertExpression(d.value, "\"They mainl...\"")

      XCTAssertStatement(stmt, "(+= a.b \"They mainl...\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc9)
    }
  }

  /// a[b] = On an island that I own
  func test_augAssign_toSubscript() {
    let s = "On an island that I own"

    var parser = self.createStmtParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.identifier("b"), start: loc4, end: loc5),
      self.token(.rightSqb,        start: loc6, end: loc7),
      self.token(.plusEqual,       start: loc8, end: loc9),
      self.token(.string(s),       start: loc10, end: loc11)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAugAssign(stmt) else { return }

      XCTAssertExpression(d.target, "a[b]")
      XCTAssertEqual(d.op, .add)
      XCTAssertExpression(d.value, "\"On an isla...\"")

      XCTAssertStatement(stmt, "(+= a[b] \"On an isla...\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc11)
    }
  }

  /// 3 += Tanned and rested and alone
  func test_augAssign_toConstants_throws() {
    let s = "Tanned and rested and alone"

    var parser = self.createStmtParser(
      self.token(.int(PyInt(3)), start: loc0, end: loc1),
      self.token(.plusEqual,     start: loc2, end: loc3),
      self.token(.string(s),     start: loc4, end: loc5)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .illegalAugAssignmentTarget)
      XCTAssertEqual(error.location, loc0)
    }
  }

  /// a += yield "Surrounded by enormous piles of money"
  func test_augAssign_yield() {
    let s = "Surrounded by enormous piles of money"

    var parser = self.createStmtParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.plusEqual,       start: loc2, end: loc3),
      self.token(.yield,           start: loc4, end: loc5),
      self.token(.string(s),       start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAugAssign(stmt) else { return }

      XCTAssertExpression(d.target, "a")
      XCTAssertEqual(d.op, .add)
      XCTAssertExpression(d.value, "(yield \"Surrounded...\")")

      XCTAssertStatement(stmt, "(+= a (yield \"Surrounded...\"))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  // MARK: - Annotated assignment

  /// a:b = "I've got a dream!"
  func test_annAssign() {
    let s = "I've got a dream!"

    var parser = self.createStmtParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.colon,           start: loc2, end: loc3),
      self.token(.identifier("b"), start: loc4, end: loc5),
      self.token(.equal,           start: loc6, end: loc7),
      self.token(.string(s),       start: loc8, end: loc9)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAnnAssign(stmt) else { return }

      XCTAssertExpression(d.target, "a")
      XCTAssertExpression(d.annotation, "b")
      XCTAssertExpression(d.value, "\"I've got a...\"")
      XCTAssertEqual(d.simple, true)

      XCTAssertStatement(stmt, "(= a:b \"I've got a...\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc9)
    }
  }

  /// a:"She's got a dream!" <-- soo... wrong but valid according to grammar
  func test_annAssign_withoutValue() {
    let s = "She's got a dream!"

    var parser = self.createStmtParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.colon,           start: loc2, end: loc3),
      self.token(.string(s),       start: loc4, end: loc5)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAnnAssign(stmt) else { return }

      XCTAssertExpression(d.target, "a")
      XCTAssertExpression(d.annotation, "\"She's got ...\"")
      XCTAssertEqual(d.value, nil)
      XCTAssertEqual(d.simple, true)

      XCTAssertStatement(stmt, "(= a:\"She's got ...\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc5)
    }
  }

  /// a.b:c = "I just want to see the floating lanterns gleam!"
  func test_annAssign_toAttribute() {
    let s = "I just want to see the floating lanterns gleam!"

    var parser = self.createStmtParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.dot,             start: loc2, end: loc3),
      self.token(.identifier("b"), start: loc4, end: loc5),
      self.token(.colon,           start: loc6, end: loc7),
      self.token(.identifier("c"), start: loc8, end: loc9),
      self.token(.equal,           start: loc10, end: loc11),
      self.token(.string(s),       start: loc12, end: loc13)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAnnAssign(stmt) else { return }

      XCTAssertExpression(d.target, "a.b")
      XCTAssertExpression(d.annotation, "c")
      XCTAssertExpression(d.value, "\"I just wan...\"")
      XCTAssertEqual(d.simple, false) // <-- this

      XCTAssertStatement(stmt, "(= a.b:c \"I just wan...\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc13)
    }
  }

  /// a[b]:c = "I just want to see the floating lanterns gleam!"
  func test_annAssign_toSubscript() {
    let s = "Yeah!"

    var parser = self.createStmtParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.identifier("b"), start: loc4, end: loc5),
      self.token(.rightSqb,        start: loc6, end: loc7),
      self.token(.colon,           start: loc8, end: loc9),
      self.token(.identifier("c"), start: loc10, end: loc11),
      self.token(.equal,           start: loc12, end: loc13),
      self.token(.string(s),       start: loc14, end: loc15)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAnnAssign(stmt) else { return }

      XCTAssertExpression(d.target, "a[b]")
      XCTAssertExpression(d.annotation, "c")
      XCTAssertExpression(d.value, "\"Yeah!\"")
      XCTAssertEqual(d.simple, false) // <-- this

      XCTAssertStatement(stmt, "(= a[b]:c \"Yeah!\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc15)
    }
  }

  /// (a):b = "And with every passing hour"
  func test_annAssign_inParen_isNotSimple() {
    let s = "And with every passing hour"

    var parser = self.createStmtParser(
      self.token(.leftParen,       start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.rightParen,      start: loc4, end: loc5),
      self.token(.colon,           start: loc6, end: loc7),
      self.token(.identifier("b"), start: loc8, end: loc9),
      self.token(.equal,           start: loc10, end: loc11),
      self.token(.string(s),       start: loc12, end: loc13)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAnnAssign(stmt) else { return }

      XCTAssertExpression(d.target, "a")
      XCTAssertExpression(d.annotation, "b")
      XCTAssertExpression(d.value, "\"And with e...\"")
      XCTAssertEqual(d.simple, false) // <-- this (because parens!)

      XCTAssertStatement(stmt, "(= a:b \"And with e...\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc13)
    }
  }

  /// 3:b = "I'm so glad I left my tower"
  func test_annAssign_toConstants_throws() {
    let s = "I'm so glad I left my tower"

    var parser = self.createStmtParser(
      self.token(.int(PyInt(3)),   start: loc0, end: loc1),
      self.token(.colon,           start: loc2, end: loc3),
      self.token(.identifier("b"), start: loc4, end: loc5),
      self.token(.equal,           start: loc6, end: loc7),
      self.token(.string(s),       start: loc8, end: loc9)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .illegalAnnAssignmentTarget)
      XCTAssertEqual(error.location, loc0)
    }
  }

  // MARK: - Normal assignment

  /// a = "Like all you lovely folks"
  func test_normalAssign() {
    let s = "Like all you lovely folks"

    var parser = self.createStmtParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.equal,           start: loc2, end: loc3),
      self.token(.string(s),       start: loc4, end: loc5)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAssign(stmt) else { return }

      XCTAssertEqual(d.targets.count, 1)
      guard d.targets.count == 1 else { return }

      XCTAssertExpression(d.targets[0], "a")
      XCTAssertExpression(d.value, "\"Like all y...\"")

      XCTAssertStatement(stmt, "(= a \"Like all y...\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc5)
    }
  }

  /// a,b = "I've got a dream!"
  func test_normalAssign_toTuple() {
    let s = "I've got a dream!"

    var parser = self.createStmtParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.comma,           start: loc2, end: loc3),
      self.token(.identifier("b"), start: loc4, end: loc5),
      self.token(.equal,           start: loc6, end: loc7),
      self.token(.string(s),       start: loc8, end: loc9)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAssign(stmt) else { return }

      XCTAssertEqual(d.targets.count, 1)
      guard d.targets.count == 1 else { return }

      XCTAssertExpression(d.targets[0], "(a b)")
      XCTAssertExpression(d.value, "\"I've got a...\"")

      XCTAssertStatement(stmt, "(= (a b) \"I've got a...\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc9)
    }
  }

  /// a, = "She's got a dream!"
  func test_normalAssign_withComma_isTuple() {
    let s = "She's got a dream!"

    var parser = self.createStmtParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.comma,           start: loc2, end: loc3),
      self.token(.equal,           start: loc4, end: loc5),
      self.token(.string(s),       start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAssign(stmt) else { return }

      XCTAssertEqual(d.targets.count, 1)
      guard d.targets.count == 1 else { return }

      XCTAssertExpression(d.targets[0], "(a)")
      XCTAssertExpression(d.value, "\"She's got ...\"")

      XCTAssertStatement(stmt, "(= (a) \"She's got ...\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  /// a = b = "She's got a dream!"
  func test_normalAssign_multiple() {
    let s = "He's got a dream!"

    var parser = self.createStmtParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.equal,           start: loc2, end: loc3),
      self.token(.identifier("b"), start: loc4, end: loc5),
      self.token(.equal,           start: loc6, end: loc7),
      self.token(.string(s),       start: loc8, end: loc9)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAssign(stmt) else { return }

      XCTAssertEqual(d.targets.count, 2)
      guard d.targets.count == 2 else { return }

      XCTAssertExpression(d.targets[0], "a")
      XCTAssertExpression(d.targets[1], "b")
      XCTAssertExpression(d.value, "\"He's got a...\"")

      XCTAssertStatement(stmt, "(= a b \"He's got a...\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc9)
    }
  }

  /// a = yield "They've got a dream!"
  func test_normalAssign_yieldValue() {
    let s = "They've got a dream!"

    var parser = self.createStmtParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.equal,           start: loc2, end: loc3),
      self.token(.yield,           start: loc4, end: loc5),
      self.token(.string(s),       start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAssign(stmt) else { return }

      XCTAssertEqual(d.targets.count, 1)
      guard d.targets.count == 1 else { return }

      XCTAssertExpression(d.targets[0], "a")
      XCTAssertExpression(d.value, "(yield \"They've go...\")")

      XCTAssertStatement(stmt, "(= a (yield \"They've go...\"))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  /// a = yield b = "We've got a dream!"
  /// If we used 'yield a = xxx' then it is 'yield stmt' by grammar
  func test_normalAssign_yieldTarget() {
    let s = "We've got a dream!"

    var parser = self.createStmtParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.equal,           start: loc2, end: loc3),
      self.token(.yield,           start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7),
      self.token(.equal,           start: loc8, end: loc9),
      self.token(.string(s),       start: loc10, end: loc11)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .illegalAssignmentToYield)
      XCTAssertEqual(error.location, loc4)
    }
  }

  // MARK: - Helpers

  private func getString(_ expr: Expression,
                         file:   StaticString = #file,
                         line:   UInt         = #line) -> String? {

    guard let group = self.destructString(expr, file: file, line: line)
      else { return nil }

    guard let string = self.destructStringSimple(group, file: file, line: line)
      else { return nil }

    return string
  }
}

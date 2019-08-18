import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length
// swiftlint:disable type_body_length
// swiftlint:disable function_body_length

class ExpressionStatementTests: XCTestCase,
  Common, DestructStatementKind, DestructExpressionKind, DestructStringGroup {

  // MARK: - Just expression

  /// "Ariel+Eric"
  func test_expression() {
    var parser = self.createStmtParser(
      self.token(.string("Ariel+Eric"), start: loc0, end: loc1)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let expr = self.destructExpr(stmt) else { return }
      guard let group = self.destructString(expr) else { return }
      guard let string = self.destructStringSimple(group) else { return }

      XCTAssertEqual(string, "Ariel+Eric")

      XCTAssertStatement(stmt, "'Ariel+Eric'")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc1)
    }
  }

  // MARK: - Augumented assignment

  /// Ariel += "legs"
  func test_augAssign() {
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
        guard let d = self.destructAugAssign(stmt) else { return }

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
  func test_augAssign_toAttribute() {
    var parser = self.createStmtParser(
      self.token(.identifier("sea"),    start: loc0, end: loc1),
      self.token(.dot,                  start: loc2, end: loc3),
      self.token(.identifier("cavern"), start: loc4, end: loc5),
      self.token(.plusEqual,            start: loc6, end: loc7),
      self.token(.string("Gizmos"),     start: loc8, end: loc9)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAugAssign(stmt) else { return }

      XCTAssertExpression(d.target, "sea.cavern")
      XCTAssertEqual(d.op, .add)
      XCTAssertExpression(d.value, "'Gizmos'")

      XCTAssertStatement(stmt, "(sea.cavern += 'Gizmos')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc9)
    }
  }

  /// sea[cavern] += "Gizmos"
  func test_augAssign_toSubscript() {
    var parser = self.createStmtParser(
      self.token(.identifier("sea"),    start: loc0, end: loc1),
      self.token(.leftSqb,              start: loc2, end: loc3),
      self.token(.identifier("cavern"), start: loc4, end: loc5),
      self.token(.rightSqb,             start: loc6, end: loc7),
      self.token(.plusEqual,            start: loc8, end: loc9),
      self.token(.string("Gizmos"),     start: loc10, end: loc11)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAugAssign(stmt) else { return }

      XCTAssertExpression(d.target, "sea[cavern]")
      XCTAssertEqual(d.op, .add)
      XCTAssertExpression(d.value, "'Gizmos'")

      XCTAssertStatement(stmt, "(sea[cavern] += 'Gizmos')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc11)
    }
  }

  /// 3 += "Ursula"
  func test_augAssign_toConstants_throws() {
    var parser = self.createStmtParser(
      self.token(.int(PyInt(3)),    start: loc0, end: loc1),
      self.token(.plusEqual,        start: loc2, end: loc3),
      self.token(.string("Ursula"), start: loc4, end: loc5)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .illegalAugAssignmentTarget)
      XCTAssertEqual(error.location, loc0)
    }
  }

  /// Ariel += yield "legs"
  func test_augAssign_yield() {
    var parser = self.createStmtParser(
      self.token(.identifier("Ariel"), start: loc0, end: loc1),
      self.token(.plusEqual,           start: loc2, end: loc3),
      self.token(.yield,               start: loc4, end: loc5),
      self.token(.string("legs"),      start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAugAssign(stmt) else { return }

      XCTAssertExpression(d.target, "Ariel")
      XCTAssertEqual(d.op, .add)
      XCTAssertExpression(d.value, "(yield 'legs')")

      XCTAssertStatement(stmt, "(Ariel += (yield 'legs'))")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  // MARK: - Annotated assignment

  /// Flounder:Animal = "Friend"
  func test_annAssign() {
    var parser = self.createStmtParser(
      self.token(.identifier("Flounder"), start: loc0, end: loc1),
      self.token(.colon,                  start: loc2, end: loc3),
      self.token(.identifier("Animal"),   start: loc4, end: loc5),
      self.token(.equal,                  start: loc6, end: loc7),
      self.token(.string("Friend"),       start: loc8, end: loc9)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAnnAssign(stmt) else { return }

      XCTAssertExpression(d.target, "Flounder")
      XCTAssertExpression(d.annotation, "Animal")
      XCTAssertExpression(d.value, "'Friend'")
      XCTAssertEqual(d.isSimple, true)

      XCTAssertStatement(stmt, "(Flounder:Animal = 'Friend')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc9)
    }
  }

  /// Ariel:Mermaid
  func test_annAssign_withoutValue() {
    var parser = self.createStmtParser(
      self.token(.identifier("Ariel"),   start: loc0, end: loc1),
      self.token(.colon,                 start: loc2, end: loc3),
      self.token(.identifier("Mermaid"), start: loc4, end: loc5)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAnnAssign(stmt) else { return }

      XCTAssertExpression(d.target, "Ariel")
      XCTAssertExpression(d.annotation, "Mermaid")
      XCTAssertEqual(d.value, nil)
      XCTAssertEqual(d.isSimple, true)

      XCTAssertStatement(stmt, "(Ariel:Mermaid)")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc5)
    }
  }

  /// Sea.Flounder:Animal = "Friend"
  func test_annAssign_toAttribute() {

    var parser = self.createStmtParser(
      self.token(.identifier("Sea"),      start: loc0, end: loc1),
      self.token(.dot,                    start: loc2, end: loc3),
      self.token(.identifier("Flounder"), start: loc4, end: loc5),
      self.token(.colon,                  start: loc6, end: loc7),
      self.token(.identifier("Animal"),   start: loc8, end: loc9),
      self.token(.equal,                  start: loc10, end: loc11),
      self.token(.string("Friend"),       start: loc12, end: loc13)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAnnAssign(stmt) else { return }

      XCTAssertExpression(d.target, "Sea.Flounder")
      XCTAssertExpression(d.annotation, "Animal")
      XCTAssertExpression(d.value, "'Friend'")
      XCTAssertEqual(d.isSimple, false) // <-- this

      XCTAssertStatement(stmt, "(Sea.Flounder:Animal = 'Friend')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc13)
    }
  }

  /// Sea[Flounder]:Animal = "Friend"
  func test_annAssign_toSubscript() {
    var parser = self.createStmtParser(
      self.token(.identifier("Sea"),      start: loc0, end: loc1),
      self.token(.leftSqb,                start: loc2, end: loc3),
      self.token(.identifier("Flounder"), start: loc4, end: loc5),
      self.token(.rightSqb,               start: loc6, end: loc7),
      self.token(.colon,                  start: loc8, end: loc9),
      self.token(.identifier("Animal"),   start: loc10, end: loc11),
      self.token(.equal,                  start: loc12, end: loc13),
      self.token(.string("Friend"),       start: loc14, end: loc15)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAnnAssign(stmt) else { return }

      XCTAssertExpression(d.target, "Sea[Flounder]")
      XCTAssertExpression(d.annotation, "Animal")
      XCTAssertExpression(d.value, "'Friend'")
      XCTAssertEqual(d.isSimple, false) // <-- this

      XCTAssertStatement(stmt, "(Sea[Flounder]:Animal = 'Friend')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc15)
    }
  }

  /// (Ariel):Mermaid = "Princess"
  func test_annAssign_inParen_isNotSimple() {
    var parser = self.createStmtParser(
      self.token(.leftParen,             start: loc0, end: loc1),
      self.token(.identifier("Ariel"),   start: loc2, end: loc3),
      self.token(.rightParen,            start: loc4, end: loc5),
      self.token(.colon,                 start: loc6, end: loc7),
      self.token(.identifier("Mermaid"), start: loc8, end: loc9),
      self.token(.equal,                 start: loc10, end: loc11),
      self.token(.string("Princess"),    start: loc12, end: loc13)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAnnAssign(stmt) else { return }

      XCTAssertExpression(d.target, "Ariel")
      XCTAssertExpression(d.annotation, "Mermaid")
      XCTAssertExpression(d.value, "'Princess'")
      XCTAssertEqual(d.isSimple, false) // <-- this (because parens!)

      XCTAssertStatement(stmt, "(Ariel:Mermaid = 'Princess')")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc13)
    }
  }

  /// 3:Witch = "Ursula"
  func test_annAssign_toConstants_throws() {
    var parser = self.createStmtParser(
      self.token(.int(PyInt(3)),       start: loc0, end: loc1),
      self.token(.colon,               start: loc2, end: loc3),
      self.token(.identifier("Witch"), start: loc4, end: loc5),
      self.token(.equal,               start: loc6, end: loc7),
      self.token(.string("Ursula"),    start: loc8, end: loc9)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .illegalAnnAssignmentTarget)
      XCTAssertEqual(error.location, loc0)
    }
  }

  // MARK: - Normal assignment

  /// Ariel = "Princess"
  func test_normalAssign() {
    var parser = self.createStmtParser(
      self.token(.identifier("Ariel"), start: loc0, end: loc1),
      self.token(.equal,               start: loc2, end: loc3),
      self.token(.string("Princess"),  start: loc4, end: loc5)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAssign(stmt) else { return }

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
  func test_normalAssign_toTuple() {
    var parser = self.createStmtParser(
      self.token(.identifier("Ariel"), start: loc0, end: loc1),
      self.token(.comma,               start: loc2, end: loc3),
      self.token(.identifier("Eric"),  start: loc4, end: loc5),
      self.token(.equal,               start: loc6, end: loc7),
      self.token(.string("couple"),    start: loc8, end: loc9)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAssign(stmt) else { return }

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
  func test_normalAssign_withComma_isTuple() {
    var parser = self.createStmtParser(
      self.token(.identifier("Ariel"), start: loc0, end: loc1),
      self.token(.comma,               start: loc2, end: loc3),
      self.token(.equal,               start: loc4, end: loc5),
      self.token(.string("Princess"),  start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAssign(stmt) else { return }

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
  func test_normalAssign_multiple() {
    var parser = self.createStmtParser(
      self.token(.identifier("Sebastian"), start: loc0, end: loc1),
      self.token(.equal,                   start: loc2, end: loc3),
      self.token(.identifier("Flounder"),  start: loc4, end: loc5),
      self.token(.equal,                   start: loc6, end: loc7),
      self.token(.string("Friend"),        start: loc8, end: loc9)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAssign(stmt) else { return }

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
  func test_normalAssign_yieldValue() {
    var parser = self.createStmtParser(
      self.token(.identifier("Ariel"), start: loc0, end: loc1),
      self.token(.equal,               start: loc2, end: loc3),
      self.token(.yield,               start: loc4, end: loc5),
      self.token(.string("Princess"),  start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructAssign(stmt) else { return }

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
  func test_normalAssign_yieldTarget() {
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

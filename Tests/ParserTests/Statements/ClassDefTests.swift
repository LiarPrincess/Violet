import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length
// swiftlint:disable type_body_length
// swiftlint:disable function_body_length

// TODO: decoratorList

class ClassDefTests: XCTestCase,
  Common, DestructExpressionKind, DestructStatementKind {

  // MARK: - No base

  /// class Princess: "Sing"
  func test_noBase() {
    var parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Princess"), start: loc2, end: loc3),
      self.token(.colon,                  start: loc4, end: loc5),
      self.token(.string("Sing"),         start: loc6, end: loc7)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructClassDef(stmt) else { return }

      XCTAssertEqual(d.name, "Princess")
      XCTAssertEqual(d.bases, [])
      XCTAssertEqual(d.keywords, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Sing\"")

      XCTAssertStatement(stmt, "(class Princess body: \"Sing\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc7)
    }
  }

  /// class Princess(): "Sing"
  func test_noBase_emptyParens() {
    var parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Princess"), start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.rightParen,             start: loc6, end: loc7),
      self.token(.colon,                  start: loc8, end: loc9),
      self.token(.string("Sing"),         start: loc10, end: loc11)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructClassDef(stmt) else { return }

      XCTAssertEqual(d.name, "Princess")
      XCTAssertEqual(d.bases, [])
      XCTAssertEqual(d.keywords, [])

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Sing\"")

      XCTAssertStatement(stmt, "(class Princess body: \"Sing\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc11)
    }
  }

  // MARK: - Bases

  /// class Aurora(Princess): "Sleep"
  func test_base_single() {
    var parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Aurora"),   start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("Princess"), start: loc6, end: loc7),
      self.token(.rightParen,             start: loc8, end: loc9),
      self.token(.colon,                  start: loc10, end: loc11),
      self.token(.string("Sleep"),        start: loc12, end: loc13)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructClassDef(stmt) else { return }

      XCTAssertEqual(d.name, "Aurora")
      XCTAssertEqual(d.keywords, [])

      XCTAssertEqual(d.bases.count, 1)
      guard d.bases.count == 1 else { return }
      XCTAssertExpression(d.bases[0], "Princess")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Sleep\"")

      XCTAssertStatement(stmt, "(class Aurora (Princess) body: \"Sleep\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc13)
    }
  }

  /// class Aurora(Princess,): "Sleep"
  func test_base_withCommaAfter() {
    var parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Aurora"),   start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("Princess"), start: loc6, end: loc7),
      self.token(.comma,                  start: loc8, end: loc9),
      self.token(.rightParen,             start: loc10, end: loc11),
      self.token(.colon,                  start: loc12, end: loc13),
      self.token(.string("Sleep"),        start: loc14, end: loc15)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructClassDef(stmt) else { return }

      XCTAssertEqual(d.name, "Aurora")
      XCTAssertEqual(d.keywords, [])

      XCTAssertEqual(d.bases.count, 1)
      guard d.bases.count == 1 else { return }
      XCTAssertExpression(d.bases[0], "Princess")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Sleep\"")

      XCTAssertStatement(stmt, "(class Aurora (Princess) body: \"Sleep\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc15)
    }
  }

  /// class Aurora(Princess, Human): "Sleep"
  func test_base_multiple() {
    var parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Aurora"),   start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("Princess"), start: loc6, end: loc7),
      self.token(.comma,                  start: loc8, end: loc9),
      self.token(.identifier("Human"),    start: loc10, end: loc11),
      self.token(.rightParen,             start: loc12, end: loc13),
      self.token(.colon,                  start: loc14, end: loc15),
      self.token(.string("Sleep"),        start: loc16, end: loc17)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructClassDef(stmt) else { return }

      XCTAssertEqual(d.name, "Aurora")
      XCTAssertEqual(d.keywords, [])

      XCTAssertEqual(d.bases.count, 2)
      guard d.bases.count == 2 else { return }
      XCTAssertExpression(d.bases[0], "Princess")
      XCTAssertExpression(d.bases[1], "Human")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Sleep\"")

      XCTAssertStatement(stmt, "(class Aurora (Princess Human) body: \"Sleep\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc17)
    }
  }

  /// class Aurora((Princess)): "Sleep"
  func test_base_withAdditionalParens() {
    var parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Aurora"),   start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.leftParen,              start: loc6, end: loc7),
      self.token(.identifier("Princess"), start: loc8, end: loc9),
      self.token(.rightParen,             start: loc10, end: loc11),
      self.token(.rightParen,             start: loc12, end: loc13),
      self.token(.colon,                  start: loc14, end: loc15),
      self.token(.string("Sleep"),        start: loc16, end: loc17)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructClassDef(stmt) else { return }

      XCTAssertEqual(d.name, "Aurora")
      XCTAssertEqual(d.keywords, [])

      XCTAssertEqual(d.bases.count, 1)
      guard d.bases.count == 1 else { return }
      XCTAssertExpression(d.bases[0], "Princess")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Sleep\"")

      XCTAssertStatement(stmt, "(class Aurora (Princess) body: \"Sleep\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc17)
    }
  }

  /// class Aurora(Princess=1, Human): "Sleep"
  func test_base_afterKeyword_throws() {
    var parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Aurora"),   start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("Princess"), start: loc6, end: loc7),
      self.token(.equal,                  start: loc8, end: loc9),
      self.token(.float(1.0),             start: loc10, end: loc11),
      self.token(.comma,                  start: loc12, end: loc13),
      self.token(.identifier("Human"),    start: loc14, end: loc15),
      self.token(.rightParen,             start: loc16, end: loc17),
      self.token(.colon,                  start: loc18, end: loc19),
      self.token(.string("Sleep"),        start: loc20, end: loc21)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .callWithPositionalArgumentAfterKeywordArgument)
      XCTAssertEqual(error.location, loc14)
    }
  }

  /// class Aurora(**Princess, Human): "Sleep"
  func test_base_afterKeywordUnpacking_throws() {
    var parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Aurora"),   start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.starStar,               start: loc6, end: loc7),
      self.token(.identifier("Princess"), start: loc8, end: loc9),
      self.token(.comma,                  start: loc10, end: loc11),
      self.token(.identifier("Human"),    start: loc12, end: loc13),
      self.token(.rightParen,             start: loc14, end: loc15),
      self.token(.colon,                  start: loc16, end: loc17),
      self.token(.string("Sleep"),        start: loc18, end: loc19)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .callWithPositionalArgumentAfterKeywordUnpacking)
      XCTAssertEqual(error.location, loc12)
    }
  }

  // MARK: - Base - star

  /// class Aurora(*Princess): "Sleep"
  func test_base_withStar() {
    var parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Aurora"),   start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.star,                   start: loc6, end: loc7),
      self.token(.identifier("Princess"), start: loc8, end: loc9),
      self.token(.rightParen,             start: loc10, end: loc11),
      self.token(.colon,                  start: loc12, end: loc13),
      self.token(.string("Sleep"),        start: loc14, end: loc15)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructClassDef(stmt) else { return }

      XCTAssertEqual(d.name, "Aurora")
      XCTAssertEqual(d.keywords, [])

      XCTAssertEqual(d.bases.count, 1)
      guard d.bases.count == 1 else { return }
      XCTAssertExpression(d.bases[0], "*Princess")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Sleep\"")

      XCTAssertStatement(stmt, "(class Aurora (*Princess) body: \"Sleep\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc15)
    }
  }

  /// class Aurora(Princess=1, *Human): "Sleep"
  func test_base_withStar_afterKeyword() {
    var parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Aurora"),   start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("Princess"), start: loc6, end: loc7),
      self.token(.equal,                  start: loc8, end: loc9),
      self.token(.float(1.0),             start: loc10, end: loc11),
      self.token(.comma,                  start: loc12, end: loc13),
      self.token(.star,                   start: loc14, end: loc15),
      self.token(.identifier("Human"),    start: loc16, end: loc17),
      self.token(.rightParen,             start: loc18, end: loc19),
      self.token(.colon,                  start: loc20, end: loc21),
      self.token(.string("Sleep"),        start: loc22, end: loc23)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructClassDef(stmt) else { return }

      XCTAssertEqual(d.name, "Aurora")

      XCTAssertEqual(d.bases.count, 1)
      guard d.bases.count == 1 else { return }
      XCTAssertExpression(d.bases[0], "*Human")

      XCTAssertEqual(d.keywords.count, 1)
      guard d.keywords.count == 1 else { return }
      XCTAssertKeyword(d.keywords[0], "Princess=1.0")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Sleep\"")

      XCTAssertStatement(stmt, "(class Aurora (*Human Princess=1.0) body: \"Sleep\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc23)
    }
  }

  /// class Aurora(**Princess, *Human): "Sleep"
  func test_base_withStar_afterKeywordUnpacking_throws() {
    var parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Aurora"),   start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.starStar,               start: loc6, end: loc7),
      self.token(.identifier("Princess"), start: loc8, end: loc9),
      self.token(.comma,                  start: loc10, end: loc11),
      self.token(.star,                   start: loc12, end: loc13),
      self.token(.identifier("Human"),    start: loc14, end: loc15),
      self.token(.rightParen,             start: loc16, end: loc17),
      self.token(.colon,                  start: loc18, end: loc19),
      self.token(.string("Sleep"),        start: loc20, end: loc21)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .callWithIterableArgumentAfterKeywordUnpacking)
      XCTAssertEqual(error.location, loc12)
    }
  }

  // MARK: - Keyword

  /// class Aurora(Princess=1): "Sleep"
  func test_keyword_single() {
    var parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Aurora"),   start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("Princess"), start: loc6, end: loc7),
      self.token(.equal,                  start: loc8, end: loc9),
      self.token(.float(1.0),             start: loc10, end: loc11),
      self.token(.rightParen,             start: loc12, end: loc13),
      self.token(.colon,                  start: loc14, end: loc15),
      self.token(.string("Sleep"),        start: loc16, end: loc17)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructClassDef(stmt) else { return }

      XCTAssertEqual(d.name, "Aurora")
      XCTAssertEqual(d.bases.count, 0)

      XCTAssertEqual(d.keywords.count, 1)
      guard d.keywords.count == 1 else { return }
      XCTAssertKeyword(d.keywords[0], "Princess=1.0")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Sleep\"")

      XCTAssertStatement(stmt, "(class Aurora (Princess=1.0) body: \"Sleep\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc17)
    }
  }

  /// class Aurora(Princess=1, Human=2): "Sleep"
  func test_keyword_multiple() {
    var parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Aurora"),   start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("Princess"), start: loc6, end: loc7),
      self.token(.equal,                  start: loc8, end: loc9),
      self.token(.float(1.0),             start: loc10, end: loc11),
      self.token(.comma,                  start: loc12, end: loc13),
      self.token(.identifier("Human"),    start: loc14, end: loc15),
      self.token(.equal,                  start: loc16, end: loc17),
      self.token(.float(2.0),             start: loc18, end: loc19),
      self.token(.rightParen,             start: loc20, end: loc21),
      self.token(.colon,                  start: loc22, end: loc23),
      self.token(.string("Sleep"),        start: loc24, end: loc25)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructClassDef(stmt) else { return }

      XCTAssertEqual(d.name, "Aurora")
      XCTAssertEqual(d.bases.count, 0)

      XCTAssertEqual(d.keywords.count, 2)
      guard d.keywords.count == 2 else { return }
      XCTAssertKeyword(d.keywords[0], "Princess=1.0")
      XCTAssertKeyword(d.keywords[1], "Human=2.0")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Sleep\"")

      XCTAssertStatement(stmt, "(class Aurora (Princess=1.0 Human=2.0) body: \"Sleep\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc25)
    }
  }

  /// class Aurora(Princess=1, Princess=2): "Sleep"
  func test_keyword_duplicate_throws() {
    var parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Aurora"),   start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("Princess"), start: loc6, end: loc7),
      self.token(.equal,                  start: loc8, end: loc9),
      self.token(.float(1.0),             start: loc10, end: loc11),
      self.token(.comma,                  start: loc12, end: loc13),
      self.token(.identifier("Princess"), start: loc14, end: loc15),
      self.token(.equal,                  start: loc16, end: loc17),
      self.token(.float(2.0),             start: loc18, end: loc19),
      self.token(.rightParen,             start: loc20, end: loc21),
      self.token(.colon,                  start: loc22, end: loc23),
      self.token(.string("Sleep"),        start: loc24, end: loc25)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .callWithDuplicateKeywordArgument("Princess"))
      XCTAssertEqual(error.location, loc14)
    }
  }

  /// From comment in CPython:
  /// class Aurora(lambda x: x[0] = 3): "Sleep"
  /// I have no idea what would that even mean in class context.
  func test_keyword_lambda_assignment_throws() {
    var parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Aurora"),   start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.lambda,                 start: loc6, end: loc7),
      self.token(.identifier("x"),        start: loc8, end: loc9),
      self.token(.colon,                  start: loc10, end: loc11),
      self.token(.identifier("x"),        start: loc12, end: loc13),
      self.token(.leftSqb,                start: loc14, end: loc15),
      self.token(.int(PyInt(0)),          start: loc16, end: loc17),
      self.token(.rightSqb,               start: loc18, end: loc19),
      self.token(.equal,                  start: loc20, end: loc21),
      self.token(.int(PyInt(3)),          start: loc20, end: loc21),
      self.token(.rightParen,             start: loc22, end: loc23),
      self.token(.colon,                  start: loc24, end: loc25),
      self.token(.string("Sleep"),        start: loc26, end: loc27)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .callWithLambdaAssignment)
      XCTAssertEqual(error.location, loc6)
    }
  }

  /// class Aurora(3=1): "Sleep"
  func test_keyword_invalidName_throws() {
    var parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Aurora"),   start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.int(PyInt(3)),          start: loc6, end: loc7),
      self.token(.equal,                  start: loc8, end: loc9),
      self.token(.int(PyInt(1)),          start: loc10, end: loc11),
      self.token(.rightParen,             start: loc12, end: loc13),
      self.token(.colon,                  start: loc14, end: loc15),
      self.token(.string("Sleep"),        start: loc16, end: loc17)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .callWithKeywordExpression)
      XCTAssertEqual(error.location, loc6)
    }
  }

  // MARK: - Keyword - star star

  /// class Aurora(**Princess): "Sleep"
  func test_keyword_withStarStar() {
    var parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Aurora"),   start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.starStar,               start: loc6, end: loc7),
      self.token(.identifier("Princess"), start: loc8, end: loc9),
      self.token(.rightParen,             start: loc10, end: loc11),
      self.token(.colon,                  start: loc12, end: loc13),
      self.token(.string("Sleep"),        start: loc14, end: loc15)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructClassDef(stmt) else { return }

      XCTAssertEqual(d.name, "Aurora")
      XCTAssertEqual(d.bases.count, 0)

      XCTAssertEqual(d.keywords.count, 1)
      guard d.keywords.count == 1 else { return }
      XCTAssertKeyword(d.keywords[0], "**Princess")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Sleep\"")

      XCTAssertStatement(stmt, "(class Aurora (**Princess) body: \"Sleep\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc15)
    }
  }

  /// class Aurora(Princess, **Human): "Sleep"
  func test_keyword_withStarStar_afterNormal() {
    var parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Aurora"),   start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("Princess"), start: loc6, end: loc7),
      self.token(.comma,                  start: loc8, end: loc9),
      self.token(.starStar,               start: loc10, end: loc11),
      self.token(.identifier("Human"),    start: loc12, end: loc13),
      self.token(.rightParen,             start: loc14, end: loc15),
      self.token(.colon,                  start: loc16, end: loc17),
      self.token(.string("Sleep"),        start: loc18, end: loc19)
    )

    if let stmt = self.parseStmt(&parser) {
      guard let d = self.destructClassDef(stmt) else { return }

      XCTAssertEqual(d.name, "Aurora")

      XCTAssertEqual(d.bases.count, 1)
      guard d.bases.count == 1 else { return }
      XCTAssertExpression(d.bases[0], "Princess")

      XCTAssertEqual(d.keywords.count, 1)
      guard d.keywords.count == 2 else { return }
      XCTAssertKeyword(d.keywords[1], "**Human")

      XCTAssertEqual(d.body.count, 1)
      guard d.body.count == 1 else { return }
      XCTAssertStatement(d.body[0], "\"Sleep\"")

      XCTAssertStatement(stmt, "(class Aurora (Princess **Human) body: \"Sleep\")")
      XCTAssertEqual(stmt.start, loc0)
      XCTAssertEqual(stmt.end,   loc19)
    }
  }

  // MARK: - Comprehension/generator

  /// class Aurora(a for b in []): "Sleep"
  func test_generator_throws() {
    var parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Aurora"),   start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("a"),        start: loc6, end: loc7),
      self.token(.for,                    start: loc8, end: loc9),
      self.token(.identifier("b"),        start: loc10, end: loc11),
      self.token(.in,                     start: loc12, end: loc13),
      self.token(.leftSqb,                start: loc14, end: loc15),
      self.token(.rightSqb,               start: loc16, end: loc17),
      self.token(.rightParen,             start: loc18, end: loc19),
      self.token(.colon,                  start: loc20, end: loc21),
      self.token(.string("Sleep"),        start: loc22, end: loc23)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .baseClassWithGenerator)
      XCTAssertEqual(error.location, loc6)
    }
  }
}

import XCTest
import BigInt
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftlint:disable file_length
// swiftlint:disable function_body_length
// swiftformat:disable consecutiveSpaces

class ParseClassDef: XCTestCase {

  // MARK: - No base

  /// class Princess: "Sing"
  func test_noBase() {
    let parser = createStmtParser(
      createToken(.class,                  start: loc0, end: loc1),
      createToken(.identifier("Princess"), start: loc2, end: loc3),
      createToken(.colon,                  start: loc4, end: loc5),
      createToken(.string("Sing"),         start: loc6, end: loc7)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      ClassDefStmt(start: 0:0, end: 7:12)
        Name: Princess
        Bases: none
        Keywords: none
        Body
          ExprStmt(start: 6:6, end: 7:12)
            StringExpr(context: Load, start: 6:6, end: 7:12)
              String: 'Sing'
        Decorators: none
    """)
  }

  /// class Princess(): "Sing"
  func test_noBase_emptyParens() {
    let parser = createStmtParser(
      createToken(.class,                  start: loc0, end: loc1),
      createToken(.identifier("Princess"), start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.rightParen,             start: loc6, end: loc7),
      createToken(.colon,                  start: loc8, end: loc9),
      createToken(.string("Sing"),         start: loc10, end: loc11)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 11:16)
      ClassDefStmt(start: 0:0, end: 11:16)
        Name: Princess
        Bases: none
        Keywords: none
        Body
          ExprStmt(start: 10:10, end: 11:16)
            StringExpr(context: Load, start: 10:10, end: 11:16)
              String: 'Sing'
        Decorators: none
    """)
  }

  // MARK: - Bases

  /// class Aurora(Princess): "Sleep"
  func test_base_single() {
    let parser = createStmtParser(
      createToken(.class,                  start: loc0, end: loc1),
      createToken(.identifier("Aurora"),   start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.identifier("Princess"), start: loc6, end: loc7),
      createToken(.rightParen,             start: loc8, end: loc9),
      createToken(.colon,                  start: loc10, end: loc11),
      createToken(.string("Sleep"),        start: loc12, end: loc13)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 13:18)
      ClassDefStmt(start: 0:0, end: 13:18)
        Name: Aurora
        Bases
          IdentifierExpr(context: Load, start: 6:6, end: 7:12)
            Value: Princess
        Keywords: none
        Body
          ExprStmt(start: 12:12, end: 13:18)
            StringExpr(context: Load, start: 12:12, end: 13:18)
              String: 'Sleep'
        Decorators: none
    """)
  }

  /// class Aurora(Princess,): "Sleep"
  func test_base_withCommaAfter() {
    let parser = createStmtParser(
      createToken(.class,                  start: loc0, end: loc1),
      createToken(.identifier("Aurora"),   start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.identifier("Princess"), start: loc6, end: loc7),
      createToken(.comma,                  start: loc8, end: loc9),
      createToken(.rightParen,             start: loc10, end: loc11),
      createToken(.colon,                  start: loc12, end: loc13),
      createToken(.string("Sleep"),        start: loc14, end: loc15)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      ClassDefStmt(start: 0:0, end: 15:20)
        Name: Aurora
        Bases
          IdentifierExpr(context: Load, start: 6:6, end: 7:12)
            Value: Princess
        Keywords: none
        Body
          ExprStmt(start: 14:14, end: 15:20)
            StringExpr(context: Load, start: 14:14, end: 15:20)
              String: 'Sleep'
        Decorators: none
    """)
  }

  /// class Aurora(Princess, Human): "Sleep"
  func test_base_multiple() {
    let parser = createStmtParser(
      createToken(.class,                  start: loc0, end: loc1),
      createToken(.identifier("Aurora"),   start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.identifier("Princess"), start: loc6, end: loc7),
      createToken(.comma,                  start: loc8, end: loc9),
      createToken(.identifier("Human"),    start: loc10, end: loc11),
      createToken(.rightParen,             start: loc12, end: loc13),
      createToken(.colon,                  start: loc14, end: loc15),
      createToken(.string("Sleep"),        start: loc16, end: loc17)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 17:22)
      ClassDefStmt(start: 0:0, end: 17:22)
        Name: Aurora
        Bases
          IdentifierExpr(context: Load, start: 6:6, end: 7:12)
            Value: Princess
          IdentifierExpr(context: Load, start: 10:10, end: 11:16)
            Value: Human
        Keywords: none
        Body
          ExprStmt(start: 16:16, end: 17:22)
            StringExpr(context: Load, start: 16:16, end: 17:22)
              String: 'Sleep'
        Decorators: none
    """)
  }

  /// class Aurora((Princess)): "Sleep"
  func test_base_withAdditionalParens() {
    let parser = createStmtParser(
      createToken(.class,                  start: loc0, end: loc1),
      createToken(.identifier("Aurora"),   start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.leftParen,              start: loc6, end: loc7),
      createToken(.identifier("Princess"), start: loc8, end: loc9),
      createToken(.rightParen,             start: loc10, end: loc11),
      createToken(.rightParen,             start: loc12, end: loc13),
      createToken(.colon,                  start: loc14, end: loc15),
      createToken(.string("Sleep"),        start: loc16, end: loc17)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 17:22)
      ClassDefStmt(start: 0:0, end: 17:22)
        Name: Aurora
        Bases
          IdentifierExpr(context: Load, start: 6:6, end: 11:16)
            Value: Princess
        Keywords: none
        Body
          ExprStmt(start: 16:16, end: 17:22)
            StringExpr(context: Load, start: 16:16, end: 17:22)
              String: 'Sleep'
        Decorators: none
    """)
  }

  /// class Aurora(Princess=1, Human): "Sleep"
  func test_base_afterKeyword_throws() {
    let parser = createStmtParser(
      createToken(.class,                  start: loc0, end: loc1),
      createToken(.identifier("Aurora"),   start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.identifier("Princess"), start: loc6, end: loc7),
      createToken(.equal,                  start: loc8, end: loc9),
      createToken(.float(1.0),             start: loc10, end: loc11),
      createToken(.comma,                  start: loc12, end: loc13),
      createToken(.identifier("Human"),    start: loc14, end: loc15),
      createToken(.rightParen,             start: loc16, end: loc17),
      createToken(.colon,                  start: loc18, end: loc19),
      createToken(.string("Sleep"),        start: loc20, end: loc21)
    )

    if let error = parseError(parser) {
      XCTAssertEqual(error.kind, .callWithPositionalArgumentAfterKeywordArgument)
      XCTAssertEqual(error.location, loc14)
    }
  }

  /// class Aurora(**Princess, Human): "Sleep"
  func test_base_afterKeywordUnpacking_throws() {
    let parser = createStmtParser(
      createToken(.class,                  start: loc0, end: loc1),
      createToken(.identifier("Aurora"),   start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.starStar,               start: loc6, end: loc7),
      createToken(.identifier("Princess"), start: loc8, end: loc9),
      createToken(.comma,                  start: loc10, end: loc11),
      createToken(.identifier("Human"),    start: loc12, end: loc13),
      createToken(.rightParen,             start: loc14, end: loc15),
      createToken(.colon,                  start: loc16, end: loc17),
      createToken(.string("Sleep"),        start: loc18, end: loc19)
    )

    if let error = parseError(parser) {
      XCTAssertEqual(error.kind, .callWithPositionalArgumentAfterKeywordUnpacking)
      XCTAssertEqual(error.location, loc12)
    }
  }

  // MARK: - Base - star

  /// class Aurora(*Princess): "Sleep"
  func test_base_withStar() {
    let parser = createStmtParser(
      createToken(.class,                  start: loc0, end: loc1),
      createToken(.identifier("Aurora"),   start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.star,                   start: loc6, end: loc7),
      createToken(.identifier("Princess"), start: loc8, end: loc9),
      createToken(.rightParen,             start: loc10, end: loc11),
      createToken(.colon,                  start: loc12, end: loc13),
      createToken(.string("Sleep"),        start: loc14, end: loc15)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      ClassDefStmt(start: 0:0, end: 15:20)
        Name: Aurora
        Bases
          StarredExpr(context: Load, start: 6:6, end: 9:14)
            Expression
              IdentifierExpr(context: Load, start: 8:8, end: 9:14)
                Value: Princess
        Keywords: none
        Body
          ExprStmt(start: 14:14, end: 15:20)
            StringExpr(context: Load, start: 14:14, end: 15:20)
              String: 'Sleep'
        Decorators: none
    """)
  }

  /// class Aurora(Princess=1, *Human): "Sleep"
  func test_base_withStar_afterKeyword() {
    let parser = createStmtParser(
      createToken(.class,                  start: loc0, end: loc1),
      createToken(.identifier("Aurora"),   start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.identifier("Princess"), start: loc6, end: loc7),
      createToken(.equal,                  start: loc8, end: loc9),
      createToken(.float(1.0),             start: loc10, end: loc11),
      createToken(.comma,                  start: loc12, end: loc13),
      createToken(.star,                   start: loc14, end: loc15),
      createToken(.identifier("Human"),    start: loc16, end: loc17),
      createToken(.rightParen,             start: loc18, end: loc19),
      createToken(.colon,                  start: loc20, end: loc21),
      createToken(.string("Sleep"),        start: loc22, end: loc23)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 23:28)
      ClassDefStmt(start: 0:0, end: 23:28)
        Name: Aurora
        Bases
          StarredExpr(context: Load, start: 14:14, end: 17:22)
            Expression
              IdentifierExpr(context: Load, start: 16:16, end: 17:22)
                Value: Human
        Keywords
          Keyword(start: 6:6, end: 11:16)
            Kind
              Named('Princess')
            Value
              FloatExpr(context: Load, start: 10:10, end: 11:16)
                Value: 1.0
        Body
          ExprStmt(start: 22:22, end: 23:28)
            StringExpr(context: Load, start: 22:22, end: 23:28)
              String: 'Sleep'
        Decorators: none
    """)
  }

  /// class Aurora(**Princess, *Human): "Sleep"
  func test_base_withStar_afterKeywordUnpacking_throws() {
    let parser = createStmtParser(
      createToken(.class,                  start: loc0, end: loc1),
      createToken(.identifier("Aurora"),   start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.starStar,               start: loc6, end: loc7),
      createToken(.identifier("Princess"), start: loc8, end: loc9),
      createToken(.comma,                  start: loc10, end: loc11),
      createToken(.star,                   start: loc12, end: loc13),
      createToken(.identifier("Human"),    start: loc14, end: loc15),
      createToken(.rightParen,             start: loc16, end: loc17),
      createToken(.colon,                  start: loc18, end: loc19),
      createToken(.string("Sleep"),        start: loc20, end: loc21)
    )

    if let error = parseError(parser) {
      XCTAssertEqual(error.kind, .callWithIterableArgumentAfterKeywordUnpacking)
      XCTAssertEqual(error.location, loc12)
    }
  }

  // MARK: - Keyword

  /// class Aurora(Princess=1): "Sleep"
  func test_keyword_single() {
    let parser = createStmtParser(
      createToken(.class,                  start: loc0, end: loc1),
      createToken(.identifier("Aurora"),   start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.identifier("Princess"), start: loc6, end: loc7),
      createToken(.equal,                  start: loc8, end: loc9),
      createToken(.float(1.0),             start: loc10, end: loc11),
      createToken(.rightParen,             start: loc12, end: loc13),
      createToken(.colon,                  start: loc14, end: loc15),
      createToken(.string("Sleep"),        start: loc16, end: loc17)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 17:22)
      ClassDefStmt(start: 0:0, end: 17:22)
        Name: Aurora
        Bases: none
        Keywords
          Keyword(start: 6:6, end: 11:16)
            Kind
              Named('Princess')
            Value
              FloatExpr(context: Load, start: 10:10, end: 11:16)
                Value: 1.0
        Body
          ExprStmt(start: 16:16, end: 17:22)
            StringExpr(context: Load, start: 16:16, end: 17:22)
              String: 'Sleep'
        Decorators: none
    """)
  }

  /// class Aurora(Princess=1, Human=2): "Sleep"
  func test_keyword_multiple() {
    let parser = createStmtParser(
      createToken(.class,                  start: loc0, end: loc1),
      createToken(.identifier("Aurora"),   start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.identifier("Princess"), start: loc6, end: loc7),
      createToken(.equal,                  start: loc8, end: loc9),
      createToken(.float(1.0),             start: loc10, end: loc11),
      createToken(.comma,                  start: loc12, end: loc13),
      createToken(.identifier("Human"),    start: loc14, end: loc15),
      createToken(.equal,                  start: loc16, end: loc17),
      createToken(.float(2.0),             start: loc18, end: loc19),
      createToken(.rightParen,             start: loc20, end: loc21),
      createToken(.colon,                  start: loc22, end: loc23),
      createToken(.string("Sleep"),        start: loc24, end: loc25)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 25:30)
      ClassDefStmt(start: 0:0, end: 25:30)
        Name: Aurora
        Bases: none
        Keywords
          Keyword(start: 6:6, end: 11:16)
            Kind
              Named('Princess')
            Value
              FloatExpr(context: Load, start: 10:10, end: 11:16)
                Value: 1.0
          Keyword(start: 14:14, end: 19:24)
            Kind
              Named('Human')
            Value
              FloatExpr(context: Load, start: 18:18, end: 19:24)
                Value: 2.0
        Body
          ExprStmt(start: 24:24, end: 25:30)
            StringExpr(context: Load, start: 24:24, end: 25:30)
              String: 'Sleep'
        Decorators: none
    """)
  }

  /// class Aurora(Princess=1, Princess=2): "Sleep"
  func test_keyword_duplicate_throws() {
    let parser = createStmtParser(
      createToken(.class,                  start: loc0, end: loc1),
      createToken(.identifier("Aurora"),   start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.identifier("Princess"), start: loc6, end: loc7),
      createToken(.equal,                  start: loc8, end: loc9),
      createToken(.float(1.0),             start: loc10, end: loc11),
      createToken(.comma,                  start: loc12, end: loc13),
      createToken(.identifier("Princess"), start: loc14, end: loc15),
      createToken(.equal,                  start: loc16, end: loc17),
      createToken(.float(2.0),             start: loc18, end: loc19),
      createToken(.rightParen,             start: loc20, end: loc21),
      createToken(.colon,                  start: loc22, end: loc23),
      createToken(.string("Sleep"),        start: loc24, end: loc25)
    )

    if let error = parseError(parser) {
      XCTAssertEqual(error.kind, .callWithDuplicateKeywordArgument("Princess"))
      XCTAssertEqual(error.location, loc14)
    }
  }

  /// From comment in CPython:
  /// class Aurora(lambda x: x[0] = 3): "Sleep"
  /// I have no idea what would that even mean in class context.
  func test_keyword_lambda_assignment_throws() {
    let parser = createStmtParser(
      createToken(.class,                   start: loc0, end: loc1),
      createToken(.identifier("Aurora"),    start: loc2, end: loc3),
      createToken(.leftParen,               start: loc4, end: loc5),
      createToken(.lambda,                  start: loc6, end: loc7),
      createToken(.identifier("x"),         start: loc8, end: loc9),
      createToken(.colon,                   start: loc10, end: loc11),
      createToken(.identifier("x"),         start: loc12, end: loc13),
      createToken(.leftSqb,                 start: loc14, end: loc15),
      createToken(.int(BigInt(0)),          start: loc16, end: loc17),
      createToken(.rightSqb,                start: loc18, end: loc19),
      createToken(.equal,                   start: loc20, end: loc21),
      createToken(.int(BigInt(3)),          start: loc20, end: loc21),
      createToken(.rightParen,              start: loc22, end: loc23),
      createToken(.colon,                   start: loc24, end: loc25),
      createToken(.string("Sleep"),         start: loc26, end: loc27)
    )

    if let error = parseError(parser) {
      XCTAssertEqual(error.kind, .callWithLambdaAssignment)
      XCTAssertEqual(error.location, loc6)
    }
  }

  /// class Aurora(3=1): "Sleep"
  func test_keyword_invalidName_throws() {
    let parser = createStmtParser(
      createToken(.class,                   start: loc0, end: loc1),
      createToken(.identifier("Aurora"),    start: loc2, end: loc3),
      createToken(.leftParen,               start: loc4, end: loc5),
      createToken(.int(BigInt(3)),          start: loc6, end: loc7),
      createToken(.equal,                   start: loc8, end: loc9),
      createToken(.int(BigInt(1)),          start: loc10, end: loc11),
      createToken(.rightParen,              start: loc12, end: loc13),
      createToken(.colon,                   start: loc14, end: loc15),
      createToken(.string("Sleep"),         start: loc16, end: loc17)
    )

    if let error = parseError(parser) {
      XCTAssertEqual(error.kind, .callWithKeywordExpression)
      XCTAssertEqual(error.location, loc6)
    }
  }

  // MARK: - Keyword - star star

  /// class Aurora(**Princess): "Sleep"
  func test_keyword_withStarStar() {
    let parser = createStmtParser(
      createToken(.class,                  start: loc0, end: loc1),
      createToken(.identifier("Aurora"),   start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.starStar,               start: loc6, end: loc7),
      createToken(.identifier("Princess"), start: loc8, end: loc9),
      createToken(.rightParen,             start: loc10, end: loc11),
      createToken(.colon,                  start: loc12, end: loc13),
      createToken(.string("Sleep"),        start: loc14, end: loc15)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      ClassDefStmt(start: 0:0, end: 15:20)
        Name: Aurora
        Bases: none
        Keywords
          Keyword(start: 6:6, end: 9:14)
            Kind
              DictionaryUnpack
            Value
              IdentifierExpr(context: Load, start: 8:8, end: 9:14)
                Value: Princess
        Body
          ExprStmt(start: 14:14, end: 15:20)
            StringExpr(context: Load, start: 14:14, end: 15:20)
              String: 'Sleep'
        Decorators: none
    """)
  }

  /// class Aurora(Princess, **Human): "Sleep"
  func test_keyword_withStarStar_afterNormal() {
    let parser = createStmtParser(
      createToken(.class,                  start: loc0, end: loc1),
      createToken(.identifier("Aurora"),   start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.identifier("Princess"), start: loc6, end: loc7),
      createToken(.comma,                  start: loc8, end: loc9),
      createToken(.starStar,               start: loc10, end: loc11),
      createToken(.identifier("Human"),    start: loc12, end: loc13),
      createToken(.rightParen,             start: loc14, end: loc15),
      createToken(.colon,                  start: loc16, end: loc17),
      createToken(.string("Sleep"),        start: loc18, end: loc19)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 19:24)
      ClassDefStmt(start: 0:0, end: 19:24)
        Name: Aurora
        Bases
          IdentifierExpr(context: Load, start: 6:6, end: 7:12)
            Value: Princess
        Keywords
          Keyword(start: 10:10, end: 13:18)
            Kind
              DictionaryUnpack
            Value
              IdentifierExpr(context: Load, start: 12:12, end: 13:18)
                Value: Human
        Body
          ExprStmt(start: 18:18, end: 19:24)
            StringExpr(context: Load, start: 18:18, end: 19:24)
              String: 'Sleep'
        Decorators: none
    """)
  }

  // MARK: - Comprehension/generator

  /// class Aurora(a for b in []): "Sleep"
  func test_generator_throws() {
    let parser = createStmtParser(
      createToken(.class,                  start: loc0, end: loc1),
      createToken(.identifier("Aurora"),   start: loc2, end: loc3),
      createToken(.leftParen,              start: loc4, end: loc5),
      createToken(.identifier("a"),        start: loc6, end: loc7),
      createToken(.for,                    start: loc8, end: loc9),
      createToken(.identifier("b"),        start: loc10, end: loc11),
      createToken(.in,                     start: loc12, end: loc13),
      createToken(.leftSqb,                start: loc14, end: loc15),
      createToken(.rightSqb,               start: loc16, end: loc17),
      createToken(.rightParen,             start: loc18, end: loc19),
      createToken(.colon,                  start: loc20, end: loc21),
      createToken(.string("Sleep"),        start: loc22, end: loc23)
    )

    if let error = parseError(parser) {
      XCTAssertEqual(error.kind, .baseClassWithGenerator)
      XCTAssertEqual(error.location, loc6)
    }
  }
}

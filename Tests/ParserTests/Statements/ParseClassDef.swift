import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length

class ParseClassDef: XCTestCase, Common {

  // MARK: - No base

  /// class Princess: "Sing"
  func test_noBase() {
    let parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Princess"), start: loc2, end: loc3),
      self.token(.colon,                  start: loc4, end: loc5),
      self.token(.string("Sing"),         start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      ClassDefStmt(start: 0:0, end: 7:12)
        Name: Princess
        Bases: none
        Keywords: none
        Body
          ExprStmt(start: 6:6, end: 7:12)
            StringExpr(start: 6:6, end: 7:12)
              String: 'Sing'
        Decorators: none
    """)
  }

  /// class Princess(): "Sing"
  func test_noBase_emptyParens() {
    let parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Princess"), start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.rightParen,             start: loc6, end: loc7),
      self.token(.colon,                  start: loc8, end: loc9),
      self.token(.string("Sing"),         start: loc10, end: loc11)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 11:16)
      ClassDefStmt(start: 0:0, end: 11:16)
        Name: Princess
        Bases: none
        Keywords: none
        Body
          ExprStmt(start: 10:10, end: 11:16)
            StringExpr(start: 10:10, end: 11:16)
              String: 'Sing'
        Decorators: none
    """)
  }

  // MARK: - Bases

  /// class Aurora(Princess): "Sleep"
  func test_base_single() {
    let parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Aurora"),   start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("Princess"), start: loc6, end: loc7),
      self.token(.rightParen,             start: loc8, end: loc9),
      self.token(.colon,                  start: loc10, end: loc11),
      self.token(.string("Sleep"),        start: loc12, end: loc13)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 13:18)
      ClassDefStmt(start: 0:0, end: 13:18)
        Name: Aurora
        Bases
          IdentifierExpr(start: 6:6, end: 7:12)
            Value: Princess
        Keywords: none
        Body
          ExprStmt(start: 12:12, end: 13:18)
            StringExpr(start: 12:12, end: 13:18)
              String: 'Sleep'
        Decorators: none
    """)
  }

  /// class Aurora(Princess,): "Sleep"
  func test_base_withCommaAfter() {
    let parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Aurora"),   start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.identifier("Princess"), start: loc6, end: loc7),
      self.token(.comma,                  start: loc8, end: loc9),
      self.token(.rightParen,             start: loc10, end: loc11),
      self.token(.colon,                  start: loc12, end: loc13),
      self.token(.string("Sleep"),        start: loc14, end: loc15)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      ClassDefStmt(start: 0:0, end: 15:20)
        Name: Aurora
        Bases
          IdentifierExpr(start: 6:6, end: 7:12)
            Value: Princess
        Keywords: none
        Body
          ExprStmt(start: 14:14, end: 15:20)
            StringExpr(start: 14:14, end: 15:20)
              String: 'Sleep'
        Decorators: none
    """)
  }

  /// class Aurora(Princess, Human): "Sleep"
  func test_base_multiple() {
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 17:22)
      ClassDefStmt(start: 0:0, end: 17:22)
        Name: Aurora
        Bases
          IdentifierExpr(start: 6:6, end: 7:12)
            Value: Princess
          IdentifierExpr(start: 10:10, end: 11:16)
            Value: Human
        Keywords: none
        Body
          ExprStmt(start: 16:16, end: 17:22)
            StringExpr(start: 16:16, end: 17:22)
              String: 'Sleep'
        Decorators: none
    """)
  }

  /// class Aurora((Princess)): "Sleep"
  func test_base_withAdditionalParens() {
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 17:22)
      ClassDefStmt(start: 0:0, end: 17:22)
        Name: Aurora
        Bases
          IdentifierExpr(start: 6:6, end: 11:16)
            Value: Princess
        Keywords: none
        Body
          ExprStmt(start: 16:16, end: 17:22)
            StringExpr(start: 16:16, end: 17:22)
              String: 'Sleep'
        Decorators: none
    """)
  }

  /// class Aurora(Princess=1, Human): "Sleep"
  func test_base_afterKeyword_throws() {
    let parser = self.createStmtParser(
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

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .callWithPositionalArgumentAfterKeywordArgument)
      XCTAssertEqual(error.location, loc14)
    }
  }

  /// class Aurora(**Princess, Human): "Sleep"
  func test_base_afterKeywordUnpacking_throws() {
    let parser = self.createStmtParser(
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

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .callWithPositionalArgumentAfterKeywordUnpacking)
      XCTAssertEqual(error.location, loc12)
    }
  }

  // MARK: - Base - star

  /// class Aurora(*Princess): "Sleep"
  func test_base_withStar() {
    let parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Aurora"),   start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.star,                   start: loc6, end: loc7),
      self.token(.identifier("Princess"), start: loc8, end: loc9),
      self.token(.rightParen,             start: loc10, end: loc11),
      self.token(.colon,                  start: loc12, end: loc13),
      self.token(.string("Sleep"),        start: loc14, end: loc15)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 15:20)
      ClassDefStmt(start: 0:0, end: 15:20)
        Name: Aurora
        Bases
          StarredExpr(start: 6:6, end: 9:14)
            Expression
              IdentifierExpr(start: 8:8, end: 9:14)
                Value: Princess
        Keywords: none
        Body
          ExprStmt(start: 14:14, end: 15:20)
            StringExpr(start: 14:14, end: 15:20)
              String: 'Sleep'
        Decorators: none
    """)
  }

  /// class Aurora(Princess=1, *Human): "Sleep"
  func test_base_withStar_afterKeyword() {
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 23:28)
      ClassDefStmt(start: 0:0, end: 23:28)
        Name: Aurora
        Bases
          StarredExpr(start: 14:14, end: 17:22)
            Expression
              IdentifierExpr(start: 16:16, end: 17:22)
                Value: Human
        Keywords
          Keyword(start: 6:6, end: 11:16)
            Kind
              Named('Princess')
            Value
              FloatExpr(start: 10:10, end: 11:16)
                Value: 1.0
        Body
          ExprStmt(start: 22:22, end: 23:28)
            StringExpr(start: 22:22, end: 23:28)
              String: 'Sleep'
        Decorators: none
    """)
  }

  /// class Aurora(**Princess, *Human): "Sleep"
  func test_base_withStar_afterKeywordUnpacking_throws() {
    let parser = self.createStmtParser(
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

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .callWithIterableArgumentAfterKeywordUnpacking)
      XCTAssertEqual(error.location, loc12)
    }
  }

  // MARK: - Keyword

  /// class Aurora(Princess=1): "Sleep"
  func test_keyword_single() {
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

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
              FloatExpr(start: 10:10, end: 11:16)
                Value: 1.0
        Body
          ExprStmt(start: 16:16, end: 17:22)
            StringExpr(start: 16:16, end: 17:22)
              String: 'Sleep'
        Decorators: none
    """)
  }

  /// class Aurora(Princess=1, Human=2): "Sleep"
  func test_keyword_multiple() {
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

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
              FloatExpr(start: 10:10, end: 11:16)
                Value: 1.0
          Keyword(start: 14:14, end: 19:24)
            Kind
              Named('Human')
            Value
              FloatExpr(start: 18:18, end: 19:24)
                Value: 2.0
        Body
          ExprStmt(start: 24:24, end: 25:30)
            StringExpr(start: 24:24, end: 25:30)
              String: 'Sleep'
        Decorators: none
    """)
  }

  /// class Aurora(Princess=1, Princess=2): "Sleep"
  func test_keyword_duplicate_throws() {
    let parser = self.createStmtParser(
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

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .callWithDuplicateKeywordArgument("Princess"))
      XCTAssertEqual(error.location, loc14)
    }
  }

  /// From comment in CPython:
  /// class Aurora(lambda x: x[0] = 3): "Sleep"
  /// I have no idea what would that even mean in class context.
  func test_keyword_lambda_assignment_throws() {
    let parser = self.createStmtParser(
      self.token(.class,                   start: loc0, end: loc1),
      self.token(.identifier("Aurora"),    start: loc2, end: loc3),
      self.token(.leftParen,               start: loc4, end: loc5),
      self.token(.lambda,                  start: loc6, end: loc7),
      self.token(.identifier("x"),         start: loc8, end: loc9),
      self.token(.colon,                   start: loc10, end: loc11),
      self.token(.identifier("x"),         start: loc12, end: loc13),
      self.token(.leftSqb,                 start: loc14, end: loc15),
      self.token(.int(BigInt(0)),          start: loc16, end: loc17),
      self.token(.rightSqb,                start: loc18, end: loc19),
      self.token(.equal,                   start: loc20, end: loc21),
      self.token(.int(BigInt(3)),          start: loc20, end: loc21),
      self.token(.rightParen,              start: loc22, end: loc23),
      self.token(.colon,                   start: loc24, end: loc25),
      self.token(.string("Sleep"),         start: loc26, end: loc27)
    )

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .callWithLambdaAssignment)
      XCTAssertEqual(error.location, loc6)
    }
  }

  /// class Aurora(3=1): "Sleep"
  func test_keyword_invalidName_throws() {
    let parser = self.createStmtParser(
      self.token(.class,                   start: loc0, end: loc1),
      self.token(.identifier("Aurora"),    start: loc2, end: loc3),
      self.token(.leftParen,               start: loc4, end: loc5),
      self.token(.int(BigInt(3)),          start: loc6, end: loc7),
      self.token(.equal,                   start: loc8, end: loc9),
      self.token(.int(BigInt(1)),          start: loc10, end: loc11),
      self.token(.rightParen,              start: loc12, end: loc13),
      self.token(.colon,                   start: loc14, end: loc15),
      self.token(.string("Sleep"),         start: loc16, end: loc17)
    )

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .callWithKeywordExpression)
      XCTAssertEqual(error.location, loc6)
    }
  }

  // MARK: - Keyword - star star

  /// class Aurora(**Princess): "Sleep"
  func test_keyword_withStarStar() {
    let parser = self.createStmtParser(
      self.token(.class,                  start: loc0, end: loc1),
      self.token(.identifier("Aurora"),   start: loc2, end: loc3),
      self.token(.leftParen,              start: loc4, end: loc5),
      self.token(.starStar,               start: loc6, end: loc7),
      self.token(.identifier("Princess"), start: loc8, end: loc9),
      self.token(.rightParen,             start: loc10, end: loc11),
      self.token(.colon,                  start: loc12, end: loc13),
      self.token(.string("Sleep"),        start: loc14, end: loc15)
    )

    guard let ast = self.parse(parser) else { return }

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
              IdentifierExpr(start: 8:8, end: 9:14)
                Value: Princess
        Body
          ExprStmt(start: 14:14, end: 15:20)
            StringExpr(start: 14:14, end: 15:20)
              String: 'Sleep'
        Decorators: none
    """)
  }

  /// class Aurora(Princess, **Human): "Sleep"
  func test_keyword_withStarStar_afterNormal() {
    let parser = self.createStmtParser(
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

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 19:24)
      ClassDefStmt(start: 0:0, end: 19:24)
        Name: Aurora
        Bases
          IdentifierExpr(start: 6:6, end: 7:12)
            Value: Princess
        Keywords
          Keyword(start: 10:10, end: 13:18)
            Kind
              DictionaryUnpack
            Value
              IdentifierExpr(start: 12:12, end: 13:18)
                Value: Human
        Body
          ExprStmt(start: 18:18, end: 19:24)
            StringExpr(start: 18:18, end: 19:24)
              String: 'Sleep'
        Decorators: none
    """)
  }

  // MARK: - Comprehension/generator

  /// class Aurora(a for b in []): "Sleep"
  func test_generator_throws() {
    let parser = self.createStmtParser(
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

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .baseClassWithGenerator)
      XCTAssertEqual(error.location, loc6)
    }
  }
}

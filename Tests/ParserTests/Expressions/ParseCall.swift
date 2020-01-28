import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length

class ParseCall: XCTestCase, Common {

  // MARK: - No arguments

  /// f()
  func test_noArgs() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.rightParen,      start: loc4, end: loc5)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 5:10)
      CallExpr(context: Load, start: 0:0, end: 5:10)
        Name
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: f
        Args: none
        Keywords: none
    """)
  }

  // MARK: - Positional

  /// f(1)
  func test_positional_single() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.float(1.0),      start: loc4, end: loc5),
      self.token(.rightParen,      start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 7:12)
      CallExpr(context: Load, start: 0:0, end: 7:12)
        Name
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: f
        Args
          FloatExpr(context: Load, start: 4:4, end: 5:10)
            Value: 1.0
        Keywords: none
    """)
  }

  /// f(a, 1)
  func test_positional_multiple() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.comma,           start: loc6, end: loc7),
      self.token(.float(1.0),      start: loc8, end: loc9),
      self.token(.rightParen,      start: loc10, end: loc11)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 11:16)
      CallExpr(context: Load, start: 0:0, end: 11:16)
        Name
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: f
        Args
          IdentifierExpr(context: Load, start: 4:4, end: 5:10)
            Value: a
          FloatExpr(context: Load, start: 8:8, end: 9:14)
            Value: 1.0
        Keywords: none
    """)
  }

  /// f(1,)
  func test_positional_withCommaAfter() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.float(1.0),      start: loc4, end: loc5),
      self.token(.comma,           start: loc6, end: loc7),
      self.token(.rightParen,      start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      CallExpr(context: Load, start: 0:0, end: 9:14)
        Name
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: f
        Args
          FloatExpr(context: Load, start: 4:4, end: 5:10)
            Value: 1.0
        Keywords: none
    """)
  }

  /// f((a))
  func test_positional_withAdditionalParens() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.leftParen,       start: loc4, end: loc5),
      self.token(.identifier("a"), start: loc6, end: loc7),
      self.token(.rightParen,      start: loc8, end: loc9),
      self.token(.rightParen,      start: loc10, end: loc11)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 11:16)
      CallExpr(context: Load, start: 0:0, end: 11:16)
        Name
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: f
        Args
          IdentifierExpr(context: Load, start: 4:4, end: 9:14)
            Value: a
        Keywords: none
    """)
  }

  /// f(a=1, b)
  func test_positional_afterKeyword_throws() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.equal,           start: loc6, end: loc7),
      self.token(.float(1.0),      start: loc8, end: loc9),
      self.token(.comma,           start: loc10, end: loc11),
      self.token(.identifier("b"), start: loc12, end: loc13),
      self.token(.rightParen,      start: loc14, end: loc15)
    )

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .callWithPositionalArgumentAfterKeywordArgument)
      XCTAssertEqual(error.location, loc12)
    }
  }

  /// f(**a, b)
  func test_positional_afterKeywordUnpacking_throws() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.starStar,        start: loc6, end: loc7),
      self.token(.identifier("a"), start: loc8, end: loc9),
      self.token(.comma,           start: loc10, end: loc11),
      self.token(.identifier("b"), start: loc12, end: loc13),
      self.token(.rightParen,      start: loc14, end: loc15)
    )

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .callWithPositionalArgumentAfterKeywordUnpacking)
      XCTAssertEqual(error.location, loc12)
    }
  }

  // MARK: - Positional - star

  /// f(*a)
  func test_star() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.star,            start: loc4, end: loc5),
      self.token(.identifier("a"), start: loc6, end: loc7),
      self.token(.rightParen,      start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      CallExpr(context: Load, start: 0:0, end: 9:14)
        Name
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: f
        Args
          StarredExpr(context: Load, start: 4:4, end: 7:12)
            Expression
              IdentifierExpr(context: Load, start: 6:6, end: 7:12)
                Value: a
        Keywords: none
    """)
  }

  /// f(a, *b)
  func test_star_afterPositional() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.comma,           start: loc6, end: loc7),
      self.token(.star,            start: loc8, end: loc9),
      self.token(.identifier("b"), start: loc10, end: loc11),
      self.token(.rightParen,      start: loc12, end: loc13)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 13:18)
      CallExpr(context: Load, start: 0:0, end: 13:18)
        Name
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: f
        Args
          IdentifierExpr(context: Load, start: 4:4, end: 5:10)
            Value: a
          StarredExpr(context: Load, start: 8:8, end: 11:16)
            Expression
              IdentifierExpr(context: Load, start: 10:10, end: 11:16)
                Value: b
        Keywords: none
    """)
  }

  /// f(a=1, *b)
  func test_star_afterKeyword() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.equal,           start: loc6, end: loc7),
      self.token(.float(1.0),      start: loc8, end: loc9),
      self.token(.comma,           start: loc10, end: loc11),
      self.token(.star,            start: loc12, end: loc13),
      self.token(.identifier("b"), start: loc14, end: loc15),
      self.token(.rightParen,      start: loc16, end: loc17)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 17:22)
      CallExpr(context: Load, start: 0:0, end: 17:22)
        Name
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: f
        Args
          StarredExpr(context: Load, start: 12:12, end: 15:20)
            Expression
              IdentifierExpr(context: Load, start: 14:14, end: 15:20)
                Value: b
        Keywords
          Keyword(start: 4:4, end: 9:14)
            Kind
              Named('a')
            Value
              FloatExpr(context: Load, start: 8:8, end: 9:14)
                Value: 1.0
    """)
  }

  /// f(**a, *b)
  func test_star_afterKeywordUnpacking_throws() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.starStar,        start: loc4, end: loc5),
      self.token(.identifier("a"), start: loc6, end: loc7),
      self.token(.comma,           start: loc8, end: loc9),
      self.token(.star,            start: loc10, end: loc11),
      self.token(.identifier("b"), start: loc12, end: loc13),
      self.token(.rightParen,      start: loc14, end: loc15)
    )

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .callWithIterableArgumentAfterKeywordUnpacking)
      XCTAssertEqual(error.location, loc10)
    }
  }

  // MARK: - Keyword

  /// f(a=1)
  func test_keyword_single() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.equal,           start: loc6, end: loc7),
      self.token(.float(1.0),      start: loc8, end: loc9),
      self.token(.rightParen,      start: loc10, end: loc11)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 11:16)
      CallExpr(context: Load, start: 0:0, end: 11:16)
        Name
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: f
        Args: none
        Keywords
          Keyword(start: 4:4, end: 9:14)
            Kind
              Named('a')
            Value
              FloatExpr(context: Load, start: 8:8, end: 9:14)
                Value: 1.0
    """)
  }

  /// f(a=1.0, b=2.0)
  func test_keyword_multiple() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.equal,           start: loc6, end: loc7),
      self.token(.float(1.0),      start: loc8, end: loc9),
      self.token(.comma,           start: loc10, end: loc11),
      self.token(.identifier("b"), start: loc12, end: loc13),
      self.token(.equal,           start: loc14, end: loc15),
      self.token(.float(2.0),      start: loc16, end: loc17),
      self.token(.rightParen,      start: loc18, end: loc19)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 19:24)
      CallExpr(context: Load, start: 0:0, end: 19:24)
        Name
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: f
        Args: none
        Keywords
          Keyword(start: 4:4, end: 9:14)
            Kind
              Named('a')
            Value
              FloatExpr(context: Load, start: 8:8, end: 9:14)
                Value: 1.0
          Keyword(start: 12:12, end: 17:22)
            Kind
              Named('b')
            Value
              FloatExpr(context: Load, start: 16:16, end: 17:22)
                Value: 2.0
    """)
  }

  /// f(a=1, a=2)
  func test_keyword_duplicate_throws() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.equal,           start: loc6, end: loc7),
      self.token(.float(1.0),      start: loc8, end: loc9),
      self.token(.comma,           start: loc10, end: loc11),
      self.token(.identifier("a"), start: loc12, end: loc13),
      self.token(.equal,           start: loc14, end: loc15),
      self.token(.float(2.0),      start: loc16, end: loc17),
      self.token(.rightParen,      start: loc18, end: loc19)
    )

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .callWithDuplicateKeywordArgument("a"))
      XCTAssertEqual(error.location, loc12)
    }
  }

  /// From comment in CPython:
  /// `f(lambda x: x[0] = 3)`
  func test_keyword_lambda_assignment_throws() {
    let parser = self.createExprParser(
      self.token(.identifier("f"),  start: loc0, end: loc1),
      self.token(.leftParen,        start: loc2, end: loc3),
      self.token(.lambda,           start: loc4, end: loc5),
      self.token(.identifier("x"),  start: loc6, end: loc7),
      self.token(.colon,            start: loc8, end: loc9),
      self.token(.identifier("x"),  start: loc10, end: loc11),
      self.token(.leftSqb,          start: loc12, end: loc13),
      self.token(.int(BigInt(0)),   start: loc14, end: loc15),
      self.token(.rightSqb,         start: loc16, end: loc17),
      self.token(.equal,            start: loc18, end: loc19),
      self.token(.int(BigInt(3)),   start: loc20, end: loc21),
      self.token(.rightParen,       start: loc22, end: loc23)
    )

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .callWithLambdaAssignment)
      XCTAssertEqual(error.location, loc4)
    }
  }

  /// f(3=1)
  func test_keyword_invalidName_throws() {
    let parser = self.createExprParser(
      self.token(.identifier("f"),  start: loc0, end: loc1),
      self.token(.leftParen,        start: loc2, end: loc3),
      self.token(.int(BigInt(3)),   start: loc4, end: loc5),
      self.token(.equal,            start: loc6, end: loc7),
      self.token(.int(BigInt(1)),   start: loc8, end: loc9),
      self.token(.rightParen,       start: loc10, end: loc11)
    )

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .callWithKeywordExpression)
      XCTAssertEqual(error.location, loc4)
    }
  }

  // MARK: - Keyword - star star

  /// f(**a)
  func test_starStar() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.starStar,        start: loc4, end: loc5),
      self.token(.identifier("a"), start: loc6, end: loc7),
      self.token(.rightParen,      start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      CallExpr(context: Load, start: 0:0, end: 9:14)
        Name
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: f
        Args: none
        Keywords
          Keyword(start: 4:4, end: 7:12)
            Kind
              DictionaryUnpack
            Value
              IdentifierExpr(context: Load, start: 6:6, end: 7:12)
                Value: a
    """)
  }

  /// f(a, **b)
  func test_starStar_afterPositional() {
    let parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.comma,           start: loc6, end: loc7),
      self.token(.starStar,        start: loc8, end: loc9),
      self.token(.identifier("b"), start: loc10, end: loc11),
      self.token(.rightParen,      start: loc12, end: loc13)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 13:18)
      CallExpr(context: Load, start: 0:0, end: 13:18)
        Name
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: f
        Args
          IdentifierExpr(context: Load, start: 4:4, end: 5:10)
            Value: a
        Keywords
          Keyword(start: 8:8, end: 11:16)
            Kind
              DictionaryUnpack
            Value
              IdentifierExpr(context: Load, start: 10:10, end: 11:16)
                Value: b
    """)
  }
}

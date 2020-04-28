import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseParenExpr: XCTestCase, Common {

  // MARK: - Empty

  /// ()
  func test_emptyTuple() {
    let parser = self.createExprParser(
      self.token(.leftParen,  start: loc0, end: loc1),
      self.token(.rightParen, start: loc2, end: loc3)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 3:8)
      TupleExpr(context: Load, start: 0:0, end: 3:8)
        Elements: none
    """)
  }

  // MARK: - Single

  /// (elsa)
  func test_value() {
    let parser = self.createExprParser(
      self.token(.leftParen,          start: loc0, end: loc1),
      self.token(.identifier("elsa"), start: loc2, end: loc3),
      self.token(.rightParen,         start: loc4, end: loc5)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 5:10)
      IdentifierExpr(context: Load, start: 0:0, end: 5:10)
        Value: elsa
    """)
  }

  // MARK: - Tuple

  /// (elsa,)
  func test_value_withComaAfter_givesTuple() {
    let parser = self.createExprParser(
      self.token(.leftParen,          start: loc0, end: loc1),
      self.token(.identifier("elsa"), start: loc2, end: loc3),
      self.token(.comma,              start: loc4, end: loc5),
      self.token(.rightParen,         start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 7:12)
      TupleExpr(context: Load, start: 0:0, end: 7:12)
        Elements
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: elsa
    """)
  }

  /// (elsa, anna)
  func test_tuple() {
    let parser = self.createExprParser(
      self.token(.leftParen,          start: loc0, end: loc1),
      self.token(.identifier("elsa"), start: loc2, end: loc3),
      self.token(.comma,              start: loc4, end: loc5),
      self.token(.identifier("anna"), start: loc6, end: loc7),
      self.token(.rightParen,         start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      TupleExpr(context: Load, start: 0:0, end: 9:14)
        Elements
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: elsa
          IdentifierExpr(context: Load, start: 6:6, end: 7:12)
            Value: anna
    """)
  }

  // MARK: - Yield

  /// (yield)
  func test_yield_nil() {
    let parser = self.createExprParser(
      self.token(.leftParen,  start: loc0, end: loc1),
      self.token(.yield,      start: loc2, end: loc3),
      self.token(.rightParen, start: loc4, end: loc5)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 5:10)
      YieldExpr(context: Load, start: 2:2, end: 3:8)
        Value: none
    """)
  }

  /// (yield elsa)
  func test_yield_expr() {
    let parser = self.createExprParser(
      self.token(.leftParen,          start: loc0, end: loc1),
      self.token(.yield,              start: loc2, end: loc3),
      self.token(.identifier("elsa"), start: loc4, end: loc5),
      self.token(.rightParen,         start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 7:12)
      YieldExpr(context: Load, start: 2:2, end: 5:10)
        Value
          IdentifierExpr(context: Load, start: 4:4, end: 5:10)
            Value: elsa
    """)
  }

  /// (yield elsa, anna)
  func test_yield_tuple() {
    let parser = self.createExprParser(
      self.token(.leftParen,          start: loc0, end: loc1),
      self.token(.yield,              start: loc2, end: loc3),
      self.token(.identifier("elsa"), start: loc4, end: loc5),
      self.token(.comma,              start: loc6, end: loc7),
      self.token(.identifier("anna"), start: loc8, end: loc9),
      self.token(.rightParen,         start: loc10, end: loc11)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 11:16)
      YieldExpr(context: Load, start: 2:2, end: 9:14)
        Value
          TupleExpr(context: Load, start: 4:4, end: 9:14)
            Elements
              IdentifierExpr(context: Load, start: 4:4, end: 5:10)
                Value: elsa
              IdentifierExpr(context: Load, start: 8:8, end: 9:14)
                Value: anna
    """)
  }

  // MARK: - Generator expr

  /// (elsa for anna in [])
  func test_generator() {
    let parser = self.createExprParser(
      self.token(.leftParen,          start: loc0, end: loc1),
      self.token(.identifier("elsa"), start: loc2, end: loc3),
      self.token(.for,                start: loc4, end: loc5),
      self.token(.identifier("anna"), start: loc6, end: loc7),
      self.token(.in,                 start: loc8, end: loc9),
      self.token(.leftSqb,            start: loc10, end: loc11),
      self.token(.rightSqb,           start: loc12, end: loc13),
      self.token(.rightParen,         start: loc14, end: loc15)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 15:20)
      GeneratorExpr(context: Load, start: 0:0, end: 15:20)
        Element
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: elsa
        Generators
          Comprehension(start: 4:4, end: 13:18)
            isAsync: false
            Target
              IdentifierExpr(context: Store, start: 6:6, end: 7:12)
                Value: anna
            Iterable
              ListExpr(context: Load, start: 10:10, end: 13:18)
                Elements: none
            Ifs: none
    """)
  }
}

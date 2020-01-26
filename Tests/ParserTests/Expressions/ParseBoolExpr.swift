import XCTest
import Core
import Lexer
@testable import Parser

class ParseBoolExpr: XCTestCase, Common {

  func test_not() {
    let parser = self.createExprParser(
      self.token(.not,   start: loc0, end: loc1),
      self.token(.false, start: loc2, end: loc3)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 3:8)
      UnaryOpExpr(start: 0:0, end: 3:8)
        Operator: not
        Right
          FalseExpr(start: 2:2, end: 3:8)
    """)
  }

  func test_and_or() {
    let variants: [(TokenKind, BooleanOperator)] = [
      (.or, .or), // grammar: or_test
      (.and, .and) // grammar: and_test
    ]

    for (token, op) in variants {
      let parser = self.createExprParser(
        self.token(.true,  start: loc0, end: loc1),
        self.token(token,  start: loc2, end: loc3),
        self.token(.false, start: loc4, end: loc5)
      )

      guard let ast = self.parse(parser) else { continue }

      XCTAssertAST(ast, """
      ExpressionAST(start: 0:0, end: 5:10)
        BoolOpExpr(start: 0:0, end: 5:10)
          Operator: \(op)
          Left
            TrueExpr(start: 0:0, end: 1:6)
          Right
            FalseExpr(start: 4:4, end: 5:10)
      """)
    }
  }

  // MARK: - Associativity

  /// not not false = not (not false)
  func test_not_isRightAssociative() {
    let parser = self.createExprParser(
      self.token(.not,   start: loc0, end: loc1),
      self.token(.not,   start: loc2, end: loc3),
      self.token(.false, start: loc4, end: loc5)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 5:10)
      UnaryOpExpr(start: 0:0, end: 5:10)
        Operator: not
        Right
          UnaryOpExpr(start: 2:2, end: 5:10)
            Operator: not
            Right
              FalseExpr(start: 4:4, end: 5:10)
    """)
  }

  /// true and false and true = (true and false) and true
  func test_and_isLeftAssociative() {
    let parser = self.createExprParser(
      self.token(.true,  start: loc0, end: loc1),
      self.token(.and,   start: loc2, end: loc3),
      self.token(.false, start: loc4, end: loc5),
      self.token(.and,   start: loc6, end: loc7),
      self.token(.true,  start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      BoolOpExpr(start: 0:0, end: 9:14)
        Operator: and
        Left
          BoolOpExpr(start: 0:0, end: 5:10)
            Operator: and
            Left
              TrueExpr(start: 0:0, end: 1:6)
            Right
              FalseExpr(start: 4:4, end: 5:10)
        Right
          TrueExpr(start: 8:8, end: 9:14)
    """)
  }

  /// true or false or true = (true or false) or true
  func test_or_isLeftAssociative() {
    let parser = self.createExprParser(
      self.token(.true,  start: loc0, end: loc1),
      self.token(.or,    start: loc2, end: loc3),
      self.token(.false, start: loc4, end: loc5),
      self.token(.or,    start: loc6, end: loc7),
      self.token(.true,  start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      BoolOpExpr(start: 0:0, end: 9:14)
        Operator: or
        Left
          BoolOpExpr(start: 0:0, end: 5:10)
            Operator: or
            Left
              TrueExpr(start: 0:0, end: 1:6)
            Right
              FalseExpr(start: 4:4, end: 5:10)
        Right
          TrueExpr(start: 8:8, end: 9:14)
    """)
  }

  // MARK: - Precedence

  /// not true and false = (not true) and false
  func test_not_hasHigherPrecedence_thanAnd() {
    let parser = self.createExprParser(
      self.token(.not,   start: loc0, end: loc1),
      self.token(.true,  start: loc2, end: loc3),
      self.token(.and,   start: loc4, end: loc5),
      self.token(.false, start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 7:12)
      BoolOpExpr(start: 0:0, end: 7:12)
        Operator: and
        Left
          UnaryOpExpr(start: 0:0, end: 3:8)
            Operator: not
            Right
              TrueExpr(start: 2:2, end: 3:8)
        Right
          FalseExpr(start: 6:6, end: 7:12)
    """)
  }

  /// true or false and true = true or (false and true)
  func test_and_hasHigherPrecedence_thanOr() {
    let parser = self.createExprParser(
      self.token(.true,  start: loc0, end: loc1),
      self.token(.or,    start: loc2, end: loc3),
      self.token(.false, start: loc4, end: loc5),
      self.token(.and,   start: loc6, end: loc7),
      self.token(.true,  start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      BoolOpExpr(start: 0:0, end: 9:14)
        Operator: or
        Left
          TrueExpr(start: 0:0, end: 1:6)
        Right
          BoolOpExpr(start: 4:4, end: 9:14)
            Operator: and
            Left
              FalseExpr(start: 4:4, end: 5:10)
            Right
              TrueExpr(start: 8:8, end: 9:14)
    """)
  }
}

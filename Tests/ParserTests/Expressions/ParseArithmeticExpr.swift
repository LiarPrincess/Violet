import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseArithmeticExpr: XCTestCase, Common {

  func test_unary() {
    let variants: [(Token.Kind, UnaryOpExpr.Operator)] = [
      (.plus, .plus), // grammar: factor
      (.minus, .minus),
      (.tilde, .invert)
    ]

    for (token, op) in variants {
      let parser = self.createExprParser(
        self.token(token,               start: loc0, end: loc1),
        self.token(.identifier("lilo"), start: loc2, end: loc3)
      )

      guard let ast = self.parse(parser) else { return }

      XCTAssertAST(ast, """
      ExpressionAST(start: 0:0, end: 3:8)
        UnaryOpExpr(context: Load, start: 0:0, end: 3:8)
          Operator: \(op)
          Right
            IdentifierExpr(context: Load, start: 2:2, end: 3:8)
              Value: lilo
      """)
    }
  }

  func test_binary() {
    let variants: [(Token.Kind, BinaryOpExpr.Operator)] = [
      (.plus, .add), // grammar: arith_expr
      (.minus, .sub),
      (.star, .mul), // grammar: term
      (.at, .matMul),
      (.slash, .div),
      (.percent, .modulo),
      (.slashSlash, .floorDiv),
      (.starStar, .pow) // grammar: power
    ]

    for (token, op) in variants {
      let parser = self.createExprParser(
        self.token(.identifier("lilo"),   start: loc0, end: loc1),
        self.token(token,                 start: loc2, end: loc3),
        self.token(.identifier("stitch"), start: loc4, end: loc5)
      )

      guard let ast = self.parse(parser) else { continue }

      XCTAssertAST(ast, """
      ExpressionAST(start: 0:0, end: 5:10)
        BinaryOpExpr(context: Load, start: 0:0, end: 5:10)
          Operator: \(op)
          Left
            IdentifierExpr(context: Load, start: 0:0, end: 1:6)
              Value: lilo
          Right
            IdentifierExpr(context: Load, start: 4:4, end: 5:10)
              Value: stitch
      """)
    }
  }

  // MARK: - Associativity

  /// -+4.2 = -(+4.2)
  func test_unaryGroup_isRightAssociative() {
    let parser = self.createExprParser(
      self.token(.minus,      start: loc0, end: loc1),
      self.token(.plus,       start: loc2, end: loc3),
      self.token(.identifier("lilo"), start: loc4, end: loc5)
    )

    guard let ast = self.parse(parser) else { return }

      XCTAssertAST(ast, """
      ExpressionAST(start: 0:0, end: 5:10)
        UnaryOpExpr(context: Load, start: 0:0, end: 5:10)
          Operator: -
          Right
            UnaryOpExpr(context: Load, start: 2:2, end: 5:10)
              Operator: +
              Right
                IdentifierExpr(context: Load, start: 4:4, end: 5:10)
                  Value: lilo
      """)
  }

  /// 4.2 ** 3.1 ** 2.0 -> 4.2 ** (3.1 ** 2.0)
  /// For example: 2 ** 3 ** 4 = 2 ** 81 = 2417851639229258349412352
  func test_powerGroup_isRightAssociative() {
    let parser = self.createExprParser(
      self.token(.identifier("lilo"),   start: loc0, end: loc1),
      self.token(.starStar,             start: loc2, end: loc3),
      self.token(.identifier("stitch"), start: loc4, end: loc5),
      self.token(.starStar,             start: loc6, end: loc7),
      self.token(.identifier("nani"),   start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      BinaryOpExpr(context: Load, start: 0:0, end: 9:14)
        Operator: **
        Left
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: lilo
        Right
          BinaryOpExpr(context: Load, start: 4:4, end: 9:14)
            Operator: **
            Left
              IdentifierExpr(context: Load, start: 4:4, end: 5:10)
                Value: stitch
            Right
              IdentifierExpr(context: Load, start: 8:8, end: 9:14)
                Value: nani
    """)
  }

  /// 4.2 + 3.1 - 2.0 -> (4.2 + 3.1) - 2.0
  func test_addGroup_isLeftAssociative() {
    let parser = self.createExprParser(
      self.token(.identifier("lilo"),   start: loc0, end: loc1),
      self.token(.plus,                 start: loc2, end: loc3),
      self.token(.identifier("stitch"), start: loc4, end: loc5),
      self.token(.minus,                start: loc6, end: loc7),
      self.token(.identifier("nani"),   start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      BinaryOpExpr(context: Load, start: 0:0, end: 9:14)
        Operator: -
        Left
          BinaryOpExpr(context: Load, start: 0:0, end: 5:10)
            Operator: +
            Left
              IdentifierExpr(context: Load, start: 0:0, end: 1:6)
                Value: lilo
            Right
              IdentifierExpr(context: Load, start: 4:4, end: 5:10)
                Value: stitch
        Right
          IdentifierExpr(context: Load, start: 8:8, end: 9:14)
            Value: nani
    """)
  }

  /// 4.2 * 3.1 / 2.0 -> (4.2 * 3.1) / 2.0
  func test_mulGroup_isLeftAssociative() {
    let parser = self.createExprParser(
      self.token(.identifier("lilo"),   start: loc0, end: loc1),
      self.token(.star,                 start: loc2, end: loc3),
      self.token(.identifier("stitch"), start: loc4, end: loc5),
      self.token(.slash,                start: loc6, end: loc7),
      self.token(.identifier("nani"),   start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      BinaryOpExpr(context: Load, start: 0:0, end: 9:14)
        Operator: /
        Left
          BinaryOpExpr(context: Load, start: 0:0, end: 5:10)
            Operator: *
            Left
              IdentifierExpr(context: Load, start: 0:0, end: 1:6)
                Value: lilo
            Right
              IdentifierExpr(context: Load, start: 4:4, end: 5:10)
                Value: stitch
        Right
          IdentifierExpr(context: Load, start: 8:8, end: 9:14)
            Value: nani
    """)
  }

  // MARK: - Precedence

  /// 4.2 * -3.1 = 4.2 * (-3.1)
  func test_minus_hasHigherPrecedence_thanMul() {
    let parser = self.createExprParser(
      self.token(.identifier("lilo"),   start: loc0, end: loc1),
      self.token(.star,                 start: loc2, end: loc3),
      self.token(.minus,                start: loc4, end: loc5),
      self.token(.identifier("stitch"), start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 7:12)
      BinaryOpExpr(context: Load, start: 0:0, end: 7:12)
        Operator: *
        Left
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: lilo
        Right
          UnaryOpExpr(context: Load, start: 4:4, end: 7:12)
            Operator: -
            Right
              IdentifierExpr(context: Load, start: 6:6, end: 7:12)
                Value: stitch
    """)
  }

  /// 4.2 + 3.1 * 2.0 = 4.2 + (3.1 * 2.0)
  func test_mul_hasHigherPrecedence_thanAdd() {
    let parser = self.createExprParser(
      self.token(.identifier("lilo"),   start: loc0, end: loc1),
      self.token(.plus,                 start: loc2, end: loc3),
      self.token(.identifier("stitch"), start: loc4, end: loc5),
      self.token(.star,                 start: loc6, end: loc7),
      self.token(.identifier("nani"),   start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      BinaryOpExpr(context: Load, start: 0:0, end: 9:14)
        Operator: +
        Left
          IdentifierExpr(context: Load, start: 0:0, end: 1:6)
            Value: lilo
        Right
          BinaryOpExpr(context: Load, start: 4:4, end: 9:14)
            Operator: *
            Left
              IdentifierExpr(context: Load, start: 4:4, end: 5:10)
                Value: stitch
            Right
              IdentifierExpr(context: Load, start: 8:8, end: 9:14)
                Value: nani
    """)
  }
}

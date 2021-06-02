import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftformat:disable consecutiveSpaces

class ParseBitExpr: XCTestCase {

  func test_operators() {
    let variants: [(Token.Kind, BinaryOpExpr.Operator)] = [
      (.vbar, .bitOr), // grammar: expr
      (.circumflex, .bitXor), // grammar: xor_expr
      (.amper, .bitAnd), // grammar: and_expr
      (.leftShift, .leftShift), // grammar: shift_expr
      (.rightShift, .rightShift)
    ]

    for (token, op) in variants {
      let parser = createExprParser(
        createToken(.identifier("lilo"),   start: loc0, end: loc1),
        createToken(token,                 start: loc2, end: loc3),
        createToken(.identifier("stitch"), start: loc4, end: loc5)
      )

      guard let ast = parse(parser) else { continue }

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

  /// 1 << 2 << 4 = (1 << 2) << 4
  func test_shiftGroup_isLeftAssociative() {
    let parser = createExprParser(
      createToken(.identifier("lilo"),   start: loc0, end: loc1),
      createToken(.leftShift,            start: loc2, end: loc3),
      createToken(.identifier("stitch"), start: loc4, end: loc5),
      createToken(.leftShift,            start: loc6, end: loc7),
      createToken(.identifier("nani"),   start: loc8, end: loc9)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      BinaryOpExpr(context: Load, start: 0:0, end: 9:14)
        Operator: <<
        Left
          BinaryOpExpr(context: Load, start: 0:0, end: 5:10)
            Operator: <<
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

  /// 1 & 2 & 4 = (1 & 2) & 4
  func test_andGroup_isLeftAssociative() {
    let parser = createExprParser(
      createToken(.identifier("lilo"),   start: loc0, end: loc1),
      createToken(.amper,                start: loc2, end: loc3),
      createToken(.identifier("stitch"), start: loc4, end: loc5),
      createToken(.amper,                start: loc6, end: loc7),
      createToken(.identifier("nani"),   start: loc8, end: loc9)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      BinaryOpExpr(context: Load, start: 0:0, end: 9:14)
        Operator: &
        Left
          BinaryOpExpr(context: Load, start: 0:0, end: 5:10)
            Operator: &
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

  /// 1 ^ 2 ^ 4 = (1 ^ 2) ^ 4
  func test_xorGroup_isLeftAssociative() {
    let parser = createExprParser(
      createToken(.identifier("lilo"),   start: loc0, end: loc1),
      createToken(.circumflex,           start: loc2, end: loc3),
      createToken(.identifier("stitch"), start: loc4, end: loc5),
      createToken(.circumflex,           start: loc6, end: loc7),
      createToken(.identifier("nani"),   start: loc8, end: loc9)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      BinaryOpExpr(context: Load, start: 0:0, end: 9:14)
        Operator: ^
        Left
          BinaryOpExpr(context: Load, start: 0:0, end: 5:10)
            Operator: ^
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

  /// 1 | 2 | 4 = (1 | 2) | 4
  func test_orGroup_isLeftAssociative() {
    let parser = createExprParser(
      createToken(.identifier("lilo"),  start: loc0, end: loc1),
      createToken(.vbar,                 start: loc2, end: loc3),
      createToken(.identifier("stitch"), start: loc4, end: loc5),
      createToken(.vbar,                 start: loc6, end: loc7),
      createToken(.identifier("nani"),  start: loc8, end: loc9)
    )

    guard let ast = parse(parser) else { return }

    XCTAssertAST(ast, """
    ExpressionAST(start: 0:0, end: 9:14)
      BinaryOpExpr(context: Load, start: 0:0, end: 9:14)
        Operator: |
        Left
          BinaryOpExpr(context: Load, start: 0:0, end: 5:10)
            Operator: |
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

  // MARK: - Precedence (skipped)
}

import XCTest
import Core
import Lexer
@testable import Parser

class ArithmeticExprTests: XCTestCase, Common, ExpressionMatcher {

  func test_unaryOpertors() {
    let variants: [(TokenKind, UnaryOperator)] = [
      (.plus, .plus), // grammar: factor
      (.minus, .minus),
      (.tilde, .invert)
    ]

    for (token, op) in variants {
      var parser = self.createExprParser(
        self.token(token,               start: loc0, end: loc1),
        self.token(.identifier("lilo"), start: loc2, end: loc3)
      )

      if let expr = self.parseExpr(&parser) {
        let msg = "for token '\(token)'"

        guard let unaryOp = self.matchUnaryOp(expr) else { return }
        XCTAssertEqual(unaryOp.0, op)
        XCTAssertExpression(unaryOp.right, "lilo", msg)

        XCTAssertExpression(expr, "(\(op) lilo)", msg)
        XCTAssertEqual(expr.start, loc0, msg)
        XCTAssertEqual(expr.end,   loc3, msg)
      }
    }
  }

  func test_binaryOperators() {
    let variants: [(TokenKind, BinaryOperator)] = [
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
      var parser = self.createExprParser(
        self.token(.identifier("lilo"),   start: loc0, end: loc1),
        self.token(token,                 start: loc2, end: loc3),
        self.token(.identifier("stitch"), start: loc4, end: loc5)
      )

      if let expr = self.parseExpr(&parser) {
        let msg = "for token '\(token)'"

        guard let binOp = self.matchBinaryOp(expr) else { return }
        XCTAssertEqual(binOp.0, op, msg)
        XCTAssertExpression(binOp.left,  "lilo", msg)
        XCTAssertExpression(binOp.right, "stitch", msg)

        XCTAssertExpression(expr, "(\(op) lilo stitch)", msg)
        XCTAssertEqual(expr.start, loc0, msg)
        XCTAssertEqual(expr.end,   loc5, msg)
      }
    }
  }

  // MARK: - Associativity

  /// -+4.2 = -(+4.2)
  func test_unaryGroup_isRightAssociative() {
    var parser = self.createExprParser(
      self.token(.minus,      start: loc0, end: loc1),
      self.token(.plus,       start: loc2, end: loc3),
      self.token(.identifier("lilo"), start: loc4, end: loc5)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "(- (+ lilo))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc5)
    }
  }

  /// 4.2 ** 3.1 ** 2.0 -> 4.2 ** (3.1 ** 2.0)
  /// For example: 2 ** 3 ** 4 = 2 ** 81 = 2417851639229258349412352
  func test_powerGroup_isRightAssociative() {
    var parser = self.createExprParser(
      self.token(.identifier("lilo"),   start: loc0, end: loc1),
      self.token(.starStar,             start: loc2, end: loc3),
      self.token(.identifier("stitch"), start: loc4, end: loc5),
      self.token(.starStar,             start: loc6, end: loc7),
      self.token(.identifier("nani"),   start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "(** lilo (** stitch nani))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  /// 4.2 + 3.1 - 2.0 -> (4.2 + 3.1) - 2.0
  func test_addGroup_isLeftAssociative() {
    var parser = self.createExprParser(
      self.token(.identifier("lilo"),   start: loc0, end: loc1),
      self.token(.plus,                 start: loc2, end: loc3),
      self.token(.identifier("stitch"), start: loc4, end: loc5),
      self.token(.minus,                start: loc6, end: loc7),
      self.token(.identifier("nani"),   start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "(- (+ lilo stitch) nani)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  /// 4.2 * 3.1 / 2.0 -> (4.2 * 3.1) / 2.0
  func test_mulGroup_isLeftAssociative() {
    var parser = self.createExprParser(
      self.token(.identifier("lilo"),   start: loc0, end: loc1),
      self.token(.star,                 start: loc2, end: loc3),
      self.token(.identifier("stitch"), start: loc4, end: loc5),
      self.token(.slash,                start: loc6, end: loc7),
      self.token(.identifier("nani"),   start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "(/ (* lilo stitch) nani)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  // MARK: - Precedence

  /// 4.2 * -3.1 = 4.2 * (-3.1)
  func test_minus_hasHigherPrecedence_thanMul() {
    var parser = self.createExprParser(
      self.token(.identifier("lilo"),   start: loc0, end: loc1),
      self.token(.star,                 start: loc2, end: loc3),
      self.token(.minus,                start: loc4, end: loc5),
      self.token(.identifier("stitch"), start: loc6, end: loc7)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "(* lilo (- stitch))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc7)
    }
  }

  /// 4.2 + 3.1 * 2.0 = 4.2 + (3.1 * 2.0)
  func test_mul_hasHigherPrecedence_thanAdd() {
    var parser = self.createExprParser(
      self.token(.identifier("lilo"),   start: loc0, end: loc1),
      self.token(.plus,                 start: loc2, end: loc3),
      self.token(.identifier("stitch"), start: loc4, end: loc5),
      self.token(.star,                 start: loc6, end: loc7),
      self.token(.identifier("nani"),   start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "(+ lilo (* stitch nani))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }
}

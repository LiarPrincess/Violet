import XCTest
import Core
import Lexer
@testable import Parser

class ArithmeticExprTests: XCTestCase, Common {

  func test_unaryOpertors() {
    let variants: [(TokenKind, UnaryOperator)] = [
      (.plus, .plus), // grammar: factor
      (.minus, .minus),
      (.tilde, .invert)
    ]

    for (token, op) in variants {
      let value = PyInt(42)

      var parser = self.parser(
        self.token(token,       start: self.loc0, end: self.loc1),
        self.token(.int(value), start: self.loc2, end: self.loc3)
      )

      if let expr = self.parse(&parser) {
        let msg = "for token '\(token)'"

        guard let b = self.destructUnary(expr) else { return }

        XCTAssertEqual(b.0, op)
        XCTAssertEqual(b.right, Expression(.int(value), start: self.loc2, end: self.loc3))

        XCTAssertExpression(expr, "(\(op) 42)", msg)
        XCTAssertEqual(expr.start, self.loc0, msg)
        XCTAssertEqual(expr.end,   self.loc3, msg)
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
      var parser = self.parser(
        self.token(.float(4.2), start: self.loc0, end: self.loc1),
        self.token(token,       start: self.loc2, end: self.loc3),
        self.token(.float(3.1), start: self.loc4, end: self.loc5)
      )

      if let expr = self.parse(&parser) {
        let msg = "for token '\(token)'"

        guard let b = self.destructBinary(expr) else { return }

        XCTAssertEqual(b.0, op, msg)
        XCTAssertEqual(b.left,  Expression(.float(4.2), start: self.loc0, end: self.loc1))
        XCTAssertEqual(b.right, Expression(.float(3.1), start: self.loc4, end: self.loc5))

        XCTAssertExpression(expr, "(\(op) 4.2 3.1)", msg)
        XCTAssertEqual(expr.start, self.loc0, msg)
        XCTAssertEqual(expr.end,   self.loc5, msg)
      }
    }
  }

  // MARK: - Associativity

  /// -+4.2 = -(+4.2)
  func test_unaryGroup_isRightAssociative() {
    var parser = self.parser(
      self.token(.minus,      start: self.loc0, end: self.loc1),
      self.token(.plus,       start: self.loc2, end: self.loc3),
      self.token(.float(4.2), start: self.loc4, end: self.loc5)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "(- (+ 4.2))")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc5)
    }
  }

  /// 4.2 ** 3.1 ** 2.0 -> 4.2 ** (3.1 ** 2.0)
  /// For example: 2 ** 3 ** 4 = 2 ** 81 = 2417851639229258349412352
  func test_powerGroup_isRightAssociative() {
    var parser = self.parser(
      self.token(.float(4.2), start: self.loc0, end: self.loc1),
      self.token(.starStar,   start: self.loc2, end: self.loc3),
      self.token(.float(3.1), start: self.loc4, end: self.loc5),
      self.token(.starStar,   start: self.loc6, end: self.loc7),
      self.token(.float(2.0), start: self.loc8, end: self.loc9)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "(** 4.2 (** 3.1 2.0))")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }

  /// 4.2 + 3.1 - 2.0 -> (4.2 + 3.1) - 2.0
  func test_addGroup_isLeftAssociative() {
    var parser = self.parser(
      self.token(.float(4.2), start: self.loc0, end: self.loc1),
      self.token(.plus,       start: self.loc2, end: self.loc3),
      self.token(.float(3.1), start: self.loc4, end: self.loc5),
      self.token(.minus,      start: self.loc6, end: self.loc7),
      self.token(.float(2.0), start: self.loc8, end: self.loc9)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "(- (+ 4.2 3.1) 2.0)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }

  /// 4.2 * 3.1 / 2.0 -> (4.2 * 3.1) / 2.0
  func test_mulGroup_isLeftAssociative() {
    var parser = self.parser(
      self.token(.float(4.2), start: self.loc0, end: self.loc1),
      self.token(.star,       start: self.loc2, end: self.loc3),
      self.token(.float(3.1), start: self.loc4, end: self.loc5),
      self.token(.slash,      start: self.loc6, end: self.loc7),
      self.token(.float(2.0), start: self.loc8, end: self.loc9)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "(/ (* 4.2 3.1) 2.0)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }

  // MARK: - Precedence

  /// 4.2 * -3.1 = 4.2 * (-3.1)
  func test_minus_hasHigherPrecedence_thanMul() {
    var parser = self.parser(
      self.token(.float(4.2), start: self.loc0, end: self.loc1),
      self.token(.star,       start: self.loc2, end: self.loc3),
      self.token(.minus,      start: self.loc4, end: self.loc5),
      self.token(.float(3.1), start: self.loc6, end: self.loc7)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "(* 4.2 (- 3.1))")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc7)
    }
  }

  /// 4.2 + 3.1 * 2.0 = 4.2 + (3.1 * 2.0)
  func test_mul_hasHigherPrecedence_thanAdd() {
    var parser = self.parser(
      self.token(.float(4.2), start: self.loc0, end: self.loc1),
      self.token(.plus,       start: self.loc2, end: self.loc3),
      self.token(.float(3.1), start: self.loc4, end: self.loc5),
      self.token(.star,       start: self.loc6, end: self.loc7),
      self.token(.float(2.0), start: self.loc8, end: self.loc9)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "(+ 4.2 (* 3.1 2.0))")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }
}

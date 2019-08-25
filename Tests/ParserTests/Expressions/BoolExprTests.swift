import XCTest
import Core
import Lexer
@testable import Parser

class BoolExprTests: XCTestCase, Common, ExpressionMatcher {

  func test_notOperator() {
    var parser = self.createExprParser(
      self.token(.not,   start: loc0, end: loc1),
      self.token(.false, start: loc2, end: loc3)
    )

    if let expr = self.parseExpr(&parser) {

      guard let unaryOp = self.matchUnaryOp(expr) else { return }
      XCTAssertEqual(unaryOp.0, .not)
      XCTAssertExpression(unaryOp.right, "False")

      XCTAssertExpression(expr, "(not False)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc3)
    }
  }

  func test_and_or_operators() {
    let variants: [(TokenKind, BooleanOperator)] = [
      (.or, .or), // grammar: or_test
      (.and, .and) // grammar: and_test
    ]

    for (token, op) in variants {
      var parser = self.createExprParser(
        self.token(.true,  start: loc0, end: loc1),
        self.token(token,  start: loc2, end: loc3),
        self.token(.false, start: loc4, end: loc5)
      )

      if let expr = self.parseExpr(&parser) {
        let msg = "for token '\(token)'"

        guard let binOp = self.matchBoolOp(expr) else { return }
        XCTAssertEqual(binOp.0, op, msg)
        XCTAssertExpression(binOp.left,  "True", msg)
        XCTAssertExpression(binOp.right, "False", msg)

        XCTAssertExpression(expr, "(\(op) True False)", msg)
        XCTAssertEqual(expr.start, loc0, msg)
        XCTAssertEqual(expr.end,   loc5, msg)
      }
    }
  }

  // MARK: - Associativity

  /// not not false = not (not false)
  func test_not_isRightAssociative() {
    var parser = self.createExprParser(
      self.token(.not,   start: loc0, end: loc1),
      self.token(.not,   start: loc2, end: loc3),
      self.token(.false, start: loc4, end: loc5)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "(not (not False))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc5)
    }
  }

  /// true and false and true = (true and false) and true
  func test_and_isLeftAssociative() {
    var parser = self.createExprParser(
      self.token(.true,  start: loc0, end: loc1),
      self.token(.and,   start: loc2, end: loc3),
      self.token(.false, start: loc4, end: loc5),
      self.token(.and,   start: loc6, end: loc7),
      self.token(.true,  start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "(and (and True False) True)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  /// true or false or true = (true or false) or true
  func test_or_isLeftAssociative() {
    var parser = self.createExprParser(
      self.token(.true,  start: loc0, end: loc1),
      self.token(.or,    start: loc2, end: loc3),
      self.token(.false, start: loc4, end: loc5),
      self.token(.or,    start: loc6, end: loc7),
      self.token(.true,  start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "(or (or True False) True)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  // MARK: - Precedence

  /// not true and false = (not true) and false
  func test_not_hasHigherPrecedence_thanAnd() {
    var parser = self.createExprParser(
      self.token(.not,   start: loc0, end: loc1),
      self.token(.true,  start: loc2, end: loc3),
      self.token(.and,   start: loc4, end: loc5),
      self.token(.false, start: loc6, end: loc7)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "(and (not True) False)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc7)
    }
  }

  /// true or false and true = true or (false and true)
  func test_and_hasHigherPrecedence_thanOr() {
    var parser = self.createExprParser(
      self.token(.true,  start: loc0, end: loc1),
      self.token(.or,    start: loc2, end: loc3),
      self.token(.false, start: loc4, end: loc5),
      self.token(.and,   start: loc6, end: loc7),
      self.token(.true,  start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "(or True (and False True))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }
}

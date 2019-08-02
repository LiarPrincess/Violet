import XCTest
import Core
import Lexer
@testable import Parser

class BoolExprTests: XCTestCase, Common {

  func test_notOperator() {
    var parser = self.parser(
      self.token(.not,   start: self.loc0, end: self.loc1),
      self.token(.false, start: self.loc2, end: self.loc3)
    )

    if let expr = self.parse(&parser) {
      guard let b = self.destructUnary(expr) else { return }

      XCTAssertEqual(b.0, .not)
      XCTAssertEqual(b.right, Expression(.false, start: self.loc2, end: self.loc3))

      XCTAssertExpression(expr, "(not False)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc3)
    }
  }

  func test_and_or_operators() {
    let variants: [(TokenKind, BooleanOperator)] = [
      (.or, .or), // grammar: or_test
      (.and, .and) // grammar: and_test
    ]

    for (token, op) in variants {
      var parser = self.parser(
        self.token(.true,  start: self.loc0, end: self.loc1),
        self.token(token,  start: self.loc2, end: self.loc3),
        self.token(.false, start: self.loc4, end: self.loc5)
      )

      if let expr = self.parse(&parser) {
        let msg = "for token '\(token)'"

        guard let b = self.destructBoolean(expr) else { return }

        XCTAssertEqual(b.0, op, msg)
        XCTAssertEqual(b.left,  Expression(.true, start: self.loc0, end: self.loc1), msg)
        XCTAssertEqual(b.right, Expression(.false, start: self.loc4, end: self.loc5), msg)

        XCTAssertExpression(expr, "(\(op) True False)", msg)
        XCTAssertEqual(expr.start, self.loc0, msg)
        XCTAssertEqual(expr.end,   self.loc5, msg)
      }
    }
  }

  // MARK: - Associativity

  /// not not false = not (not false)
  func test_not_isRightAssociative() {
    var parser = self.parser(
      self.token(.not,   start: self.loc0, end: self.loc1),
      self.token(.not,   start: self.loc2, end: self.loc3),
      self.token(.false, start: self.loc4, end: self.loc5)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "(not (not False))")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc5)
    }
  }

  /// true and false and true = (true and false) and true
  func test_and_isLeftAssociative() {
    var parser = self.parser(
      self.token(.true,  start: self.loc0, end: self.loc1),
      self.token(.and,   start: self.loc2, end: self.loc3),
      self.token(.false, start: self.loc4, end: self.loc5),
      self.token(.and,   start: self.loc6, end: self.loc7),
      self.token(.true,  start: self.loc8, end: self.loc9)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "(and (and True False) True)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }

  /// true or false or true = (true or false) or true
  func test_or_isLeftAssociative() {
    var parser = self.parser(
      self.token(.true,  start: self.loc0, end: self.loc1),
      self.token(.or,    start: self.loc2, end: self.loc3),
      self.token(.false, start: self.loc4, end: self.loc5),
      self.token(.or,    start: self.loc6, end: self.loc7),
      self.token(.true,  start: self.loc8, end: self.loc9)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "(or (or True False) True)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }

  // MARK: - Precedence

  /// not true and false = (not true) and false
  func test_not_hasHigherPrecedence_thanAnd() {
    var parser = self.parser(
      self.token(.not,   start: self.loc0, end: self.loc1),
      self.token(.true,  start: self.loc2, end: self.loc3),
      self.token(.and,   start: self.loc4, end: self.loc5),
      self.token(.false, start: self.loc6, end: self.loc7)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "(and (not True) False)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc7)
    }
  }

  /// true or false and true = true or (false and true)
  func test_and_hasHigherPrecedence_thanOr() {
    var parser = self.parser(
      self.token(.true,  start: self.loc0, end: self.loc1),
      self.token(.or,    start: self.loc2, end: self.loc3),
      self.token(.false, start: self.loc4, end: self.loc5),
      self.token(.and,   start: self.loc6, end: self.loc7),
      self.token(.true,  start: self.loc8, end: self.loc9)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "(or True (and False True))")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }
}

import XCTest
import Core
import Lexer
@testable import Parser

class ComparisonTests: XCTestCase, Common, DestructExpressionKind {

  func test_simple() {
    let variants: [(TokenKind, ComparisonOperator)] = [
      (.equalEqual, .equal),
      (.notEqual,   .notEqual),
      // <> - pep401 is not implmented
      (.less,      .less),
      (.lessEqual, .lessEqual),
      (.greater,      .greater),
      (.greaterEqual, .greaterEqual),
      (.in,  .in),
      (.is,  .is)
      // not in - separate test
      // is not - separate test
    ]

    for (token, op) in variants {
      var parser = self.createExprParser(
        self.token(.float(1.0), start: loc0, end: loc1),
        self.token(token,       start: loc2, end: loc3),
        self.token(.float(2.0), start: loc4, end: loc5)
      )

      if let expr = self.parseExpr(&parser) {
        let msg = "for token '\(token)'"

        guard let b = self.destructCompare(expr) else { return }

        let two = Expression(.float(2.0), start: loc4, end: loc5)
        XCTAssertEqual(b.left, Expression(.float(1.0), start: loc0, end: loc1), msg)
        XCTAssertEqual(b.elements, [ComparisonElement(op: op, right: two)], msg)

        XCTAssertExpression(expr, "(1.0 \(op) 2.0)", msg)
        XCTAssertEqual(expr.start, loc0, msg)
        XCTAssertEqual(expr.end,   loc5, msg)
      }
    }
  }

  /// this does not make sense: '1.0 not in 2.0', but it is not sema...
  func test_notIn() {
    var parser = self.createExprParser(
      self.token(.float(1.0), start: loc0, end: loc1),
      self.token(.not,        start: loc2, end: loc3),
      self.token(.in,         start: loc4, end: loc5),
      self.token(.float(2.0), start: loc6, end: loc7)
    )

    if let expr = self.parseExpr(&parser) {
      guard let b = self.destructCompare(expr) else { return }

      let two = Expression(.float(2.0), start: loc6, end: loc7)
      XCTAssertEqual(b.left, Expression(.float(1.0), start: loc0, end: loc1))
      XCTAssertEqual(b.elements, [ComparisonElement(op: .notIn, right: two)])

      XCTAssertExpression(expr, "(1.0 not in 2.0)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc7)
    }
  }

  /// '1.0 is not 2.0'
  func test_isNot() {
    var parser = self.createExprParser(
      self.token(.float(1.0), start: loc0, end: loc1),
      self.token(.is,         start: loc2, end: loc3),
      self.token(.not,        start: loc4, end: loc5),
      self.token(.float(2.0), start: loc6, end: loc7)
    )

    if let expr = self.parseExpr(&parser) {
      guard let b = self.destructCompare(expr) else { return }

      let two = Expression(.float(2.0), start: loc6, end: loc7)
      XCTAssertEqual(b.left, Expression(.float(1.0), start: loc0, end: loc1))
      XCTAssertEqual(b.elements, [ComparisonElement(op: .isNot, right: two)])

      XCTAssertExpression(expr, "(1.0 is not 2.0)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc7)
    }
  }

  /// complex compare: 1 < 2 <= 3
  func test_compare_withMultipleElements() {
    var parser = self.createExprParser(
      self.token(.float(1.0), start: loc0, end: loc1),
      self.token(.less,       start: loc2, end: loc3),
      self.token(.float(2.0), start: loc4, end: loc5),
      self.token(.lessEqual,  start: loc6, end: loc7),
      self.token(.float(3.0), start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "(1.0 < 2.0 <= 3.0)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }
}

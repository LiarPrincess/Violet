import XCTest
import Core
import Lexer
@testable import Parser

class ParseComparisonExpr: XCTestCase, Common, ExpressionMatcher {

  func test_operators() {
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
        self.token(.identifier("aladdin"), start: loc0, end: loc1),
        self.token(token,                  start: loc2, end: loc3),
        self.token(.identifier("jasmine"), start: loc4, end: loc5)
      )

      if let expr = self.parseExpr(&parser) {
        let msg = "for token '\(token)'"

        guard let comp = self.matchCompare(expr) else { return }
        XCTAssertExpression(comp.left, "aladdin", msg)

        XCTAssertEqual(comp.elements.count, 1, msg)
        guard comp.elements.count == 1 else { return }

        XCTAssertEqual(comp.elements[0].op, op, msg)
        XCTAssertExpression(comp.elements[0].right, "jasmine", msg)

        XCTAssertExpression(expr, "(aladdin \(op) jasmine)", msg)
        XCTAssertEqual(expr.start, loc0, msg)
        XCTAssertEqual(expr.end,   loc5, msg)
      }
    }
  }

  func test_notIn() {
    var parser = self.createExprParser(
      self.token(.identifier("rapunzel"), start: loc0, end: loc1),
      self.token(.not,                    start: loc2, end: loc3),
      self.token(.in,                     start: loc4, end: loc5),
      self.token(.identifier("aladdin"),  start: loc6, end: loc7)
    )

    if let expr = self.parseExpr(&parser) {
      guard let comp = self.matchCompare(expr) else { return }
      XCTAssertExpression(comp.left, "rapunzel")

      XCTAssertEqual(comp.elements.count, 1)
      guard comp.elements.count == 1 else { return }

      XCTAssertEqual(comp.elements[0].op, .notIn)
      XCTAssertExpression(comp.elements[0].right, "aladdin")

      XCTAssertExpression(expr, "(rapunzel not in aladdin)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc7)
    }
  }

  func test_isNot() {
    var parser = self.createExprParser(
      self.token(.identifier("aladdin"), start: loc0, end: loc1),
      self.token(.is,                    start: loc2, end: loc3),
      self.token(.not,                   start: loc4, end: loc5),
      self.token(.identifier("jasmine"), start: loc6, end: loc7)
    )

    if let expr = self.parseExpr(&parser) {
      guard let comp = self.matchCompare(expr) else { return }
      XCTAssertExpression(comp.left, "aladdin")

      XCTAssertEqual(comp.elements.count, 1)
      guard comp.elements.count == 1 else { return }

      XCTAssertEqual(comp.elements[0].op, .isNot)
      XCTAssertExpression(comp.elements[0].right, "jasmine")

      XCTAssertExpression(expr, "(aladdin is not jasmine)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc7)
    }
  }

  /// aladdin < jasmine <= genie
  func test_compare_withMultipleElements() {
    var parser = self.createExprParser(
      self.token(.identifier("aladdin"), start: loc0, end: loc1),
      self.token(.less,                  start: loc2, end: loc3),
      self.token(.identifier("jasmine"), start: loc4, end: loc5),
      self.token(.lessEqual,             start: loc6, end: loc7),
      self.token(.identifier("genie"),   start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "(aladdin < jasmine <= genie)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }
}

import XCTest
import Core
import Lexer
@testable import Parser

class ParseAttribute: XCTestCase, Common, ExpressionMatcher, SliceMatcher {

  /// a.b
  func test_simple() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.dot,             start: loc2, end: loc3),
      self.token(.identifier("b"), start: loc4, end: loc5)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchAttribute(expr) else { return }
      XCTAssertExpression(d.0, "a")
      XCTAssertEqual(d.name, "b")

      XCTAssertExpression(expr, "a.b")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc5)
    }
  }

  /// a.b.c = (a.b).c
  func test_isLeftAssociative() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.dot,             start: loc2, end: loc3),
      self.token(.identifier("b"), start: loc4, end: loc5),
      self.token(.dot,             start: loc6, end: loc7),
      self.token(.identifier("c"), start: loc7, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d0 = self.matchAttribute(expr) else { return }
      XCTAssertExpression(d0.0, "a.b")
      XCTAssertEqual(d0.name, "c")

      guard let d1 = self.matchAttribute(d0.0) else { return }
      XCTAssertExpression(d1.0, "a")
      XCTAssertEqual(d1.name, "b")

      XCTAssertExpression(expr, "a.b.c")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }
}

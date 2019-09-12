import XCTest
import Core
import Lexer
@testable import Parser

class ParseIfExpr: XCTestCase, Common, ExpressionMatcher {

  /// prince if belle else beast
  func test_simple() {
    var parser = self.createExprParser(
      self.token(.identifier("prince"), start: loc0, end: loc1),
      self.token(.if,                   start: loc2, end: loc3),
      self.token(.identifier("belle"),  start: loc4, end: loc5),
      self.token(.else,                 start: loc6, end: loc7),
      self.token(.identifier("beast"),  start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchIfExpression(expr) else { return }

      XCTAssertExpression(d.test, "belle")
      XCTAssertExpression(d.body, "prince")
      XCTAssertExpression(d.orElse, "beast")

      XCTAssertExpression(expr, "(if belle then prince else beast)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }
}

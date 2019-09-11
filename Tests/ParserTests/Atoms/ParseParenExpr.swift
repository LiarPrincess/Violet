import XCTest
import Core
import Lexer
@testable import Parser

class ParseParenExpr: XCTestCase, Common, ExpressionMatcher {

  // MARK: - Empty

  /// ()
  func test_emptyTuple() {
    var parser = self.createExprParser(
      self.token(.leftParen,  start: loc0, end: loc1),
      self.token(.rightParen, start: loc2, end: loc3)
    )

    if let expr = self.parseExpr(&parser) {
      guard let tupleExpr = self.matchTuple(expr) else { return }
      XCTAssertEqual(tupleExpr.count, 0)

      XCTAssertExpression(expr, "()")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc3)
    }
  }

  // MARK: - Single

  /// (elsa)
  func test_value() {
    var parser = self.createExprParser(
      self.token(.leftParen,          start: loc0, end: loc1),
      self.token(.identifier("elsa"), start: loc2, end: loc3),
      self.token(.rightParen,         start: loc4, end: loc5)
    )

    if let expr = self.parseExpr(&parser) {
      guard let id = self.matchIdentifier(expr) else { return }
      XCTAssertEqual(id, "elsa")

      XCTAssertExpression(expr, "elsa")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc5)
    }
  }

  // MARK: - Tuple

  /// (elsa,)
  func test_value_withComaAfter_givesTuple() {
    var parser = self.createExprParser(
      self.token(.leftParen,          start: loc0, end: loc1),
      self.token(.identifier("elsa"), start: loc2, end: loc3),
      self.token(.comma,              start: loc4, end: loc5),
      self.token(.rightParen,         start: loc6, end: loc7)
    )

    if let expr = self.parseExpr(&parser) {
      guard let tupleExpr = self.matchTuple(expr) else { return }

      XCTAssertEqual(tupleExpr.count, 1)
      guard tupleExpr.count == 1 else { return }
      XCTAssertExpression(tupleExpr[0], "elsa")

      XCTAssertExpression(expr, "(elsa)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc7)
    }
  }

  /// (elsa, anna)
  func test_tuple() {
    var parser = self.createExprParser(
      self.token(.leftParen,          start: loc0, end: loc1),
      self.token(.identifier("elsa"), start: loc2, end: loc3),
      self.token(.comma,              start: loc4, end: loc5),
      self.token(.identifier("anna"), start: loc6, end: loc7),
      self.token(.rightParen,         start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      guard let tupleExpr = self.matchTuple(expr) else { return }

      XCTAssertEqual(tupleExpr.count, 2)
      guard tupleExpr.count == 2 else { return }
      XCTAssertExpression(tupleExpr[0], "elsa")
      XCTAssertExpression(tupleExpr[1], "anna")

      XCTAssertExpression(expr, "(elsa anna)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  // MARK: - Yield

  /// (yield)
  func test_yield_nil() {
    var parser = self.createExprParser(
      self.token(.leftParen,  start: loc0, end: loc1),
      self.token(.yield,      start: loc2, end: loc3),
      self.token(.rightParen, start: loc4, end: loc5)
    )

    if let expr = self.parseExpr(&parser) {
      guard let yieldExpr = self.matchYield(expr) else { return }
      XCTAssertEqual(yieldExpr, nil)

      XCTAssertExpression(expr, "(yield)")
      XCTAssertEqual(expr.start, loc2)
      XCTAssertEqual(expr.end,   loc3)
    }
  }

  /// (yield elsa)
  func test_yield_expr() {
    var parser = self.createExprParser(
      self.token(.leftParen,          start: loc0, end: loc1),
      self.token(.yield,              start: loc2, end: loc3),
      self.token(.identifier("elsa"), start: loc4, end: loc5),
      self.token(.rightParen,         start: loc6, end: loc7)
    )

    if let expr = self.parseExpr(&parser) {
      guard let yieldExpr = self.matchYield(expr) else { return }
      XCTAssertExpression(yieldExpr, "elsa")

      XCTAssertExpression(expr, "(yield elsa)")
      XCTAssertEqual(expr.start, loc2)
      XCTAssertEqual(expr.end,   loc5)
    }
  }

  /// (yield elsa, anna)
  func test_yield_tuple() {
    var parser = self.createExprParser(
      self.token(.leftParen,          start: loc0, end: loc1),
      self.token(.yield,              start: loc2, end: loc3),
      self.token(.identifier("elsa"), start: loc4, end: loc5),
      self.token(.comma,              start: loc6, end: loc7),
      self.token(.identifier("anna"), start: loc8, end: loc9),
      self.token(.rightParen,         start: loc10, end: loc11)
    )

    if let expr = self.parseExpr(&parser) {
      guard let yieldExpr = self.matchYield(expr) else { return }
      XCTAssertExpression(yieldExpr, "(elsa anna)")

      XCTAssertExpression(expr, "(yield (elsa anna))")
      XCTAssertEqual(expr.start, loc2)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  // MARK: - Generator expr

  /// (elsa for anna in [])
  func test_generator() {
    var parser = self.createExprParser(
      self.token(.leftParen,          start: loc0, end: loc1),
      self.token(.identifier("elsa"), start: loc2, end: loc3),
      self.token(.for,                start: loc4, end: loc5),
      self.token(.identifier("anna"), start: loc6, end: loc7),
      self.token(.in,                 start: loc8, end: loc9),
      self.token(.leftSqb,            start: loc10, end: loc11),
      self.token(.rightSqb,           start: loc12, end: loc13),
      self.token(.rightParen,         start: loc14, end: loc15)
    )

    if let expr = self.parseExpr(&parser) {
      guard let genExpr = self.matchGeneratorExp(expr) else { return }
      XCTAssertExpression(genExpr.elt, "elsa")

      XCTAssertEqual(genExpr.generators.count, 1)
      guard genExpr.generators.count == 1 else { return }

      let g = genExpr.generators[0]
      XCTAssertEqual(g.isAsync, false)
      XCTAssertExpression(g.target, "anna")
      XCTAssertExpression(g.iter, "[]")
      XCTAssertEqual(g.ifs.count, 0)
      XCTAssertEqual(g.start, loc4)
      XCTAssertEqual(g.end, loc13)

      XCTAssertExpression(expr, "(generatorCompr elsa (for anna in []))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc15)
    }
  }
}

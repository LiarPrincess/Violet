import XCTest
import Core
import Lexer
@testable import Parser

class ParseSet: XCTestCase, Common, ExpressionMatcher {

  // MARK: - Set

  /// {rapunzel}
  func test_singleElement() {
    var parser = self.createExprParser(
      self.token(.leftBrace,              start: loc0, end: loc1),
      self.token(.identifier("rapunzel"), start: loc2, end: loc3),
      self.token(.rightBrace,             start: loc4, end: loc5)
    )

    if let expr = self.parseExpr(&parser) {
      guard let setExpr = self.matchSet(expr) else { return }

      XCTAssertEqual(setExpr.count, 1)
      guard setExpr.count == 1 else { return }
      XCTAssertExpression(setExpr[0], "rapunzel")

      XCTAssertExpression(expr, "{rapunzel}")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc5)
    }
  }

  /// {rapunzel,}
  func test_withComaAfter() {
    var parser = self.createExprParser(
      self.token(.leftBrace,              start: loc0, end: loc1),
      self.token(.identifier("rapunzel"), start: loc2, end: loc3),
      self.token(.comma,                  start: loc4, end: loc5),
      self.token(.rightBrace,             start: loc6, end: loc7)
    )

    if let expr = self.parseExpr(&parser) {
      guard let setExpr = self.matchSet(expr) else { return }

      XCTAssertEqual(setExpr.count, 1)
      guard setExpr.count == 1 else { return }
      XCTAssertExpression(setExpr[0], "rapunzel")

      XCTAssertExpression(expr, "{rapunzel}")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc7)
    }
  }

  /// {*1}
  func test_star() {
    var parser = self.createExprParser(
      self.token(.leftBrace,              start: loc0, end: loc1),
      self.token(.star,                   start: loc2, end: loc3),
      self.token(.identifier("rapunzel"), start: loc4, end: loc5),
      self.token(.rightBrace,             start: loc6, end: loc7)
    )

    if let expr = self.parseExpr(&parser) {
      guard let setExpr = self.matchSet(expr) else { return }

      XCTAssertEqual(setExpr.count, 1)
      guard setExpr.count == 1 else { return }
      XCTAssertExpression(setExpr[0], "*rapunzel")

      XCTAssertExpression(expr, "{*rapunzel}")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc7)
    }
  }

  /// {rapunzel, *eugene, cassandra}
  func test_multipleElements() {
    var parser = self.createExprParser(
      self.token(.leftBrace,               start: loc0, end: loc1),
      self.token(.identifier("rapunzel"),  start: loc2, end: loc3),
      self.token(.comma,                   start: loc4, end: loc5),
      self.token(.star,                    start: loc6, end: loc7),
      self.token(.identifier("eugene"),    start: loc8, end: loc9),
      self.token(.comma,                   start: loc10, end: loc11),
      self.token(.identifier("cassandra"), start: loc12, end: loc13),
      self.token(.rightBrace,              start: loc14, end: loc15)
    )

    if let expr = self.parseExpr(&parser) {
      guard let setExpr = self.matchSet(expr) else { return }

      XCTAssertEqual(setExpr.count, 3)
      guard setExpr.count == 3 else { return }
      XCTAssertExpression(setExpr[0], "rapunzel")
      XCTAssertExpression(setExpr[1], "*eugene")
      XCTAssertExpression(setExpr[2], "cassandra")

      XCTAssertExpression(expr, "{rapunzel *eugene cassandra}")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc15)
    }
  }

  // MARK: - Set comprehension

  /// {rapunzel for eugene in []}
  func test_comprehension() {
    var parser = self.createExprParser(
      self.token(.leftBrace,              start: loc0, end: loc1),
      self.token(.identifier("rapunzel"), start: loc2, end: loc3),
      self.token(.for,                    start: loc4, end: loc5),
      self.token(.identifier("eugene"),   start: loc6, end: loc7),
      self.token(.in,                     start: loc8, end: loc9),
      self.token(.leftSqb,                start: loc10, end: loc11),
      self.token(.rightSqb,               start: loc12, end: loc13),
      self.token(.rightBrace,             start: loc14, end: loc15)
    )

    if let expr = self.parseExpr(&parser) {
      guard let setGen = self.matchSetComprehension(expr) else { return }
      XCTAssertExpression(setGen.elt, "rapunzel")

      XCTAssertEqual(setGen.generators.count, 1)
      guard setGen.generators.count == 1 else { return }

      let g = setGen.generators[0]
      XCTAssertEqual(g.isAsync, false)
      XCTAssertExpression(g.target, "eugene")
      XCTAssertExpression(g.iter, "[]")
      XCTAssertEqual(g.ifs.count, 0)
      XCTAssertEqual(g.start, loc4)
      XCTAssertEqual(g.end, loc13)

      XCTAssertExpression(expr, "(setCompr rapunzel (for eugene in []))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc15)
    }
  }
}

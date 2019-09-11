import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length
// swiftlint:disable function_body_length

class ParseList: XCTestCase, Common, ExpressionMatcher {

  // MARK: - List

  /// []
  func test_empty() {
    var parser = self.createExprParser(
      self.token(.leftSqb,  start: loc0, end: loc1),
      self.token(.rightSqb, start: loc2, end: loc3)
    )

    if let expr = self.parseExpr(&parser) {
      guard let listExpr = self.matchList(expr) else { return }
      XCTAssertEqual(listExpr.count, 0)

      XCTAssertExpression(expr, "[]")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc3)
    }
  }

  /// [ariel]
  func test_value() {
    var parser = self.createExprParser(
      self.token(.leftSqb,             start: loc0, end: loc1),
      self.token(.identifier("ariel"), start: loc2, end: loc3),
      self.token(.rightSqb,            start: loc4, end: loc5)
    )

    if let expr = self.parseExpr(&parser) {
      guard let listExpr = self.matchList(expr) else { return }

      XCTAssertEqual(listExpr.count, 1)
      guard listExpr.count == 1 else { return }
      XCTAssertExpression(listExpr[0], "ariel")

      XCTAssertExpression(expr, "[ariel]")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc5)
    }
  }

  /// [ariel,]
  func test_value_withComaAfter() {
    var parser = self.createExprParser(
      self.token(.leftSqb,             start: loc0, end: loc1),
      self.token(.identifier("ariel"), start: loc2, end: loc3),
      self.token(.comma,               start: loc4, end: loc5),
      self.token(.rightSqb,            start: loc6, end: loc7)
    )

    if let expr = self.parseExpr(&parser) {
      guard let listExpr = self.matchList(expr) else { return }

      XCTAssertEqual(listExpr.count, 1)
      guard listExpr.count == 1 else { return }
      XCTAssertExpression(listExpr[0], "ariel")

      XCTAssertExpression(expr, "[ariel]")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc7)
    }
  }

  /// [ariel, eric]
  func test_value_multiple() {
    var parser = self.createExprParser(
      self.token(.leftSqb,             start: loc0, end: loc1),
      self.token(.identifier("ariel"), start: loc2, end: loc3),
      self.token(.comma,               start: loc4, end: loc5),
      self.token(.identifier("eric"),  start: loc6, end: loc7),
      self.token(.rightSqb,            start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      guard let listExpr = self.matchList(expr) else { return }

      XCTAssertEqual(listExpr.count, 2)
      guard listExpr.count == 2 else { return }
      XCTAssertExpression(listExpr[0], "ariel")
      XCTAssertExpression(listExpr[1], "eric")

      XCTAssertExpression(expr, "[ariel eric]")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  // MARK: - Comprehension

  /// [ariel for eric in []]
  func test_comprehension_list() {
    var parser = self.createExprParser(
      self.token(.leftSqb,         start: loc0, end: loc1),
      self.token(.identifier("ariel"), start: loc2, end: loc3),
      self.token(.for,             start: loc4, end: loc5),
      self.token(.identifier("eric"), start: loc6, end: loc7),
      self.token(.in,              start: loc8, end: loc9),
      self.token(.leftSqb,         start: loc10, end: loc11),
      self.token(.rightSqb,        start: loc12, end: loc13),
      self.token(.rightSqb,        start: loc14, end: loc15)
    )

    if let expr = self.parseExpr(&parser) {
      guard let listGen = self.matchListComprehension(expr) else { return }
      XCTAssertExpression(listGen.elt, "ariel")

      XCTAssertEqual(listGen.generators.count, 1)
      guard listGen.generators.count == 1 else { return }

      let g = listGen.generators[0]
      XCTAssertEqual(g.isAsync, false)
      XCTAssertExpression(g.target, "eric")
      XCTAssertExpression(g.iter, "[]")
      XCTAssertEqual(g.ifs.count, 0)
      XCTAssertEqual(g.start, loc4)
      XCTAssertEqual(g.end, loc13)

      XCTAssertExpression(expr, "(listCompr ariel (for eric in []))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc15)
    }
  }

  /// [ariel async for eric in []]
  func test_comprehension_async() {
    var parser = self.createExprParser(
      self.token(.leftSqb,             start: loc0, end: loc1),
      self.token(.identifier("ariel"), start: loc2, end: loc3),
      self.token(.async,               start: loc4, end: loc5),
      self.token(.for,                 start: loc6, end: loc7),
      self.token(.identifier("eric"),  start: loc8, end: loc9),
      self.token(.in,                  start: loc10, end: loc11),
      self.token(.leftSqb,             start: loc12, end: loc13),
      self.token(.rightSqb,            start: loc14, end: loc15),
      self.token(.rightSqb,            start: loc16, end: loc17)
    )

    if let expr = self.parseExpr(&parser) {
      guard let listGen = self.matchListComprehension(expr) else { return }
      XCTAssertExpression(listGen.elt, "ariel")

      XCTAssertEqual(listGen.generators.count, 1)
      guard listGen.generators.count == 1 else { return }

      let g = listGen.generators[0]
      XCTAssertEqual(g.isAsync, true)
      XCTAssertExpression(g.target, "eric")
      XCTAssertExpression(g.iter, "[]")
      XCTAssertEqual(g.ifs.count, 0)
      XCTAssertEqual(g.start, loc4)
      XCTAssertEqual(g.end, loc15)

      XCTAssertExpression(expr, "(listCompr ariel (async for eric in []))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc17)
    }
  }

  /// [ariel for eric, sebastian in []]
  func test_comprehension_target_multiple() {
    var parser = self.createExprParser(
      self.token(.leftSqb,                 start: loc0, end: loc1),
      self.token(.identifier("ariel"),     start: loc2, end: loc3),
      self.token(.for,                     start: loc4, end: loc5),
      self.token(.identifier("eric"),      start: loc6, end: loc7),
      self.token(.comma,                   start: loc8, end: loc9),
      self.token(.identifier("sebastian"), start: loc10, end: loc11),
      self.token(.in,                      start: loc12, end: loc13),
      self.token(.leftSqb,                 start: loc14, end: loc15),
      self.token(.rightSqb,                start: loc16, end: loc17),
      self.token(.rightSqb,                start: loc18, end: loc19)
    )

    if let expr = self.parseExpr(&parser) {
      guard let listGen = self.matchListComprehension(expr) else { return }
      XCTAssertExpression(listGen.elt, "ariel")

      XCTAssertEqual(listGen.generators.count, 1)
      guard listGen.generators.count == 1 else { return }

      let g = listGen.generators[0]
      XCTAssertEqual(g.isAsync, false)
      XCTAssertExpression(g.target, "(eric sebastian)")
      XCTAssertExpression(g.iter, "[]")
      XCTAssertEqual(g.ifs.count, 0)
      XCTAssertEqual(g.start, loc4)
      XCTAssertEqual(g.end, loc17)

      XCTAssertExpression(expr, "(listCompr ariel (for (eric sebastian) in []))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc19)
    }
  }

  /// [ariel for eric, in []]
  func test_comprehension_target_withCommaAfter_isTuple() {
    var parser = self.createExprParser(
      self.token(.leftSqb,             start: loc0, end: loc1),
      self.token(.identifier("ariel"), start: loc2, end: loc3),
      self.token(.for,                 start: loc4, end: loc5),
      self.token(.identifier("eric"),  start: loc6, end: loc7),
      self.token(.comma,               start: loc8, end: loc9),
      self.token(.in,                  start: loc10, end: loc11),
      self.token(.leftSqb,             start: loc12, end: loc13),
      self.token(.rightSqb,            start: loc14, end: loc15),
      self.token(.rightSqb,            start: loc16, end: loc17)
    )

    if let expr = self.parseExpr(&parser) {
      guard let listGen = self.matchListComprehension(expr) else { return }
      XCTAssertExpression(listGen.elt, "ariel")

      XCTAssertEqual(listGen.generators.count, 1)
      guard listGen.generators.count == 1 else { return }

      let g = listGen.generators[0]
      XCTAssertEqual(g.isAsync, false)
      XCTAssertExpression(g.target, "(eric)")
      XCTAssertExpression(g.iter, "[]")
      XCTAssertEqual(g.ifs.count, 0)
      XCTAssertEqual(g.start, loc4)
      XCTAssertEqual(g.end, loc15)

      XCTAssertExpression(expr, "(listCompr ariel (for (eric) in []))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc17)
    }
  }

  /// [ariel for eric in [] for sebastian in []]
  func test_comprehension_for_multiple() {
    var parser = self.createExprParser(
      self.token(.leftSqb,                 start: loc0, end: loc1),
      self.token(.identifier("ariel"),     start: loc2, end: loc3),
      self.token(.for,                     start: loc4, end: loc5),
      self.token(.identifier("eric"),      start: loc6, end: loc7),
      self.token(.in,                      start: loc8, end: loc9),
      self.token(.leftSqb,                 start: loc10, end: loc11),
      self.token(.rightSqb,                start: loc12, end: loc13),
      self.token(.for,                     start: loc14, end: loc15),
      self.token(.identifier("sebastian"), start: loc16, end: loc17),
      self.token(.in,                      start: loc18, end: loc19),
      self.token(.leftSqb,                 start: loc20, end: loc21),
      self.token(.rightSqb,                start: loc22, end: loc23),
      self.token(.rightSqb,                start: loc24, end: loc25)
    )

    if let expr = self.parseExpr(&parser) {
      guard let listGen = self.matchListComprehension(expr) else { return }
      XCTAssertExpression(listGen.elt, "ariel")

      XCTAssertEqual(listGen.generators.count, 2)
      guard listGen.generators.count == 2 else { return }

      let g0 = listGen.generators[0]
      XCTAssertEqual(g0.isAsync, false)
      XCTAssertExpression(g0.target, "eric")
      XCTAssertExpression(g0.iter, "[]")
      XCTAssertEqual(g0.ifs.count, 0)
      XCTAssertEqual(g0.start, loc4)
      XCTAssertEqual(g0.end, loc13)

      let g1 = listGen.generators[1]
      XCTAssertEqual(g1.isAsync, false)
      XCTAssertExpression(g1.target, "sebastian")
      XCTAssertExpression(g1.iter, "[]")
      XCTAssertEqual(g1.ifs.count, 0)
      XCTAssertEqual(g1.start, loc14)
      XCTAssertEqual(g1.end, loc23)

      XCTAssertExpression(expr, "(listCompr ariel (for eric in []) (for sebastian in []))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc25)
    }
  }

  /// [ariel for eric in [] if sebastian if flounder]
  func test_comprehension_ifs_multiple() {
    var parser = self.createExprParser(
      self.token(.leftSqb,                 start: loc0, end: loc1),
      self.token(.identifier("ariel"),     start: loc2, end: loc3),
      self.token(.for,                     start: loc4, end: loc5),
      self.token(.identifier("eric"),      start: loc6, end: loc7),
      self.token(.in,                      start: loc8, end: loc9),
      self.token(.leftSqb,                 start: loc10, end: loc11),
      self.token(.rightSqb,                start: loc12, end: loc13),
      self.token(.if,                      start: loc14, end: loc15),
      self.token(.identifier("sebastian"), start: loc16, end: loc17),
      self.token(.if,                      start: loc18, end: loc19),
      self.token(.identifier("flounder"),  start: loc20, end: loc21),
      self.token(.rightSqb,                start: loc22, end: loc23)
    )

    if let expr = self.parseExpr(&parser) {
      guard let listGen = self.matchListComprehension(expr) else { return }
      XCTAssertExpression(listGen.elt, "ariel")

      XCTAssertEqual(listGen.generators.count, 1)
      guard listGen.generators.count == 1 else { return }

      let g = listGen.generators[0]
      XCTAssertEqual(g.isAsync, false)
      XCTAssertExpression(g.target, "eric")
      XCTAssertExpression(g.iter, "[]")
      XCTAssertEqual(g.ifs.count, 2)
      XCTAssertEqual(g.start, loc4)
      XCTAssertEqual(g.end, loc21)

      guard g.ifs.count == 2 else { return }
      XCTAssertExpression(g.ifs[0], "sebastian")
      XCTAssertExpression(g.ifs[1], "flounder")

      XCTAssertExpression(expr, "(listCompr ariel (for eric in [] (if sebastian flounder)))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc23)
    }
  }
}

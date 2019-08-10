import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length
// swiftlint:disable function_body_length

class AtomSquareBracketTests: XCTestCase, Common, DestructExpressionKind {

  // MARK: - List

  /// []
  func test_empty() {
    var parser = self.createExprParser(
      self.token(.leftSqb,  start: loc0, end: loc1),
      self.token(.rightSqb, start: loc2, end: loc3)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "[]")
      XCTAssertEqual(expr.kind,  .list([]))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc3)
    }
  }

  /// [1]
  func test_value() {
    var parser = self.createExprParser(
      self.token(.leftSqb,    start: loc0, end: loc1),
      self.token(.float(1.0), start: loc2, end: loc3),
      self.token(.rightSqb,   start: loc4, end: loc5)
    )

    if let expr = self.parseExpr(&parser) {
      let one = Expression(.float(1.0), start: loc2, end: loc3)

      XCTAssertExpression(expr, "[1.0]")
      XCTAssertEqual(expr.kind,  .list([one]))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc5)
    }
  }

  /// [1,]
  func test_value_withComaAfter() {
    var parser = self.createExprParser(
      self.token(.leftSqb,    start: loc0, end: loc1),
      self.token(.float(1.0), start: loc2, end: loc3),
      self.token(.comma,      start: loc4, end: loc5),
      self.token(.rightSqb,   start: loc6, end: loc7)
    )

    if let expr = self.parseExpr(&parser) {
      let one = Expression(.float(1.0), start: loc2, end: loc3)

      XCTAssertExpression(expr, "[1.0]")
      XCTAssertEqual(expr.kind,  .list([one]))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc7)
    }
  }

  /// [1, 2]
  func test_value_multiple() {
    var parser = self.createExprParser(
      self.token(.leftSqb,    start: loc0, end: loc1),
      self.token(.float(1.0), start: loc2, end: loc3),
      self.token(.comma,      start: loc4, end: loc5),
      self.token(.float(2.0), start: loc6, end: loc7),
      self.token(.rightSqb,   start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      let one = Expression(.float(1.0), start: loc2, end: loc3)
      let two = Expression(.float(2.0), start: loc6, end: loc7)

      XCTAssertExpression(expr, "[1.0 2.0]")
      XCTAssertEqual(expr.kind,  .list([one, two]))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  // MARK: - Comprehension

  /// [a for b in []]
  func test_list() {
    var parser = self.createExprParser(
      self.token(.leftSqb,         start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.for,             start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7),
      self.token(.in,              start: loc8, end: loc9),
      self.token(.leftSqb,         start: loc10, end: loc11),
      self.token(.rightSqb,        start: loc12, end: loc13),
      self.token(.rightSqb,        start: loc14, end: loc15)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructListComprehension(expr) else { return }

      XCTAssertEqual(d.elt, Expression(.identifier("a"), start: loc2, end: loc3))

      XCTAssertEqual(d.generators.count, 1)
      guard d.generators.count == 1 else { return }

      let g = d.generators[0]
      XCTAssertEqual(g.isAsync, false)
      XCTAssertEqual(g.target, Expression(.identifier("b"), start: loc6, end: loc7))
      XCTAssertEqual(g.iter, Expression(.list([]), start: loc10, end: loc13))
      XCTAssertEqual(g.ifs.count, 0)
      XCTAssertEqual(g.start, loc4)
      XCTAssertEqual(g.end, loc13)

      XCTAssertExpression(expr, "(listCompr a (for b in []))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc15)
    }
  }

  /// [a async for b in []]
  func test_list_async() {
    var parser = self.createExprParser(
      self.token(.leftSqb,         start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.async,           start: loc4, end: loc5),
      self.token(.for,             start: loc6, end: loc7),
      self.token(.identifier("b"), start: loc8, end: loc9),
      self.token(.in,              start: loc10, end: loc11),
      self.token(.leftSqb,         start: loc12, end: loc13),
      self.token(.rightSqb,        start: loc14, end: loc15),
      self.token(.rightSqb,        start: loc16, end: loc17)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructListComprehension(expr) else { return }

      XCTAssertEqual(d.elt, Expression(.identifier("a"), start: loc2, end: loc3))

      XCTAssertEqual(d.generators.count, 1)
      guard d.generators.count == 1 else { return }

      let gen = d.generators[0]
      XCTAssertEqual(gen.isAsync, true)
      XCTAssertEqual(gen.target, Expression(.identifier("b"), start: loc8, end: loc9))
      XCTAssertEqual(gen.iter, Expression(.list([]), start: loc12, end: loc15))
      XCTAssertEqual(gen.ifs.count, 0)
      XCTAssertEqual(gen.start, loc4)
      XCTAssertEqual(gen.end, loc15)

      XCTAssertExpression(expr, "(listCompr a (async for b in []))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc17)
    }
  }

  /// [a for b, c in []]
  func test_list_target_multiple() {
    var parser = self.createExprParser(
      self.token(.leftSqb,         start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.for,             start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7),
      self.token(.comma,           start: loc8, end: loc9),
      self.token(.identifier("c"), start: loc10, end: loc11),
      self.token(.in,              start: loc12, end: loc13),
      self.token(.leftSqb,         start: loc14, end: loc15),
      self.token(.rightSqb,        start: loc16, end: loc17),
      self.token(.rightSqb,        start: loc18, end: loc19)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructListComprehension(expr) else { return }

      XCTAssertEqual(d.elt, Expression(.identifier("a"), start: loc2, end: loc3))

      XCTAssertEqual(d.generators.count, 1)
      guard d.generators.count == 1 else { return }

      let gen = d.generators[0]
      XCTAssertEqual(gen.isAsync, false)
      XCTAssertEqual(gen.target, Expression(
        .tuple([
          Expression(.identifier("b"), start: loc6, end: loc7),
          Expression(.identifier("c"), start: loc10, end: loc11)
        ]),
        start: loc6,
        end: loc11)
      )
      XCTAssertEqual(gen.iter, Expression(.list([]), start: loc14, end: loc17))
      XCTAssertEqual(gen.ifs.count, 0)
      XCTAssertEqual(gen.start, loc4)
      XCTAssertEqual(gen.end, loc17)

      XCTAssertExpression(expr, "(listCompr a (for (b c) in []))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc19)
    }
  }

  /// [a for b, in []]
  func test_list_target_withCommaAfter_isTuple() {
    var parser = self.createExprParser(
      self.token(.leftSqb,         start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.for,             start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7),
      self.token(.comma,           start: loc8, end: loc9),
      self.token(.in,              start: loc10, end: loc11),
      self.token(.leftSqb,         start: loc12, end: loc13),
      self.token(.rightSqb,        start: loc14, end: loc15),
      self.token(.rightSqb,        start: loc16, end: loc17)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructListComprehension(expr) else { return }

      XCTAssertEqual(d.elt, Expression(.identifier("a"), start: loc2, end: loc3))

      XCTAssertEqual(d.generators.count, 1)
      guard d.generators.count == 1 else { return }

      let gen = d.generators[0]
      XCTAssertEqual(gen.isAsync, false)
      XCTAssertEqual(gen.target, Expression(
        .tuple([
          Expression(.identifier("b"), start: loc6, end: loc7)
        ]),
        start: loc6,
        end: loc9)
      )
      XCTAssertEqual(gen.iter, Expression(.list([]), start: loc12, end: loc15))
      XCTAssertEqual(gen.ifs.count, 0)
      XCTAssertEqual(gen.start, loc4)
      XCTAssertEqual(gen.end, loc15)

      XCTAssertExpression(expr, "(listCompr a (for (b) in []))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc17)
    }
  }

  /// [a for b in [] for c in []]
  func test_list_for_multiple() {
    var parser = self.createExprParser(
      self.token(.leftSqb,         start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.for,             start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7),
      self.token(.in,              start: loc8, end: loc9),
      self.token(.leftSqb,         start: loc10, end: loc11),
      self.token(.rightSqb,        start: loc12, end: loc13),
      self.token(.for,             start: loc14, end: loc15),
      self.token(.identifier("c"), start: loc16, end: loc17),
      self.token(.in,              start: loc18, end: loc19),
      self.token(.leftSqb,         start: loc20, end: loc21),
      self.token(.rightSqb,        start: loc22, end: loc23),
      self.token(.rightSqb,        start: loc24, end: loc25)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructListComprehension(expr) else { return }

      XCTAssertEqual(d.elt, Expression(.identifier("a"), start: loc2, end: loc3))

      XCTAssertEqual(d.generators.count, 2)
      guard d.generators.count == 2 else { return }

      let gen0 = d.generators[0]
      XCTAssertEqual(gen0.isAsync, false)
      XCTAssertEqual(gen0.target, Expression(.identifier("b"), start: loc6, end: loc7))
      XCTAssertEqual(gen0.iter, Expression(.list([]), start: loc10, end: loc13))
      XCTAssertEqual(gen0.ifs.count, 0)
      XCTAssertEqual(gen0.start, loc4)
      XCTAssertEqual(gen0.end, loc13)

      let gen1 = d.generators[1]
      XCTAssertEqual(gen1.isAsync, false)
      XCTAssertEqual(gen1.target, Expression(.identifier("c"), start: loc16, end: loc17))
      XCTAssertEqual(gen1.iter, Expression(.list([]), start: loc20, end: loc23))
      XCTAssertEqual(gen1.ifs.count, 0)
      XCTAssertEqual(gen1.start, loc14)
      XCTAssertEqual(gen1.end, loc23)

      XCTAssertExpression(expr, "(listCompr a (for b in []) (for c in []))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc25)
    }
  }

  /// [a for b in [] if c if d]
  func test_list_ifs_multiple() {
    var parser = self.createExprParser(
      self.token(.leftSqb,         start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.for,             start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7),
      self.token(.in,              start: loc8, end: loc9),
      self.token(.leftSqb,         start: loc10, end: loc11),
      self.token(.rightSqb,        start: loc12, end: loc13),
      self.token(.if,              start: loc14, end: loc15),
      self.token(.identifier("c"), start: loc16, end: loc17),
      self.token(.if,              start: loc18, end: loc19),
      self.token(.identifier("d"), start: loc20, end: loc21),
      self.token(.rightSqb,        start: loc22, end: loc23)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructListComprehension(expr) else { return }

      XCTAssertEqual(d.elt, Expression(.identifier("a"), start: loc2, end: loc3))

      XCTAssertEqual(d.generators.count, 1)
      guard d.generators.count == 1 else { return }

      let gen = d.generators[0]
      XCTAssertEqual(gen.isAsync, false)
      XCTAssertEqual(gen.target, Expression(.identifier("b"), start: loc6, end: loc7))
      XCTAssertEqual(gen.iter, Expression(.list([]), start: loc10, end: loc13))
      XCTAssertEqual(gen.ifs.count, 2)
      guard gen.ifs.count == 2 else { return }
      XCTAssertEqual(gen.ifs[0], Expression(.identifier("c"), start: loc16, end: loc17))
      XCTAssertEqual(gen.ifs[1], Expression(.identifier("d"), start: loc20, end: loc21))
      XCTAssertEqual(gen.start, loc4)
      XCTAssertEqual(gen.end, loc21)

      XCTAssertExpression(expr, "(listCompr a (for b in [] (if c d)))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc23)
    }
  }
}

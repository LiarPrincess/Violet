import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable function_body_length

class CallComprehensionTests: XCTestCase, Common, DestructExpressionKind {

  /// f(a for b in [])
  func test_simple() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.for,             start: loc6, end: loc7),
      self.token(.identifier("b"), start: loc8, end: loc9),
      self.token(.in,              start: loc10, end: loc11),
      self.token(.leftSqb,         start: loc12, end: loc13),
      self.token(.rightSqb,        start: loc14, end: loc15),
      self.token(.rightParen,      start: loc16, end: loc17)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructCall(expr) else { return }

      XCTAssertEqual(d.func, Expression(.identifier("f"), start: loc0, end: loc1))
      XCTAssertEqual(d.keywords, [])

      XCTAssertEqual(d.args.count, 1)
      guard d.args.count == 1 else { return }
      guard let gen = self.destructGeneratorExp(d.args[0]) else { return }

      XCTAssertEqual(gen.elt, Expression(.identifier("a"), start: loc4, end: loc5))
      XCTAssertEqual(gen.generators.count, 1)
      guard gen.generators.count == 1 else { return }

      let g = gen.generators[0]
      XCTAssertEqual(g.isAsync, false)
      XCTAssertEqual(g.target, Expression(.identifier("b"), start: loc8, end: loc9))
      XCTAssertEqual(g.iter, Expression(.list([]), start: loc12, end: loc15))
      XCTAssertEqual(g.ifs.count, 0)
      XCTAssertEqual(g.start, loc6)
      XCTAssertEqual(g.end, loc15)

      XCTAssertExpression(expr, "(call f (generatorCompr a (for b in [])))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc17)
    }
  }

  /// f(1, a for b in [])
  func test_afterPositional() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.float(1.0),      start: loc6, end: loc7),
      self.token(.comma,           start: loc8, end: loc9),
      self.token(.identifier("a"), start: loc10, end: loc11),
      self.token(.for,             start: loc12, end: loc13),
      self.token(.identifier("b"), start: loc14, end: loc15),
      self.token(.in,              start: loc16, end: loc17),
      self.token(.leftSqb,         start: loc18, end: loc19),
      self.token(.rightSqb,        start: loc20, end: loc21),
      self.token(.rightParen,      start: loc22, end: loc23)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructCall(expr) else { return }

      XCTAssertEqual(d.func, Expression(.identifier("f"), start: loc0, end: loc1))
      XCTAssertEqual(d.args.count, 2)
      XCTAssertEqual(d.keywords, [])

      // We don't have to check detailed props,
      // if the basic tests are working then this one should too.

      XCTAssertExpression(expr, "(call f 1.0 (generatorCompr a (for b in [])))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc23)
    }
  }

  /// f(1, (a for b in []))
  func test_afterPositional_inParens() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.float(1.0),      start: loc6, end: loc7),
      self.token(.comma,           start: loc8, end: loc9),
      self.token(.leftParen,       start: loc10, end: loc11),
      self.token(.identifier("a"), start: loc12, end: loc13),
      self.token(.for,             start: loc14, end: loc15),
      self.token(.identifier("b"), start: loc16, end: loc17),
      self.token(.in,              start: loc18, end: loc19),
      self.token(.leftSqb,         start: loc20, end: loc21),
      self.token(.rightSqb,        start: loc22, end: loc23),
      self.token(.rightParen,      start: loc24, end: loc25),
      self.token(.rightParen,      start: loc26, end: loc27)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructCall(expr) else { return }

      XCTAssertEqual(d.func, Expression(.identifier("f"), start: loc0, end: loc1))
      XCTAssertEqual(d.args.count, 2)
      XCTAssertEqual(d.keywords, [])

      // We don't have to check detailed props,
      // if the basic tests are working then this one should too.

      XCTAssertExpression(expr, "(call f 1.0 (generatorCompr a (for b in [])))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc27)
    }
  }

  /// f(a for b in [], 1)
  func test_beforePositional() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc11),
      self.token(.for,             start: loc6, end: loc13),
      self.token(.identifier("b"), start: loc8, end: loc15),
      self.token(.in,              start: loc10, end: loc17),
      self.token(.leftSqb,         start: loc12, end: loc19),
      self.token(.rightSqb,        start: loc14, end: loc21),
      self.token(.comma,           start: loc16, end: loc9),
      self.token(.float(1.0),      start: loc18, end: loc7),
      self.token(.rightParen,      start: loc20, end: loc23)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructCall(expr) else { return }

      XCTAssertEqual(d.func, Expression(.identifier("f"), start: loc0, end: loc1))
      XCTAssertEqual(d.args.count, 2)
      XCTAssertEqual(d.keywords, [])

      // We don't have to check detailed props,
      // if the basic tests are working then this one should too.

      XCTAssertExpression(expr, "(call f (generatorCompr a (for b in [])) 1.0)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc23)
    }
  }

  /// f(a for b in [])
  func test_commaAfter() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.for,             start: loc6, end: loc7),
      self.token(.identifier("b"), start: loc8, end: loc9),
      self.token(.in,              start: loc10, end: loc11),
      self.token(.leftSqb,         start: loc12, end: loc13),
      self.token(.rightSqb,        start: loc14, end: loc15),
      self.token(.comma,           start: loc16, end: loc17),
      self.token(.rightParen,      start: loc18, end: loc19)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructCall(expr) else { return }

      XCTAssertEqual(d.func, Expression(.identifier("f"), start: loc0, end: loc1))
      XCTAssertEqual(d.args.count, 1)
      XCTAssertEqual(d.keywords, [])

      guard d.args.count == 1 else { return }
      guard let gen = self.destructGeneratorExp(d.args[0]) else { return }

      XCTAssertEqual(gen.elt, Expression(.identifier("a"), start: loc4, end: loc5))
      XCTAssertEqual(gen.generators.count, 1)
      guard gen.generators.count == 1 else { return }

      let g = gen.generators[0]
      XCTAssertEqual(g.isAsync, false)
      XCTAssertEqual(g.target, Expression(.identifier("b"), start: loc8, end: loc9))
      XCTAssertEqual(g.iter, Expression(.list([]), start: loc12, end: loc15))
      XCTAssertEqual(g.ifs.count, 0)
      XCTAssertEqual(g.start, loc6)
      XCTAssertEqual(g.end, loc15)

      XCTAssertExpression(expr, "(call f (generatorCompr a (for b in [])))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc19)
    }
  }
}

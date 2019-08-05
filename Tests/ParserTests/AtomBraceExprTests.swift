import XCTest
import Core
import Lexer
@testable import Parser

class AtomBraceExprTests: XCTestCase, Common, DestructExpressionKind {

  // MARK: - Empty

  /// {}
  func test_empty_givesDictionary() {
    var parser = self.parser(
      self.token(.leftBrace,  start: loc0, end: loc1),
      self.token(.rightBrace, start: loc2, end: loc3)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "{}")
      XCTAssertEqual(expr.kind,  .dictionary([]))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc3)
    }
  }

  // MARK: - Set

  /// {1}
  func test_set_singleElement() {
    var parser = self.parser(
      self.token(.leftBrace,  start: loc0, end: loc1),
      self.token(.float(1.0), start: loc2, end: loc3),
      self.token(.rightBrace, start: loc4, end: loc5)
    )

    if let expr = self.parse(&parser) {
      let one = Expression(.float(1.0), start: loc2, end: loc3)

      XCTAssertExpression(expr, "{1.0}")
      XCTAssertEqual(expr.kind,  .set([one]))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc5)
    }
  }

  /// {1,}
  func test_set_withComaAfter() {
    var parser = self.parser(
      self.token(.leftBrace,  start: loc0, end: loc1),
      self.token(.float(1.0), start: loc2, end: loc3),
      self.token(.comma,      start: loc4, end: loc5),
      self.token(.rightBrace, start: loc6, end: loc7)
    )

    if let expr = self.parse(&parser) {
      let one = Expression(.float(1.0), start: loc2, end: loc3)

      XCTAssertExpression(expr, "{1.0}")
      XCTAssertEqual(expr.kind,  .set([one]))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc7)
    }
  }

  /// {*1}
  func test_set_star() {
    var parser = self.parser(
      self.token(.leftBrace,  start: loc0, end: loc1),
      self.token(.star,       start: loc2, end: loc3),
      self.token(.float(1.0), start: loc4, end: loc5),
      self.token(.rightBrace, start: loc6, end: loc7)
    )

    if let expr = self.parse(&parser) {
      let one = Expression(.float(1.0), start: loc4, end: loc5)
      let star = Expression(.starred(one), start: loc2, end: loc5)

      dump(expr.kind)

      XCTAssertExpression(expr, "{*1.0}")
      XCTAssertEqual(expr.kind,  .set([star]))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc7)
    }
  }

  /// {1, *2, 3}
  func test_set_multipleElements() {
    var parser = self.parser(
      self.token(.leftBrace,  start: loc0, end: loc1),
      self.token(.float(1.0), start: loc2, end: loc3),
      self.token(.comma,      start: loc4, end: loc5),
      self.token(.star,       start: loc6, end: loc7),
      self.token(.float(2.0), start: loc8, end: loc9),
      self.token(.comma,      start: loc10, end: loc11),
      self.token(.float(3.0), start: loc12, end: loc13),
      self.token(.rightBrace, start: loc14, end: loc15)
    )

    if let expr = self.parse(&parser) {
      let one = Expression(.float(1.0), start: loc2, end: loc3)
      let two = Expression(.float(2.0), start: loc8, end: loc9)
      let starTwo = Expression(.starred(two), start: loc6, end: loc9)
      let three = Expression(.float(3.0), start: loc12, end: loc13)

      XCTAssertExpression(expr, "{1.0 *2.0 3.0}")
      XCTAssertEqual(expr.kind,  .set([one, starTwo, three]))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc15)
    }
  }

  // MARK: - Set comprehension

  /// { a for b in [] }
  func test_set_comprehension() {
    var parser = self.parser(
      self.token(.leftBrace,       start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.for,             start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7),
      self.token(.in,              start: loc8, end: loc9),
      self.token(.leftSqb,         start: loc10, end: loc11),
      self.token(.rightSqb,        start: loc12, end: loc13),
      self.token(.rightBrace,      start: loc14, end: loc15)
    )

    if let expr = self.parse(&parser) {
      guard let d = self.destructSetComprehension(expr) else { return }

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

      XCTAssertExpression(expr, "(setCompr a (for b in []))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc15)
    }
  }

  /*

   // MARK: - Yield

   /// (yield)
   func test_yield_nil() {
   var parser = self.parser(
   self.token(.leftParen,  start: loc0, end: loc1),
   self.token(.yield,      start: loc2, end: loc3),
   self.token(.rightParen, start: loc4, end: loc5)
   )

   if let expr = self.parse(&parser) {
   XCTAssertExpression(expr, "(yield)")
   XCTAssertEqual(expr.kind,  .yield(nil))
   XCTAssertEqual(expr.start, loc2)
   XCTAssertEqual(expr.end,   loc3)
   }
   }

   /// (yield 1.0)
   func test_yield_expr() {
   var parser = self.parser(
   self.token(.leftParen,  start: loc0, end: loc1),
   self.token(.yield,      start: loc2, end: loc3),
   self.token(.float(1.0), start: loc4, end: loc5),
   self.token(.rightParen, start: loc6, end: loc7)
   )

   if let expr = self.parse(&parser) {
   let one = Expression(.float(1.0), start: loc4, end: loc5)

   XCTAssertExpression(expr, "(yield 1.0)")
   XCTAssertEqual(expr.kind,  .yield(one))
   XCTAssertEqual(expr.start, loc2)
   XCTAssertEqual(expr.end,   loc5)
   }
   }

   /// (yield 1.0, )
   func test_yield_tuple() {
   var parser = self.parser(
   self.token(.leftParen,  start: loc0, end: loc1),
   self.token(.yield,      start: loc2, end: loc3),
   self.token(.float(1.0), start: loc4, end: loc5),
   self.token(.comma,      start: loc6, end: loc7),
   self.token(.rightParen, start: loc8, end: loc9)
   )

   if let expr = self.parse(&parser) {
   let one = Expression(.float(1.0), start: loc4, end: loc5)
   let tuple = Expression(.tuple([one]), start: loc4, end: loc5)

   XCTAssertExpression(expr, "(yield (1.0))")
   XCTAssertEqual(expr.kind,  .yield(tuple))
   XCTAssertEqual(expr.start, loc2)
   XCTAssertEqual(expr.end,   loc5)
   }
   }

   // MARK: - Generator expr

   /// (a for b in [])
   func test_generator() {
   var parser = self.parser(
   self.token(.leftParen,       start: loc0, end: loc1),
   self.token(.identifier("a"), start: loc2, end: loc3),
   self.token(.for,             start: loc4, end: loc5),
   self.token(.identifier("b"), start: loc6, end: loc7),
   self.token(.in,              start: loc8, end: loc9),
   self.token(.leftSqb,         start: loc10, end: loc11),
   self.token(.rightSqb,        start: loc12, end: loc13),
   self.token(.rightParen,      start: loc14, end: loc15)
   )

   if let expr = self.parse(&parser) {
   guard let d = self.destructGeneratorExp(expr) else { return }

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

   XCTAssertExpression(expr, "(generatorCompr a (for b in []))")
   XCTAssertEqual(expr.start, loc0)
   XCTAssertEqual(expr.end,   loc15)
   }
   }
   */
}

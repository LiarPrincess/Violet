import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length
// swiftlint:disable function_body_length

class AtomBraceExprTests: XCTestCase, Common, DestructExpressionKind {

  // MARK: - Empty

  /// {}
  func test_empty_givesDictionary() {
    var parser = self.createExprParser(
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
    var parser = self.createExprParser(
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
    var parser = self.createExprParser(
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
    var parser = self.createExprParser(
      self.token(.leftBrace,  start: loc0, end: loc1),
      self.token(.star,       start: loc2, end: loc3),
      self.token(.float(1.0), start: loc4, end: loc5),
      self.token(.rightBrace, start: loc6, end: loc7)
    )

    if let expr = self.parse(&parser) {
      let one = Expression(.float(1.0), start: loc4, end: loc5)
      let star = Expression(.starred(one), start: loc2, end: loc5)

      XCTAssertExpression(expr, "{*1.0}")
      XCTAssertEqual(expr.kind,  .set([star]))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc7)
    }
  }

  /// {1, *2, 3}
  func test_set_multipleElements() {
    var parser = self.createExprParser(
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

  /// {a for b in []}
  func test_set_comprehension() {
    var parser = self.createExprParser(
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

  // MARK: - Dictionary

  /// {a:b}
  func test_dictionary_singleElement() {
    var parser = self.createExprParser(
      self.token(.leftBrace,       start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7),
      self.token(.rightBrace,      start: loc8, end: loc9)
    )

    if let expr = self.parse(&parser) {
      let exprA = Expression(.identifier("a"), start: loc2, end: loc3)
      let exprB = Expression(.identifier("b"), start: loc6, end: loc7)
      let element = DictionaryElement.keyValue(key: exprA, value: exprB)

      XCTAssertExpression(expr, "{a:b}")
      XCTAssertEqual(expr.kind,  .dictionary([element]))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  /// {a:b,}
  func test_dictionary_withComaAfter() {
    var parser = self.createExprParser(
      self.token(.leftBrace,       start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7),
      self.token(.comma,           start: loc8, end: loc9),
      self.token(.rightBrace,      start: loc10, end: loc11)
    )

    if let expr = self.parse(&parser) {
      let exprA = Expression(.identifier("a"), start: loc2, end: loc3)
      let exprB = Expression(.identifier("b"), start: loc6, end: loc7)
      let element = DictionaryElement.keyValue(key: exprA, value: exprB)

      XCTAssertExpression(expr, "{a:b}")
      XCTAssertEqual(expr.kind,  .dictionary([element]))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc11)
    }
  }

  /// {**a}
  func test_dictionary_starStar() {
    var parser = self.createExprParser(
      self.token(.leftBrace,       start: loc0, end: loc1),
      self.token(.starStar,        start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.rightBrace,      start: loc6, end: loc7)
    )

    if let expr = self.parse(&parser) {
      let exprA = Expression(.identifier("a"), start: loc4, end: loc5)
      let element = DictionaryElement.unpacking(exprA)

      XCTAssertExpression(expr, "{**a}")
      XCTAssertEqual(expr.kind,  .dictionary([element]))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc7)
    }
  }

  /// {a:b, **c, d:e}
  func test_dictionary_multipleElements() {
    var parser = self.createExprParser(
      self.token(.leftBrace,       start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7),
      self.token(.comma,           start: loc8, end: loc9),
      self.token(.starStar,        start: loc10, end: loc11),
      self.token(.identifier("c"), start: loc12, end: loc13),
      self.token(.comma,           start: loc14, end: loc15),
      self.token(.identifier("d"), start: loc16, end: loc17),
      self.token(.colon,           start: loc18, end: loc19),
      self.token(.identifier("e"), start: loc20, end: loc21),
      self.token(.rightBrace,      start: loc22, end: loc23)
    )

    if let expr = self.parse(&parser) {
      let exprA = Expression(.identifier("a"), start: loc2, end: loc3)
      let exprB = Expression(.identifier("b"), start: loc6, end: loc7)
      let el0 = DictionaryElement.keyValue(key: exprA, value: exprB)

      let exprC = Expression(.identifier("c"), start: loc12, end: loc13)
      let el1 = DictionaryElement.unpacking(exprC)

      let exprD = Expression(.identifier("d"), start: loc16, end: loc17)
      let exprE = Expression(.identifier("e"), start: loc20, end: loc21)
      let el2 = DictionaryElement.keyValue(key: exprD, value: exprE)

      XCTAssertExpression(expr, "{a:b **c d:e}")
      XCTAssertEqual(expr.kind,  .dictionary([el0, el1, el2]))
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc23)
    }
  }

  // MARK: - Dictionary comprehension

  /// { a:b for c in [] }
  func test_dictionary_comprehension() {
    var parser = self.createExprParser(
      self.token(.leftBrace,       start: loc0, end: loc1),
      self.token(.identifier("a"), start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.identifier("b"), start: loc6, end: loc7),
      self.token(.for,             start: loc8, end: loc9),
      self.token(.identifier("c"), start: loc10, end: loc11),
      self.token(.in,              start: loc12, end: loc13),
      self.token(.leftSqb,         start: loc14, end: loc15),
      self.token(.rightSqb,        start: loc16, end: loc17),
      self.token(.rightBrace,      start: loc18, end: loc19)
    )

    if let expr = self.parse(&parser) {
      guard let d = self.destructDictionaryComprehension(expr) else { return }

      XCTAssertEqual(d.key,   Expression(.identifier("a"), start: loc2, end: loc3))
      XCTAssertEqual(d.value, Expression(.identifier("b"), start: loc6, end: loc7))

      XCTAssertEqual(d.generators.count, 1)
      guard d.generators.count == 1 else { return }

      let g = d.generators[0]
      XCTAssertEqual(g.isAsync, false)
      XCTAssertEqual(g.target, Expression(.identifier("c"), start: loc10, end: loc11))
      XCTAssertEqual(g.iter, Expression(.list([]), start: loc14, end: loc17))
      XCTAssertEqual(g.ifs.count, 0)
      XCTAssertEqual(g.start, loc8)
      XCTAssertEqual(g.end, loc17)

      XCTAssertExpression(expr, "(dicCompr a:b (for c in []))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc19)
    }
  }

  /// { **a for b in [] }
  func test_dictUnpacking_insideComprehension_throws() {
    var parser = self.createExprParser(
      self.token(.leftBrace,       start: loc0, end: loc1),
      self.token(.starStar,        start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.for,             start: loc6, end: loc7),
      self.token(.identifier("b"), start: loc8, end: loc9),
      self.token(.in,              start: loc10, end: loc11),
      self.token(.leftSqb,         start: loc12, end: loc13),
      self.token(.rightSqb,        start: loc14, end: loc15),
      self.token(.rightBrace,      start: loc16, end: loc17)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .dictUnpackingInsideComprehension)
      XCTAssertEqual(error.location, loc2)
    }
  }
}

import XCTest
import Core
import Lexer
@testable import Parser

class ParseDictionary: XCTestCase, Common, ExpressionMatcher {

  // MARK: - Empty

  /// {}
  func test_empty() {
    var parser = self.createExprParser(
      self.token(.leftBrace,  start: loc0, end: loc1),
      self.token(.rightBrace, start: loc2, end: loc3)
    )

    if let expr = self.parseExpr(&parser) {
      guard let dicExpr = self.matchDictionary(expr) else { return }
      XCTAssertEqual(dicExpr.count, 0)

      XCTAssertExpression(expr, "{}")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc3)
    }
  }

  // MARK: - Dictionary

  /// {rapunzel:eugene}
  func test_singleElement() {
    var parser = self.createExprParser(
      self.token(.leftBrace,              start: loc0, end: loc1),
      self.token(.identifier("rapunzel"), start: loc2, end: loc3),
      self.token(.colon,                  start: loc4, end: loc5),
      self.token(.identifier("eugene"),   start: loc6, end: loc7),
      self.token(.rightBrace,             start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      guard let dicElts = self.matchDictionary(expr) else { return }

      XCTAssertEqual(dicElts.count, 1)
      guard dicElts.count == 1 else { return }
      XCTAssertDictionaryElement(dicElts[0], key: "rapunzel", value: "eugene")

      XCTAssertExpression(expr, "{rapunzel:eugene}")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  /// {rapunzel:eugene,}
  func test_withComaAfter() {
    var parser = self.createExprParser(
      self.token(.leftBrace,              start: loc0, end: loc1),
      self.token(.identifier("rapunzel"), start: loc2, end: loc3),
      self.token(.colon,                  start: loc4, end: loc5),
      self.token(.identifier("eugene"),   start: loc6, end: loc7),
      self.token(.comma,                  start: loc8, end: loc9),
      self.token(.rightBrace,             start: loc10, end: loc11)
    )

    if let expr = self.parseExpr(&parser) {
      guard let dicElts = self.matchDictionary(expr) else { return }

      XCTAssertEqual(dicElts.count, 1)
      guard dicElts.count == 1 else { return }
      XCTAssertDictionaryElement(dicElts[0], key: "rapunzel", value: "eugene")

      XCTAssertExpression(expr, "{rapunzel:eugene}")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc11)
    }
  }

  /// {**rapunzel}
  func test_starStar() {
    var parser = self.createExprParser(
      self.token(.leftBrace,                   start: loc0, end: loc1),
      self.token(.starStar,                    start: loc2, end: loc3),
      self.token(.identifier("rapunzel"),      start: loc4, end: loc5),
      self.token(.rightBrace,                  start: loc6, end: loc7)
    )

    if let expr = self.parseExpr(&parser) {
      guard let dicElts = self.matchDictionary(expr) else { return }

      XCTAssertEqual(dicElts.count, 1)
      guard dicElts.count == 1 else { return }
      XCTAssertDictionaryElement(dicElts[0], unpacking: "rapunzel")

      XCTAssertExpression(expr, "{**rapunzel}")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc7)
    }
  }

  /// {rapunzel:eugene, **cassandra, pascal:maximus}
  func test_multipleElements() {
    var parser = self.createExprParser(
      self.token(.leftBrace,                   start: loc0, end: loc1),
      self.token(.identifier("rapunzel"),      start: loc2, end: loc3),
      self.token(.colon,                       start: loc4, end: loc5),
      self.token(.identifier("eugene"),        start: loc6, end: loc7),
      self.token(.comma,                       start: loc8, end: loc9),
      self.token(.starStar,                    start: loc10, end: loc11),
      self.token(.identifier("cassandra"),     start: loc12, end: loc13),
      self.token(.comma,                       start: loc14, end: loc15),
      self.token(.identifier("pascal"),        start: loc16, end: loc17),
      self.token(.colon,                       start: loc18, end: loc19),
      self.token(.identifier("maximus"),       start: loc20, end: loc21),
      self.token(.rightBrace,                  start: loc22, end: loc23)
    )

    if let expr = self.parseExpr(&parser) {
      guard let dicElts = self.matchDictionary(expr) else { return }

      XCTAssertEqual(dicElts.count, 3)
      guard dicElts.count == 3 else { return }
      XCTAssertDictionaryElement(dicElts[0], key: "rapunzel", value: "eugene")
      XCTAssertDictionaryElement(dicElts[1], unpacking: "cassandra")
      XCTAssertDictionaryElement(dicElts[2], key: "pascal", value: "maximus")

      XCTAssertExpression(expr, "{rapunzel:eugene **cassandra pascal:maximus}")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc23)
    }
  }

  // MARK: - Dictionary comprehension

  /// { rapunzel:eugene for cassandra in [] }
  func test_comprehension() {
    var parser = self.createExprParser(
      self.token(.leftBrace,                   start: loc0, end: loc1),
      self.token(.identifier("rapunzel"),      start: loc2, end: loc3),
      self.token(.colon,                       start: loc4, end: loc5),
      self.token(.identifier("eugene"),        start: loc6, end: loc7),
      self.token(.for,                         start: loc8, end: loc9),
      self.token(.identifier("cassandra"),     start: loc10, end: loc11),
      self.token(.in,                          start: loc12, end: loc13),
      self.token(.leftSqb,                     start: loc14, end: loc15),
      self.token(.rightSqb,                    start: loc16, end: loc17),
      self.token(.rightBrace,                  start: loc18, end: loc19)
    )

    if let expr = self.parseExpr(&parser) {
      guard let dicCompr = self.matchDictionaryComprehension(expr) else { return }

      XCTAssertExpression(dicCompr.key, "rapunzel")
      XCTAssertExpression(dicCompr.value, "eugene")

      XCTAssertEqual(dicCompr.generators.count, 1)
      guard dicCompr.generators.count == 1 else { return }

      let g = dicCompr.generators[0]
      XCTAssertEqual(g.isAsync, false)
      XCTAssertExpression(g.target, "cassandra")
      XCTAssertExpression(g.iter, "[]")
      XCTAssertEqual(g.ifs.count, 0)
      XCTAssertEqual(g.start, loc8)
      XCTAssertEqual(g.end, loc17)

      XCTAssertExpression(expr, "(dicCompr rapunzel:eugene (for cassandra in []))")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc19)
    }
  }

  /// { **rapunzel for eugene in [] }
  func test_unpacking_insideComprehension_throws() {
    var parser = self.createExprParser(
      self.token(.leftBrace,                   start: loc0, end: loc1),
      self.token(.starStar,                    start: loc2, end: loc3),
      self.token(.identifier("rapunzel"),      start: loc4, end: loc5),
      self.token(.for,                         start: loc6, end: loc7),
      self.token(.identifier("eugene"),        start: loc8, end: loc9),
      self.token(.in,                          start: loc10, end: loc11),
      self.token(.leftSqb,                     start: loc12, end: loc13),
      self.token(.rightSqb,                    start: loc14, end: loc15),
      self.token(.rightBrace,                  start: loc16, end: loc17)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .dictUnpackingInsideComprehension)
      XCTAssertEqual(error.location, loc2)
    }
  }
}

import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length
// swiftlint:disable function_body_length

class AtomBraceTests: XCTestCase, Common, ExpressionMatcher {

  // MARK: - Empty

  /// {}
  func test_empty_givesDictionary() {
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

  // MARK: - Set

  /// {rapunzel}
  func test_set_singleElement() {
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
  func test_set_withComaAfter() {
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
  func test_set_star() {
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
  func test_set_multipleElements() {
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
  func test_set_comprehension() {
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

  // MARK: - Dictionary

  /// {rapunzel:eugene}
  func test_dictionary_singleElement() {
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
  func test_dictionary_withComaAfter() {
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
  func test_dictionary_starStar() {
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
  func test_dictionary_multipleElements() {
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
  func test_dictionary_comprehension() {
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
  func test_dictUnpacking_insideComprehension_throws() {
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

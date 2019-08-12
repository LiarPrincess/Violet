import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length
// swiftlint:disable type_body_length

class CallTests: XCTestCase, Common, DestructExpressionKind {

  // MARK: - No arguments

  /// f()
  func test_noArgs() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.rightParen,      start: loc4, end: loc5)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructCall(expr) else { return }

      XCTAssertEqual(d.func, Expression(.identifier("f"), start: loc0, end: loc1))
      XCTAssertEqual(d.args, [])
      XCTAssertEqual(d.keywords, [])

      XCTAssertExpression(expr, "(call f)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc5)
    }
  }

  // MARK: - Positional

  /// f(1)
  func test_positional_single() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.float(1.0),      start: loc4, end: loc5),
      self.token(.rightParen,      start: loc6, end: loc7)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructCall(expr) else { return }

      XCTAssertEqual(d.func, Expression(.identifier("f"), start: loc0, end: loc1))
      XCTAssertEqual(d.args, [
        Expression(.float(1.0), start: loc4, end: loc5)
      ])
      XCTAssertEqual(d.keywords, [])

      XCTAssertExpression(expr, "(call f 1.0)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc7)
    }
  }

  /// f(a, 1)
  func test_positional_multiple() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.comma,           start: loc6, end: loc7),
      self.token(.float(1.0),      start: loc8, end: loc9),
      self.token(.rightParen,      start: loc10, end: loc11)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructCall(expr) else { return }

      XCTAssertEqual(d.func, Expression(.identifier("f"), start: loc0, end: loc1))
      XCTAssertEqual(d.args, [
        Expression(.identifier("a"), start: loc4, end: loc5),
        Expression(.float(1.0),      start: loc8, end: loc9)
      ])
      XCTAssertEqual(d.keywords, [])

      XCTAssertExpression(expr, "(call f a 1.0)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc11)
    }
  }

  /// f(1,)
  func test_positional_withCommaAfter() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.float(1.0),      start: loc4, end: loc5),
      self.token(.comma,           start: loc6, end: loc7),
      self.token(.rightParen,      start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructCall(expr) else { return }

      XCTAssertEqual(d.func, Expression(.identifier("f"), start: loc0, end: loc1))
      XCTAssertEqual(d.args, [
        Expression(.float(1.0), start: loc4, end: loc5)
      ])
      XCTAssertEqual(d.keywords, [])

      XCTAssertExpression(expr, "(call f 1.0)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  /// f((a))
  func test_positional_withAdditionalParens() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.leftParen,       start: loc4, end: loc5),
      self.token(.identifier("a"), start: loc6, end: loc7),
      self.token(.rightParen,      start: loc8, end: loc9),
      self.token(.rightParen,      start: loc10, end: loc11)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructCall(expr) else { return }

      XCTAssertEqual(d.func, Expression(.identifier("f"), start: loc0, end: loc1))
      XCTAssertEqual(d.args, [
        Expression(.identifier("a"), start: loc4, end: loc9)
      ])
      XCTAssertEqual(d.keywords, [])

      XCTAssertExpression(expr, "(call f a)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc11)
    }
  }

  /// f(a=1, b)
  func test_positional_afterKeyword_throws() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.equal,           start: loc6, end: loc7),
      self.token(.float(1.0),      start: loc8, end: loc9),
      self.token(.comma,           start: loc10, end: loc11),
      self.token(.identifier("b"), start: loc12, end: loc13),
      self.token(.rightParen,      start: loc14, end: loc15)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .callWithPositionalArgumentAfterKeywordArgument)
      XCTAssertEqual(error.location, loc12)
    }
  }

  /// f(**a, b)
  func test_positional_afterKeywordUnpacking_throws() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.starStar,        start: loc6, end: loc7),
      self.token(.identifier("a"), start: loc8, end: loc9),
      self.token(.comma,           start: loc10, end: loc11),
      self.token(.identifier("b"), start: loc12, end: loc13),
      self.token(.rightParen,      start: loc14, end: loc15)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .callWithPositionalArgumentAfterKeywordUnpacking)
      XCTAssertEqual(error.location, loc12)
    }
  }

  // MARK: - Positional - star

  /// f(*a)
  func test_star() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.star,            start: loc4, end: loc5),
      self.token(.identifier("a"), start: loc6, end: loc7),
      self.token(.rightParen,      start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructCall(expr) else { return }

      let argA = Expression(.identifier("a"), start: loc6, end: loc7)
      let starredA = Expression(.starred(argA), start: loc4, end: loc7)

      XCTAssertEqual(d.func, Expression(.identifier("f"), start: loc0, end: loc1))
      XCTAssertEqual(d.args, [starredA])
      XCTAssertEqual(d.keywords, [])

      XCTAssertExpression(expr, "(call f *a)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  /// f(a, *b)
  func test_star_afterPositional() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.comma,           start: loc6, end: loc7),
      self.token(.star,            start: loc8, end: loc9),
      self.token(.identifier("b"), start: loc10, end: loc11),
      self.token(.rightParen,      start: loc12, end: loc13)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructCall(expr) else { return }

      let argA = Expression(.identifier("a"), start: loc4, end: loc5)
      let argB = Expression(.identifier("b"), start: loc10, end: loc11)
      let starredB = Expression(.starred(argB), start: loc8, end: loc11)

      XCTAssertEqual(d.func, Expression(.identifier("f"), start: loc0, end: loc1))
      XCTAssertEqual(d.args, [argA, starredB])
      XCTAssertEqual(d.keywords, [])

      XCTAssertExpression(expr, "(call f a *b)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc13)
    }
  }

  /// f(a=1, *b)
  func test_star_afterKeyword() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.equal,           start: loc6, end: loc7),
      self.token(.float(1.0),      start: loc8, end: loc9),
      self.token(.comma,           start: loc10, end: loc11),
      self.token(.star,            start: loc12, end: loc13),
      self.token(.identifier("b"), start: loc14, end: loc15),
      self.token(.rightParen,      start: loc16, end: loc17)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructCall(expr) else { return }

      let valueA = Expression(.float(1.0), start: loc8, end: loc9)
      let keywordA = Keyword("a", value: valueA, start: loc4, end: loc9)

      let argB = Expression(.identifier("b"), start: loc14, end: loc15)
      let starredB = Expression(.starred(argB), start: loc12, end: loc15)

      XCTAssertEqual(d.func, Expression(.identifier("f"), start: loc0, end: loc1))
      XCTAssertEqual(d.args, [starredB])
      XCTAssertEqual(d.keywords, [keywordA])

      XCTAssertExpression(expr, "(call f *b a=1.0)") // reorder?
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc17)
    }
  }

  /// f(**a, *b)
  func test_star_afterKeywordUnpacking_throws() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.starStar,        start: loc4, end: loc5),
      self.token(.identifier("a"), start: loc6, end: loc7),
      self.token(.comma,           start: loc8, end: loc9),
      self.token(.star,            start: loc10, end: loc11),
      self.token(.identifier("b"), start: loc12, end: loc13),
      self.token(.rightParen,      start: loc14, end: loc15)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .callWithIterableArgumentAfterKeywordUnpacking)
      XCTAssertEqual(error.location, loc10)
    }
  }

  // MARK: - Keyword

  /// f(a=1)
  func test_keyword_single() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.equal,           start: loc6, end: loc7),
      self.token(.float(1.0),      start: loc8, end: loc9),
      self.token(.rightParen,      start: loc10, end: loc11)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructCall(expr) else { return }

      let valueA = Expression(.float(1.0), start: loc8, end: loc9)
      let keywordA = Keyword("a", value: valueA, start: loc4, end: loc9)

      XCTAssertEqual(d.func, Expression(.identifier("f"), start: loc0, end: loc1))
      XCTAssertEqual(d.args, [])
      XCTAssertEqual(d.keywords, [keywordA])

      XCTAssertExpression(expr, "(call f a=1.0)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc11)
    }
  }

  /// f(a=1.0, b=2.0)
  func test_keyword_multiple() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.equal,           start: loc6, end: loc7),
      self.token(.float(1.0),      start: loc8, end: loc9),
      self.token(.comma,           start: loc10, end: loc11),
      self.token(.identifier("b"), start: loc12, end: loc13),
      self.token(.equal,           start: loc14, end: loc15),
      self.token(.float(2.0),      start: loc16, end: loc17),
      self.token(.rightParen,      start: loc18, end: loc19)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructCall(expr) else { return }

      let valueA = Expression(.float(1.0), start: loc8, end: loc9)
      let keywordA = Keyword("a", value: valueA, start: loc4, end: loc9)

      let valueB = Expression(.float(2.0), start: loc16, end: loc17)
      let keywordB = Keyword("b", value: valueB, start: loc12, end: loc17)

      XCTAssertEqual(d.func, Expression(.identifier("f"), start: loc0, end: loc1))
      XCTAssertEqual(d.args, [])
      XCTAssertEqual(d.keywords, [keywordA, keywordB])

      XCTAssertExpression(expr, "(call f a=1.0 b=2.0)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc19)
    }
  }

  /// f(a=1, a=2)
  func test_keyword_duplicate_throws() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.equal,           start: loc6, end: loc7),
      self.token(.float(1.0),      start: loc8, end: loc9),
      self.token(.comma,           start: loc10, end: loc11),
      self.token(.identifier("a"), start: loc12, end: loc13),
      self.token(.equal,           start: loc14, end: loc15),
      self.token(.float(2.0),      start: loc16, end: loc17),
      self.token(.rightParen,      start: loc18, end: loc19)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .callWithDuplicateKeywordArgument("a"))
      XCTAssertEqual(error.location, loc12)
    }
  }

  /// From comment in CPython:
  /// `f(lambda x: x[0] = 3)`
  func test_keyword_lambda_assignment_throws() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.lambda,          start: loc4, end: loc5),
      self.token(.identifier("x"), start: loc6, end: loc7),
      self.token(.colon,           start: loc8, end: loc9),
      self.token(.identifier("x"), start: loc10, end: loc11),
      self.token(.leftSqb,         start: loc12, end: loc13),
      self.token(.int(PyInt(0)),   start: loc14, end: loc15),
      self.token(.rightSqb,        start: loc16, end: loc17),
      self.token(.equal,           start: loc18, end: loc19),
      self.token(.int(PyInt(3)),   start: loc20, end: loc21),
      self.token(.rightParen,      start: loc22, end: loc23)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .callWithLambdaAssignment)
      XCTAssertEqual(error.location, loc4)
    }
  }

  /// f(3=1)
  func test_keyword_invalidName_throws() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.int(PyInt(3)),   start: loc4, end: loc5),
      self.token(.equal,           start: loc6, end: loc7),
      self.token(.int(PyInt(1)),   start: loc8, end: loc9),
      self.token(.rightParen,      start: loc10, end: loc11)
    )

    if let error = self.error(&parser) {
      XCTAssertEqual(error.kind, .callWithKeywordExpression)
      XCTAssertEqual(error.location, loc4)
    }
  }

  // MARK: - Keyword - star star

  /// f(**a)
  func test_starStar() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.starStar,        start: loc4, end: loc5),
      self.token(.identifier("a"), start: loc6, end: loc7),
      self.token(.rightParen,      start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructCall(expr) else { return }

      let valueA = Expression(.identifier("a"), start: loc6, end: loc7)
      let keywordA = Keyword(nil, value: valueA, start: loc4, end: loc7)

      XCTAssertEqual(d.func, Expression(.identifier("f"), start: loc0, end: loc1))
      XCTAssertEqual(d.args, [])
      XCTAssertEqual(d.keywords, [keywordA])

      XCTAssertExpression(expr, "(call f **=a)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  /// f(a, **b)
  func test_starStar_afterPositional() {
    var parser = self.createExprParser(
      self.token(.identifier("f"), start: loc0, end: loc1),
      self.token(.leftParen,       start: loc2, end: loc3),
      self.token(.identifier("a"), start: loc4, end: loc5),
      self.token(.comma,           start: loc6, end: loc7),
      self.token(.starStar,        start: loc8, end: loc9),
      self.token(.identifier("b"), start: loc10, end: loc11),
      self.token(.rightParen,      start: loc12, end: loc13)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructCall(expr) else { return }

      let argA = Expression(.identifier("a"), start: loc4, end: loc5)
      let valueB = Expression(.identifier("b"), start: loc10, end: loc11)
      let keywordB = Keyword(nil, value: valueB, start: loc8, end: loc11)

      XCTAssertEqual(d.func, Expression(.identifier("f"), start: loc0, end: loc1))
      XCTAssertEqual(d.args, [argA])
      XCTAssertEqual(d.keywords, [keywordB])

      XCTAssertExpression(expr, "(call f a **=b)")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc13)
    }
  }
}

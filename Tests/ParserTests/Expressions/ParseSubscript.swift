import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length
// swiftlint:disable function_body_length

class ParseSubscript: XCTestCase, Common, ExpressionMatcher, SliceMatcher {

  // MARK: - Subscript index

  /// a[]
  func test_empty_throws() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.rightSqb,        start: loc4, end: loc5)
    )

    if let error = self.error(&parser) {
      let kind = ParserErrorKind.unexpectedToken(.rightSqb, expected: [.expression])
      XCTAssertEqual(error.kind, kind)
      XCTAssertEqual(error.location, loc4)
    }
  }

  /// a[1]
  func test_index() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.int(BigInt(1)),  start: loc4, end: loc5),
      self.token(.rightSqb,        start: loc6, end: loc7)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchSubscriptIndex(expr) else { return }

      XCTAssertExpression(d.1, "1")
      XCTAssertEqual(d.slice.start, loc2)
      XCTAssertEqual(d.slice.end,   loc7)

      XCTAssertExpression(expr, "a[1]")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc7)
    }
  }

  /// a[1,2]
  func test_index_tuple() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.int(BigInt(1)),  start: loc4, end: loc5),
      self.token(.comma,           start: loc6, end: loc7),
      self.token(.int(BigInt(2)),  start: loc8, end: loc9),
      self.token(.rightSqb,        start: loc10, end: loc11)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchSubscriptIndex(expr) else { return }

      XCTAssertExpression(d.1, "(1 2)")
      XCTAssertEqual(d.slice.start, loc2)
      XCTAssertEqual(d.slice.end,   loc11)

      XCTAssertExpression(expr, "a[(1 2)]")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc11)
    }
  }

  /// a[1,]
  func test_index_withCommaAfter_isTuple() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.int(BigInt(1)),  start: loc4, end: loc5),
      self.token(.comma,           start: loc6, end: loc7),
      self.token(.rightSqb,        start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchSubscriptIndex(expr) else { return }

      XCTAssertExpression(d.1, "(1)")
      XCTAssertEqual(d.slice.start, loc2)
      XCTAssertEqual(d.slice.end,   loc9)

      XCTAssertExpression(expr, "a[(1)]")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  // MARK: - Subscript slices

  /// a[::]
  func test_slice_none() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.colon,           start: loc6, end: loc7),
      self.token(.rightSqb,        start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchSubscriptSlice(expr) else { return }

      XCTAssertNil(d.lower)
      XCTAssertNil(d.upper)
      XCTAssertNil(d.step)
      XCTAssertEqual(d.slice.start, loc2)
      XCTAssertEqual(d.slice.end,   loc9)

      XCTAssertExpression(expr, "a[::]")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  /// a[1:]
  func test_slice_lower() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.int(BigInt(1)),  start: loc4, end: loc5),
      self.token(.colon,           start: loc6, end: loc7),
      self.token(.rightSqb,        start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchSubscriptSlice(expr) else { return }

      XCTAssertExpression(d.lower, "1")
      XCTAssertNil(d.upper)
      XCTAssertNil(d.step)
      XCTAssertEqual(d.slice.start, loc2)
      XCTAssertEqual(d.slice.end,   loc9)

      XCTAssertExpression(expr, "a[1::]")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  /// a[:2]
  func test_slice_upper() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.int(BigInt(2)),  start: loc6, end: loc7),
      self.token(.colon,           start: loc8, end: loc9),
      self.token(.rightSqb,        start: loc10, end: loc11)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchSubscriptSlice(expr) else { return }

      XCTAssertNil(d.lower)
      XCTAssertExpression(d.upper, "2")
      XCTAssertNil(d.step)
      XCTAssertEqual(d.slice.start, loc2)
      XCTAssertEqual(d.slice.end,   loc11)

      XCTAssertExpression(expr, "a[:2:]")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc11)
    }
  }

  /// a[::3]
  func test_slice_step() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.colon,           start: loc6, end: loc7),
      self.token(.int(BigInt(3)),  start: loc8, end: loc9),
      self.token(.rightSqb,        start: loc10, end: loc11)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchSubscriptSlice(expr) else { return }

      XCTAssertNil(d.lower)
      XCTAssertNil(d.upper)
      XCTAssertExpression(d.step, "3")
      XCTAssertEqual(d.slice.start, loc2)
      XCTAssertEqual(d.slice.end,   loc11)

      XCTAssertExpression(expr, "a[::3]")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc11)
    }
  }

  /// a[1:2:3]
  func test_slice_all() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.int(BigInt(1)),  start: loc4, end: loc5),
      self.token(.colon,           start: loc6, end: loc7),
      self.token(.int(BigInt(2)),  start: loc8, end: loc9),
      self.token(.colon,           start: loc10, end: loc11),
      self.token(.int(BigInt(3)),  start: loc12, end: loc13),
      self.token(.rightSqb,        start: loc14, end: loc15)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchSubscriptSlice(expr) else { return }

      XCTAssertExpression(d.lower, "1")
      XCTAssertExpression(d.upper, "2")
      XCTAssertExpression(d.step, "3")
      XCTAssertEqual(d.slice.start, loc2)
      XCTAssertEqual(d.slice.end,   loc15)

      XCTAssertExpression(expr, "a[1:2:3]")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc15)
    }
  }

  // MARK: - Subscript extended

  /// a[1:,2]
  func test_extSlice() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.int(BigInt(1)),  start: loc4, end: loc5),
      self.token(.colon,           start: loc6, end: loc7),
      self.token(.comma,           start: loc8, end: loc9),
      self.token(.int(BigInt(2)),  start: loc10, end: loc11),
      self.token(.rightSqb,        start: loc12, end: loc13)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.matchSubscriptExtSlice(expr) else { return }
      let dimensions = d.1

      XCTAssertEqual(dimensions.count, 2)
      guard dimensions.count == 2 else { return }

      if case let SliceKind.slice(lower: l, upper: u, step: s) = dimensions[0].kind {
        XCTAssertExpression(l, "1")
        XCTAssertNil(u)
        XCTAssertNil(s)
      } else {
        XCTAssertFalse(true)
      }

      if case let SliceKind.index(e) = dimensions[1].kind {
        XCTAssertExpression(e, "2")
      } else {
        XCTAssertFalse(true)
      }

      XCTAssertEqual(d.slice.start, loc2)
      XCTAssertEqual(d.slice.end,   loc13)

      XCTAssertExpression(expr, "a[(1:: 2)]")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc13)
    }
  }
}

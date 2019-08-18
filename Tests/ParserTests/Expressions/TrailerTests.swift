import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length

class TrailerTests: XCTestCase, Common, DestructExpressionKind, DestructSliceKind {

  // MARK: - Attribute

  /// a.b
  func test_attribute() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.dot,             start: loc2, end: loc3),
      self.token(.identifier("b"), start: loc4, end: loc5)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructAttribute(expr) else { return }

      let valueKind = ExpressionKind.identifier("a")
      XCTAssertEqual(d.0, Expression(valueKind, start: loc0, end: loc1))
      XCTAssertEqual(d.name, "b")

      XCTAssertExpression(expr, "a.b")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc5)
    }
  }

  /// a.b.c
  func test_attribute_multiple() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.dot,             start: loc2, end: loc3),
      self.token(.identifier("b"), start: loc4, end: loc5),
      self.token(.dot,             start: loc6, end: loc7),
      self.token(.identifier("c"), start: loc7, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      XCTAssertExpression(expr, "a.b.c")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  // MARK: - Subscript index

  /// a[]
  func test_subscript_empty_throws() {
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
  func test_subscript_index() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.int(PyInt(1)),   start: loc4, end: loc5),
      self.token(.rightSqb,        start: loc6, end: loc7)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructSubscriptIndex(expr) else { return }

      XCTAssertEqual(d.1, Expression(.int(PyInt(1)), start: loc4, end: loc5))
      XCTAssertEqual(d.slice.start, loc2)
      XCTAssertEqual(d.slice.end,   loc7)

      XCTAssertExpression(expr, "a[1]")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc7)
    }
  }

  /// a[1,2]
  func test_subscript_index_tuple() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.int(PyInt(1)),   start: loc4, end: loc5),
      self.token(.comma,           start: loc6, end: loc7),
      self.token(.int(PyInt(2)),   start: loc8, end: loc9),
      self.token(.rightSqb,        start: loc10, end: loc11)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructSubscriptIndex(expr) else { return }

      let tuple = ExpressionKind.tuple([
        Expression(.int(PyInt(1)), start: loc4, end: loc5),
        Expression(.int(PyInt(2)), start: loc8, end: loc9)
      ])

      XCTAssertEqual(d.1, Expression(tuple, start: loc4, end: loc9))
      XCTAssertEqual(d.slice.start, loc2)
      XCTAssertEqual(d.slice.end,   loc11)

      XCTAssertExpression(expr, "a[(1 2)]")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc11)
    }
  }

  /// a[1,]
  func test_subscript_index_withCommaAfter_isTuple() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.int(PyInt(1)),   start: loc4, end: loc5),
      self.token(.comma,           start: loc6, end: loc7),
      self.token(.rightSqb,        start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructSubscriptIndex(expr) else { return }

      let tuple = ExpressionKind.tuple([
        Expression(.int(PyInt(1)), start: loc4, end: loc5)
      ])

      XCTAssertEqual(d.1, Expression(tuple, start: loc4, end: loc5))
      XCTAssertEqual(d.slice.start, loc2)
      XCTAssertEqual(d.slice.end,   loc9)

      XCTAssertExpression(expr, "a[(1)]")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc9)
    }
  }

  // MARK: - Subscript slices

  /// a[::]
  func test_subscript_slice_none() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.colon,           start: loc6, end: loc7),
      self.token(.rightSqb,        start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructSubscriptSlice(expr) else { return }

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
  func test_subscript_slice_lower() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.int(PyInt(1)),   start: loc4, end: loc5),
      self.token(.colon,           start: loc6, end: loc7),
      self.token(.rightSqb,        start: loc8, end: loc9)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructSubscriptSlice(expr) else { return }

      XCTAssertEqual(d.lower, Expression(.int(PyInt(1)), start: loc4, end: loc5))
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
  func test_subscript_slice_upper() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.int(PyInt(2)),   start: loc6, end: loc7),
      self.token(.colon,           start: loc8, end: loc9),
      self.token(.rightSqb,        start: loc10, end: loc11)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructSubscriptSlice(expr) else { return }

      XCTAssertNil(d.lower)
      XCTAssertEqual(d.upper, Expression(.int(PyInt(2)), start: loc6, end: loc7))
      XCTAssertNil(d.step)
      XCTAssertEqual(d.slice.start, loc2)
      XCTAssertEqual(d.slice.end,   loc11)

      XCTAssertExpression(expr, "a[:2:]")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc11)
    }
  }

  /// a[::3]
  func test_subscript_slice_step() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.colon,           start: loc4, end: loc5),
      self.token(.colon,           start: loc6, end: loc7),
      self.token(.int(PyInt(3)),   start: loc8, end: loc9),
      self.token(.rightSqb,        start: loc10, end: loc11)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructSubscriptSlice(expr) else { return }

      XCTAssertNil(d.lower)
      XCTAssertNil(d.upper)
      XCTAssertEqual(d.step, Expression(.int(PyInt(3)), start: loc8, end: loc9))
      XCTAssertEqual(d.slice.start, loc2)
      XCTAssertEqual(d.slice.end,   loc11)

      XCTAssertExpression(expr, "a[::3]")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc11)
    }
  }

  /// a[1:2:3]
  func test_subscript_slice_all() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.int(PyInt(1)),   start: loc4, end: loc5),
      self.token(.colon,           start: loc6, end: loc7),
      self.token(.int(PyInt(2)),   start: loc8, end: loc9),
      self.token(.colon,           start: loc10, end: loc11),
      self.token(.int(PyInt(3)),   start: loc12, end: loc13),
      self.token(.rightSqb,        start: loc14, end: loc15)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructSubscriptSlice(expr) else { return }

      XCTAssertEqual(d.lower, Expression(.int(PyInt(1)), start: loc4, end: loc5))
      XCTAssertEqual(d.upper, Expression(.int(PyInt(2)), start: loc8, end: loc9))
      XCTAssertEqual(d.step,  Expression(.int(PyInt(3)), start: loc12, end: loc13))
      XCTAssertEqual(d.slice.start, loc2)
      XCTAssertEqual(d.slice.end,   loc15)

      XCTAssertExpression(expr, "a[1:2:3]")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc15)
    }
  }

  // MARK: - Subscript extended

  /// a[1:,2]
  func test_subscript_extSlice() {
    var parser = self.createExprParser(
      self.token(.identifier("a"), start: loc0, end: loc1),
      self.token(.leftSqb,         start: loc2, end: loc3),
      self.token(.int(PyInt(1)),   start: loc4, end: loc5),
      self.token(.colon,           start: loc6, end: loc7),
      self.token(.comma,           start: loc8, end: loc9),
      self.token(.int(PyInt(2)),   start: loc10, end: loc11),
      self.token(.rightSqb,        start: loc12, end: loc13)
    )

    if let expr = self.parseExpr(&parser) {
      guard let d = self.destructSubscriptExtSlice(expr) else { return }

      XCTAssertEqual(d.1.count, 2)
      guard d.1.count == 2 else { return }

      let dim0 = d.1[0]
      let dim0Lower = Expression(.int(PyInt(1)), start: loc4, end: loc5)
      let dim0Kind = SliceKind.slice(lower: dim0Lower, upper: nil, step: nil)
      XCTAssertEqual(dim0.kind, dim0Kind)

      let dim1 = d.1[1]
      let dim1Expr = Expression(.int(PyInt(2)), start: loc10, end: loc11)
      let dim1Kind = SliceKind.index(dim1Expr)
      XCTAssertEqual(dim1.kind, dim1Kind)

      XCTAssertEqual(d.slice.start, loc2)
      XCTAssertEqual(d.slice.end,   loc13)

      XCTAssertExpression(expr, "a[(1:: 2)]")
      XCTAssertEqual(expr.start, loc0)
      XCTAssertEqual(expr.end,   loc13)
    }
  }
}

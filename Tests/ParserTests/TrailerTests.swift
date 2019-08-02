import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable file_length

class TrailerTests: XCTestCase, Common {

  // MARK: - Attribute

  /// a.b
  func test_attribute() {
    var parser = self.parser(
      self.token(.identifier("a"), start: self.loc0, end: self.loc1),
      self.token(.dot,             start: self.loc2, end: self.loc3),
      self.token(.identifier("b"), start: self.loc4, end: self.loc5)
    )

    if let expr = self.parse(&parser) {
      guard let d = self.destructAttribute(expr) else { return }

      let valueKind = ExpressionKind.identifier("a")
      XCTAssertEqual(d.0, Expression(valueKind, start: self.loc0, end: self.loc1))
      XCTAssertEqual(d.name, "b")

      XCTAssertExpression(expr, "(attribute a b)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc5)
    }
  }

  /// a.b.c
  func test_attribute_multiple() {
    var parser = self.parser(
      self.token(.identifier("a"), start: self.loc0, end: self.loc1),
      self.token(.dot,             start: self.loc2, end: self.loc3),
      self.token(.identifier("b"), start: self.loc4, end: self.loc5),
      self.token(.dot,             start: self.loc6, end: self.loc7),
      self.token(.identifier("c"), start: self.loc7, end: self.loc9)
    )

    if let expr = self.parse(&parser) {
      XCTAssertExpression(expr, "(attribute (attribute a b) c)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }

  // MARK: - Subscript index

  // TODO: a[]

  /// a[1]
  func test_subscript_index() {
    var parser = self.parser(
      self.token(.identifier("a"), start: self.loc0, end: self.loc1),
      self.token(.leftSqb,         start: self.loc2, end: self.loc3),
      self.token(.int(PyInt(1)),   start: self.loc4, end: self.loc5),
      self.token(.rightSqb,        start: self.loc6, end: self.loc7)
    )

    if let expr = self.parse(&parser) {
      guard let d = self.destructSubscriptIndex(expr) else { return }

      XCTAssertEqual(d.index, Expression(.int(PyInt(1)), start: self.loc4, end: self.loc5))
      XCTAssertEqual(d.slice.start, self.loc2)
      XCTAssertEqual(d.slice.end,   self.loc7)

      XCTAssertExpression(expr, "(subscript a 1)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc7)
    }
  }

  /// a[1,2]
  func test_subscript_index_tuple() {
    var parser = self.parser(
      self.token(.identifier("a"), start: self.loc0, end: self.loc1),
      self.token(.leftSqb,         start: self.loc2, end: self.loc3),
      self.token(.int(PyInt(1)),   start: self.loc4, end: self.loc5),
      self.token(.comma,           start: self.loc6, end: self.loc7),
      self.token(.int(PyInt(2)),   start: self.loc8, end: self.loc9),
      self.token(.rightSqb,        start: self.loc10, end: self.loc11)
    )

    if let expr = self.parse(&parser) {
      guard let d = self.destructSubscriptIndex(expr) else { return }

      let tuple = ExpressionKind.tuple([
        Expression(.int(PyInt(1)), start: self.loc4, end: self.loc5),
        Expression(.int(PyInt(2)), start: self.loc8, end: self.loc9)
      ])

      XCTAssertEqual(d.index, Expression(tuple, start: self.loc4, end: self.loc9))
      XCTAssertEqual(d.slice.start, self.loc2)
      XCTAssertEqual(d.slice.end,   self.loc11)

      XCTAssertExpression(expr, "(subscript a (1 2))")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc11)
    }
  }

  /// a[1,]
  func test_subscript_index_withCommaAfter_isTuple() {
    var parser = self.parser(
      self.token(.identifier("a"), start: self.loc0, end: self.loc1),
      self.token(.leftSqb,         start: self.loc2, end: self.loc3),
      self.token(.int(PyInt(1)),   start: self.loc4, end: self.loc5),
      self.token(.comma,           start: self.loc6, end: self.loc7),
      self.token(.rightSqb,        start: self.loc8, end: self.loc9)
    )

    if let expr = self.parse(&parser) {
      guard let d = self.destructSubscriptIndex(expr) else { return }

      let tuple = ExpressionKind.tuple([
        Expression(.int(PyInt(1)), start: self.loc4, end: self.loc5)
      ])

      XCTAssertEqual(d.index, Expression(tuple, start: self.loc4, end: self.loc5))
      XCTAssertEqual(d.slice.start, self.loc2)
      XCTAssertEqual(d.slice.end,   self.loc9)

      XCTAssertExpression(expr, "(subscript a (1))")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }

  // MARK: - Subscript slices

  /// a[::]
  func test_subscript_slice_none() {
    var parser = self.parser(
      self.token(.identifier("a"), start: self.loc0, end: self.loc1),
      self.token(.leftSqb,         start: self.loc2, end: self.loc3),
      self.token(.colon,           start: self.loc4, end: self.loc5),
      self.token(.colon,           start: self.loc6, end: self.loc7),
      self.token(.rightSqb,        start: self.loc8, end: self.loc9)
    )

    if let expr = self.parse(&parser) {
      guard let d = self.destructSubscriptSlice(expr) else { return }

      XCTAssertNil(d.lower)
      XCTAssertNil(d.upper)
      XCTAssertNil(d.step)
      XCTAssertEqual(d.slice.start, self.loc2)
      XCTAssertEqual(d.slice.end,   self.loc9)

      XCTAssertExpression(expr, "(subscript a ::)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }

  /// a[1:]
  func test_subscript_slice_lower() {
    var parser = self.parser(
      self.token(.identifier("a"), start: self.loc0, end: self.loc1),
      self.token(.leftSqb,         start: self.loc2, end: self.loc3),
      self.token(.int(PyInt(1)),   start: self.loc4, end: self.loc5),
      self.token(.colon,           start: self.loc6, end: self.loc7),
      self.token(.rightSqb,        start: self.loc8, end: self.loc9)
    )

    if let expr = self.parse(&parser) {
      guard let d = self.destructSubscriptSlice(expr) else { return }

      XCTAssertEqual(d.lower, Expression(.int(PyInt(1)), start: self.loc4, end: self.loc5))
      XCTAssertNil(d.upper)
      XCTAssertNil(d.step)
      XCTAssertEqual(d.slice.start, self.loc2)
      XCTAssertEqual(d.slice.end,   self.loc9)

      XCTAssertExpression(expr, "(subscript a 1::)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }

  /// a[:2]
  func test_subscript_slice_upper() {
    var parser = self.parser(
      self.token(.identifier("a"), start: self.loc0, end: self.loc1),
      self.token(.leftSqb,         start: self.loc2, end: self.loc3),
      self.token(.colon,           start: self.loc4, end: self.loc5),
      self.token(.int(PyInt(2)),   start: self.loc6, end: self.loc7),
      self.token(.colon,           start: self.loc8, end: self.loc9),
      self.token(.rightSqb,        start: self.loc10, end: self.loc11)
    )

    if let expr = self.parse(&parser) {
      guard let d = self.destructSubscriptSlice(expr) else { return }

      XCTAssertNil(d.lower)
      XCTAssertEqual(d.upper, Expression(.int(PyInt(2)), start: self.loc6, end: self.loc7))
      XCTAssertNil(d.step)
      XCTAssertEqual(d.slice.start, self.loc2)
      XCTAssertEqual(d.slice.end,   self.loc11)

      XCTAssertExpression(expr, "(subscript a :2:)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc11)
    }
  }

  /// a[::3]
  func test_subscript_slice_step() {
    var parser = self.parser(
      self.token(.identifier("a"), start: self.loc0, end: self.loc1),
      self.token(.leftSqb,         start: self.loc2, end: self.loc3),
      self.token(.colon,           start: self.loc4, end: self.loc5),
      self.token(.colon,           start: self.loc6, end: self.loc7),
      self.token(.int(PyInt(3)),   start: self.loc8, end: self.loc9),
      self.token(.rightSqb,        start: self.loc10, end: self.loc11)
    )

    if let expr = self.parse(&parser) {
      guard let d = self.destructSubscriptSlice(expr) else { return }

      XCTAssertNil(d.lower)
      XCTAssertNil(d.upper)
      XCTAssertEqual(d.step, Expression(.int(PyInt(3)), start: self.loc8, end: self.loc9))
      XCTAssertEqual(d.slice.start, self.loc2)
      XCTAssertEqual(d.slice.end,   self.loc11)

      XCTAssertExpression(expr, "(subscript a ::3)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc11)
    }
  }

  /// a[1:2:3]
  func test_subscript_slice_all() {
    var parser = self.parser(
      self.token(.identifier("a"), start: self.loc0, end: self.loc1),
      self.token(.leftSqb,         start: self.loc2, end: self.loc3),
      self.token(.int(PyInt(1)),   start: self.loc4, end: self.loc5),
      self.token(.colon,           start: self.loc6, end: self.loc7),
      self.token(.int(PyInt(2)),   start: self.loc8, end: self.loc9),
      self.token(.colon,           start: self.loc10, end: self.loc11),
      self.token(.int(PyInt(3)),   start: self.loc12, end: self.loc13),
      self.token(.rightSqb,        start: self.loc14, end: self.loc15)
    )

    if let expr = self.parse(&parser) {
      guard let d = self.destructSubscriptSlice(expr) else { return }

      XCTAssertEqual(d.lower, Expression(.int(PyInt(1)), start: self.loc4, end: self.loc5))
      XCTAssertEqual(d.upper, Expression(.int(PyInt(2)), start: self.loc8, end: self.loc9))
      XCTAssertEqual(d.step,  Expression(.int(PyInt(3)), start: self.loc12, end: self.loc13))
      XCTAssertEqual(d.slice.start, self.loc2)
      XCTAssertEqual(d.slice.end,   self.loc15)

      XCTAssertExpression(expr, "(subscript a 1:2:3)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc15)
    }
  }

  // MARK: - Subscript extended

  /// a[1:,2]
  func test_subscript_extSlice() {
    var parser = self.parser(
      self.token(.identifier("a"), start: self.loc0, end: self.loc1),
      self.token(.leftSqb,         start: self.loc2, end: self.loc3),
      self.token(.int(PyInt(1)),   start: self.loc4, end: self.loc5),
      self.token(.colon,           start: self.loc6, end: self.loc7),
      self.token(.comma,           start: self.loc8, end: self.loc9),
      self.token(.int(PyInt(2)),   start: self.loc10, end: self.loc11),
      self.token(.rightSqb,        start: self.loc12, end: self.loc13)
    )

    if let expr = self.parse(&parser) {
      guard let d = self.destructSubscriptSliceExt(expr) else { return }

      XCTAssertEqual(d.dims.count, 2)
      guard d.dims.count == 2 else { return } // prevent out of range exceptions

      let dim0 = d.dims[0]
      let dim0Lower = Expression(.int(PyInt(1)), start: self.loc4, end: self.loc5)
      let dim0Kind = SliceKind.slice(lower: dim0Lower, upper: nil, step: nil)
      XCTAssertEqual(dim0.kind, dim0Kind)

      let dim1 = d.dims[1]
      let dim1Expr = Expression(.int(PyInt(2)), start: self.loc10, end: self.loc11)
      let dim1Kind = SliceKind.index(dim1Expr)
      XCTAssertEqual(dim1.kind, dim1Kind)

      XCTAssertEqual(d.slice.start, self.loc2)
      XCTAssertEqual(d.slice.end,   self.loc13)

      XCTAssertExpression(expr, "(subscript a (1:: 2))")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc13)
    }
  }
}

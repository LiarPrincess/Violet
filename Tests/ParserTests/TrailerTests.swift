// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Core
import Lexer
@testable import Parser

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

  // MARK: - Subscript

  // TODO: a[]

  /// a[5]
  func test_subscript_index() {
    var parser = self.parser(
      self.token(.identifier("a"), start: self.loc0, end: self.loc1),
      self.token(.leftSqb,         start: self.loc2, end: self.loc3),
      self.token(.int(PyInt(5)),   start: self.loc4, end: self.loc5),
      self.token(.rightSqb,        start: self.loc6, end: self.loc7)
    )

    if let expr = self.parse(&parser) {
      guard let slice = self.destructSubscript(expr) else { return }
      XCTAssertEqual(slice.start, self.loc2)
      XCTAssertEqual(slice.end,   self.loc7)

      XCTAssertExpression(expr, "(subscript a 5)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc7)
    }
  }

  // Slices:
  //      nil,      nil,      nil // 0
  // PyInt(1),      nil,      nil // 1
  //      nil, PyInt(2),      nil
  //      nil,      nil, PyInt(3)
  // PyInt(1), PyInt(2),      nil // 2 (no tests)
  // PyInt(1),      nil, PyInt(3)
  //      nil, PyInt(2), PyInt(3)
  // PyInt(1), PyInt(2), PyInt(3) // 3

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
      guard let slice = self.destructSubscript(expr) else { return }
      XCTAssertEqual(slice.start, self.loc2)
      XCTAssertEqual(slice.end,   self.loc9)

      XCTAssertExpression(expr, "(subscript a ::)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }

  /// a[1::]
  func test_subscript_slice_lower() {
    var parser = self.parser(
      self.token(.identifier("a"), start: self.loc0, end: self.loc1),
      self.token(.leftSqb,         start: self.loc2, end: self.loc3),
      self.token(.int(PyInt(1)),   start: self.loc4, end: self.loc5),
      self.token(.colon,           start: self.loc6, end: self.loc7),
      self.token(.colon,           start: self.loc8, end: self.loc9),
      self.token(.rightSqb,        start: self.loc10, end: self.loc11)
    )

    if let expr = self.parse(&parser) {
      guard let slice = self.destructSubscript(expr) else { return }
      XCTAssertEqual(slice.start, self.loc2)
      XCTAssertEqual(slice.end,   self.loc11)

      XCTAssertExpression(expr, "(subscript a 1::)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc11)
    }
  }

  /// a[:2:]
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
      guard let slice = self.destructSubscript(expr) else { return }
      XCTAssertEqual(slice.start, self.loc2)
      XCTAssertEqual(slice.end,   self.loc11)

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
      guard let slice = self.destructSubscript(expr) else { return }
      XCTAssertEqual(slice.start, self.loc2)
      XCTAssertEqual(slice.end,   self.loc11)

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
      guard let slice = self.destructSubscript(expr) else { return }
      XCTAssertEqual(slice.start, self.loc2)
      XCTAssertEqual(slice.end,   self.loc15)

      XCTAssertExpression(expr, "(subscript a 1:2:3)")
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc15)
    }
  }
}

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
      XCTAssertEqual(d.value, Expression(valueKind, start: self.loc0, end: self.loc1))
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

  // MARK: - Subscript/slice
}

// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Core
import Lexer
@testable import Parser

class ComparisonExprTest: XCTestCase, Common {

  func test_simple() {
    let variants: [(TokenKind, ComparisonOperator)] = [
      (.equalEqual, .equal),
      (.notEqual,   .notEqual),
      // <> - pep401 is not implmented
      (.less,      .less),
      (.lessEqual, .lessEqual),
      (.greater,      .greater),
      (.greaterEqual, .greaterEqual),
      (.in,  .in),
      (.is,  .is)
      // not in - separate test
      // is not - separate test
    ]

    for (token, op) in variants {
      var parser = self.parser(
        self.token(.float(1.0), start: self.loc0, end: self.loc1),
        self.token(token,       start: self.loc2, end: self.loc3),
        self.token(.float(2.0), start: self.loc4, end: self.loc5)
      )

      if let expr = self.parse(&parser) {
        let msg = "\(token) -> \(op)"

        let one = Expression(kind: .float(1.0), start: self.loc0, end: self.loc1)
        let two = Expression(kind: .float(2.0), start: self.loc4, end: self.loc5)
        let element = ComparisonElement(op: op, right: two)

        XCTAssertEqual(expr.kind, .compare(left: one, elements: [element]), msg)

        XCTAssertEqual(expr.start, self.loc0, msg)
        XCTAssertEqual(expr.end,   self.loc5, msg)
      }
    }
  }

  /// this does not make sense: '1.0 not in 2.0', but it is not sema...
  func test_notIn() {
    var parser = self.parser(
      self.token(.float(1.0), start: self.loc0, end: self.loc1),
      self.token(.not,        start: self.loc2, end: self.loc3),
      self.token(.in,         start: self.loc4, end: self.loc5),
      self.token(.float(2.0), start: self.loc6, end: self.loc7)
    )

    if let expr = self.parse(&parser) {
      let one = Expression(kind: .float(1.0), start: self.loc0, end: self.loc1)
      let two = Expression(kind: .float(2.0), start: self.loc6, end: self.loc7)
      let element = ComparisonElement(op: .notIn, right: two)

      XCTAssertEqual(expr.kind, .compare(left: one, elements: [element]))
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc7)
    }
  }

  /// this does not make sense: '1.0 is not 2.0', but it is not sema...
  func test_isNot() {
    var parser = self.parser(
      self.token(.float(1.0), start: self.loc0, end: self.loc1),
      self.token(.is,         start: self.loc2, end: self.loc3),
      self.token(.not,        start: self.loc4, end: self.loc5),
      self.token(.float(2.0), start: self.loc6, end: self.loc7)
    )

    if let expr = self.parse(&parser) {
      let one = Expression(kind: .float(1.0), start: self.loc0, end: self.loc1)
      let two = Expression(kind: .float(2.0), start: self.loc6, end: self.loc7)
      let element = ComparisonElement(op: .isNot, right: two)

      XCTAssertEqual(expr.kind, .compare(left: one, elements: [element]))
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc7)
    }
  }

  /// complex compare: 1<2<3
  func test_compare_withMultipleElements() {
    var parser = self.parser(
      self.token(.float(1.0), start: self.loc0, end: self.loc1),
      self.token(.less,       start: self.loc2, end: self.loc3),
      self.token(.float(2.0), start: self.loc4, end: self.loc5),
      self.token(.lessEqual,  start: self.loc6, end: self.loc7),
      self.token(.float(3.0), start: self.loc8, end: self.loc9)
    )

    if let expr = self.parse(&parser) {
      let one   = Expression(kind: .float(1.0), start: self.loc0, end: self.loc1)
      let two   = Expression(kind: .float(2.0), start: self.loc4, end: self.loc5)
      let three = Expression(kind: .float(3.0), start: self.loc8, end: self.loc9)

      var elements = [ComparisonElement]()
      elements.append(ComparisonElement(op: .less, right: two))
      elements.append(ComparisonElement(op: .lessEqual, right: three))

      XCTAssertEqual(expr.kind, .compare(left: one, elements: elements))
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }
}

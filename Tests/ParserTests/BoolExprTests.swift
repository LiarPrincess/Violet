// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable multiline_arguments

class BoolExprTests: XCTestCase, Common {

  func test_notOperator() {
    var parser = self.parser(
      self.token(.not,   start: self.loc0, end: self.loc1),
      self.token(.false, start: self.loc2, end: self.loc3)
    )

    if let expr = self.parse(&parser) {
      let falseExpr = Expression(.false, start: self.loc2, end: self.loc3)

      XCTAssertEqual(expr.kind, .unaryOp(.not, right: falseExpr))
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc3)
    }
  }

  func test_and_or_operators() {
    let variants: [(TokenKind, BooleanOperator)] = [
      (.or, .or), // grammar: or_test
      (.and, .and) // grammar: and_test
    ]

    for (token, op) in variants {
      var parser = self.parser(
        self.token(.true,  start: self.loc0, end: self.loc1),
        self.token(token,  start: self.loc2, end: self.loc3),
        self.token(.false, start: self.loc4, end: self.loc5)
      )

      if let expr = self.parse(&parser) {
        let msg = "\(token) -> \(op)"

        XCTAssertEqual(expr.kind, .boolOp(
          op,
          left:  Expression(kind: .true, start: self.loc0, end: self.loc1),
          right: Expression(kind: .false, start: self.loc4, end: self.loc5)
        ), msg)

        XCTAssertEqual(expr.start, self.loc0, msg)
        XCTAssertEqual(expr.end,   self.loc5, msg)
      }
    }
  }

  // MARK: - Associativity

  /// not not false = not (not false)
  func test_not_isRightAssociative() {
    var parser = self.parser(
      self.token(.not,   start: self.loc0, end: self.loc1),
      self.token(.not,   start: self.loc2, end: self.loc3),
      self.token(.false, start: self.loc4, end: self.loc5)
    )

    if let expr = self.parse(&parser) {
      let first = Expression(.false, start: self.loc4, end: self.loc5)

      let secondKind = ExpressionKind.unaryOp(.not, right: first)
      let second = Expression(secondKind, start: self.loc2, end: self.loc5)

      let thirdKind = ExpressionKind.unaryOp(.not, right: second)
      let third = Expression(thirdKind, start: self.loc0, end: self.loc5)

      XCTAssertEqual(expr, third)
    }
  }

  /// true and false and true = (true and false) and true
  func test_and_isLeftAssociative() {
    var parser = self.parser(
      self.token(.true,  start: self.loc0, end: self.loc1),
      self.token(.and,   start: self.loc2, end: self.loc3),
      self.token(.false, start: self.loc4, end: self.loc5),
      self.token(.and,   start: self.loc6, end: self.loc7),
      self.token(.true,  start: self.loc8, end: self.loc9)
    )

    if let expr = self.parse(&parser) {
      let first  = Expression(.true,  start: self.loc0, end: self.loc1)
      let second = Expression(.false, start: self.loc4, end: self.loc5)
      let third  = Expression(.true,  start: self.loc8, end: self.loc9)

      let leftKind = ExpressionKind.boolOp(.and, left: first, right: second)
      let left = Expression(kind: leftKind, start: self.loc0, end: self.loc5)

      XCTAssertEqual(expr.kind, .boolOp(.and, left: left, right: third))
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }

  /// true or false or true = (true or false) or true
  func test_or_isLeftAssociative() {
    var parser = self.parser(
      self.token(.true,  start: self.loc0, end: self.loc1),
      self.token(.or,    start: self.loc2, end: self.loc3),
      self.token(.false, start: self.loc4, end: self.loc5),
      self.token(.or,    start: self.loc6, end: self.loc7),
      self.token(.true,  start: self.loc8, end: self.loc9)
    )

    if let expr = self.parse(&parser) {
      let first  = Expression(.true,  start: self.loc0, end: self.loc1)
      let second = Expression(.false, start: self.loc4, end: self.loc5)
      let third  = Expression(.true,  start: self.loc8, end: self.loc9)

      let leftKind = ExpressionKind.boolOp(.or, left: first, right: second)
      let left = Expression(kind: leftKind, start: self.loc0, end: self.loc5)

      XCTAssertEqual(expr.kind, .boolOp(.or, left: left, right: third))
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }

  // MARK: - Precedence

  /// not true and false = (not true) and false
  func test_not_hasHigherPrecedence_thanAnd() {
    var parser = self.parser(
      self.token(.not,   start: self.loc0, end: self.loc1),
      self.token(.true,  start: self.loc2, end: self.loc3),
      self.token(.and,   start: self.loc4, end: self.loc5),
      self.token(.false, start: self.loc6, end: self.loc7)
    )

    if let expr = self.parse(&parser) {
      let trueExpr = Expression(.true,  start: self.loc2, end: self.loc3)

      let notTrueExprKind = ExpressionKind.unaryOp(.not, right: trueExpr)
      let notTrueExpr = Expression(notTrueExprKind, start: self.loc0, end: self.loc3)

      let falseExpr = Expression(kind: .false, start: self.loc6, end: self.loc7)

      XCTAssertEqual(expr.kind, .boolOp(.and, left: notTrueExpr, right: falseExpr))
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc7)
    }
  }

  /// true or false and true = true or (false and true)
  func test_and_hasHigherPrecedence_thanOr() {
    var parser = self.parser(
      self.token(.true,  start: self.loc0, end: self.loc1),
      self.token(.or,    start: self.loc2, end: self.loc3),
      self.token(.false, start: self.loc4, end: self.loc5),
      self.token(.and,   start: self.loc6, end: self.loc7),
      self.token(.true,  start: self.loc8, end: self.loc9)
    )

    if let expr = self.parse(&parser) {
      let first  = Expression(.true,  start: self.loc0, end: self.loc1)
      let second = Expression(.false, start: self.loc4, end: self.loc5)
      let third  = Expression(.true,  start: self.loc8, end: self.loc9)

      let rightKind = ExpressionKind.boolOp(.and, left: second, right: third)
      let right = Expression(kind: rightKind, start: self.loc4, end: self.loc9)

      XCTAssertEqual(expr.kind, .boolOp(.or, left: first, right: right))
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }
}

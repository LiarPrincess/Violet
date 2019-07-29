// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable multiline_arguments

class ArithmeticExprTests: XCTestCase, Common {

  func test_unaryOpertors() {
    let variants: [(TokenKind, UnaryOperator)] = [
      (.plus, .plus), // grammar: factor
      (.minus, .minus),
      (.tilde, .invert)
    ]

    for (token, op) in variants {
      let value = PyInt(42)

      var parser = self.parser(
        self.token(token,       start: self.loc0, end: self.loc1),
        self.token(.int(value), start: self.loc2, end: self.loc3)
      )

      if let expr = self.parse(&parser) {
        let msg = "\(token) -> \(op)"

        XCTAssertEqual(expr.kind, .unaryOp(
          op,
          right: Expression(.int(value), start: self.loc2, end: self.loc3)
        ), msg)

        XCTAssertEqual(expr.start, self.loc0, msg)
        XCTAssertEqual(expr.end,   self.loc3, msg)
      }
    }
  }

  func test_binaryOperators() {
    let variants: [(TokenKind, BinaryOperator)] = [
      (.plus, .add), // grammar: arith_expr
      (.minus, .sub),
      (.star, .mul), // grammar: term
      (.at, .matMul),
      (.slash, .div),
      (.percent, .modulo),
      (.slashSlash, .floorDiv),
      (.starStar, .pow) // grammar: power
    ]

    for (token, op) in variants {
      var parser = self.parser(
        self.token(.float(4.2), start: self.loc0, end: self.loc1),
        self.token(token,       start: self.loc2, end: self.loc3),
        self.token(.float(3.1), start: self.loc4, end: self.loc5)
      )

      if let expr = self.parse(&parser) {
        let msg = "\(token) -> \(op)"

        XCTAssertEqual(expr.kind, .binaryOp(
          op,
          left:  Expression(kind: .float(4.2), start: self.loc0, end: self.loc1),
          right: Expression(kind: .float(3.1), start: self.loc4, end: self.loc5)
          ), msg)

        XCTAssertEqual(expr.start, self.loc0, msg)
        XCTAssertEqual(expr.end,   self.loc5, msg)
      }
    }
  }

  // MARK: - Associativity

  /// -+4.2 = -(+4.2)
  func test_unaryGroup_isRightAssociative() {
    var parser = self.parser(
      self.token(.minus,      start: self.loc0, end: self.loc1),
      self.token(.plus,       start: self.loc2, end: self.loc3),
      self.token(.float(4.2), start: self.loc4, end: self.loc5)
    )

    if let expr = self.parse(&parser) {
      let first = Expression(.float(4.2), start: self.loc4, end: self.loc5)

      let plusKind = ExpressionKind.unaryOp(.plus, right: first)
      let plus = Expression(kind: plusKind, start: self.loc2, end: self.loc5)

      XCTAssertEqual(expr.kind, .unaryOp(.minus, right: plus))
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc5)
    }
  }

  /// 4.2 ** 3.1 ** 2.0 -> 4.2 ** (3.1 ** 2.0)
  /// For example: 2 ** 3 ** 4 = 2 ** 81 = 2417851639229258349412352
  func test_powerGroup_isRightAssociative() {
    var parser = self.parser(
      self.token(.float(4.2), start: self.loc0, end: self.loc1),
      self.token(.starStar,   start: self.loc2, end: self.loc3),
      self.token(.float(3.1), start: self.loc4, end: self.loc5),
      self.token(.starStar,   start: self.loc6, end: self.loc7),
      self.token(.float(2.0), start: self.loc8, end: self.loc9)
    )

    if let expr = self.parse(&parser) {
      let first  = Expression(.float(4.2), start: self.loc0, end: self.loc1)
      let second = Expression(.float(3.1), start: self.loc4, end: self.loc5)
      let third  = Expression(.float(2.0), start: self.loc8, end: self.loc9)

      let rightKind = ExpressionKind.binaryOp(.pow, left: second, right: third)
      let right = Expression(kind: rightKind, start: self.loc4, end: self.loc9)

      XCTAssertEqual(expr.kind, .binaryOp(.pow, left: first, right: right))
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }

  /// 4.2 + 3.1 - 2.0 -> (4.2 + 3.1) - 2.0
  func test_addGroup_isLeftAssociative() {
    var parser = self.parser(
      self.token(.float(4.2), start: self.loc0, end: self.loc1),
      self.token(.plus,       start: self.loc2, end: self.loc3),
      self.token(.float(3.1), start: self.loc4, end: self.loc5),
      self.token(.minus,      start: self.loc6, end: self.loc7),
      self.token(.float(2.0), start: self.loc8, end: self.loc9)
    )

    if let expr = self.parse(&parser) {
      let first  = Expression(.float(4.2), start: self.loc0, end: self.loc1)
      let second = Expression(.float(3.1), start: self.loc4, end: self.loc5)
      let third  = Expression(.float(2.0), start: self.loc8, end: self.loc9)

      let addKind = ExpressionKind.binaryOp(.add, left: first, right: second)
      let add = Expression(kind: addKind, start: self.loc0, end: self.loc5)

      XCTAssertEqual(expr.kind, .binaryOp(.sub, left: add, right: third))
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }

  /// 4.2 * 3.1 / 2.0 -> (4.2 * 3.1) / 2.0
  func test_mulGroup_isLeftAssociative() {
    var parser = self.parser(
      self.token(.float(4.2), start: self.loc0, end: self.loc1),
      self.token(.star,       start: self.loc2, end: self.loc3),
      self.token(.float(3.1), start: self.loc4, end: self.loc5),
      self.token(.slash,      start: self.loc6, end: self.loc7),
      self.token(.float(2.0), start: self.loc8, end: self.loc9)
    )

    if let expr = self.parse(&parser) {
      let first  = Expression(.float(4.2), start: self.loc0, end: self.loc1)
      let second = Expression(.float(3.1), start: self.loc4, end: self.loc5)
      let third  = Expression(.float(2.0), start: self.loc8, end: self.loc9)

      let mulKind = ExpressionKind.binaryOp(.mul, left: first, right: second)
      let mul = Expression(kind: mulKind, start: self.loc0, end: self.loc5)

      XCTAssertEqual(expr.kind, .binaryOp(.div, left: mul, right: third))
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }

  // MARK: - Precedence

  /// 4.2 * -3.1 = 4.2 * (-3.1)
  func test_minus_hasHigherPrecedence_thanMul() {
    var parser = self.parser(
      self.token(.float(4.2), start: self.loc0, end: self.loc1),
      self.token(.star,       start: self.loc2, end: self.loc3),
      self.token(.minus,      start: self.loc4, end: self.loc5),
      self.token(.float(3.1), start: self.loc6, end: self.loc7)
    )

    if let expr = self.parse(&parser) {
      let first  = Expression(.float(4.2), start: self.loc0, end: self.loc1)
      let second = Expression(.float(3.1), start: self.loc6, end: self.loc7)

      let negKind = ExpressionKind.unaryOp(.minus, right: second)
      let neg = Expression(kind: negKind, start: self.loc4, end: self.loc7)

      XCTAssertEqual(expr.kind, .binaryOp(.mul, left: first, right: neg))
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc7)
    }
  }

  /// 4.2 + 3.1 * 2.0 = 4.2 + (3.1 * 2.0)
  func test_mul_hasHigherPrecedence_thanAdd() {
    var parser = self.parser(
      self.token(.float(4.2), start: self.loc0, end: self.loc1),
      self.token(.plus,       start: self.loc2, end: self.loc3),
      self.token(.float(3.1), start: self.loc4, end: self.loc5),
      self.token(.star,       start: self.loc6, end: self.loc7),
      self.token(.float(2.0), start: self.loc8, end: self.loc9)
    )

    if let expr = self.parse(&parser) {
      let first  = Expression(.float(4.2), start: self.loc0, end: self.loc1)
      let second = Expression(.float(3.1), start: self.loc4, end: self.loc5)
      let third  = Expression(.float(2.0), start: self.loc8, end: self.loc9)

      let mulKind = ExpressionKind.binaryOp(.mul, left: second, right: third)
      let mul = Expression(kind: mulKind, start: self.loc4, end: self.loc9)

      XCTAssertEqual(expr.kind, .binaryOp(.add, left: first, right: mul))
      XCTAssertEqual(expr.start, self.loc0)
      XCTAssertEqual(expr.end,   self.loc9)
    }
  }
}

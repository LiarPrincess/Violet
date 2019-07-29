// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable multiline_arguments

extension Expression {
  public init(_ kind: ExpressionKind, start: SourceLocation, end: SourceLocation) {
    self.init(kind: kind, start: start, end: end)
  }
}

class ArithmeticExprTests: XCTestCase, Common {

  func test_int() {
    let value = PyInt(42)

    var parser = self.parser(
      self.token(.int(value), start: loc(l: 1, c: 0), end: loc(l: 1, c: 2))
    )

    if let expr = self.parse(&parser) {
      XCTAssertEqual(expr.kind,  .int(value))
      XCTAssertEqual(expr.start, loc(l: 1, c: 0))
      XCTAssertEqual(expr.end,   loc(l: 1, c: 2))
    }
  }

  func test_float() {
    var parser = self.parser(
      self.token(.float(4.2), start: loc(l: 1, c: 0), end: loc(l: 1, c: 3))
    )

    if let expr = self.parse(&parser) {
      XCTAssertEqual(expr.kind,  .float(4.2))
      XCTAssertEqual(expr.start, loc(l: 1, c: 0))
      XCTAssertEqual(expr.end,   loc(l: 1, c: 3))
    }
  }

  func test_imaginary() {
    var parser = self.parser(
      self.token(.imaginary(4.2), start: loc(l: 1, c: 0), end: loc(l: 1, c: 4))
    )

    if let expr = self.parse(&parser) {
      XCTAssertEqual(expr.kind,  .complex(real: 0.0, imag: 4.2))
      XCTAssertEqual(expr.start, loc(l: 1, c: 0))
      XCTAssertEqual(expr.end,   loc(l: 1, c: 4))
    }
  }

  func test_await() {
    let value = PyInt(42)

    var parser = self.parser(
      self.token(.await,      start: loc(l: 1, c: 0), end: loc(l: 1, c: 2)),
      self.token(.int(value), start: loc(l: 1, c: 4), end: loc(l: 1, c: 10))
    )

    if let expr = self.parse(&parser) {
      let inner = Expression(kind: .int(value), start: loc(l: 1, c: 4), end: loc(l: 1, c: 10))

      XCTAssertEqual(expr.kind,  ExpressionKind.await(inner))
      XCTAssertEqual(expr.start, loc(l: 1, c: 0))
      XCTAssertEqual(expr.end,   loc(l: 1, c: 10))
    }
  }

  func test_unaryOpertors() {
    let variants: [(TokenKind, UnaryOperator)] = [
      (.plus, .plus), // grammar: factor
      (.minus, .minus),
      (.tilde, .invert)
    ]

    for (token, op) in variants {
      let value = PyInt(42)

      var parser = self.parser(
        self.token(token,       start: loc(l: 1, c: 0), end: loc(l: 1, c: 1)),
        self.token(.int(value), start: loc(l: 1, c: 3), end: loc(l: 1, c: 7))
      )

      if let expr = self.parse(&parser) {
        let msg = "\(token) -> \(op)"

        XCTAssertEqual(expr.kind, .unaryOp(
          op,
          right: Expression(.int(value), start: loc(l: 1, c: 3), end: loc(l: 1, c: 7))
          ), msg)

        XCTAssertEqual(expr.start, loc(l: 1, c: 0), msg)
        XCTAssertEqual(expr.end,   loc(l: 1, c: 7), msg)
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
        self.token(.float(4.2), start: loc(l: 1, c: 0), end: loc(l: 1, c: 5)),
        self.token(token,       start: loc(l: 1, c: 7), end: loc(l: 1, c: 9)),
        self.token(.float(3.1), start: loc(l: 2, c: 0), end: loc(l: 2, c: 3))
      )

      if let expr = self.parse(&parser) {
        let msg = "\(token) -> \(op)"

        XCTAssertEqual(expr.kind, .binaryOp(
          op,
          left:  Expression(kind: .float(4.2), start: loc(l: 1, c: 0), end: loc(l: 1, c: 5)),
          right: Expression(kind: .float(3.1), start: loc(l: 2, c: 0), end: loc(l: 2, c: 3))
          ), msg)

        XCTAssertEqual(expr.start, loc(l: 1, c: 0), msg)
        XCTAssertEqual(expr.end,   loc(l: 2, c: 3), msg)
      }
    }
  }

  // MARK: - Associativity

  /// -+4.2 = -(+4.2)
  func test_unaryGroup_isRightAssociative() {
    var parser = self.parser(
      self.token(.minus,      start: loc(l: 1, c: 0), end: loc(l: 1, c: 1)),
      self.token(.plus,       start: loc(l: 1, c: 7), end: loc(l: 1, c: 9)),
      self.token(.float(4.2), start: loc(l: 2, c: 3), end: loc(l: 2, c: 5))
    )

    if let expr = self.parse(&parser) {
      let first = Expression(.float(4.2), start: loc(l: 2, c: 3), end: loc(l: 2, c: 5))

      let plusKind = ExpressionKind.unaryOp(.plus, right: first)
      let plus = Expression(kind: plusKind, start: loc(l: 1, c: 7), end: loc(l: 2, c: 5))

      XCTAssertEqual(expr.kind, .unaryOp(.minus, right: plus))
      XCTAssertEqual(expr.start, loc(l: 1, c: 0))
      XCTAssertEqual(expr.end,   loc(l: 2, c: 5))
    }
  }

  /// 4.2 + 3.1 - 2.0 -> (4.2 + 3.1) - 2.0
  func test_addGroup_isLeftAssociative() {
    var parser = self.parser(
      self.token(.float(4.2), start: loc(l: 1, c: 0), end: loc(l: 1, c: 5)),
      self.token(.plus,       start: loc(l: 1, c: 7), end: loc(l: 1, c: 9)),
      self.token(.float(3.1), start: loc(l: 2, c: 0), end: loc(l: 2, c: 3)),
      self.token(.minus,      start: loc(l: 3, c: 7), end: loc(l: 3, c: 9)),
      self.token(.float(2.0), start: loc(l: 3, c: 11), end: loc(l: 3, c: 15))
    )

    if let expr = self.parse(&parser) {
      let first  = Expression(.float(4.2), start: loc(l: 1, c: 0), end: loc(l: 1, c: 5))
      let second = Expression(.float(3.1), start: loc(l: 2, c: 0), end: loc(l: 2, c: 3))
      let third  = Expression(.float(2.0), start: loc(l: 3, c: 11), end: loc(l: 3, c: 15))

      let addKind = ExpressionKind.binaryOp(.add, left: first, right: second)
      let add = Expression(kind: addKind, start: loc(l: 1, c: 0), end: loc(l: 2, c: 3))

      XCTAssertEqual(expr.kind, .binaryOp(.sub, left: add, right: third))
      XCTAssertEqual(expr.start, loc(l: 1, c: 0))
      XCTAssertEqual(expr.end,   loc(l: 3, c: 15))
    }
  }

  /// 4.2 * 3.1 / 2.0 -> (4.2 * 3.1) / 2.0
  func test_mulGroup_isLeftAssociative() {
    var parser = self.parser(
      self.token(.float(4.2), start: loc(l: 1, c: 0), end: loc(l: 1, c: 5)),
      self.token(.star,       start: loc(l: 1, c: 7), end: loc(l: 1, c: 9)),
      self.token(.float(3.1), start: loc(l: 2, c: 0), end: loc(l: 2, c: 3)),
      self.token(.slash,      start: loc(l: 3, c: 7), end: loc(l: 3, c: 9)),
      self.token(.float(2.0), start: loc(l: 3, c: 11), end: loc(l: 3, c: 15))
    )

    if let expr = self.parse(&parser) {
      let first  = Expression(.float(4.2), start: loc(l: 1, c: 0), end: loc(l: 1, c: 5))
      let second = Expression(.float(3.1), start: loc(l: 2, c: 0), end: loc(l: 2, c: 3))
      let third  = Expression(.float(2.0), start: loc(l: 3, c: 11), end: loc(l: 3, c: 15))

      let mulKind = ExpressionKind.binaryOp(.mul, left: first, right: second)
      let mul = Expression(kind: mulKind, start: loc(l: 1, c: 0), end: loc(l: 2, c: 3))

      XCTAssertEqual(expr.kind, .binaryOp(.div, left: mul, right: third))
      XCTAssertEqual(expr.start, loc(l: 1, c: 0))
      XCTAssertEqual(expr.end,   loc(l: 3, c: 15))
    }
  }

  // MARK: - Precedence

  /// 4.2 * -3.1 = 4.2 * (-3.1)
  func test_minus_haveHigherPrecedence_thanMul() {
    var parser = self.parser(
      self.token(.float(4.2), start: loc(l: 1, c: 0), end: loc(l: 1, c: 5)),
      self.token(.star,       start: loc(l: 1, c: 7), end: loc(l: 1, c: 9)),
      self.token(.minus,      start: loc(l: 2, c: 0), end: loc(l: 2, c: 3)),
      self.token(.float(3.1), start: loc(l: 3, c: 7), end: loc(l: 3, c: 9))
    )

    if let expr = self.parse(&parser) {
      let first  = Expression(.float(4.2), start: loc(l: 1, c: 0), end: loc(l: 1, c: 5))
      let second = Expression(.float(3.1), start: loc(l: 3, c: 7), end: loc(l: 3, c: 9))

      let negKind = ExpressionKind.unaryOp(.minus, right: second)
      let neg = Expression(kind: negKind, start: loc(l: 2, c: 0), end: loc(l: 3, c: 9))

      XCTAssertEqual(expr.kind, .binaryOp(.mul, left: first, right: neg))
      XCTAssertEqual(expr.start, loc(l: 1, c: 0))
      XCTAssertEqual(expr.end,   loc(l: 3, c: 9))
    }
  }

  /// 4.2 + 3.1 * 2.0 = 4.2 + (3.1 * 2.0)
  func test_mul_haveHigherPrecedence_thanAdd() {
    var parser = self.parser(
      self.token(.float(4.2), start: loc(l: 1, c: 0), end: loc(l: 1, c: 5)),
      self.token(.plus,       start: loc(l: 1, c: 7), end: loc(l: 1, c: 9)),
      self.token(.float(3.1), start: loc(l: 2, c: 0), end: loc(l: 2, c: 3)),
      self.token(.star,       start: loc(l: 3, c: 7), end: loc(l: 3, c: 9)),
      self.token(.float(2.0), start: loc(l: 3, c: 11), end: loc(l: 3, c: 15))
    )

    if let expr = self.parse(&parser) {
      let first  = Expression(.float(4.2), start: loc(l: 1, c: 0), end: loc(l: 1, c: 5))
      let second = Expression(.float(3.1), start: loc(l: 2, c: 0), end: loc(l: 2, c: 3))
      let third  = Expression(.float(2.0), start: loc(l: 3, c: 11), end: loc(l: 3, c: 15))

      let mulKind = ExpressionKind.binaryOp(.mul, left: second, right: third)
      let mul = Expression(kind: mulKind, start: loc(l: 2, c: 0), end: loc(l: 3, c: 15))

      XCTAssertEqual(expr.kind, .binaryOp(.add, left: first, right: mul))
      XCTAssertEqual(expr.start, loc(l: 1, c: 0))
      XCTAssertEqual(expr.end,   loc(l: 3, c: 15))
    }
  }
}

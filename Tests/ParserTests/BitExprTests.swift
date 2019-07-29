// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import Core
import Lexer
@testable import Parser

// swiftlint:disable multiline_arguments

class BitExprTests: XCTestCase, Common {

  func test_operators() {
    let variants: [(TokenKind, BinaryOperator)] = [
      (.vbar, .bitOr), // grammar: expr
      (.circumflex, .bitXor), // grammar: xor_expr
      (.amper, .bitAnd), // grammar: and_expr
      (.leftShift, .leftShift), // grammar: shift_expr
      (.rightShift, .rightShift)
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

  /// 1 << 2 << 4 = (1 << 2) << 4
  func test_shiftGroup_isLeftAssociative() {
    var parser = self.parser(
      self.token(.int(PyInt(1)), start: loc(l: 1, c: 0), end: loc(l: 1, c: 5)),
      self.token(.leftShift,     start: loc(l: 1, c: 7), end: loc(l: 1, c: 9)),
      self.token(.int(PyInt(2)), start: loc(l: 2, c: 0), end: loc(l: 2, c: 3)),
      self.token(.leftShift,     start: loc(l: 3, c: 7), end: loc(l: 3, c: 9)),
      self.token(.int(PyInt(4)), start: loc(l: 3, c: 11), end: loc(l: 3, c: 15))
    )

    if let expr = self.parse(&parser) {
      let first  = Expression(.int(PyInt(1)), start: loc(l: 1, c: 0), end: loc(l: 1, c: 5))
      let second = Expression(.int(PyInt(2)), start: loc(l: 2, c: 0), end: loc(l: 2, c: 3))
      let third  = Expression(.int(PyInt(4)), start: loc(l: 3, c: 11), end: loc(l: 3, c: 15))

      let leftKind = ExpressionKind.binaryOp(.leftShift, left: first, right: second)
      let left = Expression(kind: leftKind, start: loc(l: 1, c: 0), end: loc(l: 2, c: 3))

      XCTAssertEqual(expr.kind, .binaryOp(.leftShift, left: left, right: third))
      XCTAssertEqual(expr.start, loc(l: 1, c: 0))
      XCTAssertEqual(expr.end,   loc(l: 3, c: 15))
    }
  }

  /// 1 & 2 & 4 = (1 & 2) & 4
  func test_andGroup_isLeftAssociative() {
    var parser = self.parser(
      self.token(.int(PyInt(1)), start: loc(l: 1, c: 0), end: loc(l: 1, c: 5)),
      self.token(.amper,         start: loc(l: 1, c: 7), end: loc(l: 1, c: 9)),
      self.token(.int(PyInt(2)), start: loc(l: 2, c: 0), end: loc(l: 2, c: 3)),
      self.token(.amper,         start: loc(l: 3, c: 7), end: loc(l: 3, c: 9)),
      self.token(.int(PyInt(4)), start: loc(l: 3, c: 11), end: loc(l: 3, c: 15))
    )

    if let expr = self.parse(&parser) {
      let first  = Expression(.int(PyInt(1)), start: loc(l: 1, c: 0), end: loc(l: 1, c: 5))
      let second = Expression(.int(PyInt(2)), start: loc(l: 2, c: 0), end: loc(l: 2, c: 3))
      let third  = Expression(.int(PyInt(4)), start: loc(l: 3, c: 11), end: loc(l: 3, c: 15))

      let leftKind = ExpressionKind.binaryOp(.bitAnd, left: first, right: second)
      let left = Expression(kind: leftKind, start: loc(l: 1, c: 0), end: loc(l: 2, c: 3))

      XCTAssertEqual(expr.kind, .binaryOp(.bitAnd, left: left, right: third))
      XCTAssertEqual(expr.start, loc(l: 1, c: 0))
      XCTAssertEqual(expr.end,   loc(l: 3, c: 15))
    }
  }

  /// 1 ^ 2 ^ 4 = (1 ^ 2) ^ 4
  func test_xorGroup_isLeftAssociative() {
    var parser = self.parser(
      self.token(.int(PyInt(1)), start: loc(l: 1, c: 0), end: loc(l: 1, c: 5)),
      self.token(.circumflex,    start: loc(l: 1, c: 7), end: loc(l: 1, c: 9)),
      self.token(.int(PyInt(2)), start: loc(l: 2, c: 0), end: loc(l: 2, c: 3)),
      self.token(.circumflex,    start: loc(l: 3, c: 7), end: loc(l: 3, c: 9)),
      self.token(.int(PyInt(4)), start: loc(l: 3, c: 11), end: loc(l: 3, c: 15))
    )

    if let expr = self.parse(&parser) {
      let first  = Expression(.int(PyInt(1)), start: loc(l: 1, c: 0), end: loc(l: 1, c: 5))
      let second = Expression(.int(PyInt(2)), start: loc(l: 2, c: 0), end: loc(l: 2, c: 3))
      let third  = Expression(.int(PyInt(4)), start: loc(l: 3, c: 11), end: loc(l: 3, c: 15))

      let leftKind = ExpressionKind.binaryOp(.bitXor, left: first, right: second)
      let left = Expression(kind: leftKind, start: loc(l: 1, c: 0), end: loc(l: 2, c: 3))

      XCTAssertEqual(expr.kind, .binaryOp(.bitXor, left: left, right: third))
      XCTAssertEqual(expr.start, loc(l: 1, c: 0))
      XCTAssertEqual(expr.end,   loc(l: 3, c: 15))
    }
  }

  /// 1 | 2 | 4 = (1 | 2) | 4
  func test_orGroup_isLeftAssociative() {
    var parser = self.parser(
      self.token(.int(PyInt(1)), start: loc(l: 1, c: 0), end: loc(l: 1, c: 5)),
      self.token(.vbar,          start: loc(l: 1, c: 7), end: loc(l: 1, c: 9)),
      self.token(.int(PyInt(2)), start: loc(l: 2, c: 0), end: loc(l: 2, c: 3)),
      self.token(.vbar,          start: loc(l: 3, c: 7), end: loc(l: 3, c: 9)),
      self.token(.int(PyInt(4)), start: loc(l: 3, c: 11), end: loc(l: 3, c: 15))
    )

    if let expr = self.parse(&parser) {
      let first  = Expression(.int(PyInt(1)), start: loc(l: 1, c: 0), end: loc(l: 1, c: 5))
      let second = Expression(.int(PyInt(2)), start: loc(l: 2, c: 0), end: loc(l: 2, c: 3))
      let third  = Expression(.int(PyInt(4)), start: loc(l: 3, c: 11), end: loc(l: 3, c: 15))

      let leftKind = ExpressionKind.binaryOp(.bitOr, left: first, right: second)
      let left = Expression(kind: leftKind, start: loc(l: 1, c: 0), end: loc(l: 2, c: 3))

      XCTAssertEqual(expr.kind, .binaryOp(.bitOr, left: left, right: third))
      XCTAssertEqual(expr.start, loc(l: 1, c: 0))
      XCTAssertEqual(expr.end,   loc(l: 3, c: 15))
    }
  }

  // MARK: - Precedence (skipped)
}

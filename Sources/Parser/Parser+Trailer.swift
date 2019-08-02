// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Lexer

// In CPython:
// Python -> ast.c
//  ast_for_trailer(struct compiling *c, const node *n, expr_ty left_expr)
//  ast_for_slice(struct compiling *c, const node *n)

extension Parser {

  // MARK: - Trailer

  /// ```c
  /// trailer:
  ///     '(' [arglist] ')'
  ///   | '[' subscriptlist ']'
  ///   | '.' NAME
  /// ```
  /// 'Or nop' means that we terminate (without changing current parser state)
  /// if we can't parse according to that rule.
  internal mutating func trailerOrNop(for leftExpr: Expression) throws -> Expression? {
    switch self.peek.kind {
    case .leftParen:
      throw self.unimplemented()

    case .leftSqb:
      let sub = try self.subscript(closingToken: .rightSqb)
      let kind = ExpressionKind.subscript(leftExpr, slice: sub)
      return self.expression(kind, start: leftExpr.start, end: sub.end)

    case .dot:
      try self.advance() // .

      let nameToken = self.peek
      let name = try self.consumeIdentifierOrThrow()
      let kind = ExpressionKind.attribute(leftExpr, name: name)
      return self.expression(kind, start: leftExpr.start, end: nameToken.end)

    default: // no trailer
      return nil
    }
  }

  // MARK: - Subscript list

  // TODO: subscriptlist
  /// subscriptlist: subscript (',' subscript)* [',']

  /// `testlist: test (',' test)* [',']`
  /*
  private mutating func testList(closingToken: TokenKind) throws -> Expression {
    var elements = [Expression]()

    let first = try self.test()
    elements.append(first)

    while self.peek.kind == .comma && self.peekNext.kind != closingToken {
      try self.advance() // ,

      let test = try self.test()
      elements.append(test)
    }

    // optional trailing comma
    if self.peek.kind == .comma {
      try self.advance() // ,
    }

    if elements.count == 1 {
      return first
    }

    let start = first.start
    let end = elements.last?.end ?? first.end
    return self.expression(.tuple(elements), start: start, end: end)
  }
  */

  /// ```c
  /// subscript: test | [test] ':' [test] [sliceop]
  /// sliceop: ':' [test]
  /// ```
  private mutating func `subscript`(closingToken: TokenKind) throws -> Slice {
    assert(self.peek.kind == .leftSqb)
    let start = self.peek.start
    try self.advance() // [

    var lower, upper, step: Expression?

    if self.peek.kind != .colon {
      lower = try self.test()
    }

    // subscript: test -> index
    if let index = lower, self.peek.kind == closingToken {
      let end = self.peek.end
      try self.advance() // closingToken
      return Slice(.index(index), start: start, end: end)
    }

    // subscript: [test] ':' [test] [sliceop] -> slice
    try self.consumeOrThrow(.colon)

    // do we have 2nd?
    if self.peek.kind != .colon {
      upper = try self.test()
    }

    // do we have 3rd? (sliceop)
    if self.peek.kind == .colon {
      try self.advance() // :

      if self.peek.kind != closingToken {
        step = try self.test()
      }
    }

    let end = self.peek.end
    try self.consumeOrThrow(closingToken)

    let kind = SliceKind.slice(lower: lower, upper: upper, step: step)
    return Slice(kind, start: start, end: end)
  }
}

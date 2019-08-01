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

  /// ```
  /// trailer:
  ///     '(' [arglist] ')'
  ///   | '[' subscriptlist ']'
  ///   | '.' NAME
  /// ```
  /// 'Or nop' means that we terminate (without changing current parser state)
  /// if we can't parse according to that rule.
  internal mutating func trailerOrNop(for leftExpr: Expression) throws -> Expression? {
    let token = self.peek

    switch token.kind {
    case .leftParen:
      throw self.unimplemented()

    case .leftSqb:
      throw self.unimplemented()

    case .dot:
      try self.advance() // .

      let nameToken = self.peek
      let name = try self.consumeIdentifierOrThrow()
      let kind = ExpressionKind.attribute(value: leftExpr, name: name)
      return self.expression(kind, start: leftExpr.start, end: nameToken.end)

    default: // no trailer
      return nil
    }
  }

  // MARK: - Subscript list

  /// subscriptlist: subscript (',' subscript)* [',']

  /// subscript: test | [test] ':' [test] [sliceop]
  private mutating func `subscript`(closingToken: TokenKind) throws -> Expression? {


    return nil
  }

  /// sliceop: ':' [test]
  ///
  /// 'Or nop' means that we terminate (without changing current parser state)
  /// if we can't parse according to that rule.
  private mutating func sliceOpOrNil(closingToken: TokenKind) throws -> Expression? {
    guard self.peek.kind == .colon else {
      return nil
    }

    let colon = self.peek
    try self.advance() // :

    if self.peek.kind == closingToken {
      let location = colon.end
      return self.expression(.none, start: location, end: location)
    }

    return try self.test()
  }

}

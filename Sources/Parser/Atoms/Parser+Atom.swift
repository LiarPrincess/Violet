import Lexer

// In CPython:
// Python -> ast.c
//  ast_for_atom(struct compiling *c, const node *n)

extension Parser {

  /// `atom_expr: [AWAIT] atom trailer*`
  internal func atomExpr() throws -> Expression {
    let start = self.peek.start
    let isAwait = try self.consumeIf(.await)

    var rightExpr = try self.atom()
    while let withTrailer = try self.trailerOrNop(for: rightExpr) {
      rightExpr = withTrailer
    }

    return isAwait ?
      Expression(.await(rightExpr), start: start, end: rightExpr.end):
    rightExpr
  }

  ///```
  /// atom:
  ///  - '(' [yield_expr|testlist_comp] ')'
  ///  - '[' [testlist_comp] ']'
  ///  - '{' [dictorsetmaker] '}'
  ///  - NAME | NUMBER | STRING+ | '...' | 'None' | 'True' | 'False'
  /// ```
  internal func atom() throws -> Expression {
    let token = self.peek

    switch token.kind {
    case .leftParen:
      return try self.atomParens()
    case .leftSqb:
      return try self.atomList()
    case .leftBrace:
      return try self.atomSetDictionary()

    case let .identifier(value):
      return try self.simpleAtom(.identifier(value), from: token)

    case let .int(value):
      return try self.simpleAtom(.int(value), from: token)
    case let .float(value):
      return try self.simpleAtom(.float(value), from: token)
    case let .imaginary(value):
      return try self.simpleAtom(.complex(real: 0.0, imag: value), from: token)

    case .string, .formatString:
      return try self.strPlus()
    case .bytes:
      return try self.bytesPlus()

    case .ellipsis:
      return try self.simpleAtom(.ellipsis, from: token)
    case .none:
      return try self.simpleAtom(.none, from: token)
    case .true:
      return try self.simpleAtom(.true, from: token)
    case .false:
      return try self.simpleAtom(.false, from: token)

    default:
      throw self.unexpectedToken(expected: [.expression])
    }
  }

  private func simpleAtom(_ kind: ExpressionKind,
                          from token: Token) throws -> Expression {
    try self.advance()
    return self.expression(kind, start: token.start, end: token.end)
  }
}

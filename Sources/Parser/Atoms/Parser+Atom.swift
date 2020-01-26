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
      self.builder.awaitExpr(value: rightExpr, start: start, end: rightExpr.end) :
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
      try self.advance()
      return self.builder.identifierExpr(value: value,
                                         start: token.start,
                                         end: token.end)

    case let .int(value):
      try self.advance()
      return self.builder.intExpr(value: value,
                                  start: token.start,
                                  end: token.end)
    case let .float(value):
      try self.advance()
      return self.builder.floatExpr(value: value,
                                    start: token.start,
                                    end: token.end)
    case let .imaginary(value):
      try self.advance()
      return self.builder.complexExpr(real: 0.0,
                                      imag: value,
                                      start: token.start,
                                      end: token.end)

    case .string, .formatString:
      return try self.strPlus()
    case .bytes:
      return try self.bytesPlus()

    case .ellipsis:
      try self.advance()
      return self.builder.ellipsisExpr(start: token.start, end: token.end)
    case .none:
      try self.advance()
      return self.builder.noneExpr(start: token.start, end: token.end)
    case .true:
      try self.advance()
      return self.builder.trueExpr(start: token.start, end: token.end)
    case .false:
      try self.advance()
      return self.builder.falseExpr(start: token.start, end: token.end)

    default:
      throw self.unexpectedToken(expected: [.expression])
    }
  }
}

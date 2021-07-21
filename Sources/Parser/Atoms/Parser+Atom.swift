import VioletLexer

// In CPython:
// Python -> ast.c
//  ast_for_atom(struct compiling *c, const node *n)

// swiftlint:disable function_body_length

extension Parser {

  /// `atom_expr: [AWAIT] atom trailer*`
  internal func atomExpr(context: ExpressionContext) throws -> Expression {
    let start = self.peek.start
    let isAwait = try self.consumeIf(.await)

    // 'await' is always load.
    let contextOverride = isAwait ? .load : context

    var rightExpr = try self.atom(context: contextOverride)
    while let withTrailer = try self.trailerOrNop(for: rightExpr,
                                                  context: contextOverride) {
      rightExpr = withTrailer
    }

    return isAwait ?
      self.builder.awaitExpr(value: rightExpr,
                             context: .load,
                             start: start,
                             end: rightExpr.end) :
      rightExpr
  }

  /// ```
  /// atom:
  ///  - '(' [yield_expr|testlist_comp] ')'
  ///  - '[' [testlist_comp] ']'
  ///  - '{' [dictorsetmaker] '}'
  ///  - NAME | NUMBER | STRING+ | '...' | 'None' | 'True' | 'False'
  /// ```
  internal func atom(context: ExpressionContext) throws -> Expression {
    let token = self.peek
    let start = token.start
    let end = token.end

    switch token.kind {
    case .leftParen:
      return try self.atomParens(context: context)
    case .leftSqb:
      return try self.atomList(context: context)
    case .leftBrace:
      return try self.atomSetDictionary()

    case let .identifier(value):
      try self.advance()
      return self.builder.identifierExpr(value: value,
                                         context: context,
                                         start: start,
                                         end: end)

    case let .int(value):
      try self.advance()
      return self.builder.intExpr(value: value,
                                  context: .load,
                                  start: start,
                                  end: end)
    case let .float(value):
      try self.advance()
      return self.builder.floatExpr(value: value,
                                    context: .load,
                                    start: start,
                                    end: end)
    case let .imaginary(value):
      try self.advance()
      return self.builder.complexExpr(real: 0.0,
                                      imag: value,
                                      context: .load,
                                      start: start,
                                      end: end)

    case .string,
         .formatString:
      return try self.strPlus()
    case .bytes:
      return try self.bytesPlus()

    case .ellipsis:
      try self.advance()
      return self.builder.ellipsisExpr(context: .load, start: start, end: end)
    case .none:
      try self.advance()
      return self.builder.noneExpr(context: .load, start: start, end: end)
    case .true:
      try self.advance()
      return self.builder.trueExpr(context: .load, start: start, end: end)
    case .false:
      try self.advance()
      return self.builder.falseExpr(context: .load, start: start, end: end)

    default:
      throw self.unexpectedToken(expected: [.expression])
    }
  }
}

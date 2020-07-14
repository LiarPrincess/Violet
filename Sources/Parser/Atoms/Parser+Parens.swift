import VioletLexer

// In CPython:
// Python -> ast.c
//  ast_for_atom(struct compiling *c, const node *n)

// swiftlint:disable function_body_length

extension Parser {

  // MARK: - Tuple/yield/generator

  /// ```c
  /// atom:
  ///   '(' [yield_expr|testlist_comp] ')'
  ///    and other stuff…
  /// ```
  /// So it is actually responsible for:
  /// - tuple
  /// - yield (in parens)
  /// - generator
  internal func atomParens(context: ExpressionContext) throws -> Expression {
    assert(self.peek.kind == .leftParen)

    let start = self.peek.start
    try self.advance() // (

    if self.peek.kind == .rightParen { // a = () -> empty tuple
      let end = self.peek.end
      try self.advance() // )
      return self.builder.tupleExpr(elements: [],
                                    context: context,
                                    start: start,
                                    end: end)
    }

    if let yield = try self.yieldExprOrNop(closingTokens: [.rightParen]) {
      try self.advance() // )
      return yield
    }

    let test = try self.testListComp(context: context, closingToken: .rightParen)

    assert(self.peek.kind == .rightParen)
    let end = self.peek.end
    try self.advance() // )

    switch test {
    case let .single(e):
      // rebind start/end to include parens
      e.start = start
      e.end = end
      return e
    case let .multiple(es):
      return self.builder.tupleExpr(elements: es,
                                    context: context,
                                    start: start,
                                    end: end)
    case let .listComprehension(elt: elt, generators: gen):
      return self.builder.generatorExpr(element: elt,
                                        generators: gen,
                                        context: .load,
                                        start: start,
                                        end: end)
    }
  }
}

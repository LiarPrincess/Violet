import VioletLexer

// In CPython:
// Python -> ast.c
//  ast_for_atom(struct compiling *c, const node *n)

extension Parser {

  /// ```c
  /// atom:
  ///   '[' [testlist_comp] ']'
  ///    and other stuff…
  /// ```
  internal func atomList(context: ExpressionContext) throws -> Expression {
    assert(self.peek.kind == .leftSqb)

    let start = self.peek.start
    try self.advance() // [

    if self.peek.kind == .rightSqb { // a = [] -> empty list
      let end = self.peek.end
      try self.advance() // ]

      return self.builder.listExpr(elements: [], context: context, start: start, end: end)
    }

    let test = try self.testListComp(context: context, closingToken: .rightSqb)

    let end = self.peek.end
    try self.consumeOrThrow(.rightSqb)

    switch test {
    case let .single(e):
      return self.builder.listExpr(elements: [e],
                                   context: context,
                                   start: start,
                                   end: end)
    case let .multiple(es):
      return self.builder.listExpr(elements: es,
                                   context: context,
                                   start: start,
                                   end: end)
    case let .listComprehension(elt: elt, generators: gen):
      return self.builder.listComprehensionExpr(element: elt,
                                                generators: gen,
                                                context: .load,
                                                start: start,
                                                end: end)
    }
  }
}

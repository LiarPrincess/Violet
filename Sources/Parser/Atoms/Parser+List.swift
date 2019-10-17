import Lexer

// In CPython:
// Python -> ast.c
//  ast_for_atom(struct compiling *c, const node *n)

extension Parser {

  /// ```c
  /// atom:
  ///   '[' [testlist_comp] ']'
  ///    and other stuff...
  /// ```
  internal func atomList() throws -> Expression {
    assert(self.peek.kind == .leftSqb)

    let start = self.peek.start
    try self.advance() // [

    if self.peek.kind == .rightSqb { // a = [] -> empty list
      let end = self.peek.end
      try self.advance() // ]

      return self.expression(.list([]), start: start, end: end)
    }

    let test = try self.testListComp(closingToken: .rightSqb)

    let end = self.peek.end
    try self.consumeOrThrow(.rightSqb)

    switch test {
    case let .single(e):
      return self.expression(.list([e]), start: start, end: end)
    case let .multiple(es):
      return self.expression(.list(es), start: start, end: end)
    case let .listComprehension(elt: elt, generators: gen):
      let kind = ExpressionKind.listComprehension(elt: elt, generators: gen)
      return self.expression(kind, start: start, end: end)
    }
  }
}

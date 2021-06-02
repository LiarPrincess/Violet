import VioletLexer

// In CPython:
// Python -> ast.c
//  ast_for_expr(struct compiling *c, const node *n)

extension Parser {

  /// ```c
  /// yield_expr: 'yield' [yield_arg]
  /// yield_arg: 'from' test | testlist
  /// ```
  internal func isYieldExpr() -> Bool {
    return self.peek.kind == .yield
  }

  /// ```c
  /// yield_expr: 'yield' [yield_arg]
  /// yield_arg: 'from' test | testlist
  /// ```
  ///
  /// 'Or nop' means that we terminate (without changing current parser state)
  /// if we can't parse according to this rule.
  internal func yieldExprOrNop(closingTokens: [Token.Kind]) throws -> Expression? {
    return self.isYieldExpr() ?
      try self.yieldExpr(closingTokens: closingTokens) :
      nil
  }

  /// ```c
  /// yield_expr: 'yield' [yield_arg]
  /// yield_arg: 'from' test | testlist
  /// ```
  internal func yieldExpr(closingTokens: [Token.Kind]) throws -> Expression {
      let yieldToken = self.peek
      try self.advance() // yield

      switch self.peek.kind {
      case let token where closingTokens.contains(token):
        return self.builder.yieldExpr(value: nil,
                                      context: .load,
                                      start: yieldToken.start,
                                      end: yieldToken.end)

      case .from:
        try self.advance() // yield from

        let test = try self.test(context: .load)
        return self.builder.yieldFromExpr(value: test,
                                          context: .load,
                                          start: yieldToken.start,
                                          end: test.end)

      default:
        let testList = try self.testList(context: .load,
                                         closingTokens: closingTokens)
        let target = self.yieldTarget(testList)
        return self.builder.yieldExpr(value: target,
                                      context: .load,
                                      start: yieldToken.start,
                                      end: target.end)
      }
  }

  private func yieldTarget(_ result: TestListResult) -> Expression {
    switch result.kind {
    case let .single(e):
      return e
    case let .tuple(es, end):
      let start = es.first.start
      return self.builder.tupleExpr(elements: Array(es),
                                    context: .load,
                                    start: start,
                                    end: end)
    }
  }
}

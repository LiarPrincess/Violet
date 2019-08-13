import Lexer

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
  internal mutating func yieldExprOrNop(closingTokens: [TokenKind])
    throws -> Expression? {

      return self.isYieldExpr() ?
        try self.yieldExpr(closingTokens: closingTokens) :
      nil
  }

  /// ```c
  /// yield_expr: 'yield' [yield_arg]
  /// yield_arg: 'from' test | testlist
  /// ```
  internal mutating func yieldExpr(closingTokens: [TokenKind])
    throws -> Expression {

      let yieldToken = self.peek
      try self.advance() // yield

      switch self.peek.kind {
      case let token where closingTokens.contains(token):
        let kind = ExpressionKind.yield(nil)
        return self.expression(kind, start: yieldToken.start, end: yieldToken.end)

      case .from:
        try self.advance() // yield from

        let test = try self.test()
        let kind = ExpressionKind.yieldFrom(test)
        return self.expression(kind, start: yieldToken.start, end: test.end)

      default:
        let testList = try self.testList(closingTokens: closingTokens)
        let target = self.yieldTarget(testList)
        let kind = ExpressionKind.yield(target)
        return self.expression(kind, start: yieldToken.start, end: target.end)
      }
  }

  private func yieldTarget(_ result: TestListResult) -> Expression {
    switch result {
    case let .single(e):
      return e
    case let .tuple(es, end):
      let start = es.first.start
      return self.expression(.tuple(Array(es)), start: start, end: end)
    }
  }
}

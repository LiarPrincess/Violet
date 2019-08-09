import Lexer

// In CPython:
// Python -> ast.c
//  ast_for_comprehension(struct compiling *c, const node *n)

// TODO: yield and yield from expressions are prohibited in the implicitly
// nested scope (in Python 3.7, such expressions emit DeprecationWarning)

// swiftlint:disable discouraged_optional_collection

extension Parser {

  /// Is it a start of `comp_for` rule?
  ///
  /// ```c
  /// comp_for: ['async'] sync_comp_for
  /// sync_comp_for: 'for' exprlist 'in' or_test [comp_iter]
  /// comp_iter: comp_for | comp_if
  /// comp_if: 'if' test_nocond [comp_iter]
  /// ```
  internal func isCompFor() -> Bool {
    return self.peek.kind == .for
       || (self.peek.kind == .async && self.peekNext.kind == .for)
  }

  /// ```c
  /// comp_for: ['async'] sync_comp_for
  /// sync_comp_for: 'for' exprlist 'in' or_test [comp_iter]
  /// comp_iter: comp_for | comp_if
  /// comp_if: 'if' test_nocond [comp_iter]
  /// ```
  ///
  /// 'Or nop' means that we terminate (without changing current parser state)
  /// if we can't parse according to this rule.
  internal mutating func compForOrNop(closingTokens: [TokenKind])
    throws -> [Comprehension]? {

    return self.isCompFor() ?
      try self.compFor(closingTokens: closingTokens) :
      nil
  }

  /// ```c
  /// comp_for: ['async'] sync_comp_for
  /// sync_comp_for: 'for' exprlist 'in' or_test [comp_iter]
  /// comp_iter: comp_for | comp_if
  /// comp_if: 'if' test_nocond [comp_iter]
  /// ```
  internal mutating func compFor(closingTokens: [TokenKind])
    throws -> [Comprehension] {

    var result = [Comprehension]()

    repeat {
      let start = self.peek.start

      // comp_for: ['async'] sync_comp_for
      var isAsync = false
      if self.peek.kind == .async {
        try self.advance() // async
        isAsync = true
      }

      // sync_comp_for: 'for' exprlist 'in' or_test
      try self.consumeOrThrow(.for)
      let exprList = try self.exprList(closingTokens: [.in])
      try self.consumeOrThrow(.in)
      let iter = try self.orTest()

      // comp_if: 'if' test_nocond
      var ifs = [Expression]()
      while self.peek.kind == .if {
        try self.advance() // if
        ifs.append(try self.testNoCond())
      }

      let comp = Comprehension(target: self.compForTarget(exprList),
                               iter: iter,
                               ifs: ifs,
                               isAsync: isAsync,
                               start: start,
                               end: ifs.last?.end ?? iter.end)
      result.append(comp)
    } while !closingTokens.contains(self.peek.kind) // start another comprehension

    return result
  }

  private func compForTarget(_ result: ExprListResult) -> Expression {
    switch result {
    case let .single(e):
      return e
    case let .many(es):
      let start = es.first.start
      let end = es.last.end
      return self.expression(.tuple(Array(es)), start: start, end: end)
    }
  }
}

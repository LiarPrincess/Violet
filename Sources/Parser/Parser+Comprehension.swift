import Lexer

// In CPython:
// Python -> ast.c
//  ast_for_comprehension(struct compiling *c, const node *n)

// TODO: yield and yield from expressions are prohibited in the implicitly
// nested scope (in Python 3.7, such expressions emit DeprecationWarning)

extension Parser {

  /// ```c
  /// comp_for: ['async'] sync_comp_for
  /// sync_comp_for: 'for' exprlist 'in' or_test [comp_iter]
  /// comp_iter: comp_for | comp_if
  /// comp_if: 'if' test_nocond [comp_iter]
  /// ```
  internal mutating func compFor(closingToken: TokenKind) throws -> [Comprehension] {
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
      let target = try self.exprList(closingToken: .in)
      try self.consumeOrThrow(.in)
      let iter = try self.orTest()

      // comp_if: 'if' test_nocond
      var ifs = [Expression]()
      while self.peek.kind == .if {
        try self.advance() // if
        ifs.append(try self.testNoCond())
      }

      let end = ifs.last?.end ?? iter.end
      let comp = Comprehension(target: target,
                               iter: iter,
                               ifs: ifs,
                               isAsync: isAsync,
                               start: start,
                               end: end)
      result.append(comp)
    } while self.peek.kind != closingToken // start another comprehension

    return result
  }
}

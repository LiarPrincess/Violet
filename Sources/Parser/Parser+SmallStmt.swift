import Lexer

// In CPython:
// Python -> ast.c
//  ast_for_stmt(struct compiling *c, const node *n)

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity

// TODO: rename closingToken -> endToken

extension Parser {

  ///```c
  /// small_stmt: (expr_stmt | del_stmt | pass_stmt | flow_stmt |
  ///              import_stmt | global_stmt | nonlocal_stmt | assert_stmt)
  ///  del_stmt: 'del' exprlist
  ///  pass_stmt: 'pass'
  ///  flow_stmt: break_stmt | continue_stmt | return_stmt | raise_stmt | yield_stmt
  ///  global_stmt: 'global' NAME (',' NAME)*
  ///  nonlocal_stmt: 'nonlocal' NAME (',' NAME)*
  ///  assert_stmt: 'assert' test [',' test]
  ///```
  internal mutating func smallStmt(closingTokens: [TokenKind]) throws -> Statement {
    // TODO: closingTokens: ';' NEWLINE
    let token = self.peek
    let start = token.start

    switch token.kind {
    // MARK: expr_stmt

    // MARK: del_stmt, pass_stmt

    case .del:
      // del_stmt: 'del' exprlist
      try self.advance() // del

      let exprs = try self.exprList(closingTokens: closingTokens)
      switch exprs {
      case .single(let e):
        return self.statement(.delete([e]), start: start, end: e.end)
      case .tuple(let es):
        return self.statement(.delete(Array(es)), start: start, end: es.last.end)
      }

    case .pass:
      // pass_stmt: 'pass'
      return try self.simpleStmt(.pass, from: token)

    // MARK: flow_stmt

    case .break:
      // break_stmt: 'break'
      return try self.simpleStmt(.break, from: token)

    case .continue:
      // continue_stmt: 'continue'
      return try self.simpleStmt(.continue, from: token)

    case .return:
      // return_stmt: 'return' [testlist]
      try self.advance() // return

      let isEnd = closingTokens.contains(self.peek.kind)
      if isEnd {
        return self.statement(.return(nil), start: start, end: token.end)
      }

      let testList = try self.testList(closingTokens: closingTokens)
      switch testList {
      case .single(let e):
        return self.statement(.return(e), start: start, end: e.end)
      case .tuple(let es):
        let esStart = es.first.start
        let esEnd = es.last.end
        let tuple = self.expression(.tuple(Array(es)), start: esStart, end: esEnd)
        return self.statement(.return(tuple), start: start, end: esEnd)
      }

    case _ where self.isYieldExpr():
      // yield_stmt: yield_expr
      // DO NOT consume yield! `yield_expr` is responsible for this!

      let expr = try self.yieldExpr(closingTokens: closingTokens)
      return self.statement(.expr(expr), start: start, end: expr.end)

    case .raise:
      // raise_stmt: 'raise' [test ['from' test]]
      try self.advance() // raise

      let isEnd = closingTokens.contains(self.peek.kind)
      if isEnd {
        let kind = StatementKind.raise(exc: nil, cause: nil)
        return self.statement(kind, start: start, end: token.end)
      }

      let exc = try self.test()
      var cause: Expression?

      if self.peek.kind == .from {
        try self.advance() // from
        cause = try self.test()
      }

      let kind = StatementKind.raise(exc: exc, cause: cause)
      return self.statement(kind, start: start, end: token.end)

    // MARK: import_stmt

    // MARK: global_stmt, nonlocal_stmt, assert_stmt

    case .global:
      // global_stmt: 'global' NAME (',' NAME)*
      try self.advance() // global

      let (names, end) = try self.nameList(separator: .comma)
      return self.statement(.global(Array(names)), start: start, end: end)

    case .nonlocal:
      // nonlocal_stmt: 'nonlocal' NAME (',' NAME)*
      try self.advance() // nonlocal

      let (names, end) = try self.nameList(separator: .comma)
      return self.statement(.nonlocal(Array(names)), start: start, end: end)

    case .assert:
      // assert_stmt: 'assert' test [',' test]
      try self.advance() // assert

      let test = try self.test()
      var msg: Expression?

      if self.peek.kind == .comma {
        try self.advance() // ,
        msg  = try self.test()
      }

      let end = msg?.end ?? test.end
      let kind = StatementKind.assert(test: test, msg: msg)
      return self.statement(kind, start: start, end: end)

    default:
      throw self.unimplemented()
    }
  }

  private mutating func simpleStmt(_ kind: StatementKind,
                                   from token: Token) throws -> Statement {
    try self.advance()
    return self.statement(kind, start: token.start, end: token.end)
  }

  /// NAME (',' NAME)*
  private mutating func nameList(separator: TokenKind)
    throws -> (names: NonEmptyArray<String>, end: SourceLocation) {

    var end = self.peek.end

    guard case let TokenKind.identifier(first) = self.peek.kind else {
      throw self.failUnexpectedToken(expected: .identifier)
    }

    var additionalElements = [String]()
    while self.peek.kind == separator {
      try self.advance() // separator

      guard case let TokenKind.identifier(element) = self.peek.kind else {
        throw self.failUnexpectedToken(expected: .identifier)
      }

      end = self.peek.end
      try self.advance() // element
      additionalElements.append(element)
    }

    let names = NonEmptyArray(first: first, rest: additionalElements)
    return (names, end)
  }
}

import Core
import Lexer

// In CPython:
// Python -> ast.c
//  ast_for_stmt(struct compiling *c, const node *n)

extension Parser {

  ///```c
  /// small_stmt: (expr_stmt | del_stmt | pass_stmt | flow_stmt |
  ///              import_stmt | global_stmt | nonlocal_stmt | assert_stmt)
  ///```
  internal mutating func smallStmt(closingTokens: [TokenKind]) throws -> Statement {
    // swiftlint:disable:previous function_body_length cyclomatic_complexity

    let token = self.peek

    switch token.kind {
    case .del:
      return try self.delStmt(closingTokens: closingTokens)
    case .pass:
      return try self.simpleStmt(.pass, from: token)
    case .break:
      return try self.simpleStmt(.break, from: token)
    case .continue:
      return try self.simpleStmt(.continue, from: token)
    case .return:
      return try self.returnStmt(closingTokens: closingTokens)
    case .raise:
      return try self.raiseStmt(closingTokens: closingTokens)
    case .global:
      return try self.globalStmt(closingTokens: closingTokens)
    case .nonlocal:
      return try self.nonlocalStmt(closingTokens: closingTokens)
    case .assert:
      return try self.assertStmt(closingTokens: closingTokens)

    // DO NOT consume yield! `yield_expr` is responsible for this!
    case _ where self.isYieldExpr():
      let expr = try self.yieldExpr(closingTokens: closingTokens)
      return self.statement(.expr(expr), start: token.start, end: expr.end)

    case _ where self.isImportStmt():
      return try self.importStmt(closingTokens: closingTokens)

    default:
      return try self.exprStmt(closingTokens: closingTokens)
    }
  }

  private mutating func simpleStmt(_ kind: StatementKind,
                                   from token: Token) throws -> Statement {
    try self.advance()
    return self.statement(kind, start: token.start, end: token.end)
  }

  /// del_stmt: 'del' exprlist
  private mutating func delStmt(closingTokens: [TokenKind]) throws -> Statement {
    assert(self.peek.kind == .del)

    let start = self.peek.start
    try self.advance() // del

    let exprs = try self.exprList(closingTokens: closingTokens)
    switch exprs {
    case let .single(e):
      let es = NonEmptyArray(first: e)
      return self.statement(.delete(es), start: start, end: e.end)
    case let .tuple(es, end):
      return self.statement(.delete(es), start: start, end: end)
    }
  }

  /// return_stmt: 'return' [testlist]
  private mutating func returnStmt(closingTokens: [TokenKind]) throws -> Statement {
    assert(self.peek.kind == .return)

    let token = self.peek
    let start = token.start
    try self.advance() // return

    let isEnd = closingTokens.contains(self.peek.kind)
    if isEnd {
      return self.statement(.return(nil), start: start, end: token.end)
    }

    let testList = try self.testList(closingTokens: closingTokens)
    switch testList {
    case let .single(e):
      return self.statement(.return(e), start: start, end: e.end)
    case let .tuple(es, end):
      let tupleStart = es.first.start
      let tuple = self.expression(.tuple(Array(es)), start: tupleStart, end: end)
      return self.statement(.return(tuple), start: start, end: end)
    }
  }

  /// raise_stmt: 'raise' [test ['from' test]]
  private mutating func raiseStmt(closingTokens: [TokenKind]) throws -> Statement {
    assert(self.peek.kind == .raise)

    let token = self.peek
    let start = token.start
    try self.advance() // raise

    let isEnd = closingTokens.contains(self.peek.kind)
    if isEnd {
      let kind = StatementKind.raise(exc: nil, cause: nil)
      return self.statement(kind, start: start, end: token.end)
    }

    let exc = try self.test()

    var cause: Expression?
    if try self.consumeIf(.from) {
      cause = try self.test()
    }

    let end = cause?.end ?? exc.end
    let kind = StatementKind.raise(exc: exc, cause: cause)
    return self.statement(kind, start: start, end: end)
  }

  /// global_stmt: 'global' NAME (',' NAME)*
  private mutating func globalStmt(closingTokens: [TokenKind]) throws -> Statement {
    assert(self.peek.kind == .global)

    let token = self.peek
    let start = token.start
    try self.advance() // global

    let (names, end) = try self.nameList(separator: .comma)
    return self.statement(.global(names), start: start, end: end)
  }

  /// nonlocal_stmt: 'nonlocal' NAME (',' NAME)*
  private mutating func nonlocalStmt(closingTokens: [TokenKind]) throws -> Statement {
    assert(self.peek.kind == .nonlocal)

    let token = self.peek
    let start = token.start
    try self.advance() // nonlocal

    let (names, end) = try self.nameList(separator: .comma)
    return self.statement(.nonlocal(names), start: start, end: end)
  }

  /// assert_stmt: 'assert' test [',' test]
  private mutating func assertStmt(closingTokens: [TokenKind]) throws -> Statement {
    assert(self.peek.kind == .assert)

    let token = self.peek
    let start = token.start
    try self.advance() // assert

    let test = try self.test()

    var msg: Expression?
    if try self.consumeIf(.comma) {
      msg = try self.test()
    }

    let end = msg?.end ?? test.end
    let kind = StatementKind.assert(test: test, msg: msg)
    return self.statement(kind, start: start, end: end)
  }

  /// NAME (',' NAME)*
  private mutating func nameList(separator: TokenKind)
    throws -> (names: NonEmptyArray<String>, end: SourceLocation) {

    var end = self.peek.end
    let first = try self.consumeIdentifierOrThrow()

    var additionalElements = [String]()
    while self.peek.kind == separator {
      try self.advance() // separator

      end = self.peek.end
      let element = try self.consumeIdentifierOrThrow()
      additionalElements.append(element)
    }

    let names = NonEmptyArray(first: first, rest: additionalElements)
    return (names, end)
  }
}

import VioletCore
import VioletLexer

// In CPython:
// Python -> ast.c
//  ast_for_stmt(struct compiling *c, const node *n)

extension Parser {

  /// ```c
  /// small_stmt: (expr_stmt | del_stmt | pass_stmt | flow_stmt |
  ///              import_stmt | global_stmt | nonlocal_stmt | assert_stmt)
  /// ```
  internal func smallStmt(closingTokens: [Token.Kind]) throws -> Statement {
    // swiftlint:disable:previous function_body_length

    let token = self.peek

    switch token.kind {
    case .del:
      return try self.delStmt(closingTokens: closingTokens)
    case .pass:
      try self.advance()
      return self.builder.passStmt(start: token.start, end: token.end)
    case .break:
      try self.advance()
      return self.builder.breakStmt(start: token.start, end: token.end)
    case .continue:
      try self.advance()
      return self.builder.continueStmt(start: token.start, end: token.end)
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
      return self.builder.exprStmt(expression: expr,
                                   start: token.start,
                                   end: expr.end)

    case _ where self.isImportStmt():
      return try self.importStmt(closingTokens: closingTokens)

    default:
      return try self.exprStmt(closingTokens: closingTokens)
    }
  }

  /// del_stmt: 'del' exprlist
  private func delStmt(closingTokens: [Token.Kind]) throws -> Statement {
    assert(self.peek.kind == .del)

    let start = self.peek.start
    try self.advance() // del

    let exprs = try self.exprList(context: .del, closingTokens: closingTokens)
    switch exprs.kind {
    case let .single(e):
      let es = NonEmptyArray(first: e)
      return self.builder.deleteStmt(values: es, start: start, end: e.end)
    case let .tuple(es, end):
      return self.builder.deleteStmt(values: es, start: start, end: end)
    }
  }

  /// return_stmt: 'return' [testlist]
  private func returnStmt(closingTokens: [Token.Kind]) throws -> Statement {
    assert(self.peek.kind == .return)

    let token = self.peek
    let start = token.start
    try self.advance() // return

    let isEnd = closingTokens.contains(self.peek.kind)
    if isEnd {
      return self.builder.returnStmt(value: nil, start: start, end: token.end)
    }

    let testList = try self.testList(context: .load, closingTokens: closingTokens)
    switch testList.kind {
    case let .single(e):
      return self.builder.returnStmt(value: e, start: start, end: e.end)
    case let .tuple(es, end):
      let tupleStart = es.first.start
      let tuple = self.builder.tupleExpr(elements: Array(es),
                                         context: .load,
                                         start: tupleStart,
                                         end: end)
      return self.builder.returnStmt(value: tuple, start: start, end: end)
    }
  }

  /// raise_stmt: 'raise' [test ['from' test]]
  private func raiseStmt(closingTokens: [Token.Kind]) throws -> Statement {
    assert(self.peek.kind == .raise)

    let token = self.peek
    let start = token.start
    try self.advance() // raise

    let isEnd = closingTokens.contains(self.peek.kind)
    if isEnd {
      return self.builder.raiseStmt(exception: nil,
                                    cause: nil,
                                    start: start,
                                    end: token.end)
    }

    let exception = try self.test(context: .load)

    var cause: Expression?
    if try self.consumeIf(.from) {
      cause = try self.test(context: .load)
    }

    return self.builder.raiseStmt(exception: exception,
                                  cause: cause,
                                  start: start,
                                  end: cause?.end ?? exception.end)
  }

  /// global_stmt: 'global' NAME (',' NAME)*
  private func globalStmt(closingTokens: [Token.Kind]) throws -> Statement {
    assert(self.peek.kind == .global)

    let token = self.peek
    let start = token.start
    try self.advance() // global

    let (names, end) = try self.nameList(separator: .comma)
    return self.builder.globalStmt(identifiers: names, start: start, end: end)
  }

  /// nonlocal_stmt: 'nonlocal' NAME (',' NAME)*
  private func nonlocalStmt(closingTokens: [Token.Kind]) throws -> Statement {
    assert(self.peek.kind == .nonlocal)

    let token = self.peek
    let start = token.start
    try self.advance() // nonlocal

    let (names, end) = try self.nameList(separator: .comma)
    return self.builder.nonlocalStmt(identifiers: names, start: start, end: end)
  }

  /// assert_stmt: 'assert' test [',' test]
  private func assertStmt(closingTokens: [Token.Kind]) throws -> Statement {
    assert(self.peek.kind == .assert)

    let token = self.peek
    let start = token.start
    try self.advance() // assert

    let test = try self.test(context: .load)

    var msg: Expression?
    if try self.consumeIf(.comma) {
      msg = try self.test(context: .load)
    }

    let end = msg?.end ?? test.end
    return self.builder.assertStmt(test: test, msg: msg, start: start, end: end)
  }

  /// NAME (',' NAME)*
  private func nameList(separator: Token.Kind)
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

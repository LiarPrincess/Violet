import Core
import Lexer

// In CPython:
// Python -> ast.c
//  ast_for_stmt(struct compiling *c, const node *n)

// swiftlint:disable file_length

extension Parser {

  /// ```c
  /// compound_stmt: if_stmt   | while_stmt | for_stmt |
  ///                try_stmt  | with_stmt  | async_stmt
  ///                funcdef   | classdef   |
  ///                decorated
  /// ```
  ///
  /// 'Or nop' means that we terminate (without changing current parser state)
  /// if we can't parse according to this rule.
  internal mutating func compoundStmtOrNop(closingTokens: [TokenKind])
    throws -> Statement? {

    switch self.peek.kind {
    case .if:
      return try self.ifStmt(closingTokens: closingTokens)
    case .while:
      return try self.whileStmt(closingTokens: closingTokens)
    case .for:
      return try self.forStmt(closingTokens: closingTokens)
    case .try:
      return try self.tryStmt(closingTokens: closingTokens)
    case .with:
      return try self.withStmt(closingTokens: closingTokens)
    case .async:
      return try self.asyncStmt(closingTokens: closingTokens)
    case .def:
      return try self.funcDef(closingTokens: closingTokens)
    case .class:
      return try self.classDef(closingTokens: closingTokens)
    case .at:
      return nil // TODO: Decorated
    default:
      return nil
    }
  }

  // MARK: If

  /// Intermediate representation for if/elif.
  private struct IfIR {
    fileprivate let start: SourceLocation
    fileprivate let test:  Expression
    fileprivate let body:  NonEmptyArray<Statement>
  }

  /// ```c
  /// if_stmt:
  ///   'if' test ':' suite
  ///   ('elif' test ':' suite)*
  ///   ['else' ':' suite]
  /// ```
  internal mutating func ifStmt(closingTokens: [TokenKind]) throws -> Statement {
    assert(self.peek.kind == .if)

    var bodyClosing = closingTokens
    bodyClosing.append(contentsOf: [.elif, .else])

    let start = self.peek.start
    try self.advance() // if
    let test = try self.test()
    try self.consumeOrThrow(.colon)
    let body = try self.suite(closingTokens: bodyClosing)

    let first = IfIR(start: start, test: test, body: body)
    var irs = NonEmptyArray<IfIR>(first: first)

    while self.peek.kind == .elif {
      let start = self.peek.start
      try self.advance() // elif
      let test = try self.test()
      try self.consumeOrThrow(.colon)
      let body = try self.suite(closingTokens: bodyClosing)
      irs.append(IfIR(start: start, test: test, body: body))
    }

    var orElse: NonEmptyArray<Statement>?
    if self.peek.kind == .else {
      try self.advance() // else
      try self.consumeOrThrow(.colon)
      orElse = try self.suite(closingTokens: closingTokens)
    }

    return self.compile(irs: irs, orElse: orElse)
  }

  /// ```c
  /// if a:   "Baker: Good morning, Belle!"
  /// elif b: "Belle: Good morning, Monsieur."
  /// else:   "Baker: Where are you off to?"
  /// ```
  /// Returns:
  /// ```
  /// If
  ///   test: a
  ///   body: "Baker: Good morning, Belle!"
  ///   orElse:
  ///     If
  ///       test: b
  ///       body: "Belle: Good morning, Monsieur."
  ///       orElse: "Baker: Where are you off to?"
  /// ```
  /// Full song [here](https://www.youtube.com/watch?v=tTUZswZHsWQ ).
  private func compile(irs: NonEmptyArray<IfIR>,
                       orElse: NonEmptyArray<Statement>?) -> Statement {

    var result: Statement?
    var pendingElse = orElse.map { Array($0) } ?? []

    for ir in irs.reversed() {
      let kind = StatementKind.if(test: ir.test,
                                  body: Array(ir.body),
                                  orElse: pendingElse)

      let end = pendingElse.last?.end ?? ir.body.last.end
      let statement = self.statement(kind, start: ir.start, end: end)
      result = statement
      pendingElse = [statement]
    }

    // We know that result is not nil beacuse of NonEmptyArray
    assert(result != nil)
    return result! // swiftlint:disable:this force_unwrapping
  }

  // MARK: - While

  /// ```c
  /// while_stmt:
  ///   'while' test ':' suite
  ///   ['else' ':' suite]
  /// ```
  internal mutating func whileStmt(closingTokens: [TokenKind]) throws -> Statement {
    assert(self.peek.kind == .while)

    let start = self.peek.start
    try self.advance() // while

    let test = try self.test()
    try self.consumeOrThrow(.colon)

    var bodyClosing = closingTokens
    bodyClosing.append(contentsOf: [.else])

    let body = try self.suite(closingTokens: bodyClosing)

    var orElse: NonEmptyArray<Statement>?
    if self.peek.kind == .else {
      try self.advance() // else
      try self.consumeOrThrow(.colon)
      orElse = try self.suite(closingTokens: closingTokens)
    }

    let kind = StatementKind.while(test: test,
                                   body: Array(body),
                                   orElse: orElse.map { Array($0) } ?? [])

    let end = orElse?.last.end ?? body.last.end
    return self.statement(kind, start: start, end: end)
  }

  /// ```c
  /// for_stmt:
  ///   'for' exprlist 'in' testlist ':' suite
  ///   ['else' ':' suite]
  /// ```
  internal mutating func forStmt(closingTokens: [TokenKind],
                                 start:         SourceLocation? = nil,
                                 isAsync:       Bool = false) throws -> Statement {

    assert(self.peek.kind == .for)

    let forStart = start ?? self.peek.start
    try self.advance() // for

    let targetStart = self.peek.start
    let targetRaw = try self.exprList(closingTokens: [.in])
    let target = targetRaw.toExpression(start: targetStart)
    try self.consumeOrThrow(.in)

    let iterStart = self.peek.start
    let iterRaw = try self.testList(closingTokens: [.colon])
    let iter = iterRaw.toExpression(start: iterStart)
    try self.consumeOrThrow(.colon)

    var bodyClosing = closingTokens
    bodyClosing.append(contentsOf: [.else])

    let body = try self.suite(closingTokens: bodyClosing)

    var orElse = [Statement]()
    if self.peek.kind == .else {
      try self.advance() // else
      try self.consumeOrThrow(.colon)

      let orElseRaw = try self.suite(closingTokens: closingTokens)
      orElse = Array(orElseRaw)
    }

    let kind: StatementKind = isAsync ?
      .asyncFor(target: target, iter: iter, body: Array(body), orElse: orElse) :
      .for     (target: target, iter: iter, body: Array(body), orElse: orElse)

    let end = orElse.last?.end ?? body.last.end
    return self.statement(kind, start: forStart, end: end)
  }

  // MARK: - With

  /// `with_stmt: 'with' with_item (',' with_item)*  ':' suite`
  internal mutating func withStmt(closingTokens: [TokenKind],
                                  start:         SourceLocation? = nil,
                                  isAsync:       Bool = false) throws -> Statement {

    assert(self.peek.kind == .with)

    let start = start ?? self.peek.start
    try self.advance() // with

    let first = try self.withItem()

    var items = [WithItem]()
    items.append(first)

    while self.peek.kind == .comma {
      try self.advance() // ,

      let item = try self.withItem()
      items.append(item)
    }

    try self.consumeOrThrow(.colon)
    let body = try self.suite(closingTokens: closingTokens)

    let kind: StatementKind = isAsync ?
      .asyncWith(items: items, body: Array(body)) :
      .with(items: items, body: Array(body))

    return self.statement(kind, start: start, end: body.last.end)
  }

  /// `with_item: test ['as' expr]`
  private mutating func withItem() throws -> WithItem {
    let context = try self.test()

    var optionalVars: Expression?
    if self.peek.kind == .as {
      try self.advance() // as
      optionalVars = try self.expr()
    }

    return WithItem(contextExpr: context, optionalVars: optionalVars)
  }

  // MARK: - Async

  /// async_stmt: 'async' (funcdef | with_stmt | for_stmt)
  internal mutating func asyncStmt(closingTokens: [TokenKind])
    throws -> Statement {

    assert(self.peek.kind == .async)

    let start = self.peek.start
    try self.advance() // async

    switch self.peek.kind {
    case .def:
      return try self.funcDef(closingTokens: closingTokens,
                              start: start,
                              isAsync: true)

    case .with:
      return try self.withStmt(closingTokens: closingTokens,
                               start: start,
                               isAsync: true)

    case .for:
      return try self.forStmt(closingTokens: closingTokens,
                              start: start,
                              isAsync: true)

    default:
      throw self.unexpectedToken(expected: [.def, .with, .for])
    }
  }
}

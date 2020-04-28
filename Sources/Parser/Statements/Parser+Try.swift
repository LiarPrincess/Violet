import VioletCore
import VioletLexer

// In CPython:
// Python -> ast.c
//  ast_for_try_stmt(struct compiling *c, const node *n)

/// Intermediate representation for try.
private struct TryIR {
  fileprivate var handlers = [ExceptHandler]()
  fileprivate var orElse = [Statement]()
  fileprivate var finally = [Statement]()
  fileprivate var end: SourceLocation

  fileprivate init(end: SourceLocation) {
    self.end = end
  }
}

extension Parser {

  /// ```c
  ///  try_stmt: (
  ///    'try' ':' suite
  ///    (
  ///      (except_clause ':' suite)+
  ///      ['else' ':' suite]
  ///      ['finally' ':' suite] |
  ///      'finally' ':' suite
  ///    )
  ///  )
  ///  except_clause: 'except' [test ['as' NAME]]
  /// ```
  internal func tryStmt() throws -> Statement {
    assert(self.peek.kind == .try)

    let start = self.peek.start
    try self.advance() // try
    try self.consumeOrThrow(.colon)

    let body = try self.suite()

    var ir = TryIR(end: body.last.end)
    try self.parseExceptClauses(into: &ir)
    try self.parseElse(into: &ir)
    try self.parseFinally(into: &ir)

    if ir.handlers.isEmpty && ir.finally.isEmpty {
      throw self.error(.tryWithoutExceptOrFinally, location: start)
    }

    if ir.handlers.isEmpty && !ir.orElse.isEmpty {
      throw self.error(.tryWithElseWithoutExcept, location: start)
    }

    return self.builder.tryStmt(body: body,
                                handlers: ir.handlers,
                                orElse: ir.orElse,
                                finally: ir.finally,
                                start: start,
                                end: ir.end)
  }

  /// ```c
  /// (except_clause ':' suite)+
  /// except_clause: 'except' [test ['as' NAME]]
  /// ```
  private func parseExceptClauses(into ir: inout TryIR) throws {
    while self.peek.kind == .except {
      let start = self.peek.start
      try self.advance() // except

      let kind = try self.parseExceptHandlerKind()
      try self.consumeOrThrow(.colon)
      let body = try self.suite()

      let handler = self.builder.exceptHandler(kind: kind,
                                               body: body,
                                               start: start,
                                               end: body.last.end)

      ir.handlers.append(handler)
      ir.end = body.last.end
    }
  }

  /// [test ['as' NAME]] | <empty>
  private func parseExceptHandlerKind() throws -> ExceptHandler.Kind {
    guard self.peek.kind != .colon else {
      return .default
    }

    let type = try self.test(context: .load)

    var asName: String?
    if self.peek.kind == .as {
      try self.advance() // as
      asName = try self.consumeIdentifierOrThrow()
    }

    return .typed(type: type, asName: asName)
  }

  /// `['else' ':' suite]`
  private func parseElse(into ir: inout TryIR) throws {
    guard self.peek.kind == .else else {
      return
    }

    try self.advance() // else
    try self.consumeOrThrow(.colon)

    let value = try self.suite()
    ir.orElse = Array(value)
    ir.end = value.last.end
  }

  /// `'finally' ':' suite`
  private func parseFinally(into ir: inout TryIR) throws {
    guard self.peek.kind == .finally else {
      return
    }

    try self.advance() // finally
    try self.consumeOrThrow(.colon)

    let value = try self.suite()
    ir.finally = Array(value)
    ir.end = value.last.end
  }
}

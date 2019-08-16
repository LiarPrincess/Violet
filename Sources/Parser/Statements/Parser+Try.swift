import Core
import Lexer

// In CPython:
// Python -> ast.c
//  ast_for_try_stmt(struct compiling *c, const node *n)

/// Intermediate representation for try.
private struct TryIR {
  fileprivate var handlers = [ExceptHandler]()
  fileprivate var orElse = [Statement]()
  fileprivate var finalBody = [Statement]()
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
  internal mutating func tryStmt() throws -> Statement {
    assert(self.peek.kind == .try)

    let start = self.peek.start
    try self.advance() // try
    try self.consumeOrThrow(.colon)

    let body = try self.suite()

    var ir = TryIR(end: body.last.end)
    try self.parseExceptClauses(into: &ir)
    try self.parseElse(into: &ir)
    try self.parseFinally(into: &ir)

    if ir.handlers.isEmpty && ir.finalBody.isEmpty {
      throw self.error(.tryWithoutExceptOrFinally, location: start)
    }

    if ir.handlers.isEmpty && !ir.orElse.isEmpty {
      throw self.error(.tryWithElseWithoutExcept, location: start)
    }

    let kind = StatementKind.try(body: Array(body),
                                 handlers: ir.handlers,
                                 orElse: ir.orElse,
                                 finalBody: ir.finalBody)

    return self.statement(kind, start: start, end: ir.end)
  }

  /// ```c
  /// (except_clause ':' suite)+
  /// except_clause: 'except' [test ['as' NAME]]
  /// ```
  private mutating func parseExceptClauses(into ir: inout TryIR) throws {

    while self.peek.kind == .except {
      let start = self.peek.start
      try self.advance() // except

      var type: Expression?
      if self.peek.kind != .colon {
        type = try self.test()
      }

      var name: String?
      if type != nil && self.peek.kind == .as {
        try self.advance() // as
        name = try self.consumeIdentifierOrThrow()
      }

      try self.consumeOrThrow(.colon)
      let body = try self.suite()

      let handler = ExceptHandler(type: type,
                                  name: name,
                                  body: Array(body),
                                  start: start,
                                  end: body.last.end)

      ir.handlers.append(handler)
      ir.end = body.last.end
    }
  }

  /// `['else' ':' suite]`
  private mutating func parseElse(into ir: inout TryIR) throws {

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
  private mutating func parseFinally(into ir: inout TryIR) throws {

    guard self.peek.kind == .finally else {
      return
    }

    try self.advance() // finally
    try self.consumeOrThrow(.colon)

    let value = try self.suite()
    ir.finalBody = Array(value)
    ir.end = value.last.end
  }
}

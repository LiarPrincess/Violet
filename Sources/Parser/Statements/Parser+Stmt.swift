import VioletCore
import VioletLexer

extension Parser {

  /// stmt: simple_stmt | compound_stmt
  internal func stmt() throws -> NonEmptyArray<Statement> {
    if let stmt = try self.compoundStmtOrNop() {
      return NonEmptyArray(first: stmt)
    }

    return try self.simpleStmt()
  }

  /// simple_stmt: small_stmt (';' small_stmt)* [';'] NEWLINE
  internal func simpleStmt() throws -> NonEmptyArray<Statement> {
    let ruleClosing: [Token.Kind] = [.newLine, .eof]
    let smallStmtClosing: [Token.Kind] = [.semicolon, .newLine, .eof]

    let first = try self.smallStmt(closingTokens: smallStmtClosing)
    var array = NonEmptyArray(first: first)

    while self.peek.kind == .semicolon && !ruleClosing.contains(self.peekNext.kind) {
      try self.advance() // ;

      let element = try self.smallStmt(closingTokens: smallStmtClosing)
      array.append(element)
    }

    // optional trailing semicolon
    try self.consumeIf(.semicolon)

    // consume new line (we will also accept eof)
    switch self.peek.kind {
    case .eof: break
    case .newLine: try self.consumeNewLines()
    default: throw self.unexpectedToken(expected: [.newLine, .eof])
    }

    return array
  }

  /// suite: simple_stmt | NEWLINE INDENT stmt+ DEDENT`
  internal func suite() throws -> NonEmptyArray<Statement> {
    if try self.consumeIf(.newLine) {
      // Consume additional new lines (we can have more than 1).
      // It will also handle the case when we have comment as 1st line.
      try self.consumeNewLines()

      try self.consumeOrThrow(.indent)

      var result = try self.stmt()

      while self.peek.kind != .dedent {
        let stmts = try self.stmt()
        result.append(contentsOf: stmts)
      }

      try self.consumeOrThrow(.dedent)
      return result
    }

    return try self.simpleStmt()
  }
}

import Core
import Lexer

extension Parser {

  /// stmt: simple_stmt | compound_stmt
  internal mutating func stmt() throws -> NonEmptyArray<Statement> {
    if let stmt = try self.compoundStmtOrNop() {
      return NonEmptyArray(first: stmt)
    }

    return try self.simpleStmt()
  }

  /// simple_stmt: small_stmt (';' small_stmt)* [';'] NEWLINE
  internal mutating func simpleStmt() throws -> NonEmptyArray<Statement> {
    let ruleClosing: [TokenKind] = [.newLine, .eof]
    let smallStmtClosing: [TokenKind] = [.semicolon, .newLine, .eof]

    let first = try self.smallStmt(closingTokens: smallStmtClosing)
    var array = NonEmptyArray(first: first)

    while self.peek.kind == .semicolon && !ruleClosing.contains(self.peekNext.kind) {
      try self.advance() // ;

      let element = try self.smallStmt(closingTokens: smallStmtClosing)
      array.append(element)
    }

    // optional trailing semocolon
    try self.consumeIf(.semicolon)

    // consume new line (we will also accept eof)
    switch self.peek.kind {
    case .eof: break
    case .newLine: try self.advance()
    default: throw self.unexpectedToken(expected: [.newLine, .eof])
    }

    return array
  }

  /// suite: simple_stmt | NEWLINE INDENT stmt+ DEDENT`
  internal mutating func suite() throws -> NonEmptyArray<Statement> {
    if try self.consumeIf(.newLine) {
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

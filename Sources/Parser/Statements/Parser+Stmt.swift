import Core
import Lexer

extension Parser {

  /// `suite: simple_stmt | NEWLINE INDENT stmt+ DEDENT`
  internal mutating func suite(closingTokens: [TokenKind])
    throws -> NonEmptyArray<Statement> {

      // TODO: suite - finish
      if self.peek.kind == .newLine {
        try self.advance() // newLine
        try self.consumeOrThrow(.indent)
        throw self.unimplemented()
        try self.consumeOrThrow(.dedent)
      }

      return try self.smallStmtSuite(closingTokens: closingTokens)
  }

  private mutating func smallStmtSuite(closingTokens: [TokenKind])
    throws -> NonEmptyArray<Statement> {

    // TODO: add newline to closings?
    let first = try self.smallStmt(closingTokens: closingTokens)
    var result = NonEmptyArray(first: first)

//    var additionalClosing = closingTokens
//    additionalClosing.append(.newLine)
//
//    while self.peek.kind == .semicolon && !additionalClosing.contains(self.peekNext.kind) {
//      try self.advance() // ;
//
//      let stmt = try self.smallStmt(closingTokens: closingTokens) // additionalClosing
//      result.append(stmt)
//    }
//
//    // optional semicolon
//    if self.peek.kind == .semicolon {
//      try self.advance() // ;
//    }
//
//    try self.consumeOrThrow(.newLine)
    return result
  }
}

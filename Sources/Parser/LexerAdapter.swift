import Lexer

/// Minor pre-processing of provided lexer.
///
/// By that we mean:
/// - Take only the 1st new line if we have multiple subsequent ones
/// - Remove lines that contain only the comment
internal struct LexerAdapter {

  /// Current token.
  internal private(set) var peek = Token(.eof, start: .start, end: .start)

  /// Token after `self.peek`.
  internal private(set) var peekNext = Token(.eof, start: .start, end: .start)

  private let lexer: LexerType

  // MARK: - Init

  internal init(lexer: LexerType) {
    self.lexer = lexer
  }

  // MARK: - Populate peeks

  internal mutating func populatePeeks() throws {
    self.peek = try self.getNextToken()

    // Advance 'self.peek' until first not comment or new line
    while self.isComment(self.peek) || self.isNewLine(self.peek) {
      self.peek = try self.getNextToken()
    }

    // If we have empty source -> both eof
    if self.isEOF(self.peek) {
      self.peekNext = self.peek
      return
    }

    self.peekNext = try self.getNextNonCommentToken()
  }

  private func getNextNonCommentToken() throws -> Token {
    var result = try self.getNextToken()
    while self.isComment(result) {
      result = try self.getNextToken()
    }

    return result
  }

  // MARK: - Advance

  @discardableResult
  internal mutating func advance() throws -> Token? {
    // EOF should be handled before we ask for next token.
    // Consuming 'EOF' should not be a thing.
    assert(self.peek.kind != .eof)

    // We know that 'self.peekNext' is not a comment
    // because we used 'self.getNextNonCommentToken'
    self.peek = self.peekNext
    self.peekNext = try self.getNextNonCommentToken()

    return self.peek
  }

  // MARK: - Get next token

  private func getNextToken() throws -> Token {
    return try self.lexer.getToken()
  }

  // MARK: - Token predicates

  private func isEOF(_ token: Token) -> Bool {
    if case TokenKind.eof = token.kind { return true }
    return false
  }

  private func isComment(_ token: Token) -> Bool {
    if case TokenKind.comment = token.kind { return true }
    return false
  }

  private func isNewLine(_ token: Token) -> Bool {
    if case TokenKind.newLine = token.kind { return true }
    return false
  }

  // MARK: - New lines

  /// We can have multiple new lines, it should not matter
  internal mutating func consumeNewLines() throws {
    while self.peek.kind == .newLine {
      try self.advance()
    }
  }
}

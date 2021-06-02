import VioletLexer

/// Minor pre-processing of provided lexer.
///
/// By that we mean:
/// - Take only the 1st new line if we have subsequent ones
/// - Treat lines that contain only the comment as just new lines
///
/// Mostly because this is how grammar is defined.
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
    self.peek = try self.getNextNonCommentToken()

    // If we have empty source -> both eof
    if self.isEOF(self.peek) {
      self.peekNext = self.peek
      return
    }

    self.peekNext = try self.getPeekNextToken()
  }

  // MARK: - Advance

  @discardableResult
  internal mutating func advance() throws -> Token {
    // 'EOF' should be handled before we ask for next token.
    // Consuming 'EOF' should not be a thing.
    // It may also be a case that we forgot to call 'self.populatePeeks'.
    assert(self.peek.kind != .eof)

    // We know that 'self.peekNext' is valid (non-comment etc.) token
    // because we used 'self.getPeekNextToken' to obtain it.
    self.peek = self.peekNext
    self.peekNext = try self.getPeekNextToken()

    return self.peek
  }

  /// Token that we have already lexed, but is still waiting for processing.
  /// Basically 1 token buffer.
  ///
  /// Most of the time it will be `nil`, but sometimes (for example if we
  /// were checking for subsequent new lines) we will fill it.
  private var pendingToken: Token?

  private mutating func getPeekNextToken() throws -> Token {
    if let pending = self.pendingToken {
      self.pendingToken = nil
      return pending
    }

    let result = try self.getNextNonCommentToken()

    let hasToCheckForSubsequentNewLines = self.isNewLine(result)
    guard hasToCheckForSubsequentNewLines else {
      // Just an ordinary token, nothing to do here…
      return result
    }

    // We have a new line, we need to consume subsequent new lines as well.

    var after = try self.getNextNonCommentToken()
    while self.isNewLine(after) {
      // Do not set 'result = after' we will take only the 1st 'new line'!
      after = try self.getNextNonCommentToken()
    }

    // 'after' is not a comment or new line, we have to remember it
    // and return as 'peekNext' on next 'advance'.
    assert(self.pendingToken == nil)
    self.pendingToken = after

    return result
  }

  private func getNextNonCommentToken() throws -> Token {
    var result = try self.getNextToken()
    while self.isComment(result) {
      result = try self.getNextToken()
    }

    return result
  }

  // MARK: - Get next token

  private func getNextToken() throws -> Token {
    return try self.lexer.getToken()
  }

  // MARK: - Token predicates

  private func isEOF(_ token: Token) -> Bool {
    if case Token.Kind.eof = token.kind { return true }
    return false
  }

  private func isComment(_ token: Token) -> Bool {
    if case Token.Kind.comment = token.kind { return true }
    return false
  }

  private func isNewLine(_ token: Token) -> Bool {
    if case Token.Kind.newLine = token.kind { return true }
    return false
  }
}

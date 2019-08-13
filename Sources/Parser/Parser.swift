import Lexer

// https://docs.python.org/3/reference/index.html
// Python/ast.c in CPython

// PyAST_FromNodeObject(const node *n, PyCompilerFlags *flags,
//                      PyObject *filename, PyArena *arena)

public enum ParserMode {
  /// Used for input in interactive mode.
  case single
  /// Used for all input read from non-interactive files.
  case fileInput
  /// Used for `eval()`.
  case eval
}

private enum ParserState {
  case notStarted
  case finished(AST)
  case error(Error)
}

public struct Parser {

  /// Token source.
  internal var lexer: LexerType

  /// What are we parsing? Expression? Statement?
  private var mode: ParserMode

  /// Current parser state.
  /// Used for example for: caching parsing result.
  private var state = ParserState.notStarted

  public init(mode: ParserMode, tokenSource lexer: LexerType) {
    self.mode = mode
    self.lexer = lexer
  }

  // MARK: - Traversal

  /// Current token.
  internal var peek = Token(.eof, start: .start, end: .start)

  /// Token after `self.peek`.
  internal var peekNext = Token(.eof, start: .start, end: .start)

  @discardableResult
  internal mutating func advance() throws -> Token? {
    // EOF should be handled before we ask for next token.
    // Consuming 'EOF' should not be a thing.
    assert(self.peek.kind != .eof)

    repeat {
      self.peek = self.peekNext
      self.peekNext = try self.lexer.getToken()
    } while self.isComment(self.peek)

    return self.peek
  }

  private func isComment(_ token: Token) -> Bool {
    guard case TokenKind.comment = token.kind else { return false }
    return true
  }

  // MARK: - Parse

  public mutating func parse() throws -> AST {
    switch self.state {
    case .notStarted:

      // populate peeks
      self.peek = try self.lexer.getToken()
      self.peekNext = try self.lexer.getToken()

      do {
        let ast = try self.parseByMode()
        self.state = .finished(ast)
        return ast
      }
      catch {
        self.state = .error(error)
        throw error
      }

    case .finished(let ast):
      return ast

    case .error(let error):
      throw error
    }
  }

  private mutating func parseByMode() throws -> AST {
    // TODO: take this from grammar (PyAST_FromNodeObject)
    switch self.mode {
    case .single:
      throw self.unimplemented()

    case .fileInput:
      let closingTokens: [TokenKind] = [.semicolon, .newLine, .eof]

      var stmt: Statement?
      if let s = try self.compoundStmtOrNop(closingTokens: closingTokens) {
        stmt = s
      } else {
        stmt = try self.smallStmt(closingTokens: [.semicolon, .newLine, .eof])
      }

      return .fileInput([stmt!])

    case .eval:
      let expr = try self.test()
      return AST.expression(expr)
    }
  }

  // MARK: - Naming

  /// CPython:
  /// `forbidden_name(struct compiling*, identifier, const node*, int)`
  internal func checkForbiddenName(_ name: String) throws {
    if name == "__debug__" {
      // invalid keyword usage
      throw self.unimplemented("assignment to keyword")
    }

    // We don't need to check for 'None', 'True', 'False',
    // because those keywords are handled by lexer.
  }

  // MARK: - Consume

  internal mutating func consumeIdentifierOrThrow() throws -> String {
    if case let TokenKind.identifier(value) = self.peek.kind {
      try self.advance() // identifier
      return value
    }

    throw self.unexpectedToken(expected: [.identifier])
  }

  internal mutating func consumeOrThrow(_ kind: TokenKind) throws {
    guard try self.consumeIf(kind) else {
      throw self.unexpectedToken(expected: [kind.expected])
    }
  }

  internal mutating func consumeIf(_ kind: TokenKind) throws -> Bool {
    if self.peek.kind == kind {
      try self.advance()
      return true
    }

    return false
  }

  // MARK: - Create

  internal func statement(_ kind: StatementKind,
                          start:  SourceLocation,
                          end:    SourceLocation) -> Statement {
    return Statement(kind: kind, start: start, end: end)
  }

  internal func expression(_ kind: ExpressionKind,
                           start:  SourceLocation,
                           end:    SourceLocation) -> Expression {
    return Expression(kind, start: start, end: end)
  }

  /// Create parser warning
  internal mutating func warn(_ warning: ParserWarning,
                              start:     SourceLocation? = nil,
                              end:       SourceLocation? = nil) {
    // uh... oh... well that's embarrassing...
  }

  /// Create parser error
  internal func error(_ kind:   ParserErrorKind,
                      location: SourceLocation? = nil) -> ParserError {
    return ParserError(kind, location: location ?? self.peek.start)
  }

  // swiftlint:disable:next function_default_parameter_at_end
  internal func unexpectedToken(token: Token? = nil,
                                location: SourceLocation? = nil,
                                expected: [ExpectedToken]) -> ParserError {

    let tok = token ?? self.peek
    switch tok.kind {
    case .eof:
      return self.error(
        .unexpectedEOF(expected: expected),
        location: location
      )
    default:
      return self.error(
        .unexpectedToken(tok.kind, expected: expected),
        location: location
      )
    }
  }

  // MARK: - Unimplemented

  @available(*, deprecated, message: "Unimplemented")
  internal func unimplemented(_ message: String? = nil,
                              function:  StaticString = #function) -> ParserError {
    return self.error(.unimplemented("\(function): \(message ?? "")"))
  }
}

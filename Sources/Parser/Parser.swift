import Lexer

// https://docs.python.org/3/reference/index.html
// Python/ast.c in CPython

// PyAST_FromNodeObject(const node *n, PyCompilerFlags *flags,
//                      PyObject *filename, PyArena *arena)

private enum ParserState {
  case notStarted
  case finished(AST)
}

public struct Parser {

  /// Token source.
  internal var lexer: LexerType

  /// What are we parsing? Expression? Statement?
  private var mode: Mode

  /// Current parser state.
  /// Used for example for: caching parsing result.
  private var state = ParserState.notStarted

  public init(mode: Mode, tokenSource lexer: LexerType) {
    self.mode = mode
    self.lexer = lexer
  }

  public enum Mode {
    /// REPL.
    case single
    /// For evaluating expression.
    case eval
    /// For executing statement.
    case exec
  }

  // MARK: - Traversal

  /// Current token.
  internal var peek = Token(.comment(""), start: .start, end: .start)

  /// Token after `self.peek`.
  internal var peekNext = Token(.comment(""), start: .start, end: .start)

  @discardableResult
  internal mutating func advance() throws -> Token? {
    if self.peek.kind == .eof {
      throw self.unimplemented("Important, because we no longer have nil on end: self.failUnexpectedEOF")
    }

    repeat {
      self.peek = self.peekNext
      self.peekNext = try self.lexer.getToken()
    } while self.isComment(self.peek) && !self.isEOF(self.peek)

    return self.peek
  }

  private func isComment(_ token: Token?) -> Bool {
    guard let kind = token?.kind else { return false }
    guard case TokenKind.comment(_) = kind else { return false }
    return true
  }

  private func isEOF(_ token: Token?) -> Bool {
    guard let kind = token?.kind else { return false }
    return kind == .eof
  }

  // MARK: - Parse

  public mutating func parse() throws -> AST {
    switch self.state {
    case .notStarted:
      // populate peeks
      self.peek = try self.lexer.getToken()
      self.peekNext = try self.lexer.getToken()

      let expr = try self.expression()
      let ast = AST.expression(expr)
      self.state = .finished(ast)
      return ast

    case .finished(let ast):
      return ast
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

    throw self.unimplemented()
  }

  internal mutating func consumeOrThrow(_ kind: TokenKind) throws {
    guard try self.consumeIf(kind) else {
      throw self.unimplemented("consumeOrThrow: \(kind)")
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

  // @available(*, deprecated, message: "Unimplemented")
  internal func unimplemented(_ message: String? = nil,
                              function:  StaticString = #function) -> ParserError {
    return self.error(.unimplemented("\(function): \(message ?? "")"))
  }

  // TODO: unexpectedTokenError()
  internal func failUnexpectedToken(expected: ExpectedToken...,
                                    function:  StaticString = #function) -> Error {
    switch self.peek.kind {
    case .eof:
      // self.failUnexpectedEOF
      return self.error(.unimplemented("\(function): unexpected eof, expected: \(expected)"))
    default:
      return self.error(.unimplemented("\(function): unexpected \(self.peek.kind), expected: \(expected)"))
    }
  }
}

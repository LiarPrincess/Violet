import Core
import Lexer

// In CPython:
// Python -> ast.c
//  PyAST_FromNodeObject(const node *n, PyCompilerFlags *flags, ...)

// https://docs.python.org/3/reference/index.html

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
        try self.validate(ast)
        self.state = .finished(ast)
        return ast
      }
      catch {
        self.state = .error(error)
        throw error
      }

    case let .finished(ast):
      return ast

    case let .error(error):
      throw error
    }
  }

  private mutating func parseByMode() throws -> AST {
    switch self.mode {
    case .single:    return try self.singleInput()
    case .fileInput: return try self.fileInput()
    case .eval:      return try self.evalInput()
    }
  }

  private func validate(_ ast: AST) throws {
    let validator = ASTValidationPass()
    try validator.visit(ast)
  }

  /// single_input: NEWLINE | simple_stmt | compound_stmt NEWLINE
  internal mutating func singleInput() throws -> AST {
    // TODO: test this
    if self.peek.kind == .newLine {
      return .single([])
    }

    if let stmt = try self.compoundStmtOrNop() {
      try self.consumeOrThrow(.newLine)
      return .single([stmt])
    }

    let stmts = try self.simpleStmt()
    return .single(Array(stmts))
  }

  /// file_input: (NEWLINE | stmt)* ENDMARKER
  internal mutating func fileInput() throws -> AST {
    var result = [Statement]()

    while self.peek.kind != .eof {
      switch self.peek.kind {
      case .newLine:
        try self.advance() // newLine
      default:
        let stmts = try self.stmt()
        result.append(contentsOf: stmts)
      }
    }

    // We know that 'self.peek.kind == .eof' (because of 'while' condition)
    return .fileInput(result)
  }

  /// eval_input: testlist NEWLINE* ENDMARKER
  internal mutating func evalInput() throws -> AST {
    let start = self.peek.start
    let list = try self.testList(closingTokens: [.newLine, .eof])

    while self.peek.kind == .newLine {
      try self.advance() // newLine
    }

    guard self.peek.kind == .eof else {
      throw self.unexpectedToken(expected: [.eof])
    }

    let expr = list.toExpression(start: start)
    return .expression(expr)
  }

  // MARK: - Naming

  /// CPython:
  /// `forbidden_name(struct compiling*, identifier, const node*, int)`
  internal func checkForbiddenName(_ name: String,
                                   location: SourceLocation) throws {
    if name == "__debug__" {
      throw self.error(.forbiddenName(name), location: location)
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

  @discardableResult
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
    return Statement(kind, start: start, end: end)
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
}

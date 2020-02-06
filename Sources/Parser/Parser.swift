import Core
import Lexer

// In CPython:
// Python -> ast.c
//  PyAST_FromNodeObject(const node *n, PyCompilerFlags *flags, ...)

// https://docs.python.org/3/reference/index.html

public enum ParserMode {
  /// Used for input in interactive mode.
  case interactive
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

public class Parser {

  /// Token source.
  internal var lexer: LexerType

  /// What are we parsing? Expression? Statement?
  private var mode: ParserMode

  /// Current parser state.
  /// Used for example for: caching parsing result.
  private var state = ParserState.notStarted

  /// Helper for creating AST nodes.
  public var builder = ASTBuilder()

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
  internal func advance() throws -> Token? {
    // EOF should be handled before we ask for next token.
    // Consuming 'EOF' should not be a thing.
    assert(self.peek.kind != .eof)

    // We know that 'self.peekNext' is not a comment
    // because we used 'self.getNextNonCommentToken'
    self.peek = self.peekNext
    self.peekNext = try self.getNextNonCommentToken()

    return self.peek
  }

  private func populatePeeks() throws {
    self.peek = try self.getNextToken()

    // Advance 'self.peek' until first not comment or new line
    while self.isComment(self.peek) || self.isNewLine(self.peek) {
      self.peek = try self.getNextToken()
    }

    // If we have empty source -> both eof
    if case TokenKind.eof = self.peek.kind {
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

  private func getNextToken() throws -> Token {
    return try self.lexer.getToken()
  }

  private func isComment(_ token: Token) -> Bool {
    if case TokenKind.comment = token.kind { return true }
    return false
  }

  private func isNewLine(_ token: Token) -> Bool {
    if case TokenKind.newLine = token.kind { return true }
    return false
  }

  // MARK: - Parse

  public func parse() throws -> AST {
    switch self.state {
    case .notStarted:
      do {
        try self.populatePeeks()

        let ast = try self.parseByMode()
        try self.validate(ast)
        self.state = .finished(ast)
        return ast
      } catch {
        self.state = .error(error)
        throw error
      }

    case let .finished(ast):
      return ast

    case let .error(error):
      throw error
    }
  }

  private func parseByMode() throws -> AST {
    switch self.mode {
    case .interactive: return try self.interactiveInput()
    case .fileInput: return try self.fileInput()
    case .eval: return try self.evalInput()
    }
  }

  private func validate(_ ast: AST) throws {
    let validator = ASTValidator()
    try validator.validate(ast: ast)
  }

  /// single_input: NEWLINE | simple_stmt | compound_stmt NEWLINE
  internal func interactiveInput() throws -> AST {
    let start = self.peek.start

    if self.peek.kind == .newLine {
      return self.builder.interactiveAST(statements: [],
                                         start: start,
                                         end: self.peek.end)
    }

    if let stmt = try self.compoundStmtOrNop() {
      let end = self.peek.end
      try self.consumeOrThrow(.newLine)

      return self.builder.interactiveAST(statements: [stmt],
                                         start: start,
                                         end: end)
    }

    let stmts = try self.simpleStmt()
    return self.builder.interactiveAST(statements: Array(stmts),
                                       start: start,
                                       end: stmts.last.end)
  }

  /// file_input: (NEWLINE | stmt)* ENDMARKER
  internal func fileInput() throws -> AST {
    let first = self.peek
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
    return self.builder.moduleAST(statements: result,
                                  start: first.start,
                                  end: result.last?.end ?? first.end)
  }

  /// eval_input: testlist NEWLINE* ENDMARKER
  internal func evalInput() throws -> AST {
    let start = self.peek.start
    let list = try self.testList(context: .load, closingTokens: [.newLine, .eof])

    try self.consumeNewLines()

    let end = self.peek.end
    guard self.peek.kind == .eof else {
      throw self.unexpectedToken(expected: [.eof])
    }

    let expr = list.toExpression(using: &self.builder, start: start)
    return self.builder.expressionAST(expression: expr, start: start, end: end)
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

  internal func consumeIdentifierOrThrow() throws -> String {
    if case let TokenKind.identifier(value) = self.peek.kind {
      try self.advance() // identifier
      return value
    }

    throw self.unexpectedToken(expected: [.identifier])
  }

  internal func consumeOrThrow(_ kind: TokenKind) throws {
    guard try self.consumeIf(kind) else {
      throw self.unexpectedToken(expected: [kind.expected])
    }
  }

  @discardableResult
  internal func consumeIf(_ kind: TokenKind) throws -> Bool {
    if self.peek.kind == kind {
      try self.advance()
      return true
    }

    return false
  }

  /// We can have multiple new lines, it should not matter
  internal func consumeNewLines() throws {
    while self.peek.kind == .newLine {
      try self.advance()
    }
  }

  // MARK: - Create

  /// Create parser warning
  internal func warn(_ warning: ParserWarning, location:  SourceLocation? = nil) {
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

    let kind = tok.kind == .eof ?
      ParserErrorKind.unexpectedEOF(expected: expected) :
      ParserErrorKind.unexpectedToken(tok.kind, expected: expected)

    return self.error(kind, location: location)
  }
}

import VioletCore
import VioletLexer

// In CPython:
// Python -> ast.c
//  PyAST_FromNodeObject(const node *n, PyCompilerFlags *flags, ...)

// https://docs.python.org/3/reference/index.html

public final class Parser {

  // MARK: - Helper types

  /// What/why are we parsing?
  ///
  /// What is the meaning of life? 42?
  public enum Mode {
    /// Used for input in interactive mode.
    case interactive
    /// Used for all input read from non-interactive files.
    case fileInput
    /// Used for `eval()`.
    case eval

    /// The same as `fileInput`.
    public static var exec: Mode { return .fileInput }

    /// The same as `interactive`.
    public static var single: Mode { return .interactive }
  }

  /// Remember the parser execution result.
  ///
  /// If we ever happen to have a "great" idea along the lines of:
  /// "let's just run the parser again, because why not".
  private enum State {
    /// We will run the parser.
    case notStarted
    /// Everything is ok.
    case finished(AST)
    /// Everything is terrible and the word* hates us…
    ///
    /// (*) Microsoft Word
    case error(Error)
  }

  // MARK: - Properties

  /// Token source.
  internal var lexer: LexerAdapter

  /// What are we parsing? Expression? Statement?
  private var mode: Mode

  /// Current parser state.
  /// Used for example for: caching parsing result.
  private var state = State.notStarted

  /// Helper for creating AST nodes.
  public var builder = ASTBuilder()

  internal weak var delegate: ParserDelegate?
  internal weak var lexerDelegate: LexerDelegate?

  // MARK: - Init

  /// - Parameters:
  ///   - lexerDelegate: mostly for `fstrings` when we have to lex expression
  public init(mode: Parser.Mode,
              tokenSource: LexerType,
              delegate: ParserDelegate?,
              lexerDelegate: LexerDelegate?) {
    self.mode = mode
    self.lexer = LexerAdapter(lexer: tokenSource)
  }

  // MARK: - Traversal

  /// Current token.
  internal var peek: Token { return self.lexer.peek }

  /// Token after `self.peek`.
  internal var peekNext: Token { return self.lexer.peekNext }

  @discardableResult
  internal func advance() throws -> Token {
    let result = try self.lexer.advance()
    return result
  }

  // MARK: - Parse

  public func parse() throws -> AST {
    switch self.state {
    case .notStarted:
      do {
        try self.lexer.populatePeeks()

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
      // We need to also report 'newLine' as expected!
      try self.consumeNewLines()
      try self.assertEOF(expected: .newLine, .eof)

      return self.builder.interactiveAST(statements: [stmt],
                                         start: start,
                                         end: self.peek.end)
    }

    let stmts = try self.simpleStmt()
    try self.assertEOF()

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

    // We know that 'self.peek.kind == .eof' (because of 'while' condition),
    // but we can check anyway:
    try self.assertEOF()

    return self.builder.moduleAST(statements: result,
                                  start: first.start,
                                  end: result.last?.end ?? first.end)
  }

  /// eval_input: testlist NEWLINE* ENDMARKER
  internal func evalInput() throws -> AST {
    let start = self.peek.start
    let list = try self.testList(context: .load, closingTokens: [.newLine, .eof])

    try self.consumeNewLines()
    try self.assertEOF()

    let expr = list.toExpression(using: &self.builder, start: start)
    return self.builder.expressionAST(expression: expr,
                                      start: start,
                                      end: self.peek.end)
  }

  private func assertEOF(expected: ExpectedToken...) throws {
    var expected = expected
    if !expected.contains(.eof) {
      expected.append(.eof)
    }

    guard case .eof = self.peek.kind else {
      throw self.unexpectedToken(expected: expected)
    }
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
    if case let Token.Kind.identifier(value) = self.peek.kind {
      try self.advance() // identifier
      return value
    }

    throw self.unexpectedToken(expected: [.identifier])
  }

  internal func consumeOrThrow(_ kind: Token.Kind) throws {
    guard try self.consumeIf(kind) else {
      throw self.unexpectedToken(expected: [kind.expected])
    }
  }

  @discardableResult
  internal func consumeIf(_ kind: Token.Kind) throws -> Bool {
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

  /// Report parser warning
  internal func warn(_ kind: ParserWarningKind,
                     location: SourceLocation? = nil) {
    let warning = ParserWarning(kind, location: location ?? self.peek.start)
    self.delegate?.warn(warning: warning)
  }

  /// Create parser error
  internal func error(_ kind: ParserErrorKind,
                      location: SourceLocation? = nil) -> ParserError {
    return ParserError(kind, location: location ?? self.peek.start)
  }

  // swiftlint:disable:next function_default_parameter_at_end
  internal func unexpectedToken(token: Token? = nil,
                                location: SourceLocation? = nil,
                                expected: [ExpectedToken]) -> ParserError {
    let token = token ?? self.peek

    let kind = token.kind == .eof ?
      ParserErrorKind.unexpectedEOF(expected: expected) :
      ParserErrorKind.unexpectedToken(token.kind, expected: expected)

    return self.error(kind, location: location)
  }
}

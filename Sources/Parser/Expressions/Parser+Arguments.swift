import VioletCore
import VioletLexer

// In CPython:
// Python -> ast.c
//  ast_for_arguments(struct compiling *c, const node *n)

// Technically we are parsing parameters, but CPython calls them arguments.

/// Intermediate representation for arguments.
/// For now it is basically a copy of 'Arguments', but this may change.
private struct ArgumentsIR {

  /// Positional arguments.
  fileprivate var args: [Argument] = []
  /// Default values for positional arguments.
  fileprivate var defaults: [Expression] = []
  /// Positional only arguments count. nil means 0.
  fileprivate var posOnlyArgCount: Int?
  /// Non-keyworded variable length arguments.
  fileprivate var vararg: Vararg = .none
  /// Parameters which occur after the '*args'.
  fileprivate var kwOnlyArgs: [Argument] = []
  /// Default values for keyword-only arguments.
  fileprivate var kwOnlyDefaults: [Expression] = []
  /// Keyworded (named) variable length arguments.
  fileprivate var kwarg: Argument?

  fileprivate var start: SourceLocation
  fileprivate var end: SourceLocation

  fileprivate init(start: SourceLocation, end: SourceLocation) {
    self.start = start
    self.end = end
  }

  fileprivate func compile(using builder: inout ASTBuilder) -> Arguments {
    return builder.arguments(args: self.args,
                             posOnlyArgCount: self.posOnlyArgCount ?? 0,
                             defaults: self.defaults,
                             vararg: self.vararg,
                             kwOnlyArgs: self.kwOnlyArgs,
                             kwOnlyDefaults: self.kwOnlyDefaults,
                             kwarg: self.kwarg,
                             start: self.start,
                             end: self.end)
  }
}

extension Parser {

  /// `parameters: '(' [typedargslist] ')'`
  internal func parameters() throws -> Arguments {
    try self.consumeOrThrow(.leftParen)
    let args = try self.typedArgsList(closingToken: .rightParen)
    try self.consumeOrThrow(.rightParen)
    return args
  }

  /// ```c
  /// typedargslist:
  ///   (
  ///     tfpdef ['=' test] (',' tfpdef ['=' test])*
  ///       [','
  ///         [
  ///           '*' [tfpdef] (',' tfpdef ['=' test])* [',' ['**' tfpdef [',']]]
  ///           | '**' tfpdef [',']
  ///         ]
  ///       ]
  ///       | '*' [tfpdef] (',' tfpdef ['=' test])* [',' ['**' tfpdef [',']]]
  ///       | '**' tfpdef [',']
  ///   )
  ///
  /// tfpdef: NAME [':' test]
  /// ```
  internal func typedArgsList(closingToken: Token.Kind) throws -> Arguments {
    return try self.argsList(parseArg: Parser.tfpdef,
                             closingToken: closingToken)
  }

  /// ```c
  /// varargslist:
  ///   (
  ///     vfpdef ['=' test] (',' vfpdef ['=' test])*
  ///     [','
  ///       [
  ///         '*' [vfpdef] (',' vfpdef ['=' test])* [',' ['**' vfpdef [',']]]
  ///         | '**' vfpdef [',']
  ///       ]
  ///     ]
  ///     | '*' [vfpdef] (',' vfpdef ['=' test])* [',' ['**' vfpdef [',']]]
  ///     | '**' vfpdef [',']
  ///   )
  /// vfpdef: NAME
  /// ```
  internal func varArgsList(closingToken: Token.Kind) throws -> Arguments {
    return try self.argsList(parseArg: Parser.vfpdef,
                             closingToken: closingToken)
  }

  // MARK: - Arg factory

  private typealias ArgFactory = (Parser) throws -> Argument

  /// `vfpdef: NAME`
  private static func vfpdef(_ parser: Parser) throws -> Argument {
    let token = parser.peek
    let name = try parser.consumeIdentifierOrThrow()
    try parser.checkForbiddenName(name, location: token.start)
    return parser.builder.argument(name: name,
                                   annotation: nil,
                                   start: token.start,
                                   end: token.end)
  }

  /// `tfpdef: NAME [':' test]`
  private static func tfpdef(_ parser: Parser) throws -> Argument {
    let token = parser.peek
    let name = try parser.consumeIdentifierOrThrow()
    try parser.checkForbiddenName(name, location: token.start)

    // annotation is optional
    var annotation: Expression?
    if parser.peek.kind == .colon {
      try parser.advance() // :
      annotation = try parser.test(context: .load)
    }

    let end = annotation?.end ?? token.end
    return parser.builder.argument(name: name,
                                   annotation: annotation,
                                   start: token.start,
                                   end: end)
  }

  // MARK: - Args list

  private func argsList(parseArg: ArgFactory,
                        closingToken: Token.Kind) throws -> Arguments {
    let loc = self.peek.start
    var ir = ArgumentsIR(start: loc, end: loc)

    while self.peek.kind != closingToken {
      switch self.peek.kind {
      case .identifier: try self.parseArgument(ir: &ir, parseArg: parseArg)
      case .slash: try self.parsePosOnlySeparator(ir: &ir)
      case .star: try self.parseVarargs(ir: &ir, parseArg: parseArg)
      case .starStar: try self.parseKwargs(ir: &ir, parseArg: parseArg)
      default:
        throw self.unexpectedToken(expected: [.identifier, .star, .starStar])
      }

      // After the argument we have either comma or closing, else error
      if self.peek.kind == .comma {
        ir.end = self.peek.end
        try self.advance() // ,
      } else if self.peek.kind != closingToken {
        throw self.unexpectedToken(expected: [.comma, closingToken.expected])
      }
    }

    // After single '*' (e.g. 'lambda a, *: 5') we must have args
    if case .unnamed = ir.vararg, ir.kwOnlyArgs.isEmpty {
      throw self.error(.starWithoutFollowingArguments)
    }

    return ir.compile(using: &self.builder)
  }

  /// `vfpdef/tfpdef ['=' test]`
  private func parseArgument(ir: inout ArgumentsIR, parseArg: ArgFactory) throws {
    guard ir.kwarg == nil else {
      throw self.error(.argsAfterKwargs)
    }

    let argument = try parseArg(self)
    ir.end = argument.end

    var defaultValue: Expression?
    if try self.consumeIf(.equal) {
      let value = try self.test(context: .load)
      defaultValue = value
      ir.end = value.end
    }

    switch ir.vararg {
    case .none: // positional arg
      ir.args.append(argument)
      if let defaultValue = defaultValue {
        ir.defaults.append(defaultValue)
      } else if !ir.defaults.isEmpty {
        throw self.error(.defaultAfterNonDefaultArgument, location: argument.start)
      }
    case .unnamed,
         .named: // keyword only arg (follows * or *args)
      ir.kwOnlyArgs.append(argument)
      if let defaultValue = defaultValue {
        ir.kwOnlyDefaults.append(defaultValue)
      } else {
        // We will place 'implicit None' just after 'argument'
        let loc = argument.end
        let implicitNone = self.builder.noneExpr(context: .load, start: loc, end: loc)
        ir.kwOnlyDefaults.append(implicitNone)
      }
    }
  }

  private func parsePosOnlySeparator(ir: inout ArgumentsIR) throws {
    assert(self.peek.kind == .slash)
    guard case .none = ir.vararg else {
      throw self.error(.posOnlyAfterVarargs)
    }
    guard ir.kwarg == nil else {
      throw self.error(.posOnlyAfterKwargs)
    }
    ir.end = self.peek.end // slash end
    try self.advance() // /
    ir.posOnlyArgCount = ir.args.count
  }

  /// `'*' [vfpdef]`
  private func parseVarargs(ir: inout ArgumentsIR, parseArg: ArgFactory) throws {
    assert(self.peek.kind == .star)

    guard ir.kwarg == nil else {
      throw self.error(.varargsAfterKwargs)
    }

    guard case .none = ir.vararg else {
      throw self.error(.duplicateVarargs)
    }

    ir.end = self.peek.end // star end
    try self.advance() // *

    switch self.peek.kind {
    case .identifier:
      let value = try parseArg(self)
      ir.vararg = .named(value)
      ir.end = value.end
    default:
      // do not consume, it is probably comma which we will handle later,
      // otherwise we will throw
      ir.vararg = .unnamed
    }
  }

  /// `'**' vfpdef`
  private func parseKwargs(ir: inout ArgumentsIR, parseArg: ArgFactory) throws {
    assert(self.peek.kind == .starStar)

    guard ir.kwarg == nil else {
      throw self.error(.duplicateKwargs)
    }

    try self.advance() // **
    let value = try parseArg(self)
    ir.kwarg = value
    ir.end = value.end
  }
}

import Lexer

// swiftlint:disable file_length
// TODO: (Arguments) Better docs

// In CPython: Python -> ast.c -> ast_for_arguments(_)

// Ongoing debate on 'positional only args' (not in the scope of 3.7):
// https://www.python.org/dev/peps/pep-0457/
// https://www.python.org/dev/peps/pep-0570/

// As for the code, we use following HACK:
//   Both `typedargslist` and `varargslist` look basically the same,
//   the only difference is `tfpdef` vs `vfpdef` for parsing single argument.
//   We can't pass mutating instance method as a function arg, because
//   of exclusive access. But we can pass static method with inout arg.
//   Even if static method stored the arg somewhere it would be a COW copy!

/// Intermediate representation for arguments.
private struct ArgumentsIR: Equatable {

  /// Positional arguments.
  fileprivate var args: [Arg] = []
  /// Default values for positional arguments.
  fileprivate var defaults: [Expression] = []
  /// Non-keyworded variable length arguments.
  fileprivate var vararg: Vararg = .none
  /// Parameters which occur after the '*args'.
  fileprivate var kwOnlyArgs: [Arg] = []
  /// Default values for keyword-only arguments.
  fileprivate var kwOnlyDefaults: [Expression] = []
  /// Keyworded (named) variable length arguments.
  fileprivate var kwarg: Arg? = nil

  fileprivate var start: SourceLocation
  fileprivate var end:   SourceLocation

  fileprivate init(start: SourceLocation, end: SourceLocation) {
    self.start = start
    self.end = end
  }

  fileprivate func compile() -> Arguments {
    return Arguments(args:     self.args,
                     defaults: self.defaults,
                     vararg: self.vararg,
                     kwOnlyArgs:     self.kwOnlyArgs,
                     kwOnlyDefaults: self.kwOnlyDefaults,
                     kwarg: self.kwarg,
                     start: self.start,
                     end: self.end)
  }
}

extension Parser {

  /// `parameters: '(' [typedargslist] ')'`
  internal mutating func parameters() throws -> Arguments {
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
  internal mutating func typedArgsList(closingToken: TokenKind) throws -> Arguments {
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
  internal mutating func varArgsList(closingToken: TokenKind) throws -> Arguments {

    return try self.argsList(parseArg: Parser.vfpdef,
                             closingToken: closingToken)
  }

  // MARK: - Arguments

  /// `vfpdef: NAME`
  private static func vfpdef(_ parser: inout Parser) throws -> Arg {
    let token = parser.peek
    let name = try parser.consumeIdentifierOrThrow()
    try parser.checkForbiddenName(name)
    return Arg(name, annotation: nil, start: token.start, end: token.end)
  }

  /// `tfpdef: NAME [':' test]`
  private static func tfpdef(_ parser: inout Parser) throws -> Arg {
    let token = parser.peek
    let name = try parser.consumeIdentifierOrThrow()
    try parser.checkForbiddenName(name)

    // annotation is optional
    var annotation: Expression? = nil
    if parser.peek.kind == .colon {
      try parser.advance() // :
      annotation = try parser.test()
    }

    let end = annotation?.end ?? token.end
    return Arg(name, annotation: annotation, start: token.start, end: end)
  }

  // MARK: - Args list

  private typealias ArgFactory = (inout Parser) throws -> Arg

  private mutating func argsList(parseArg:     ArgFactory,
                                 closingToken: TokenKind) throws -> Arguments {
    let loc = self.peek.start
    var ir = ArgumentsIR(start: loc, end: loc)

    while self.peek.kind != closingToken {
      switch self.peek.kind {
      case .identifier: try self.parseArgument(ir: &ir, parseArg: parseArg)
      case .star:       try self.parseVarargs(ir: &ir, parseArg: parseArg)
      case .starStar:   try self.parseKwargs(ir: &ir, parseArg: parseArg)
      default:
        throw self.unimplemented("\(self.peek.kind)")
      }

      // After the argument we have either comma or closing, else error
      if self.peek.kind == .comma {
        ir.end = self.peek.end
        try self.advance() // ,
      } else if self.peek.kind != closingToken {
        // TODO: add 'closingToken'
        throw self.failUnexpectedToken(expected: .comma)
      }
    }

    // After single '*' (e.g. 'lambda a, *: 5') we must have args
    if ir.vararg == .unnamed && ir.kwOnlyArgs.isEmpty {
      throw self.error(.starWithoutFollowingArguments)
    }

    return ir.compile()
  }

  /// `vfpdef/tfpdef ['=' test]`
  private mutating func parseArgument(ir: inout ArgumentsIR,
                                      parseArg: ArgFactory) throws {

    guard ir.kwarg == nil else {
      throw self.error(.argsAfterKwargs)
    }

    let argument = try parseArg(&self)
    ir.end = argument.end

    var defaultValue: Expression? = nil
    if try self.consumeIf(.equal) {
      let value = try self.test()
      defaultValue = value
      ir.end = value.end
    }

    switch ir.vararg {
    case .none: // positional arg
      ir.args.append(argument)
      if let defaultValue = defaultValue {
        ir.defaults.append(defaultValue)
      } else if !ir.defaults.isEmpty {
        throw self.error(.defaultFollowedByNonDefaultArgument)
      }
    case .unnamed, .named: // keyword only arg (follows * or *args)
      ir.kwOnlyArgs.append(argument)
      if let defaultValue = defaultValue {
        ir.kwOnlyDefaults.append(defaultValue)
      } else {
        // We will place 'implicit None' just after 'argument'
        let loc = argument.end
        let implicitNone = Expression(.none, start: loc, end: loc)
        ir.kwOnlyDefaults.append(implicitNone)
      }
    }
  }

  /// `'*' [vfpdef]`
  private mutating func parseVarargs(ir: inout ArgumentsIR,
                                     parseArg: ArgFactory) throws {
    assert(self.peek.kind == .star)

    guard ir.kwarg == nil else {
      throw self.error(.varargsAfterKwargs)
    }

    guard ir.vararg == .none else {
      throw self.error(.duplicateVarargs)
    }

    ir.end = self.peek.end // star end
    try self.advance() // *

    switch self.peek.kind {
    case .identifier:
      let value = try parseArg(&self)
      ir.vararg = .named(value)
      ir.end = value.end
    default:
      // do not consume, it is probably comma which we will handle later,
      // otherwise we will throw
      ir.vararg = .unnamed
    }
  }

  /// `'**' vfpdef`
  private mutating func parseKwargs(ir: inout ArgumentsIR,
                                    parseArg: ArgFactory) throws {
    assert(self.peek.kind == .starStar)

    guard ir.kwarg == nil else {
      throw self.error(.duplicateKwargs)
    }

    try self.advance() // **
    let value = try parseArg(&self)
    ir.kwarg = value
    ir.end = value.end
  }
}

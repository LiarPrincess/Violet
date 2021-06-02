import VioletCore
import VioletLexer

// cSpell:ignore allowgen

// In CPython:
// Python -> ast.c
//  ast_for_call(struct compiling *c, const node *n, expr_ty func, bool allowgen)

// Parsing argument list for:
// - trailer when it is an function call
// - base class
// - decorators

/// Intermediate representation for call.
internal struct CallIR {

  internal fileprivate(set) var args: [Expression] = []
  internal fileprivate(set) var keywords: [KeywordArgument] = []

  /// Flag for preventing incorrect ordering of arguments.
  /// (star star = keyword argument unpacking).
  ///
  /// Something like `f(a, **b)` is allowed
  /// Something like `f(**a, b)` is not allowed.
  fileprivate var hasStarStar = false

  /// We do allow generators as arguments (except for base classes),
  /// but only in one of the following cases:
  /// - generator is the ONLY argument,
  ///   for example: `sing(n for n in [elsa, ariel])`
  /// - generators are in parenthesis,
  ///   for example: `sing('let it go', (n for n in [elsa, ariel]))`
  ///
  /// Something like (notice no parens):
  /// `sing('let it go', n for n in [elsa, ariel])` is not allowed.
  ///
  /// We also need to remember the location in the source code,
  /// so that we know where to put error.
  fileprivate var generatorWithoutParensLocation: SourceLocation?

  fileprivate var hasGeneratorWithoutParens: Bool {
    return self.generatorWithoutParensLocation != nil
  }

  /// When parsing base class definition we don't allow generators.
  ///
  /// Something like `class Elsa(n for n in [princess, singer])` is invalid.
  ///
  /// We will store it in ir so we don't have to pass it as an arg to every method.
  fileprivate let isBaseClass: Bool

  fileprivate init(isBaseClass: Bool) {
    self.isBaseClass = isBaseClass
  }
}

extension Parser {

  // MARK: - Call

  /// `arglist: argument (',' argument)*  [',']`
  internal func argList(closingToken: Token.Kind,
                        isBaseClass: Bool = false) throws -> CallIR {
    var ir = CallIR(isBaseClass: isBaseClass)

    guard self.peek.kind != closingToken else { // no args
      return ir
    }

    // 1st is required
    try self.argument(into: &ir, closingToken: closingToken)

    while self.peek.kind == .comma && self.peekNext.kind != closingToken {
      try self.advance() // ,
      try self.argument(into: &ir, closingToken: closingToken)

      // We allow generator arguments, but only if they are the only argument
      // (something like 'sing(n for n in [elsa, ariel])').
      // Otherwise parens are required.
      if let loc = ir.generatorWithoutParensLocation, ir.args.count > 1 {
        throw self.error(.callWithGeneratorArgumentWithoutParens, location: loc)
      }
    }

    // optional trailing comma
    try self.consumeIf(.comma)

    return ir
  }

  /// ```c
  /// argument: ( test [comp_for] |
  ///             test '=' test |
  ///             '**' test |
  ///             '*' test )
  /// ```
  private func argument(into ir: inout CallIR, closingToken: Token.Kind) throws {
    switch self.peek.kind {

    // '*' test
    case .star:
      try self.parseStarArgument(into: &ir)

    // '**' test
    case .starStar:
      try self.parseStarStarArgument(into: &ir)

    // test [comp_for] | test '=' test |
    default:
      let nameToken = self.peek
      let test = try self.test(context: .load)

      if self.peek.kind == .equal {
        // "test '=' test" is really "keyword '=' test",
        // so the `nameToken` should be identifier token
        // otherwise it is an error (see big comment in CPython grammar)
        try self.parseKeywordArgument(name: nameToken, into: &ir)
      } else {
        try self.parsePositionalArgument(test: test,
                                         closingToken: closingToken,
                                         into: &ir)
      }
    }
  }

  /// '*' test
  private func parseStarArgument(into ir: inout CallIR) throws {
    if ir.hasStarStar {
      throw self.error(.callWithIterableArgumentAfterKeywordUnpacking)
    }

    assert(self.peek.kind == .star)
    let start = self.peek.start
    try self.advance() // *

    let test = try self.test(context: .load)
    let expr = self.builder.starredExpr(expression: test,
                                        context: .load,
                                        start: start,
                                        end: test.end)
    ir.args.append(expr)
  }

  /// '**' test
  private func parseStarStarArgument(into ir: inout CallIR) throws {
    assert(self.peek.kind == .starStar)
    let start = self.peek.start
    try self.advance() // **

    let test = try self.test(context: .load)
    let keyword = self.builder.keywordArgument(kind: .dictionaryUnpack,
                                               value: test,
                                               start: start,
                                               end: test.end)

    ir.keywords.append(keyword)
    ir.hasStarStar = true
  }

  /// test '=' test |
  private func parseKeywordArgument(name nameToken: Token,
                                    into ir: inout CallIR) throws {
    assert(self.peek.kind == .equal)

    switch nameToken.kind {
    case .identifier(let name):
      try self.advance() // =

      try self.checkForbiddenName(name, location: nameToken.start)

      if self.isDuplicate(name: name, in: ir.keywords) {
        let kind = ParserErrorKind.callWithDuplicateKeywordArgument(name)
        throw self.error(kind, location: nameToken.start)
      }

      let value = try self.test(context: .load)
      let keyword = self.builder.keywordArgument(kind: .named(name),
                                                 value: value,
                                                 start: nameToken.start,
                                                 end: value.end)
      ir.keywords.append(keyword)

    case .lambda:
      throw self.error(.callWithLambdaAssignment, location: nameToken.start)

    default:
      throw self.error(.callWithKeywordExpression, location: nameToken.start)
    }
  }

  private func isDuplicate(name: String, in keywords: [KeywordArgument]) -> Bool {
    for k in keywords {
      switch k.kind {
      case .named(let n) where n == name:
        return true
      case .named,
           .dictionaryUnpack:
        break
      }
    }

    return false
  }

  /// test [comp_for]
  private func parsePositionalArgument(test: Expression,
                                       closingToken: Token.Kind,
                                       into ir: inout CallIR) throws {
    // We do not allow generators as base class in class definition
    if ir.isBaseClass && self.isCompFor() {
      throw self.error(.baseClassWithGenerator, location: test.start)
    }

    if ir.hasStarStar {
      throw self.error(.callWithPositionalArgumentAfterKeywordUnpacking,
                       location: test.start)
    }

    guard ir.keywords.isEmpty else {
      throw self.error(.callWithPositionalArgumentAfterKeywordArgument,
                       location: test.start)
    }

    let closings = [closingToken, .comma]
    if let generators = try self.compForOrNop(closingTokens: closings) {
      // It is possible that 'generatorWithoutParensLocation' is already filled
      // if we have multiple generator arguments without parens.
      // We will use location of the 1st generator in error message.
      if ir.generatorWithoutParensLocation == nil {
        ir.generatorWithoutParensLocation = test.start
      }

      let end = generators.last?.end ?? test.end
      let expr = self.builder.generatorExpr(element: test,
                                            generators: generators,
                                            context: .load,
                                            start: test.start,
                                            end: end)

      ir.args.append(expr)
    } else {
      // Well, it is just an argument without generator part
      // (or generator in parens).
      ir.args.append(test)
    }
  }
}

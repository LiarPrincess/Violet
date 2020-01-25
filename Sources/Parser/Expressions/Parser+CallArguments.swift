import Lexer

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
  internal fileprivate(set) var keywords: [Keyword] = []

  /// Flag for preventing incorrect ordering of arguments
  /// (for example `f(**a, b)` is not valid).
  fileprivate var hasStarStar = false

  /// Is it base class definition (so we don't allow generators)?
  /// Just so we don't have to pass it as an arg to every method.
  fileprivate let isBaseClass: Bool

  fileprivate init(isBaseClass: Bool) {
    self.isBaseClass = isBaseClass
  }
}

extension Parser {

  // MARK: - Call

  /// `arglist: argument (',' argument)*  [',']`
  internal func argList(closingToken: TokenKind,
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
  private func argument(into ir: inout CallIR, closingToken: TokenKind) throws {
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
      let test = try self.test()

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

    let test = try self.test()
    let expr = self.builder.starredExpr(expression: test, start: start, end: test.end)
    ir.args.append(expr)
  }

  /// '**' test
  private func parseStarStarArgument(into ir: inout CallIR) throws {
    assert(self.peek.kind == .starStar)
    let start = self.peek.start
    try self.advance() // **

    let test = try self.test()
    let keyword = self.builder.keyword(kind: .dictionaryUnpack,
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

      let value = try self.test()
      let keyword = self.builder.keyword(kind: .named(name),
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

  private func isDuplicate(name: String, in keywords: [Keyword]) -> Bool {
    for k in keywords {
      if case let KeywordKind.named(n) = k.kind, n == name {
        return true
      }
    }
    return false
  }

  /// test [comp_for]
  private func parsePositionalArgument(test: Expression,
                                       closingToken: TokenKind,
                                       into ir: inout CallIR) throws {

    if ir.isBaseClass && self.isCompFor() {
      throw self.error(.baseClassWithGenerator, location: test.start)
    }

    guard !ir.hasStarStar else {
      throw self.error(.callWithPositionalArgumentAfterKeywordUnpacking,
                       location: test.start)
    }

    guard ir.keywords.isEmpty else {
      throw self.error(.callWithPositionalArgumentAfterKeywordArgument,
                       location: test.start)
    }

    let closings = [closingToken, .comma]
    if let generators = try self.compForOrNop(closingTokens: closings) {
      assert(!generators.isEmpty)

      // TODO: throw parens when we have some args (+ flag in ir)
      // and another throw in while (and then remove warning)
      self.warn(.callWithGeneratorArgument)

      let end = generators.last?.end ?? test.end
      let expr = self.builder.generatorExpr(element: test,
                                            generators: generators,
                                            start: test.start,
                                            end: end)

      ir.args.append(expr)
    } else {
      ir.args.append(test)
    }
  }
}

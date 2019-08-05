import Lexer

// In CPython:
// Python -> ast.c
//  ast_for_atom(struct compiling *c, const node *n)
//  ast_for_expr(struct compiling *c, const node *n)

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable file_length

internal enum TestListCompResult {
  case single(Expression)
  case multiple([Expression])
  case listComprehension(elt: Expression, generators: [Comprehension])
}

extension Parser {

  /// `atom_expr: [AWAIT] atom trailer*`
  internal mutating func atomExpr() throws -> Expression {
    let start = self.peek.start

    var isAwait = false
    if self.peek.kind == .await {
      isAwait = true
      try self.advance() // await
    }

    var rightExpr = try self.atom()
    while let withTrailer = try self.trailerOrNop(for: rightExpr) {
      rightExpr = withTrailer
    }

    return isAwait ?
      Expression(.await(rightExpr), start: start, end: rightExpr.end):
    rightExpr
  }

  ///```
  /// atom:
  ///  - '(' [yield_expr|testlist_comp] ')'
  ///  - '[' [testlist_comp] ']'
  ///  - '{' [dictorsetmaker] '}'
  ///  - NAME | NUMBER | STRING+ | '...' | 'None' | 'True' | 'False'
  /// ```
  internal mutating func atom() throws -> Expression {
    let token = self.peek

    switch token.kind {
    case .leftParen:
      return try self.atomLeftParen()
    case .leftSqb:
      return try self.atomLeftSquareBracket()
    case .leftBrace:
      return try self.atomLeftBrace()

    case let .identifier(value):
      return try self.simpleAtom(.identifier(value), from: token)

    case let .int(value):
      return try self.simpleAtom(.int(value), from: token)
    case let .float(value):
      return try self.simpleAtom(.float(value), from: token)
    case let .imaginary(value):
      return try self.simpleAtom(.complex(real: 0.0, imag: value), from: token)

    case .string, .formatString:
      throw self.unimplemented("String+")

    case .ellipsis:
      return try self.simpleAtom(.ellipsis, from: token)
    case .none:
      return try self.simpleAtom(.none, from: token)
    case .true:
      return try self.simpleAtom(.true, from: token)
    case .false:
      return try self.simpleAtom(.false, from: token)
    case .bytes(let data):
      return try self.simpleAtom(.bytes(data), from: token)

    default:
      throw self.failUnexpectedToken(expected: .noIdea)
    }
  }

  private mutating func atomLeftParen() throws -> Expression {
    assert(self.peek.kind == .leftParen)

    let start = self.peek.start
    try self.advance() // (

    if self.peek.kind == .rightParen { // a = () -> empty tuple
      let end = self.peek.end
      try self.advance() // )
      return self.expression(.tuple([]), start: start, end: end)
    }

    if let yield = try self.yieldExprOrNop(closingToken: .rightParen) {
      try self.advance() // )
      return yield
    }

    let test = try self.testListComp(closingToken: .rightParen)

    assert(self.peek.kind == .rightParen)
    let end = self.peek.end
    try self.advance() // )

    switch test {
    case let .single(e):
      return e
    case let .multiple(es):
      return self.expression(.tuple(es), start: start, end: end)
    case let .listComprehension(elt: elt, generators: gen):
      let kind = ExpressionKind.generatorExp(elt: elt, generators: gen)
      return self.expression(kind, start: start, end: end)
    }
  }

  private mutating func atomLeftSquareBracket() throws -> Expression {
    assert(self.peek.kind == .leftSqb)

    let start = self.peek.start
    try self.advance() // [

    if self.peek.kind == .rightSqb { // a = [] -> empty list
      let end = self.peek.end
      try self.advance() // ]

      return self.expression(.list([]), start: start, end: end)
    }

    let test = try self.testListComp(closingToken: .rightSqb)

    let end = self.peek.end
    try self.consumeOrThrow(.rightSqb)

    switch test {
    case let .single(e):
      return self.expression(.list([e]), start: start, end: end)
    case let .multiple(es):
      return self.expression(.list(es), start: start, end: end)
    case let .listComprehension(elt: elt, generators: gen):
      let kind = ExpressionKind.listComprehension(elt: elt, generators: gen)
      return self.expression(kind, start: start, end: end)
    }
  }

  // TODO: Move to Parser+AtomCollections.swift
  /// ```c
  /// dictorsetmaker:
  /// (
  ///   (
  ///     (test ':' test | '**' expr)
  ///     (comp_for | (',' (test ':' test | '**' expr))* [','])
  ///   )
  ///   |
  ///   (
  ///     (test | star_expr)
  ///     (comp_for | (',' (test | star_expr))* [','])
  ///   )
  /// )
  /// ```
  private mutating func atomLeftBrace() throws -> Expression {
    assert(self.peek.kind == .leftBrace)

    let start = self.peek.start
    try self.advance() // {

    if self.peek.kind == .rightBrace { // a = { } -> empty dict
      let end = self.peek.end
      try self.advance() // }

      return self.expression(.dictionary([]), start: start, end: end)
    }

    switch self.peek.kind {
    case .starStar:
      try self.advance() // **

      // TODO: How to represent this?
      let expr = try self.expr()
      throw self.unimplemented("{**}")

    default:
      if let expr = try self.starExprOrNop() {
        return try self.setDisplay(first: expr,
                                   start: start,
                                   closingToken: .rightBrace)
      }

      let first = try self.test()

      // set with single element
      if self.peek.kind == .rightBrace {
        let end = self.peek.end
        try self.advance() // }

        let kind = ExpressionKind.set([first])
        return self.expression(kind, start: start, end: end)
      }

      // set comprehension
      if let generators = try self.compForOrNop(closingTokens: [.rightBrace]) {
        let end = self.peek.end
        try self.consumeOrThrow(.rightBrace)

        let kind = ExpressionKind.setComprehension(elt: first, generators: generators)
        return self.expression(kind, start: start, end: end)
      }

      // set with multiple elements
      if self.peek.kind == .comma {
        return try self.setDisplay(first: first,
                                   start: start,
                                   closingToken: .rightBrace)
      }

      // dictionary
      throw self.unimplemented("test:xxx")
    }
  }

  /// `(comp_for | (',' (test | star_expr))* [','])`
  private mutating func setDisplay(first: Expression,
                                   start: SourceLocation,
                                   closingToken: TokenKind) throws -> Expression {

    var elements = [Expression]()
    elements.append(first)

    while self.peek.kind == .comma && self.peekNext.kind != closingToken {
      try self.advance() // ,

      let test = try self.testOrStarExpr()
      elements.append(test)
    }

    // optional trailing comma
    if self.peek.kind == .comma {
      try self.advance() // ,
    }

    let end = self.peek.end
    try self.consumeOrThrow(closingToken)

    return self.expression(.set(elements), start: start, end: end)
  }

  private mutating func simpleAtom(_ kind: ExpressionKind,
                                   from token: Token) throws -> Expression {
    try self.advance()
    return self.expression(kind, start: token.start, end: token.end)
  }

  // MARK: - Test list comprehension

  /// ```c
  /// testlist_comp:
  ///   (test|star_expr) ( comp_for
  ///                    | (',' (test|star_expr))* [','])
  /// ```
  internal mutating func testListComp(closingToken: TokenKind)
    throws -> TestListCompResult {

      let first = try self.testOrStarExpr()

      if let generators = try self.compForOrNop(closingTokens: [closingToken]) {
        return .listComprehension(elt: first, generators: generators)
      }

      var elements = [Expression]()
      elements.append(first)

      // (',' (test|star_expr))* [',']
      while self.peek.kind == .comma && self.peekNext.kind != closingToken {
        try self.advance() // ,

        let test = try self.testOrStarExpr()
        elements.append(test)
      }

      let hasTrailingComma = self.peek.kind == .comma
      if hasTrailingComma {
        try self.advance() // ,
      }

      // if we have coma then it is a tuple! (even if it has only 1 element!)
      if elements.count == 1 && !hasTrailingComma {
        return .single(first)
      }

      return .multiple(elements)
  }

  private mutating func testOrStarExpr() throws -> Expression {
    if let expr = try self.starExprOrNop() {
      return expr
    }
    return try self.test()
  }

  // MARK: - Yield

  /// ```c
  /// yield_expr: 'yield' [yield_arg]
  /// yield_arg: 'from' test | testlist
  /// ```
  ///
  /// 'Or nop' means that we terminate (without changing current parser state)
  /// if we can't parse according to this rule.
  internal mutating func yieldExprOrNop(closingToken: TokenKind) throws -> Expression? {
    guard  self.peek.kind == .yield else {
      return nil
    }

    let yieldToken = self.peek
    try self.advance() // yield

    switch self.peek.kind {
    case closingToken:
      let kind = ExpressionKind.yield(nil)
      return self.expression(kind, start: yieldToken.start, end: yieldToken.end)

    case .from:
      try self.advance() // yield from

      let test = try self.test()
      let kind = ExpressionKind.yieldFrom(test)
      return self.expression(kind, start: yieldToken.start, end: test.end)

    default:
      let list = try self.testList(closingToken: closingToken)
      let kind = ExpressionKind.yield(list)
      return self.expression(kind, start: yieldToken.start, end: list.end)
    }
  }
}

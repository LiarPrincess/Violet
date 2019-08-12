import Lexer

// In CPython:
// Python -> ast.c
//  ast_for_atom(struct compiling *c, const node *n)

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
    // swiftlint:disable:previous function_body_length cyclomatic_complexity

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
      return try self.strPlus()
    case .bytes:
      return try self.bytesPlus()

    case .ellipsis:
      return try self.simpleAtom(.ellipsis, from: token)
    case .none:
      return try self.simpleAtom(.none, from: token)
    case .true:
      return try self.simpleAtom(.true, from: token)
    case .false:
      return try self.simpleAtom(.false, from: token)

    default:
      throw self.unexpectedToken(expected: [.expression])
    }
  }

  private mutating func simpleAtom(_ kind: ExpressionKind,
                                   from token: Token) throws -> Expression {
    try self.advance()
    return self.expression(kind, start: token.start, end: token.end)
  }

  // MARK: - Test list comprehension

  internal enum TestListCompResult {
    case single(Expression)
    case multiple([Expression])
    case listComprehension(elt: Expression, generators: [Comprehension])
  }

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

  /// Star expression if possible else test.
  internal mutating func testOrStarExpr() throws -> Expression {
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
  internal func isYieldExpr() -> Bool {
    return self.peek.kind == .yield
  }

  /// ```c
  /// yield_expr: 'yield' [yield_arg]
  /// yield_arg: 'from' test | testlist
  /// ```
  ///
  /// 'Or nop' means that we terminate (without changing current parser state)
  /// if we can't parse according to this rule.
  internal mutating func yieldExprOrNop(closingTokens: [TokenKind])
    throws -> Expression? {

    return self.isYieldExpr() ?
      try self.yieldExpr(closingTokens: closingTokens) :
      nil
  }

  /// ```c
  /// yield_expr: 'yield' [yield_arg]
  /// yield_arg: 'from' test | testlist
  /// ```
  internal mutating func yieldExpr(closingTokens: [TokenKind])
    throws -> Expression {

      let yieldToken = self.peek
      try self.advance() // yield

      switch self.peek.kind {
      case let token where closingTokens.contains(token):
        let kind = ExpressionKind.yield(nil)
        return self.expression(kind, start: yieldToken.start, end: yieldToken.end)

      case .from:
        try self.advance() // yield from

        let test = try self.test()
        let kind = ExpressionKind.yieldFrom(test)
        return self.expression(kind, start: yieldToken.start, end: test.end)

      default:
        let testList = try self.testList(closingTokens: closingTokens)
        let target = self.yieldTarget(testList)
        let kind = ExpressionKind.yield(target)
        return self.expression(kind, start: yieldToken.start, end: target.end)
      }
  }

  private func yieldTarget(_ result: TestListResult) -> Expression {
    switch result {
    case let .single(e):
      return e
    case let .tuple(es, end):
      let start = es.first.start
      return self.expression(.tuple(Array(es)), start: start, end: end)
    }
  }
}

import Core
import Lexer

extension Parser {

  // MARK: - Expr list

  internal enum ExprListResult {
    case single(Expression)
    case tuple(NonEmptyArray<Expression>, end: SourceLocation)

    internal func toExpression(using builder: inout ASTBuilder,
                               start: SourceLocation) -> Expression {
      switch self {
      case let .single(e):
        return e
      case let .tuple(es, end):
        return builder.tupleExpr(elements: Array(es), start: start, end: end)
      }
    }
  }

  /// `exprlist: (expr|star_expr) (',' (expr|star_expr))* [',']`
  internal func exprList(closingTokens: [TokenKind]) throws -> ExprListResult {
    let first = try self.starExprOrNop() ?? self.expr()
    var end = first.end

    var additionalElements = [Expression]()
    while self.peek.kind == .comma && !closingTokens.contains(self.peekNext.kind) {
      try self.advance() // ,

      let test = try self.starExprOrNop() ?? self.expr()
      additionalElements.append(test)
      end = test.end
    }

    let hasTrailingComma = self.peek.kind == .comma
    if hasTrailingComma {
      end = self.peek.end
      try self.advance() // ,
    }

    // if we have coma then it is a tuple! (even if it has only 1 element!)
    if additionalElements.isEmpty && !hasTrailingComma {
      return .single(first)
    }

    let array = NonEmptyArray<Expression>(first: first, rest: additionalElements)
    return .tuple(array, end: end)
  }

  // MARK: - Test list

  internal enum TestListResult {
    case single(Expression)
    case tuple(NonEmptyArray<Expression>, end: SourceLocation)

    internal func toExpression(using builder: inout ASTBuilder,
                               start: SourceLocation) -> Expression {
      switch self {
      case let .single(e):
        return e
      case let .tuple(es, end):
        return builder.tupleExpr(elements: Array(es), start: start, end: end)
      }
    }
  }

  /// `testlist: test (',' test)* [',']`
  internal func testList(closingTokens: [TokenKind]) throws -> TestListResult {
    let first = try self.test()
    var end = first.end

    var additionalElements = [Expression]()
    while self.peek.kind == .comma && !closingTokens.contains(self.peekNext.kind) {
      try self.advance() // ,

      let test = try self.test()
      additionalElements.append(test)
      end = test.end
    }

    let hasTrailingComma = self.peek.kind == .comma
    if hasTrailingComma {
      end = self.peek.end
      try self.advance() // ,
    }

    if additionalElements.isEmpty && !hasTrailingComma {
      return .single(first)
    }

    let array = NonEmptyArray<Expression>(first: first, rest: additionalElements)
    return .tuple(array, end: end)
  }

  // MARK: - Test list comprehension

  internal enum TestListCompResult {
    case single(Expression)
    case multiple([Expression])
    case listComprehension(elt: Expression, generators: NonEmptyArray<Comprehension>)
  }

  /// ```c
  /// testlist_comp:
  ///   (test|star_expr) ( comp_for
  ///                    | (',' (test|star_expr))* [','])
  /// ```
  internal func testListComp(closingToken: TokenKind) throws -> TestListCompResult {
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

  // MARK: - Test list star expr

  internal enum TestListStarExprResult {
    case single(Expression)
    case tuple(NonEmptyArray<Expression>, end: SourceLocation)

    internal func toExpression(using builder: inout ASTBuilder,
                               start: SourceLocation) -> Expression {
      switch self {
      case let .single(e):
        return e
      case let .tuple(es, end):
        return builder.tupleExpr(elements: Array(es), start: start, end: end)
      }
    }
  }

  /// `testlist_star_expr: (test|star_expr) (',' (test|star_expr))* [',']`
  internal func testListStarExpr(closingTokens: [TokenKind]) throws -> TestListStarExprResult {
    let first = try self.testOrStarExpr()
    var end = first.end

    var additionalElements = [Expression]()
    while self.peek.kind == .comma && !closingTokens.contains(self.peekNext.kind) {
      try self.advance() // ,

      let element = try self.testOrStarExpr()
      additionalElements.append(element)
      end = element.end
    }

    let hasTrailingComma = self.peek.kind == .comma
    if hasTrailingComma {
      end = self.peek.end
      try self.advance() // ,
    }

    if additionalElements.isEmpty && !hasTrailingComma {
      return .single(first)
    }

    let array = NonEmptyArray(first: first, rest: additionalElements)
    return .tuple(array, end: end)
  }
}

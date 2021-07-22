import VioletCore
import VioletLexer

// MARK: - Expr list

internal struct ExprListResult {
  internal let context: ExpressionContext
  internal let kind: Kind

  internal enum Kind {
    case single(Expression)
    case tuple(NonEmptyArray<Expression>, end: SourceLocation)
  }

  internal func toExpression(using builder: inout ASTBuilder,
                             start: SourceLocation) -> Expression {
    switch self.kind {
    case let .single(e):
      return e
    case let .tuple(es, end):
      return builder.tupleExpr(elements: Array(es),
                               context: self.context,
                               start: start,
                               end: end)
    }
  }
}

extension Parser {

  /// `exprlist: (expr|star_expr) (',' (expr|star_expr))* [',']`
  internal func exprList(context: ExpressionContext,
                         closingTokens: [Token.Kind]) throws -> ExprListResult {
    let first = try self.starExprOrNop(context: context) ?? self.expr(context: context)
    var end = first.end

    var additionalElements = [Expression]()
    while self.peek.kind == .comma && !closingTokens.contains(self.peekNext.kind) {
      try self.advance() // ,

      let test = try self.starExprOrNop(context: context) ?? self.expr(context: context)
      additionalElements.append(test)
      end = test.end
    }

    let hasTrailingComma = self.peek.kind == .comma
    if hasTrailingComma {
      end = self.peek.end
      try self.advance() // ,
    }

    // if we have comma then it is a tuple! (even if it has only 1 element!)
    if additionalElements.isEmpty && !hasTrailingComma {
      return ExprListResult(context: context, kind: .single(first))
    }

    let array = NonEmptyArray<Expression>(first: first, rest: additionalElements)
    return ExprListResult(context: context, kind: .tuple(array, end: end))
  }
}

// MARK: - Test list

internal struct TestListResult {
  internal let context: ExpressionContext
  internal let kind: Kind

  internal enum Kind {
    case single(Expression)
    case tuple(NonEmptyArray<Expression>, end: SourceLocation)
  }

  internal func toExpression(using builder: inout ASTBuilder,
                             start: SourceLocation) -> Expression {
    switch self.kind {
    case let .single(e):
      return e
    case let .tuple(es, end):
      return builder.tupleExpr(elements: Array(es),
                               context: self.context,
                               start: start,
                               end: end)
    }
  }
}

extension Parser {

  /// `testlist: test (',' test)* [',']`
  internal func testList(context: ExpressionContext,
                         closingTokens: [Token.Kind]) throws -> TestListResult {
    let first = try self.test(context: context)
    var end = first.end

    var additionalElements = [Expression]()
    while self.peek.kind == .comma && !closingTokens.contains(self.peekNext.kind) {
      try self.advance() // ,

      let test = try self.test(context: context)
      additionalElements.append(test)
      end = test.end
    }

    let hasTrailingComma = self.peek.kind == .comma
    if hasTrailingComma {
      end = self.peek.end
      try self.advance() // ,
    }

    if additionalElements.isEmpty && !hasTrailingComma {
      return TestListResult(context: context, kind: .single(first))
    }

    let array = NonEmptyArray<Expression>(first: first, rest: additionalElements)
    return TestListResult(context: context, kind: .tuple(array, end: end))
  }
}

// MARK: - Test list comprehension

internal enum TestListCompResult {
  case single(Expression)
  case multiple([Expression])
  case listComprehension(elt: Expression, generators: NonEmptyArray<Comprehension>)
}

extension Parser {

  /// ```c
  /// testlist_comp:
  ///   (test|star_expr) ( comp_for
  ///                    | (',' (test|star_expr))* [','])
  /// ```
  internal func testListComp(context: ExpressionContext,
                             closingToken: Token.Kind) throws -> TestListCompResult {
    let first = try self.testOrStarExpr(context: context)

    if let generators = try self.compForOrNop(closingTokens: [closingToken]) {
      return .listComprehension(elt: first, generators: generators)
    }

    var elements = [Expression]()
    elements.append(first)

    // (',' (test|star_expr))* [',']
    while self.peek.kind == .comma && self.peekNext.kind != closingToken {
      try self.advance() // ,

      let test = try self.testOrStarExpr(context: context)
      elements.append(test)
    }

    let hasTrailingComma = self.peek.kind == .comma
    if hasTrailingComma {
      try self.advance() // ,
    }

    // if we have comma then it is a tuple! (even if it has only 1 element!)
    if elements.count == 1 && !hasTrailingComma {
      return .single(first)
    }

    return .multiple(elements)
  }
}

// MARK: - Test list star expr

internal struct TestListStarExprResult {
  internal let context: ExpressionContext
  internal let kind: Kind

  internal enum Kind {
    case single(Expression)
    case tuple(NonEmptyArray<Expression>, end: SourceLocation)
  }

  internal func toExpression(using builder: inout ASTBuilder,
                             start: SourceLocation) -> Expression {
    switch self.kind {
    case let .single(e):
      return e
    case let .tuple(es, end):
      return builder.tupleExpr(elements: Array(es),
                               context: self.context,
                               start: start,
                               end: end)
    }
  }
}

extension Parser {

  /// `testlist_star_expr: (test|star_expr) (',' (test|star_expr))* [',']`
  internal func testListStarExpr(
    context: ExpressionContext,
    closingTokens: [Token.Kind]
  ) throws -> TestListStarExprResult {

    let first = try self.testOrStarExpr(context: context)
    var end = first.end

    var additionalElements = [Expression]()
    while self.peek.kind == .comma && !closingTokens.contains(self.peekNext.kind) {
      try self.advance() // ,

      let element = try self.testOrStarExpr(context: context)
      additionalElements.append(element)
      end = element.end
    }

    let hasTrailingComma = self.peek.kind == .comma
    if hasTrailingComma {
      end = self.peek.end
      try self.advance() // ,
    }

    if additionalElements.isEmpty && !hasTrailingComma {
      return TestListStarExprResult(context: context, kind: .single(first))
    }

    let array = NonEmptyArray(first: first, rest: additionalElements)
    return TestListStarExprResult(context: context, kind: .tuple(array, end: end))
  }
}

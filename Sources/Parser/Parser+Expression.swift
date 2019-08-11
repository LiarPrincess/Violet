import Lexer

// swiftlint:disable file_length

extension Parser {

  internal mutating func expression() throws -> Expression {
    return try self.test()
  }

  // MARK: - Test

  /// `test: or_test ['if' or_test 'else' test] | lambdef`
  internal mutating func test() throws -> Expression {
    // we will start from lambdef, becuse it is simpler

    if let lambda = try self.lambDefOrNop() {
      return lambda
    }

    let left = try self.orTest()

    // is this a simple form? if so then just return
    guard self.peek.kind == .if else {
      return left
    }

    try self.advance() // if
    let test = try self.orTest()

    guard self.peek.kind == .else else {
      throw self.failUnexpectedToken(expected: .else)
    }

    try self.advance() // else
    let right = try self.test()

    let kind = ExpressionKind.ifExpression(test: test, body: left, orElse: right)
    return Expression(kind, start: left.start, end: right.end)
  }

  /// `test_nocond: or_test | lambdef_nocond`
  internal mutating func testNoCond() throws -> Expression {
    // we will start from lambdef_nocond, becuse it is simpler

    if let lambda = try self.lambDefNoCondOrNop() {
      return lambda
    }

    return try self.orTest()
  }

  // MARK: - Lambda

  /// `lambdef: 'lambda' [varargslist] ':' test`
  ///
  /// 'Or nop' means that we terminate (without changing current parser state)
  /// if we can't parse according to this rule.
  internal mutating func lambDefOrNop() throws -> Expression? {
    guard self.peek.kind == .lambda else {
      return nil
    }

    let start = self.peek.start
    try self.advance() // lambda

    let args = try self.varArgsList(closingToken: .colon)

    guard try self.consumeIf(.colon) else {
      throw self.failUnexpectedToken(expected: .colon)
    }

    let body = try self.test()
    let kind = ExpressionKind.lambda(args: args, body: body)
    return Expression(kind, start: start, end: body.end)
  }

  /// `lambdef_nocond: 'lambda' [varargslist] ':' test_nocond`
  ///
  /// 'Or nop' means that we terminate (without changing current parser state)
  /// if we can't parse according to this rule.
  internal mutating func lambDefNoCondOrNop() throws -> Expression? {
    guard self.peek.kind == .lambda else {
      return nil
    }

    let start = self.peek.start
    try self.advance() // lambda

    let args = try self.varArgsList(closingToken: .colon)

    guard try self.consumeIf(.colon) else {
      throw self.failUnexpectedToken(expected: .colon)
    }

    let body = try self.testNoCond()
    let kind = ExpressionKind.lambda(args: args, body: body)
    return Expression(kind, start: start, end: body.end)
  }

  // MARK: - Or test

  /// `or_test: and_test ('or' and_test)*`
  internal mutating func orTest() throws -> Expression {
    var left = try self.andTest()

    while self.peek.kind == .or {
      try self.advance() // or

      let right = try self.andTest()
      let kind = ExpressionKind.boolOp(.or, left: left, right: right)
      left = self.expression(kind, start: left.start, end: right.end)
    }

    return left
  }

  // MARK: - And test

  /// `and_test: not_test ('and' not_test)*`
  internal mutating func andTest() throws -> Expression {
    var left = try self.notTest()

    while self.peek.kind == .and {
      try self.advance() // and

      let right = try self.notTest()
      let kind = ExpressionKind.boolOp(.and, left: left, right: right)
      left = self.expression(kind, start: left.start, end: right.end)
    }

    return left
  }

  // MARK: - Not test

  /// `not_test: 'not' not_test | comparison`
  internal mutating func notTest() throws -> Expression {
    let token = self.peek
    if token.kind == .not {
      try self.advance() // not

      let right = try self.notTest()
      let kind = ExpressionKind.unaryOp(.not, right: right)
      return self.expression(kind, start: token.start, end: right.end)
    }

    return try self.comparison()
  }

  // MARK: - Comparison

  /// `comp_op: '<'|'>'|'=='|'>='|'<='|'<>'|'!='|'in'|'not' 'in'|'is'|'is' 'not'`
  private static let comparisonOperators: [TokenKind:ComparisonOperator] = [
    .equalEqual: .equal,
    .notEqual:   .notEqual,
    // <> - pep401 is not implmented
    .less:      .less,
    .lessEqual: .lessEqual,
    .greater:      .greater,
    .greaterEqual: .greaterEqual,
    .in:  .in,
    .not: .notIn, // 'in' will be checked in code
    .is:  .is
    // is not - will be handled in code
  ]

  /// `comparison: expr (comp_op expr)*`
  internal mutating func comparison() throws -> Expression {
    let left = try self.expr()

    var elements = [ComparisonElement]()
    while var op = Parser.comparisonOperators[self.peek.kind] {
      let first = self.peek
      try self.advance() // op

      if first.kind == .not {
        if self.peek.kind != .in {
          throw self.failUnexpectedToken(expected: .in)
        }
        try self.advance() // in
      }

      if first.kind == .is && self.peek.kind == .not {
        op = .isNot
        try self.advance() // not
      }

      let right = try self.expr()
      let element = ComparisonElement(op: op, right: right)
      elements.append(element)
    }

    // If we have any element then return compare otherwise normal expr
    if let last = elements.last {
      let kind = ExpressionKind.compare(left: left, elements: elements)
      return self.expression(kind, start: left.start, end: last.right.end)
    }

    return left
  }

  // MARK: - Star expr

  /// `star_expr: '*' expr`
  ///
  /// 'Or nop' means that we terminate (without changing current parser state)
  /// if we can't parse according to this rule.
  internal mutating func starExprOrNop() throws -> Expression? {
    let token = self.peek
    switch token.kind {
    case .star:
      try self.advance() // *
      let expr = try self.expr()
      let kind = ExpressionKind.starred(expr)
      return self.expression(kind, start: token.start, end: expr.end)
    default:
      return nil
    }
  }

  // MARK: - Expr

  /// `expr: xor_expr ('|' xor_expr)*`
  internal mutating func expr() throws -> Expression {
    var left = try self.xorExpr()

    while self.peek.kind == .vbar {
      try self.advance() // op

      let right = try self.xorExpr()
      let kind = ExpressionKind.binaryOp(.bitOr, left: left, right: right)
      left = self.expression(kind, start: left.start, end: right.end)
    }

    return left
  }

  // MARK: - Xor expr

  /// `xor_expr: and_expr ('^' and_expr)*`
  internal mutating func xorExpr() throws -> Expression {
    var left = try self.andExpr()

    while self.peek.kind == .circumflex {
      try self.advance() // op

      let right = try self.andExpr()
      let kind = ExpressionKind.binaryOp(.bitXor, left: left, right: right)
      left = self.expression(kind, start: left.start, end: right.end)
    }

    return left
  }

  // MARK: - And expr

  /// `and_expr: shift_expr ('&' shift_expr)*`
  internal mutating func andExpr() throws -> Expression {
    var left = try self.shiftExpr()

    while self.peek.kind == .amper {
      try self.advance() // op

      let right = try self.shiftExpr()
      let kind = ExpressionKind.binaryOp(.bitAnd, left: left, right: right)
      left = self.expression(kind, start: left.start, end: right.end)
    }

    return left
  }

  // MARK: - Shift expr

  private static let shiftExprOperators: [TokenKind:BinaryOperator] = [
    .leftShift: .leftShift,
    .rightShift: .rightShift
  ]

  /// `shift_expr: arith_expr (('<<'|'>>') arith_expr)*`
  internal mutating func shiftExpr() throws -> Expression {
    var left = try self.arithExpr()

    while let op = Parser.shiftExprOperators[self.peek.kind] {
      try self.advance() // op

      let right = try self.term()
      let kind = ExpressionKind.binaryOp(op, left: left, right: right)
      left = self.expression(kind, start: left.start, end: right.end)
    }

    return left
  }

  // MARK: - Arith expr

  private static let arithExprOperators: [TokenKind:BinaryOperator] = [
    .plus: .add,
    .minus: .sub
  ]

  /// `arith_expr: term (('+'|'-') term)*`
  internal mutating func arithExpr() throws -> Expression {
    var left = try self.term()

    while let op = Parser.arithExprOperators[self.peek.kind] {
      try self.advance() // op

      let right = try self.term()
      let kind = ExpressionKind.binaryOp(op, left: left, right: right)
      left = self.expression(kind, start: left.start, end: right.end)
    }

    return left
  }

  // MARK: - Term

  private static let termOperators: [TokenKind:BinaryOperator] = [
    .star: .mul,
    .at: .matMul,
    .slash: .div,
    .percent: .modulo,
    .slashSlash: .floorDiv
  ]

  /// `term: factor (('*'|'@'|'/'|'%'|'//') factor)*`
  internal mutating func term() throws -> Expression {
    var left = try self.factor()

    while let op = Parser.termOperators[self.peek.kind] {
      try self.advance() // op

      let right = try self.factor()
      let kind = ExpressionKind.binaryOp(op, left: left, right: right)
      left = self.expression(kind, start: left.start, end: right.end)
    }

    return left
  }

  // MARK: - Factor

  /// `factor: ('+'|'-'|'~') factor | power`
  internal mutating func factor() throws -> Expression {
    let token = self.peek

    switch self.peek.kind {
    case .plus:
      try self.advance() // +
      let factor = try self.factor()
      let kind = ExpressionKind.unaryOp(.plus, right: factor)
      return self.expression(kind, start: token.start, end: factor.end)

    case .minus:
      try self.advance() // -
      let factor = try self.factor()
      let kind = ExpressionKind.unaryOp(.minus, right: factor)
      return self.expression(kind, start: token.start, end: factor.end)

    case .tilde:
      try self.advance() // ~
      let factor = try self.factor()
      let kind = ExpressionKind.unaryOp(.invert, right: factor)
      return self.expression(kind, start: token.start, end: factor.end)

    default:
      return try self.power()
    }
  }

  // MARK: - Power

  /// `power: atom_expr ['**' factor]`
  internal mutating func power() throws -> Expression {
    let atomExpr = try self.atomExpr()

    if self.peek.kind == .starStar {
      try self.advance() // **

      let factor = try self.factor()
      let kind = ExpressionKind.binaryOp(.pow, left: atomExpr, right: factor)
      return self.expression(kind, start: atomExpr.start, end: factor.end)
    }

    return atomExpr
  }

  // MARK: - Expr list

  internal enum ExprListResult {
    case single(Expression)
    case tuple(NonEmptyArray<Expression>, end: SourceLocation)
  }

  /// `exprlist: (expr|star_expr) (',' (expr|star_expr))* [',']`
  internal mutating func exprList(closingTokens: [TokenKind])
    throws -> ExprListResult {

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

    internal func toExpression(start: SourceLocation) -> Expression {
      switch self {
      case let .single(e):
        return e
      case let .tuple(es, end):
        return Expression(.tuple(Array(es)), start: start, end: end)
      }
    }
  }

  /// `testlist: test (',' test)* [',']`
  internal mutating func testList(closingTokens: [TokenKind])
    throws -> TestListResult {

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
}

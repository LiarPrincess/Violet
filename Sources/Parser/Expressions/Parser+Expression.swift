import VioletCore
import VioletLexer

extension Parser {

  // MARK: - Test

  /// `test: or_test ['if' or_test 'else' test] | lambdef`
  internal func test(context: ExpressionContext) throws -> Expression {
    // we will start from lambdef, because it is simpler

    if let lambda = try self.lambDefOrNop(context: context) {
      return lambda
    }

    let left = try self.orTest(context: context)

    // is this a simple form? if so then just return
    guard self.peek.kind == .if else {
      return left
    }

    try self.advance() // if
    let test = try self.orTest(context: context)
    try self.consumeOrThrow(.else)
    let right = try self.test(context: context)

    return self.builder.ifExpr(test: test,
                               body: left,
                               orElse: right,
                               context: context,
                               start: left.start,
                               end: right.end)
  }

  /// `test_nocond: or_test | lambdef_nocond`
  internal func testNoCond(context: ExpressionContext) throws -> Expression {
    // We will start from lambdef_nocond, because it is simpler

    if let lambda = try self.lambDefNoCondOrNop(context: context) {
      return lambda
    }

    return try self.orTest(context: context)
  }

  // MARK: - Lambda

  /// `lambdef: 'lambda' [varargslist] ':' test`
  ///
  /// 'Or nop' means that we terminate (without changing current parser state)
  /// if we can't parse according to this rule.
  internal func lambDefOrNop(context: ExpressionContext) throws -> Expression? {
    guard self.peek.kind == .lambda else {
      return nil
    }

    let start = self.peek.start
    try self.advance() // lambda

    let args = try self.varArgsList(closingToken: .colon)
    try self.consumeOrThrow(.colon)

    let body = try self.test(context: context)
    return self.builder.lambdaExpr(args: args,
                                   body: body,
                                   context: context,
                                   start: start,
                                   end: body.end)
  }

  /// `lambdef_nocond: 'lambda' [varargslist] ':' test_nocond`
  ///
  /// 'Or nop' means that we terminate (without changing current parser state)
  /// if we can't parse according to this rule.
  internal func lambDefNoCondOrNop(context: ExpressionContext) throws -> Expression? {
    guard self.peek.kind == .lambda else {
      return nil
    }

    let start = self.peek.start
    try self.advance() // lambda

    let args = try self.varArgsList(closingToken: .colon)
    try self.consumeOrThrow(.colon)

    let body = try self.testNoCond(context: context)
    return self.builder.lambdaExpr(args: args,
                                   body: body,
                                   context: context,
                                   start: start,
                                   end: body.end)
  }

  // MARK: - Or test

  /// `or_test: and_test ('or' and_test)*`
  internal func orTest(context: ExpressionContext) throws -> Expression {
    var left = try self.andTest(context: context)

    while self.peek.kind == .or {
      try self.advance() // or

      let right = try self.andTest(context: context)
      left = self.builder.boolOpExpr(op: .or,
                                     left: left,
                                     right: right,
                                     context: context,
                                     start: left.start,
                                     end: right.end)
    }

    return left
  }

  // MARK: - And test

  /// `and_test: not_test ('and' not_test)*`
  internal func andTest(context: ExpressionContext) throws -> Expression {
    var left = try self.notTest(context: context)

    while self.peek.kind == .and {
      try self.advance() // and

      let right = try self.notTest(context: context)
      left = self.builder.boolOpExpr(op: .and,
                                     left: left,
                                     right: right,
                                     context: context,
                                     start: left.start,
                                     end: right.end)
    }

    return left
  }

  // MARK: - Not test

  /// `not_test: 'not' not_test | comparison`
  internal func notTest(context: ExpressionContext) throws -> Expression {
    let token = self.peek
    if token.kind == .not {
      try self.advance() // not

      let right = try self.notTest(context: context)
      return self.builder.unaryOpExpr(op: .not,
                                      right: right,
                                      context: context,
                                      start: token.start,
                                      end: right.end)
    }

    return try self.comparison(context: context)
  }

  // MARK: - Comparison

  /// `comp_op: '<'|'>'|'=='|'>='|'<='|'<>'|'!='|'in'|'not' 'in'|'is'|'is' 'not'`
  private static let comparisonOperators: [Token.Kind: CompareExpr.Operator] = [
    .equalEqual: .equal,
    .notEqual: .notEqual,
    // <> - pep401 is not implemented
    .less: .less,
    .lessEqual: .lessEqual,
    .greater: .greater,
    .greaterEqual: .greaterEqual,
    .in: .in,
    .not: .notIn, // 'in' will be checked in code
    .is: .is
    // is not - will be handled in code
  ]

  /// `comparison: expr (comp_op expr)*`
  internal func comparison(context: ExpressionContext) throws -> Expression {
    let left = try self.expr(context: context)

    var elements = [CompareExpr.Element]()
    while var op = Parser.comparisonOperators[self.peek.kind] {
      let first = self.peek
      try self.advance() // op

      if first.kind == .not {
        try self.consumeOrThrow(.in)
      }

      if first.kind == .is && self.peek.kind == .not {
        op = .isNot
        try self.advance() // not
      }

      let right = try self.expr(context: context)
      let element = CompareExpr.Element(op: op, right: right)
      elements.append(element)
    }

    // If we have any element then return compare otherwise normal expr
    if let first = elements.first {
      let rest = elements.dropFirst()
      let comps = NonEmptyArray<CompareExpr.Element>(first: first, rest: rest)

      return self.builder.compareExpr(left: left,
                                      elements: comps,
                                      context: context,
                                      start: left.start,
                                      end: comps.last.right.end)
    }

    return left
  }

  // MARK: - Star expr

  /// `star_expr: '*' expr`
  ///
  /// 'Or nop' means that we terminate (without changing current parser state)
  /// if we can't parse according to this rule.
  internal func starExprOrNop(context: ExpressionContext) throws -> Expression? {
    let token = self.peek
    switch token.kind {
    case .star:
      try self.advance() // *
      let expr = try self.expr(context: context)
      return self.builder.starredExpr(expression: expr,
                                      context: context,
                                      start: token.start,
                                      end: expr.end)
    default:
      return nil
    }
  }

  // MARK: - Expr

  /// `expr: xor_expr ('|' xor_expr)*`
  internal func expr(context: ExpressionContext) throws -> Expression {
    var left = try self.xorExpr(context: context)

    while self.peek.kind == .vbar {
      try self.advance() // op

      let right = try self.xorExpr(context: context)
      left = self.builder.binaryOpExpr(op: .bitOr,
                                       left: left,
                                       right: right,
                                       context: context,
                                       start: left.start,
                                       end: right.end)
    }

    return left
  }

  // MARK: - Xor expr

  /// `xor_expr: and_expr ('^' and_expr)*`
  internal func xorExpr(context: ExpressionContext) throws -> Expression {
    var left = try self.andExpr(context: context)

    while self.peek.kind == .circumflex {
      try self.advance() // op

      let right = try self.andExpr(context: context)
      left = self.builder.binaryOpExpr(op: .bitXor,
                                       left: left,
                                       right: right,
                                       context: context,
                                       start: left.start,
                                       end: right.end)
    }

    return left
  }

  // MARK: - And expr

  /// `and_expr: shift_expr ('&' shift_expr)*`
  internal func andExpr(context: ExpressionContext) throws -> Expression {
    var left = try self.shiftExpr(context: context)

    while self.peek.kind == .amper {
      try self.advance() // op

      let right = try self.shiftExpr(context: context)
      left = self.builder.binaryOpExpr(op: .bitAnd,
                                       left: left,
                                       right: right,
                                       context: context,
                                       start: left.start,
                                       end: right.end)
    }

    return left
  }

  // MARK: - Shift expr

  private static let shiftExprOperators: [Token.Kind: BinaryOpExpr.Operator] = [
    .leftShift: .leftShift,
    .rightShift: .rightShift
  ]

  /// `shift_expr: arith_expr (('<<'|'>>') arith_expr)*`
  internal func shiftExpr(context: ExpressionContext) throws -> Expression {
    var left = try self.arithExpr(context: context)

    while let op = Parser.shiftExprOperators[self.peek.kind] {
      try self.advance() // op

      let right = try self.term(context: context)
      left = self.builder.binaryOpExpr(op: op,
                                       left: left,
                                       right: right,
                                       context: context,
                                       start: left.start,
                                       end: right.end)
    }

    return left
  }

  // MARK: - Arith expr

  private static let arithExprOperators: [Token.Kind: BinaryOpExpr.Operator] = [
    .plus: .add,
    .minus: .sub
  ]

  /// `arith_expr: term (('+'|'-') term)*`
  internal func arithExpr(context: ExpressionContext) throws -> Expression {
    var left = try self.term(context: context)

    while let op = Parser.arithExprOperators[self.peek.kind] {
      try self.advance() // op

      let right = try self.term(context: context)
      left = self.builder.binaryOpExpr(op: op,
                                       left: left,
                                       right: right,
                                       context: context,
                                       start: left.start,
                                       end: right.end)
    }

    return left
  }

  // MARK: - Term

  private static let termOperators: [Token.Kind: BinaryOpExpr.Operator] = [
    .star: .mul,
    .at: .matMul,
    .slash: .div,
    .percent: .modulo,
    .slashSlash: .floorDiv
  ]

  /// `term: factor (('*'|'@'|'/'|'%'|'//') factor)*`
  internal func term(context: ExpressionContext) throws -> Expression {
    var left = try self.factor(context: context)

    while let op = Parser.termOperators[self.peek.kind] {
      try self.advance() // op

      let right = try self.factor(context: context)
      left = self.builder.binaryOpExpr(op: op,
                                       left: left,
                                       right: right,
                                       context: context,
                                       start: left.start,
                                       end: right.end)
    }

    return left
  }

  // MARK: - Factor

  /// `factor: ('+'|'-'|'~') factor | power`
  internal func factor(context: ExpressionContext) throws -> Expression {
    let token = self.peek

    switch self.peek.kind {
    case .plus:
      try self.advance() // +
      let factor = try self.factor(context: context)
      return self.builder.unaryOpExpr(op: .plus,
                                      right: factor,
                                      context: context,
                                      start: token.start,
                                      end: factor.end)

    case .minus:
      try self.advance() // -
      let factor = try self.factor(context: context)
      return self.builder.unaryOpExpr(op: .minus,
                                      right: factor,
                                      context: context,
                                      start: token.start,
                                      end: factor.end)

    case .tilde:
      try self.advance() // ~
      let factor = try self.factor(context: context)
      return self.builder.unaryOpExpr(op: .invert,
                                      right: factor,
                                      context: context,
                                      start: token.start,
                                      end: factor.end)

    default:
      return try self.power(context: context)
    }
  }

  // MARK: - Power

  /// `power: atom_expr ['**' factor]`
  internal func power(context: ExpressionContext) throws -> Expression {
    let atomExpr = try self.atomExpr(context: context)

    if try self.consumeIf(.starStar) {
      let factor = try self.factor(context: context)
      return self.builder.binaryOpExpr(op: .pow,
                                       left: atomExpr,
                                       right: factor,
                                       context: context,
                                       start: atomExpr.start,
                                       end: factor.end)
    }

    return atomExpr
  }

  // MARK: - Test or star expr

  /// Star expression if possible else test.
  /// There is no rule for this, but it is commonly used.
  internal func testOrStarExpr(context: ExpressionContext) throws -> Expression {
    return try self.starExprOrNop(context: context) ?? self.test(context: context)
  }
}

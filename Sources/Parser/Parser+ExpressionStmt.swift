import Core
import Lexer

// In CPython:
// Python -> ast.c
//  ast_for_expr_stmt(struct compiling *c, const node *n)

// swiftlint:disable file_length

extension Parser {

  /// ```c
  /// expr_stmt: testlist_star_expr (
  ///   annassign
  ///   | augassign (yield_expr|testlist)
  ///   | ('=' (yield_expr|testlist_star_expr))*
  /// )
  /// annassign: ':' test ['=' test]
  /// testlist_star_expr: (test|star_expr) (',' (test|star_expr))* [',']
  /// augassign: ('+=' | '-=' | '*=' | '@=' | '/=' | '%=' | '&=' | '|=' | '^=' |
  /// '<<=' | '>>=' | '**=' | '//=')
  /// ```
  internal mutating func exprStmt(closingTokens: [TokenKind]) throws -> Statement {
    // FIRST(n) == '('
    let isFirstInParen = self.peek.kind == .leftParen

    let firstStart = self.peek.start
    let firstList = try self.testListStarExpr(closingTokens: closingTokens)
    let first = firstList.toExpression(start: firstStart)

    // Just an expr, without anything else (not included in grammar).
    // It does not even matter (unless it has an side-effect like exception...)
    if closingTokens.contains(self.peek.kind) {
      return self.statement(.expr(first), start: first.start, end: first.end)
    }
    // TODO: move ^ this to default?

    switch self.peek.kind {
    case .colon:
      return try self.parseAnnAssign(target: first,
                                     isTargetInParen: isFirstInParen)

    case let tokKind where Parser.augAssign[tokKind] != nil:
     return try self.parseAugAssign(target: first,
                                    closingTokens: closingTokens)

    case .equal:
      return try self.parseNormalAssign(firstTarget: first,
                                        closingTokens: closingTokens)

    default:
      throw self.unimplemented()
    }
  }

  // MARK: - Annotated assignment

  /// `expr_stmt: testlist_star_expr augassign (yield_expr|testlist)`
  private mutating func parseAnnAssign(
    target: Expression,
    isTargetInParen: Bool) throws -> Statement {

    try self.checkAnnAssignTarget(target)

    let isTargetIdentifier = self.isIdentifierExpr(target)
    let isSimple = isTargetIdentifier && !isTargetInParen

    assert(self.peek.kind == .colon)
    try self.advance() // :

    let annotation = try self.test()

    var value: Expression?
    if self.peek.kind == .equal {
      try self.advance()
      value  = try self.test()
    }

    let kind = StatementKind.annAssign(target: target,
                                       annotation: annotation,
                                       value: value,
                                       simple: isSimple)

    let start = target.start
    let end = value?.end ?? annotation.end
    return self.statement(kind, start: start, end: end)
  }

  private func checkAnnAssignTarget(_ target: Expression) throws {
    switch target.kind {

    case let .identifier(name):
      try self.checkForbiddenName(name)

    case let .attribute(_, name):
      try self.checkForbiddenName(name)

    case .subscript:
      break

    case .list:
      throw self.error(.illegalListInAnnAssignmentTarget)
    case .tuple:
      throw self.error(.illegalTupleInAnnAssignmentTarget)
    default:
      throw self.error(.illegalAnnAssignmentTarget)
    }
  }

  private func isIdentifierExpr(_ e: Expression) -> Bool {
    if case ExpressionKind.identifier = e.kind {
      return true
    }
    return false
  }

  // MARK: - Augumented assignment

  /// ```c
  /// augassign: ('+=' | '-=' | '*=' | '@=' | '/=' | '%=' | '&=' | '|=' | '^=' |
  ///             '<<=' | '>>=' | '**=' | '//=')
  /// ```
  private static let augAssign: [TokenKind:BinaryOperator] = [
    .plusEqual: .add, // +=
    .minusEqual: .sub, // -=
    .starEqual: .mul, // *=
    .atEqual: .matMul, // @=
    .slashEqual: .div, // /=
    .percentEqual: .modulo, // %=

    .amperEqual: .bitAnd, // &=
    .vbarEqual: .bitOr, // |=
    .circumflexEqual: .bitXor, // ^=

    .leftShiftEqual: .leftShift, // <<=
    .rightShiftEqual: .rightShift, // >>=
    .starStarEqual: .pow, // **=
    .slashSlashEqual: .floorDiv // //=
  ]

  /// expr_stmt: testlist_star_expr augassign (yield_expr|testlist)
  private mutating func parseAugAssign(
    target: Expression,
    closingTokens: [TokenKind]) throws -> Statement {

    try self.checkAugAssignTarget(target)

    let op = Parser.augAssign[self.peek.kind]
    assert(op != nil)
    try self.advance() // op

    let value = try self.parseAugAssignValue(closingTokens: closingTokens)

    // swiftlint:disable:next force_unwrapping
    let kind = StatementKind.augAssign(target: target, op: op!, value: value)
    return self.statement(kind, start: target.start, end: value.end)
  }

  private func checkAugAssignTarget(_ target: Expression) throws {
    switch target.kind {
    case .identifier,
         .attribute,
         .subscript:
      break
    default:
      throw self.error(.illegalAugAssignmentTarget)
    }
  }

  /// `yield_expr|testlist`
  private mutating func parseAugAssignValue(closingTokens: [TokenKind])
    throws -> Expression {

    if let e = try self.yieldExprOrNop(closingTokens: closingTokens) {
      return e
    }

    let listStart = self.peek.start
    let list = try self.testList(closingTokens: closingTokens)
    return list.toExpression(start: listStart)
  }

  // MARK: - Normal assignment

  /// `expr_stmt: testlist_star_expr ('=' (yield_expr|testlist_star_expr))*
  private mutating func parseNormalAssign(
    firstTarget: Expression,
    closingTokens: [TokenKind]) throws -> Statement {

    assert(self.peek.kind == .equal)

    var elements = [Expression]()
    var elementClosing = closingTokens
    elementClosing.append(.equal)

    while self.peek.kind == .equal {
      try self.advance() // =

      let testStart = self.peek.start
      let test = try self.testListStarExpr(closingTokens: elementClosing)
      elements.append(test.toExpression(start: testStart))
    }

    guard let value = elements.last else {
      throw self.unimplemented()
    }

    var targets = [firstTarget]
    targets.append(contentsOf: elements.dropLast())

    try self.checkNormalAssignTargets(targets)

    let kind = StatementKind.assign(targets: targets, value: value)
    return self.statement(kind, start: firstTarget.start, end: value.end)
  }

  private func isYieldExpr(_ e: Expression) -> Bool {
    if case ExpressionKind.yield = e.kind {
      return true
    }
    return false
  }

  private func checkNormalAssignTargets(_ targets: [Expression]) throws {
    for expr in targets {
      if self.isYieldExpr(expr) {
        throw self.unimplemented()
      }
    }
  }

  // MARK: - Test list star expression

  internal enum TestListStarExprResult {
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

  /// `testlist_star_expr: (test|star_expr) (',' (test|star_expr))* [',']`
  private mutating func testListStarExpr(closingTokens: [TokenKind])
    throws -> TestListStarExprResult {

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

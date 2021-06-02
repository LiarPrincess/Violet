import VioletCore
import VioletLexer

// In CPython:
// Python -> ast.c
//  ast_for_expr_stmt(struct compiling *c, const node *n)

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
  internal func exprStmt(closingTokens: [Token.Kind]) throws -> Statement {
    // FIRST(n) == '('
    let isFirstInParen = self.peek.kind == .leftParen

    var firstClosing = closingTokens
    firstClosing.append(.equal)

    let firstStart = self.peek.start
    let firstList = try self.testListStarExpr(context: .load,
                                              closingTokens: firstClosing)
    let first = firstList.toExpression(using: &self.builder, start: firstStart)

    switch self.peek.kind {
    case .colon:
      return try self.parseAnnAssign(target: first,
                                     isTargetInParen: isFirstInParen)

    case let tokKind where Parser.augAssign[tokKind] != nil:
     return try self.parseAugAssign(target: first,
                                    closingTokens: closingTokens)

    default:
      return try self.parseNormalAssign(firstTarget: first,
                                        closingTokens: closingTokens)
    }
  }

  // MARK: - Annotated assignment

  /// ```c
  /// expr_stmt: testlist_star_expr (
  ///   annassign
  ///   (...)
  /// )
  /// annassign: ':' test ['=' test]
  /// ```
  private func parseAnnAssign(target: Expression,
                              isTargetInParen: Bool) throws -> Statement {
    try self.checkAnnAssignTarget(target)
    SetStoreExpressionContext.run(expression: target)

    assert(self.peek.kind == .colon)
    try self.advance() // :

    let annotation = try self.test(context: .load)

    var value: Expression?
    if try self.consumeIf(.equal) {
      value = try self.test(context: .load)
    }

    let isSimple = target is IdentifierExpr && !isTargetInParen
    return self.builder.annAssignStmt(target: target,
                                      annotation: annotation,
                                      value: value,
                                      isSimple: isSimple,
                                      start: target.start,
                                      end: value?.end ?? annotation.end)
  }

  private func checkAnnAssignTarget(_ target: Expression) throws {
    let loc = target.start

    if let id = target as? IdentifierExpr {
      try self.checkForbiddenName(id.value, location: loc)
      return
    }

    if let attr = target as? AttributeExpr {
      try self.checkForbiddenName(attr.name, location: loc)
      return
    }

    if target is SubscriptExpr {
      return // Nothing to check
    }

    if target is ListExpr {
      throw self.error(.annAssignmentWithListTarget, location: loc)
    }

    if target is TupleExpr {
      throw self.error(.annAssignmentWithTupleTarget, location: loc)
    }

    throw self.error(.illegalAnnAssignmentTarget, location: loc)
  }

  // MARK: - Augmented assignment

  /// ```c
  /// augassign: ('+=' | '-=' | '*=' | '@=' | '/=' | '%=' | '&=' | '|=' | '^=' |
  ///             '<<=' | '>>=' | '**=' | '//=')
  /// ```
  private static let augAssign: [Token.Kind: BinaryOpExpr.Operator] = [
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
  private func parseAugAssign(target: Expression,
                              closingTokens: [Token.Kind]) throws -> Statement {
    try self.checkAugAssignTarget(target)
    SetStoreExpressionContext.run(expression: target)

    let op = Parser.augAssign[self.peek.kind]
    assert(op != nil)
    try self.advance() // op

    let value = try self.parseAugAssignValue(closingTokens: closingTokens)

    // swiftlint:disable force_unwrapping
    return self.builder.augAssignStmt(target: target,
                                      op: op!,
                                      value: value,
                                      start: target.start,
                                      end: value.end)
    // swiftlint:enable force_unwrapping
  }

  private func checkAugAssignTarget(_ target: Expression) throws {
    if target is IdentifierExpr || target is AttributeExpr || target is SubscriptExpr {
      return
    }

    throw self.error(.illegalAugAssignmentTarget, location: target.start)
  }

  /// `yield_expr|testlist`
  private func parseAugAssignValue(closingTokens: [Token.Kind]) throws -> Expression {
    if let e = try self.yieldExprOrNop(closingTokens: closingTokens) {
      return e
    }

    let listStart = self.peek.start
    let list = try self.testList(context: .load, closingTokens: closingTokens)
    return list.toExpression(using: &self.builder, start: listStart)
  }

  // MARK: - Normal assignment

  /// `expr_stmt: testlist_star_expr ('=' (yield_expr|testlist_star_expr))*
  private func parseNormalAssign(firstTarget: Expression,
                                 closingTokens: [Token.Kind]) throws -> Statement {
    // 'firstTarget' has '.load' context, we will change it later
    var elements = [Expression]()

    var elementClosing = closingTokens
    elementClosing.append(.equal)

    while self.peek.kind == .equal {
      try self.advance() // =

      if let yield = try self.yieldExprOrNop(closingTokens: elementClosing) {
        elements.append(yield)
      } else {
        let testStart = self.peek.start
        let test = try self.testListStarExpr(context: .load, closingTokens: elementClosing)
        elements.append(test.toExpression(using: &self.builder, start: testStart))
      }
    }

    guard let value = elements.last else {
      // Just an expr, without anything else. It does not even matter
      // (unless it has a side-effect, like exception…).
      return self.builder.exprStmt(expression: firstTarget,
                                   start: firstTarget.start,
                                   end: firstTarget.end)
    }

    let targets = NonEmptyArray(first: firstTarget, rest: elements.dropLast())
    try self.checkNormalAssignTargets(targets)

    SetStoreExpressionContext.run(expressions: targets)
    SetLoadExpressionContext.run(expression: value)

    return self.builder.assignStmt(targets: targets,
                                   value: value,
                                   start: firstTarget.start,
                                   end: value.end)
  }

  private func checkNormalAssignTargets(_ targets: NonEmptyArray<Expression>) throws {
    for expr in targets {
      // swiftlint:disable:next for_where
      if expr is YieldExpr {
        throw self.error(.assignmentToYield, location: expr.start)
      }
    }
  }
}

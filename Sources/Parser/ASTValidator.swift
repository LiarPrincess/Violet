import Foundation
import VioletCore
import VioletLexer

// swiftlint:disable file_length

// In CPython:
// Python -> ast.c

public final class ASTValidator {

  public init() {}

  public func validate(ast: AST) throws {
    let pass = ASTValidatorPass()
    try pass.visitAST(ast)
  }
}

internal final class ASTValidatorPass: ASTVisitor,
                                       StatementVisitor,
                                       ExpressionVisitorWithPayload {

  internal typealias ASTResult = Void
  internal typealias StatementResult = Void
  internal typealias ExpressionResult = Void
   /// Expected context.
  internal typealias ExpressionPayload = ExpressionContext

  // MARK: - AST

  internal func visitAST(_ node: AST) throws {
    try node.accept(self)
  }

  /// int PyAST_Validate(mod_ty mod)
  internal func visit(_ node: InteractiveAST) throws {
    try self.visitStatements(node.statements)
  }

  /// int PyAST_Validate(mod_ty mod)
  internal func visit(_ node: ModuleAST) throws {
    try self.visitStatements(node.statements)
  }

  /// int PyAST_Validate(mod_ty mod)
  internal func visit(_ node: ExpressionAST) throws {
    try self.visitExpression(node.expression, payload: .load)
  }

  // MARK: - Statement

  /// validate_stmt(stmt_ty stmt)
  internal func visitStatement(_ node: Statement) throws {
    try node.accept(self)
  }

  private func visitStatement(_ node: Statement?) throws {
    if let n = node {
      try self.visitStatement(n)
    }
  }

  private func visitStatements<S: Sequence>(_ nodes: S) throws
    where S.Element: Statement {

    for node in nodes {
      try self.visitStatement(node)
    }
  }

  internal func visit(_ node: FunctionDefStmt) throws {
    try self.visitStatements(node.body)
    try self.visitArguments(node.args)
    try self.visitExpressions(node.decorators, payload: .load)
    try self.visitExpression(node.returns, payload: .load)
  }

  internal func visit(_ node: AsyncFunctionDefStmt) throws {
    try self.visitStatements(node.body)
    try self.visitArguments(node.args)
    try self.visitExpressions(node.decorators, payload: .load)
    try self.visitExpression(node.returns, payload: .load)
  }

  internal func visit(_ node: ClassDefStmt) throws {
    try self.visitStatements(node.body)
    try self.visitExpressions(node.bases, payload: .load)
    try self.visitKeywords(node.keywords)
    try self.visitExpressions(node.decorators, payload: .load)
  }

  internal func visit(_ node: ReturnStmt) throws {
    try self.visitExpression(node.value, payload: .load)
  }

  internal func visit(_ node: DeleteStmt) throws {
    try self.visitExpressions(node.values, payload: .del)
  }

  internal func visit(_ node: AssignStmt) throws {
    try self.visitExpressions(node.targets, payload: .store)
    try self.visitExpression(node.value, payload: .load)
  }

  internal func visit(_ node: AugAssignStmt) throws {
    try self.visitExpression(node.target, payload: .store)
    try self.visitExpression(node.value, payload: .load)
  }

  internal func visit(_ node: AnnAssignStmt) throws {
    let isTargetIdentifier = node.target is IdentifierExpr
    if node.isSimple && !isTargetIdentifier {
      throw self.error(.simpleAnnAssignmentWithNonNameTarget, statement: node)
    }

    try self.visitExpression(node.target, payload: .store)
    try self.visitExpression(node.value, payload: .load)
    try self.visitExpression(node.annotation, payload: .load)
  }

  internal func visit(_ node: ForStmt) throws {
    try self.visitExpression(node.target, payload: .store)
    try self.visitExpression(node.iterable, payload: .load)
    try self.visitStatements(node.body)
    try self.visitStatements(node.orElse)
  }

  internal func visit(_ node: AsyncForStmt) throws {
    try self.visitExpression(node.target, payload: .store)
    try self.visitExpression(node.iterable, payload: .load)
    try self.visitStatements(node.body)
    try self.visitStatements(node.orElse)
  }

  internal func visit(_ node: WhileStmt) throws {
    try self.visitExpression(node.test, payload: .load)
    try self.visitStatements(node.body)
    try self.visitStatements(node.orElse)
  }

  internal func visit(_ node: IfStmt) throws {
    try self.visitExpression(node.test, payload: .load)
    try self.visitStatements(node.body)
    try self.visitStatements(node.orElse)
  }

  internal func visit(_ node: WithStmt) throws {
    // we don't have to check .isEmpty because of NonEmptyArray
    try self.visitWithItems(node.items)
    try self.visitStatements(node.body)
  }

  internal func visit(_ node: AsyncWithStmt) throws {
    // we don't have to check .isEmpty because of NonEmptyArray
    try self.visitWithItems(node.items)
    try self.visitStatements(node.body)
  }

  internal func visit(_ node: RaiseStmt) throws {
    if let exc = node.exception {
      try self.visitExpression(exc, payload: .load)
      try self.visitExpression(node.cause, payload: .load)
    } else if node.cause != nil {
      throw self.error(.raiseWithCauseWithoutException, statement: node)
    }
  }

  internal func visit(_ node: TryStmt) throws {
    try self.visitStatements(node.body)

    if node.handlers.isEmpty && node.finally.isEmpty {
      throw self.error(.tryWithoutExceptOrFinally, statement: node)
    }

    if node.handlers.isEmpty && !node.orElse.isEmpty {
      throw self.error(.tryWithElseWithoutExcept, statement: node)
    }

    try self.visitExceptHandlers(node.handlers)
    try self.visitStatements(node.finally)
    try self.visitStatements(node.orElse)
  }

  internal func visit(_ node: AssertStmt) throws {
    try self.visitExpression(node.test, payload: .load)
    try self.visitExpression(node.msg, payload: .load)
  }

  internal func visit(_ node: ImportStmt) throws {
    // we don't have to check names.isEmpty because of NonEmptyArray
    // we don't have to check level > 0 because of UInt
  }

  internal func visit(_ node: ImportFromStmt) throws {
    // we don't have to check names.isEmpty because of NonEmptyArray
    // we don't have to check level > 0 because of UInt
  }

  internal func visit(_ node: ImportFromStarStmt) throws {
    // we don't have to check names.isEmpty because of NonEmptyArray
    // we don't have to check level > 0 because of UInt
  }

  internal func visit(_ node: GlobalStmt) throws {
    // we don't have to check .isEmpty because of NonEmptyArray
  }

  internal func visit(_ node: NonlocalStmt) throws {
    // we don't have to check .isEmpty because of NonEmptyArray
  }

  internal func visit(_ node: ExprStmt) throws {
    try self.visitExpression(node.expression, payload: .load)
  }

  internal func visit(_ node: PassStmt) throws {}
  internal func visit(_ node: BreakStmt) throws {}
  internal func visit(_ node: ContinueStmt) throws {}

  // MARK: - WithItems

  private func visitWithItems(_ items: NonEmptyArray<WithItem>) throws {
    for i in items {
      try self.visitExpression(i.contextExpr, payload: .load)
      try self.visitExpression(i.optionalVars, payload: .store)
    }
  }

  // MARK: - ExceptHandlers

  private func visitExceptHandlers(_ handlers: [ExceptHandler]) throws {
    for h in handlers {
      if case let .typed(type: type, asName: _) = h.kind {
        try self.visitExpression(type, payload: .load)
      }
      try self.visitStatements(h.body)
    }
  }

  // MARK: - Expression

  /// validate_constant(PyObject *value)
  /// validate_expr(expr_ty exp, expr_context_ty ctx)
  internal func visitExpression(_ node: Expression,
                                payload: ExpressionPayload) throws {
    try node.accept(self, payload: payload)
  }

  private func visitExpression(_ node: Expression?,
                               payload: ExpressionPayload) throws {
    if let n = node {
      try self.visitExpression(n, payload: payload)
    }
  }

  private func visitExpressions<S: Sequence>(_ nodes: S,
                                             payload: ExpressionPayload) throws
    where S.Element: Expression {

    for node in nodes {
      try self.visitExpression(node, payload: payload)
    }
  }

  internal func visit(_ node: NoneExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
  }

  internal func visit(_ node: EllipsisExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
  }

  internal func visit(_ node: TrueExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
  }

  internal func visit(_ node: FalseExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
  }

  internal func visit(_ node: IntExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
  }

  internal func visit(_ node: FloatExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
  }

  internal func visit(_ node: ComplexExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
  }

  internal func visit(_ node: StringExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
  }

  internal func visit(_ node: BytesExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
  }

  internal func visit(_ node: IdentifierExpr, payload: ExpressionPayload) throws {
    try self.guaranteeContext(node, context: payload)
  }

  internal func visit(_ node: UnaryOpExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
    try self.visitExpression(node.right, payload: .load)
  }

  internal func visit(_ node: BinaryOpExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
    try self.visitExpression(node.left, payload: .load)
    try self.visitExpression(node.right, payload: .load)
  }

  internal func visit(_ node: BoolOpExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
    try self.visitExpression(node.left, payload: .load)
    try self.visitExpression(node.right, payload: .load)
  }

  internal func visit(_ node: CompareExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)

    try self.visitExpression(node.left, payload: .load)

    // we don't have to check elements.isEmpty because of NonEmptyArray
    for e in node.elements {
      try self.visitExpression(e.right, payload: .load)
    }
  }

  internal func visit(_ node: TupleExpr, payload: ExpressionPayload) throws {
    try self.guaranteeContext(node, context: payload)
    try self.visitExpressions(node.elements, payload: payload)
  }

  internal func visit(_ node: ListExpr, payload: ExpressionPayload) throws {
    try self.guaranteeContext(node, context: payload)
    try self.visitExpressions(node.elements, payload: payload)
  }

  internal func visit(_ node: DictionaryExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)

    for e in node.elements {
      switch e {
      case let .unpacking(expr):
        try self.visitExpression(expr, payload: .load)
      case let .keyValue(key, value):
        try self.visitExpression(key, payload: .load)
        try self.visitExpression(value, payload: .load)
      }
    }
  }

  internal func visit(_ node: SetExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
    try self.visitExpressions(node.elements, payload: .load)
  }

  internal func visit(_ node: ListComprehensionExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
    try self.visitExpression(node.element, payload: .load)
    try self.visitComprehensions(node.generators)
  }

  internal func visit(_ node: SetComprehensionExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
    try self.visitExpression(node.element, payload: .load)
    try self.visitComprehensions(node.generators)
  }

  internal func visit(_ node: DictionaryComprehensionExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
    try self.visitExpression(node.key, payload: .load)
    try self.visitExpression(node.value, payload: .load)
    try self.visitComprehensions(node.generators)
  }

  internal func visit(_ node: GeneratorExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
    try self.visitExpression(node.element, payload: .load)
    try self.visitComprehensions(node.generators)
  }

  internal func visit(_ node: AwaitExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
    try self.visitExpression(node.value, payload: .load)
  }

  internal func visit(_ node: YieldExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
    try self.visitExpression(node.value, payload: .load)
  }

  internal func visit(_ node: YieldFromExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
    try self.visitExpression(node.value, payload: .load)
  }

  internal func visit(_ node: LambdaExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
    try self.visitArguments(node.args)
    try self.visitExpression(node.body, payload: .load)
  }

  internal func visit(_ node: CallExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
    try self.visitExpression(node.function, payload: .load)
    try self.visitExpressions(node.args, payload: .load)
    try self.visitKeywords(node.keywords)
  }

  internal func visit(_ node: IfExpr, payload: ExpressionPayload) throws {
    try self.guaranteeLoadContext(node)
    try self.visitExpression(node.test, payload: .load)
    try self.visitExpression(node.body, payload: .load)
    try self.visitExpression(node.orElse, payload: .load)
  }

  internal func visit(_ node: AttributeExpr, payload: ExpressionPayload) throws {
    try self.guaranteeContext(node, context: payload)
    try self.visitExpression(node.object, payload: .load)
  }

  internal func visit(_ node: SubscriptExpr, payload: ExpressionPayload) throws {
    try self.guaranteeContext(node, context: payload)
    try self.visitExpression(node.object, payload: .load)
    try self.visitSlice(node.slice)
  }

  internal func visit(_ node: StarredExpr, payload: ExpressionPayload) throws {
    try self.guaranteeContext(node, context: payload)
    try self.visitExpression(node.expression, payload: payload)
  }

  // MARK: - Comprehensions

  /// validate_comprehension(asdl_seq *gens)
  private func visitComprehensions(
    _ comprehensions: NonEmptyArray<Comprehension>) throws {
    for c in comprehensions {
      try self.visitExpression(c.target, payload: .store)
      try self.visitExpression(c.iterable, payload: .load)
      try self.visitExpressions(c.ifs, payload: .load)
    }
  }

  // MARK: - Slice

  /// validate_slice(slice_ty slice)
  private func visitSlice(_ slice: Slice) throws {
    switch slice.kind {
    case let .slice(lower, upper, step):
      if let lower = lower { try self.visitExpression(lower, payload: .load) }
      if let upper = upper { try self.visitExpression(upper, payload: .load) }
      if let step = step { try self.visitExpression(step, payload: .load) }

    case let .extSlice(dims):
      // we don't have to check .isEmpty because of NonEmptyArray
      for slice in dims {
        try self.visitSlice(slice)
      }

    case let .index(expr):
      try self.visitExpression(expr, payload: .load)
    }
  }

  // MARK: - Arguments

  /// validate_arguments(arguments_ty args)
  private func visitArguments(_ args: Arguments) throws {
    try self.visitArgs(args.args)
    try self.visitVararg(args.vararg)
    try self.visitArgs(args.kwOnlyArgs)
    try self.visitExpression(args.kwarg?.annotation, payload: .load)

    if args.defaults.count > args.args.count {
      throw self.error(.moreDefaultsThanArgs, location: args.start)
    }

    if args.kwOnlyDefaults.count != args.kwOnlyArgs.count {
      throw self.error(.kwOnlyArgsCountNotEqualToDefaults, location: args.start)
    }

    try self.visitExpressions(args.defaults, payload: .load)
    try self.visitExpressions(args.kwOnlyDefaults, payload: .load)
  }

  /// validate_args(asdl_seq *args)
  private func visitArgs(_ args: [Argument]) throws {
    for a in args {
      try self.visitExpression(a.annotation, payload: .load)
    }
  }

  /// validate_arguments(arguments_ty args)
  private func visitVararg(_ arg: Vararg) throws {
    switch arg {
    case .none,
         .unnamed:
      break
    case let .named(arg):
      try self.visitExpression(arg.annotation, payload: .load)
    }
  }

  /// validate_keywords(asdl_seq *keywords)
  private func visitKeywords(_ keywords: [KeywordArgument]) throws {
    for keyword in keywords {
      try self.visitExpression(keyword.value, payload: .load)
    }
  }

  // MARK: - Context

  private func guaranteeLoadContext(_ expression: Expression) throws {
    try self.guaranteeContext(expression, context: .load)
  }

  private func guaranteeContext(_ expression: Expression,
                                context: ExpressionContext) throws {
    if expression.context != context {
      let e = ParserErrorKind.invalidContext(expression, expected: context)
      throw self.error(e, expression: expression)
    }
  }

  // MARK: - Error

  /// Create parser error
  private func error(_ kind: ParserErrorKind,
                     statement: Statement) -> ParserError {
    return ParserError(kind, location: statement.start)
  }

  /// Create parser error
  private func error(_ kind: ParserErrorKind,
                     expression: Expression) -> ParserError {
    return ParserError(kind, location: expression.start)
  }

  /// Create parser error
  private func error(_ kind: ParserErrorKind,
                     location: SourceLocation) -> ParserError {
    return ParserError(kind, location: location)
  }
}

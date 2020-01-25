import Foundation
import Core
import Lexer

// swiftlint:disable file_length
// swiftlint:disable function_body_length

// In CPython:
// Python -> ast.c

public class ASTValidator {
  public func validate(ast: AST) throws {
    let pass = ASTValidatorPass()
    try pass.visitAST(ast)
  }
}

internal class ASTValidatorPass: ASTVisitor, StatementVisitor, ExpressionVisitor {

  internal typealias PassResult = Void

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
    try self.visitExpression(node.expression)
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
    try self.visitExpressions(node.decorators)
    try self.visitExpression(node.returns)
  }

  internal func visit(_ node: AsyncFunctionDefStmt) throws {
    try self.visitStatements(node.body)
    try self.visitArguments(node.args)
    try self.visitExpressions(node.decorators)
    try self.visitExpression(node.returns)
  }

  internal func visit(_ node: ClassDefStmt) throws {
    try self.visitStatements(node.body)
    try self.visitExpressions(node.bases)
    try self.visitKeywords(node.keywords)
    try self.visitExpressions(node.decorators)
  }

  internal func visit(_ node: ReturnStmt) throws {
    try self.visitExpression(node.value)
  }

  internal func visit(_ node: DeleteStmt) throws {
    try self.visitExpressions(node.values)
  }

  internal func visit(_ node: AssignStmt) throws {
    try self.visitExpressions(node.targets)
    try self.visitExpression(node.value)
  }

  internal func visit(_ node: AugAssignStmt) throws {
    try self.visitExpression(node.target)
    try self.visitExpression(node.value)
  }

  internal func visit(_ node: AnnAssignStmt) throws {
    let isTargetIdentifier = node.target is IdentifierExpr
    if node.isSimple && !isTargetIdentifier {
      throw self.error(.simpleAnnAssignmentWithNonNameTarget, statement: node)
    }

    try self.visitExpression(node.target)
    try self.visitExpression(node.value)
    try self.visitExpression(node.annotation)
  }

  internal func visit(_ node: ForStmt) throws {
    try self.visitExpression(node.target)
    try self.visitExpression(node.iterable)
    try self.visitStatements(node.body)
    try self.visitStatements(node.orElse)
  }

  internal func visit(_ node: AsyncForStmt) throws {
    try self.visitExpression(node.target)
    try self.visitExpression(node.iterable)
    try self.visitStatements(node.body)
    try self.visitStatements(node.orElse)
  }

  internal func visit(_ node: WhileStmt) throws {
    try self.visitExpression(node.test)
    try self.visitStatements(node.body)
    try self.visitStatements(node.orElse)
  }

  internal func visit(_ node: IfStmt) throws {
    try self.visitExpression(node.test)
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
      try self.visitExpression(exc)
      try self.visitExpression(node.cause)
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
    try self.visitExpression(node.test)
    try self.visitExpression(node.msg)
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
    try self.visitExpression(node.expression)
  }

  internal func visit(_ node: PassStmt) throws { }
  internal func visit(_ node: BreakStmt) throws { }
  internal func visit(_ node: ContinueStmt) throws { }

  // MARK: - WithItems

  private func visitWithItems(_ items: NonEmptyArray<WithItem>) throws {
    for i in items {
      try self.visitExpression(i.contextExpr)
      try self.visitExpression(i.optionalVars)
    }
  }

  // MARK: - ExceptHandlers

  private func visitExceptHandlers(_ handlers: [ExceptHandler]) throws {
    for h in handlers {
      if case let .typed(type: type, asName: _) = h.kind {
        try self.visitExpression(type)
      }
      try self.visitStatements(h.body)
    }
  }

  // MARK: - Expression

  /// validate_constant(PyObject *value)
  /// validate_expr(expr_ty exp, expr_context_ty ctx)
  internal func visitExpression(_ node: Expression) throws {
    try node.accept(self)
  }

  private func visitExpression(_ node: Expression?) throws {
    if let n = node {
      try self.visitExpression(n)
    }
  }

  private func visitExpressions<S: Sequence>(_ nodes: S) throws
    where S.Element: Expression {

    for node in nodes {
      try self.visitExpression(node)
    }
  }

  internal func visit(_ node: NoneExpr) throws { }
  internal func visit(_ node: EllipsisExpr) throws { }
  internal func visit(_ node: TrueExpr) throws { }
  internal func visit(_ node: FalseExpr) throws { }
  internal func visit(_ node: IntExpr) throws { }
  internal func visit(_ node: FloatExpr) throws { }
  internal func visit(_ node: ComplexExpr) throws { }
  internal func visit(_ node: StringExpr) throws { }
  internal func visit(_ node: BytesExpr) throws { }
  internal func visit(_ node: IdentifierExpr) throws { }

  internal func visit(_ node: UnaryOpExpr) throws {
    try self.visitExpression(node.right)
  }

  internal func visit(_ node: BinaryOpExpr) throws {
    try self.visitExpression(node.left)
    try self.visitExpression(node.right)
  }

  internal func visit(_ node: BoolOpExpr) throws {
    try self.visitExpression(node.left)
    try self.visitExpression(node.right)
  }

  internal func visit(_ node: CompareExpr) throws {
    try self.visitExpression(node.left)

    // we don't have to check elements.isEmpty because of NonEmptyArray
    for e in node.elements {
      try self.visitExpression(e.right)
    }
  }

  internal func visit(_ node: TupleExpr) throws {
    try self.visitExpressions(node.elements)
  }

  internal func visit(_ node: ListExpr) throws {
    try self.visitExpressions(node.elements)
  }

  internal func visit(_ node: DictionaryExpr) throws {
    for e in node.elements {
      switch e {
      case let .unpacking(expr):
        try self.visitExpression(expr)
      case let .keyValue(key, value):
        try self.visitExpression(key)
        try self.visitExpression(value)
      }
    }
  }

  internal func visit(_ node: SetExpr) throws {
    try self.visitExpressions(node.elements)
  }

  internal func visit(_ node: ListComprehensionExpr) throws {
    try self.visitExpression(node.element)
    try self.visitComprehensions(node.generators)
  }

  internal func visit(_ node: SetComprehensionExpr) throws {
    try self.visitExpression(node.element)
    try self.visitComprehensions(node.generators)
  }

  internal func visit(_ node: DictionaryComprehensionExpr) throws {
    try self.visitExpression(node.key)
    try self.visitExpression(node.value)
    try self.visitComprehensions(node.generators)
  }

  internal func visit(_ node: GeneratorExpr) throws {
    try self.visitExpression(node.element)
    try self.visitComprehensions(node.generators)
  }

  internal func visit(_ node: AwaitExpr) throws {
    try self.visitExpression(node.value)
  }

  internal func visit(_ node: YieldExpr) throws {
    try self.visitExpression(node.value)
  }

  internal func visit(_ node: YieldFromExpr) throws {
    try self.visitExpression(node.value)
  }

  internal func visit(_ node: LambdaExpr) throws {
    try self.visitArguments(node.args)
    try self.visitExpression(node.body)
  }

  internal func visit(_ node: CallExpr) throws {
    try self.visitExpression(node.function)
    try self.visitExpressions(node.args)
    try self.visitKeywords(node.keywords)
  }

  internal func visit(_ node: IfExpr) throws {
    try self.visitExpression(node.test)
    try self.visitExpression(node.body)
    try self.visitExpression(node.orElse)
  }

  internal func visit(_ node: AttributeExpr) throws {
    try self.visitExpression(node.object)
  }

  internal func visit(_ node: SubscriptExpr) throws {
    try self.visitExpression(node.object)
    try self.visitSlice(node.slice)
  }

  internal func visit(_ node: StarredExpr) throws {
    try self.visitExpression(node.expression)
  }

  // MARK: - Comprehensions

  /// validate_comprehension(asdl_seq *gens)
  private func visitComprehensions(
    _ comprehensions: NonEmptyArray<Comprehension>) throws {
    for c in comprehensions {
      try self.visitExpression(c.target)
      try self.visitExpression(c.iter)
      try self.visitExpressions(c.ifs)
    }
  }

  // MARK: - Slice

  /// validate_slice(slice_ty slice)
  private func visitSlice(_ slice: Slice) throws {
    switch slice.kind {
    case let .slice(lower, upper, step):
      if let lower = lower { try self.visitExpression(lower) }
      if let upper = upper { try self.visitExpression(upper) }
      if let step  = step { try self.visitExpression(step) }

    case let .extSlice(dims):
      // we don't have to check .isEmpty because of NonEmptyArray
      for slice in dims {
        try self.visitSlice(slice)
      }

    case let .index(expr):
      try self.visitExpression(expr)
    }
  }

  // MARK: - Arguments

  /// validate_arguments(arguments_ty args)
  private func visitArguments(_ args: Arguments) throws {
    try self.visitArgs(args.args)
    try self.visitVararg(args.vararg)
    try self.visitArgs(args.kwOnlyArgs)
    try self.visitExpression(args.kwarg?.annotation)

    if args.defaults.count > args.args.count {
      throw self.error(.moreDefaultsThanArgs, location: args.start)
    }

    if args.kwOnlyDefaults.count != args.kwOnlyArgs.count {
      throw self.error(.kwOnlyArgsCountNotEqualToDefaults, location: args.start)
    }

    try self.visitExpressions(args.defaults)
    try self.visitExpressions(args.kwOnlyDefaults)
  }

  /// validate_args(asdl_seq *args)
  private func visitArgs(_ args: [Arg]) throws {
    for a in args {
      try self.visitExpression(a.annotation)
    }
  }

  /// validate_arguments(arguments_ty args)
  private func visitVararg(_ arg: Vararg) throws {
    switch arg {
    case .none, .unnamed:
      break
    case let .named(arg):
      try self.visitExpression(arg.annotation)
    }
  }

  /// validate_keywords(asdl_seq *keywords)
  private func visitKeywords(_ keywords: [Keyword]) throws {
    for keyword in keywords {
      try self.visitExpression(keyword.value)
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
                     location: SourceLocation) -> ParserError {
    return ParserError(kind, location: location)
  }
}

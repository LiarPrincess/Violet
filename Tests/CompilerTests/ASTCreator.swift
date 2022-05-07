import Foundation
import BigInt
import VioletCore
import VioletParser

// swiftlint:disable file_length

private var _id: ASTNodeId = 0

/// Create AST (without locations, because we don't need them most of the time).
internal protocol ASTCreator {}

extension ASTCreator {

  private var id: ASTNodeId {
    // We have to increment 'id', because it is used as a key in 'SymbolTable'.
    let value = _id
    _id += 1
    return value
  }

  private var start: SourceLocation {
    return SourceLocation(line: 98, column: 5)
  }

  private var end: SourceLocation {
    return SourceLocation(line: 99, column: 9)
  }

  // MARK: - InteractiveAST

  func interactiveAST(
    statements: [Statement],
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> InteractiveAST {
    return InteractiveAST(
      id: self.id,
      statements: statements,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - ModuleAST

  func moduleAST(
    statements: [Statement],
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> ModuleAST {
    return ModuleAST(
      id: self.id,
      statements: statements,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - ExpressionAST

  func expressionAST(
    expression: Expression,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> ExpressionAST {
    return ExpressionAST(
      id: self.id,
      expression: expression,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - FunctionDefStmt

  func functionDefStmt(
    name: String,
    args: Arguments,
    body: [Statement],
    decorators: [Expression] = [],
    returns: Expression? = nil,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> FunctionDefStmt {
    return FunctionDefStmt(
      id: self.id,
      name: name,
      args: args,
      body: self.toNonEmptyArray(body),
      decorators: decorators,
      returns: returns,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - AsyncFunctionDefStmt

  func asyncFunctionDefStmt(
    name: String,
    args: Arguments,
    body: [Statement],
    decorators: [Expression] = [],
    returns: Expression? = nil,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> AsyncFunctionDefStmt {
    return AsyncFunctionDefStmt(
      id: self.id,
      name: name,
      args: args,
      body: self.toNonEmptyArray(body),
      decorators: decorators,
      returns: returns,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - ClassDefStmt

  func classDefStmt(
    name: String,
    bases: [Expression],
    keywords: [KeywordArgument],
    body: [Statement],
    decorators: [Expression] = [],
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> ClassDefStmt {
    return ClassDefStmt(
      id: self.id,
      name: name,
      bases: bases,
      keywords: keywords,
      body: self.toNonEmptyArray(body),
      decorators: decorators,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - ReturnStmt

  func returnStmt(
    value: Expression?,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> ReturnStmt {
    return ReturnStmt(
      id: self.id,
      value: value,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - DeleteStmt

  func deleteStmt(
    values: [Expression],
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> DeleteStmt {
    return DeleteStmt(
      id: self.id,
      values: self.toNonEmptyArray(values),
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - AssignStmt

  func assignStmt(
    targets: [Expression],
    value: Expression,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> AssignStmt {
    return AssignStmt(
      id: self.id,
      targets: self.toNonEmptyArray(targets),
      value: value,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - AugAssignStmt

  func augAssignStmt(
    target: Expression,
    op: BinaryOpExpr.Operator,
    value: Expression,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> AugAssignStmt {
    return AugAssignStmt(
      id: self.id,
      target: target,
      op: op,
      value: value,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - AnnAssignStmt

  func annAssignStmt(
    target: Expression,
    annotation: Expression,
    value: Expression?,
    isSimple: Bool,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> AnnAssignStmt {
    return AnnAssignStmt(
      id: self.id,
      target: target,
      annotation: annotation,
      value: value,
      isSimple: isSimple,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - ForStmt

  func forStmt(
    target: Expression,
    iterable: Expression,
    body: [Statement],
    orElse: [Statement],
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> ForStmt {
    return ForStmt(
      id: self.id,
      target: target,
      iterable: iterable,
      body: self.toNonEmptyArray(body),
      orElse: orElse,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - AsyncForStmt

  func asyncForStmt(
    target: Expression,
    iterable: Expression,
    body: [Statement],
    orElse: [Statement],
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> AsyncForStmt {
    return AsyncForStmt(
      id: self.id,
      target: target,
      iterable: iterable,
      body: self.toNonEmptyArray(body),
      orElse: orElse,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - WhileStmt

  func whileStmt(
    test: Expression,
    body: [Statement],
    orElse: [Statement],
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> WhileStmt {
    return WhileStmt(
      id: self.id,
      test: test,
      body: self.toNonEmptyArray(body),
      orElse: orElse,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - IfStmt

  func ifStmt(
    test: Expression,
    body: [Statement],
    orElse: [Statement],
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> IfStmt {
    return IfStmt(
      id: self.id,
      test: test,
      body: self.toNonEmptyArray(body),
      orElse: orElse,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - WithStmt

  func withStmt(
    items: [WithItem],
    body: [Statement],
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> WithStmt {
    return WithStmt(
      id: self.id,
      items: self.toNonEmptyArray(items),
      body: self.toNonEmptyArray(body),
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - AsyncWithStmt

  func asyncWithStmt(
    items: [WithItem],
    body: [Statement],
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> AsyncWithStmt {
    return AsyncWithStmt(
      id: self.id,
      items: self.toNonEmptyArray(items),
      body: self.toNonEmptyArray(body),
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - RaiseStmt

  func raiseStmt(
    exception: Expression?,
    cause: Expression?,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> RaiseStmt {
    return RaiseStmt(
      id: self.id,
      exception: exception,
      cause: cause,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - TryStmt

  func tryStmt(
    body: [Statement],
    handlers: [ExceptHandler],
    orElse: [Statement],
    finally: [Statement],
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> TryStmt {
    return TryStmt(
      id: self.id,
      body: self.toNonEmptyArray(body),
      handlers: handlers,
      orElse: orElse,
      finally: finally,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - AssertStmt

  func assertStmt(
    test: Expression,
    msg: Expression?,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> AssertStmt {
    return AssertStmt(
      id: self.id,
      test: test,
      msg: msg,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - ImportStmt

  func importStmt(
    names: [Alias],
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> ImportStmt {
    return ImportStmt(
      id: self.id,
      names: self.toNonEmptyArray(names),
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - ImportFromStmt

  func importFromStmt(
    moduleName: String?,
    names: [Alias],
    level: UInt8,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> ImportFromStmt {
    return ImportFromStmt(
      id: self.id,
      moduleName: moduleName,
      names: self.toNonEmptyArray(names),
      level: level,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - ImportFromStarStmt

  func importFromStarStmt(
    moduleName: String?,
    level: UInt8,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> ImportFromStarStmt {
    return ImportFromStarStmt(
      id: self.id,
      moduleName: moduleName,
      level: level,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - GlobalStmt

  func globalStmt(
    identifier: String,
    start: SourceLocation? = nil
  ) -> GlobalStmt {
    return self.globalStmt(identifiers: [identifier], start: start)
  }

  func globalStmt(
    identifiers: [String],
    start: SourceLocation? = nil
  ) -> GlobalStmt {
    return GlobalStmt(
      id: self.id,
      identifiers: self.toNonEmptyArray(identifiers),
      start: start ?? self.start,
      end: self.end
    )
  }

  // MARK: - NonlocalStmt

  func nonlocalStmt(
    identifier: String,
    start: SourceLocation? = nil
  ) -> NonlocalStmt {
    return self.nonlocalStmt(identifiers: [identifier], start: start)
  }

  func nonlocalStmt(
    identifiers: [String],
    start: SourceLocation? = nil
  ) -> NonlocalStmt {
    return NonlocalStmt(
      id: self.id,
      identifiers: self.toNonEmptyArray(identifiers),
      start: start ?? self.start,
      end: self.end
    )
  }

  // MARK: - ExprStmt

  func exprStmt(
    expression: Expression,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> ExprStmt {
    return ExprStmt(
      id: self.id,
      expression: expression,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - PassStmt

  func passStmt(
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> PassStmt {
    return PassStmt(
      id: self.id,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - BreakStmt

  func breakStmt(
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> BreakStmt {
    return BreakStmt(
      id: self.id,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - ContinueStmt

  func continueStmt(
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> ContinueStmt {
    return ContinueStmt(
      id: self.id,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - TrueExpr

  func trueExpr(
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> TrueExpr {
    return TrueExpr(
      id: self.id,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - FalseExpr

  func falseExpr(
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> FalseExpr {
    return FalseExpr(
      id: self.id,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - NoneExpr

  func noneExpr(
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> NoneExpr {
    return NoneExpr(
      id: self.id,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - EllipsisExpr

  func ellipsisExpr(
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> EllipsisExpr {
    return EllipsisExpr(
      id: self.id,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - IdentifierExpr

  func identifierExpr(
    value: String,
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> IdentifierExpr {
    return IdentifierExpr(
      id: self.id,
      value: value,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  func identifierStmt(
    value: String,
    context: ExpressionContext = .load,
    exprStart: SourceLocation? = nil,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> ExprStmt {
    let expr = self.identifierExpr(
      value: value,
      context: context,
      start: exprStart ?? self.start,
      end: end ?? self.end
    )

    return self.exprStmt(
      expression: expr,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - StringExpr

  func stringExpr(
    value: StringExpr.Group,
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> StringExpr {
    return StringExpr(
      id: self.id,
      value: value,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - IntExpr

  func intExpr(
    value: Int,
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> IntExpr {
    return IntExpr(
      id: self.id,
      value: BigInt(value),
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  func intExpr(
    value: BigInt,
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> IntExpr {
    return IntExpr(
      id: self.id,
      value: value,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - FloatExpr

  func floatExpr(
    value: Double,
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> FloatExpr {
    return FloatExpr(
      id: self.id,
      value: value,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - ComplexExpr

  func complexExpr(
    real: Double,
    imag: Double,
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> ComplexExpr {
    return ComplexExpr(
      id: self.id,
      real: real,
      imag: imag,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - BytesExpr

  func bytesExpr(
    value: Data,
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> BytesExpr {
    return BytesExpr(
      id: self.id,
      value: value,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - UnaryOpExpr

  func unaryOpExpr(
    op: UnaryOpExpr.Operator,
    right: Expression,
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> UnaryOpExpr {
    return UnaryOpExpr(
      id: self.id,
      op: op,
      right: right,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - BinaryOpExpr

  func binaryOpExpr(
    op: BinaryOpExpr.Operator,
    left: Expression,
    right: Expression,
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> BinaryOpExpr {
    return BinaryOpExpr(
      id: self.id,
      op: op,
      left: left,
      right: right,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - BoolOpExpr

  func boolOpExpr(
    op: BoolOpExpr.Operator,
    left: Expression,
    right: Expression,
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> BoolOpExpr {
    return BoolOpExpr(
      id: self.id,
      op: op,
      left: left,
      right: right,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - CompareExpr

  func compareExpr(
    left: Expression,
    elements: [CompareExpr.Element],
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> CompareExpr {
    return CompareExpr(
      id: self.id,
      left: left,
      elements: self.toNonEmptyArray(elements),
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - TupleExpr

  func tupleExpr(
    elements: [Expression],
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> TupleExpr {
    return TupleExpr(
      id: self.id,
      elements: elements,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - ListExpr

  func listExpr(
    elements: [Expression],
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> ListExpr {
    return ListExpr(
      id: self.id,
      elements: elements,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - DictionaryExpr

  func dictionaryExpr(
    elements: [DictionaryExpr.Element],
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> DictionaryExpr {
    return DictionaryExpr(
      id: self.id,
      elements: elements,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - SetExpr

  func setExpr(
    elements: [Expression],
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> SetExpr {
    return SetExpr(
      id: self.id,
      elements: elements,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - ListComprehensionExpr

  func listComprehensionExpr(
    element: Expression,
    generators: [Comprehension],
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> ListComprehensionExpr {
    return ListComprehensionExpr(
      id: self.id,
      element: element,
      generators: self.toNonEmptyArray(generators),
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - SetComprehensionExpr

  func setComprehensionExpr(
    element: Expression,
    generators: [Comprehension],
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> SetComprehensionExpr {
    return SetComprehensionExpr(
      id: self.id,
      element: element,
      generators: self.toNonEmptyArray(generators),
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - DictionaryComprehensionExpr

  func dictionaryComprehensionExpr(
    key: Expression,
    value: Expression,
    generators: [Comprehension],
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> DictionaryComprehensionExpr {
    return DictionaryComprehensionExpr(
      id: self.id,
      key: key,
      value: value,
      generators: self.toNonEmptyArray(generators),
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - GeneratorExpr

  func generatorExpr(
    element: Expression,
    generators: [Comprehension],
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> GeneratorExpr {
    return GeneratorExpr(
      id: self.id,
      element: element,
      generators: self.toNonEmptyArray(generators),
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - AwaitExpr

  func awaitExpr(
    value: Expression,
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> AwaitExpr {
    return AwaitExpr(
      id: self.id,
      value: value,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - YieldExpr

  func yieldExpr(
    value: Expression?,
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> YieldExpr {
    return YieldExpr(
      id: self.id,
      value: value,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - YieldFromExpr

  func yieldFromExpr(
    value: Expression,
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> YieldFromExpr {
    return YieldFromExpr(
      id: self.id,
      value: value,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - LambdaExpr

  func lambdaExpr(
    args: Arguments,
    body: Expression,
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> LambdaExpr {
    return LambdaExpr(
      id: self.id,
      args: args,
      body: body,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - CallExpr

  func callExpr(
    function: Expression,
    args: [Expression],
    keywords: [KeywordArgument],
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> CallExpr {
    return CallExpr(
      id: self.id,
      function: function,
      args: args,
      keywords: keywords,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - IfExpr

  func ifExpr(
    test: Expression,
    body: Expression,
    orElse: Expression,
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> IfExpr {
    return IfExpr(
      id: self.id,
      test: test,
      body: body,
      orElse: orElse,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - AttributeExpr

  func attributeExpr(
    object: Expression,
    name: String,
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> AttributeExpr {
    return AttributeExpr(
      id: self.id,
      object: object,
      name: name,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - SubscriptExpr

  func subscriptExpr(
    object: Expression,
    slice: Slice,
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> SubscriptExpr {
    return SubscriptExpr(
      id: self.id,
      object: object,
      slice: slice,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - StarredExpr

  func starredExpr(
    expression: Expression,
    context: ExpressionContext = .load,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> StarredExpr {
    return StarredExpr(
      id: self.id,
      expression: expression,
      context: context,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - Arguments

  internal func arguments(
    args: [Argument] = [],
    posOnlyArgCount: Int = 0,
    defaults: [Expression] = [],
    vararg: Vararg = .none,
    kwOnlyArgs: [Argument] = [],
    kwOnlyDefaults: [Expression] = [],
    kwarg: Argument? = nil,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> Arguments {
    assert(args.count >= posOnlyArgCount)
    return Arguments(
      id: self.id,
      args: args,
      posOnlyArgCount: posOnlyArgCount,
      defaults: defaults,
      vararg: vararg,
      kwOnlyArgs: kwOnlyArgs,
      kwOnlyDefaults: kwOnlyDefaults,
      kwarg: kwarg,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  internal func arg(
    name: String,
    annotation: Expression? = nil,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> Argument {
    return Argument(
      id: self.id,
      name: name,
      annotation: annotation,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  internal func keyword(
    kind: KeywordArgument.Kind,
    value: Expression,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> KeywordArgument {
    return KeywordArgument(
      id: self.id,
      kind: kind,
      value: value,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - Alias

  internal func alias(
    name: String,
    asName: String?,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> Alias {
    return Alias(
      id: self.id,
      name: name,
      asName: asName,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - WithItem

  internal func withItem(
    contextExpr: Expression,
    optionalVars: Expression?,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> WithItem {
    return WithItem(
      id: self.id,
      contextExpr: contextExpr,
      optionalVars: optionalVars,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - ExceptHandler

  internal func exceptHandler(
    kind: ExceptHandler.Kind,
    body: [Statement],
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> ExceptHandler {
    return ExceptHandler(
      id: self.id,
      kind: kind,
      body: self.toNonEmptyArray(body),
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - Slice

  internal func slice(
    kind: Slice.Kind,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> Slice {
    return Slice(
      id: self.id,
      kind: kind,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - Comprehension

  internal func comprehension(
    target: Expression,
    iterable: Expression,
    ifs: [Expression],
    isAsync: Bool,
    start: SourceLocation? = nil,
    end: SourceLocation? = nil
  ) -> Comprehension {
    return Comprehension(
      id: self.id,
      target: target,
      iterable: iterable,
      ifs: ifs,
      isAsync: isAsync,
      start: start ?? self.start,
      end: end ?? self.end
    )
  }

  // MARK: - Helpers

  private func toNonEmptyArray<E>(_ array: [E]) -> NonEmptyArray<E> {
    assert(array.any)
    return NonEmptyArray(
      first: array[0],
      rest: Array(array.dropFirst())
    )
  }
}

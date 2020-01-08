import Core

/// Helper for creating AST nodes with increasing id.
public struct ASTBuilder {

  public private(set) var nextId: ASTNodeId = 0

  private mutating func getNextId() -> ASTNodeId {
    guard self.nextId != ASTNodeId.max else {
      fatalError("ASTBuilder: Reached maximim number of AST nodes: (\(ASTNodeId.max)).")
    }

    let result = self.nextId
    self.nextId += 1
    return result
  }

  public init() { }

  // MARK: - AST

  public mutating func ast(_ kind: ASTKind,
                           start: SourceLocation,
                           end: SourceLocation) -> AST {
    return AST(
      id: self.getNextId(),
      kind: kind,
      start: start,
      end: end
    )
  }

  // MARK: - Statement

  public mutating func statement(_ kind: StatementKind,
                                 start: SourceLocation,
                                 end: SourceLocation) -> Statement {
    return Statement(
      id: self.getNextId(),
      kind: kind,
      start: start,
      end: end
    )
  }

  // MARK: - Expression

  public mutating func expression(_ kind: ExpressionKind,
                                  start: SourceLocation,
                                  end: SourceLocation) -> Expression {
    return Expression(
      id: self.getNextId(),
      kind: kind,
      start: start,
      end: end
    )
  }

  // MARK: - Alias

  public mutating func alias(name: String,
                             asName: String?,
                             start: SourceLocation,
                             end: SourceLocation) -> Alias {
    return Alias(
      id: self.getNextId(),
      name: name,
      asName: asName,
      start: start,
      end: end
    )
  }

  // MARK: - WithItem

  public mutating func withItem(contextExpr: Expression,
                                optionalVars: Expression?,
                                start: SourceLocation,
                                end: SourceLocation) -> WithItem {
    return WithItem(
      id: self.getNextId(),
      contextExpr: contextExpr,
      optionalVars: optionalVars,
      start: start,
      end: end
    )
  }

  // MARK: - ExceptHandler

  public mutating func exceptHandler(_ kind: ExceptHandlerKind,
                                     body: NonEmptyArray<Statement>,
                                     start: SourceLocation,
                                     end: SourceLocation) -> ExceptHandler {
    return ExceptHandler(
      id: self.getNextId(),
      kind: kind,
      body: body,
      start: start,
      end: end
    )
  }

  // MARK: - Slice

  public mutating func slice(_ kind: SliceKind,
                             start: SourceLocation,
                             end: SourceLocation) -> Slice {
    return Slice(
      id: self.getNextId(),
      kind: kind,
      start: start,
      end: end
    )
  }

  // MARK: - Comprehension

  // swiftlint:disable:next function_parameter_count
  public mutating func comprehension(target: Expression,
                                     iter: Expression,
                                     ifs: [Expression],
                                     isAsync: Bool,
                                     start: SourceLocation,
                                     end: SourceLocation) -> Comprehension {
    return Comprehension(
      id: self.getNextId(),
      target: target,
      iter: iter,
      ifs: ifs,
      isAsync: isAsync,
      start: start,
      end: end
    )
  }

  // MARK: - Arguments

  // swiftlint:disable:next function_parameter_count
  public mutating func arguments(args: [Arg],
                                 defaults: [Expression],
                                 vararg: Vararg,
                                 kwOnlyArgs: [Arg],
                                 kwOnlyDefaults: [Expression],
                                 kwarg: Arg?,
                                 start: SourceLocation,
                                 end: SourceLocation) -> Arguments {
    return Arguments(
      id: self.getNextId(),
      args: args,
      defaults: defaults,
      vararg: vararg,
      kwOnlyArgs: kwOnlyArgs,
      kwOnlyDefaults: kwOnlyDefaults,
      kwarg: kwarg,
      start: start,
      end: end
    )
  }

  // MARK: - Arg

  public mutating func arg(name: String,
                           annotation: Expression?,
                           start: SourceLocation,
                           end: SourceLocation) -> Arg {
    return Arg(
      id: self.getNextId(),
      name: name,
      annotation: annotation,
      start: start,
      end: end
    )
  }

  // MARK: - Keyword

  public mutating func keyword(_ kind: KeywordKind,
                               value: Expression,
                               start: SourceLocation,
                               end: SourceLocation) -> Keyword {
    return Keyword(
      id: self.getNextId(),
      kind: kind,
      value: value,
      start: start,
      end: end
    )
  }
}

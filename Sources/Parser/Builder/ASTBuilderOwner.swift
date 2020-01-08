import Core

// Why do we have 'AnyObject' requirement?
// Because:
// https://www.bignerdranch.com/blog/protocol-oriented-problems-and-the-immutable-self-error/

/// Simplify working with `ASTBuilders` properties
/// (so that we don't have to use `self.builder` prefix).
public protocol ASTBuilderOwner: AnyObject {
  var builder: ASTBuilder { get set }
}

extension ASTBuilderOwner {

  // MARK: - AST

  public func ast(_ kind: ASTKind,
                  start: SourceLocation,
                  end: SourceLocation) -> AST {
    return self.builder.ast(kind, start: start, end: end)
  }

  // MARK: - Statement

  public func statement(_ kind: StatementKind,
                        start: SourceLocation,
                        end: SourceLocation) -> Statement {
    return self.builder.statement(kind, start: start, end: end
    )
  }

  // MARK: - Expression

  public func expression(_ kind: ExpressionKind,
                         start: SourceLocation,
                         end: SourceLocation) -> Expression {
    return self.builder.expression(kind, start: start, end: end)
  }

  // MARK: - Alias

  public func alias(name: String,
                    asName: String?,
                    start: SourceLocation,
                    end: SourceLocation) -> Alias {
    return self.builder.alias(
      name: name,
      asName: asName,
      start: start,
      end: end
    )
  }

  // MARK: - WithItem

  public func withItem(contextExpr: Expression,
                       optionalVars: Expression?,
                       start: SourceLocation,
                       end: SourceLocation) -> WithItem {
    return self.builder.withItem(
      contextExpr: contextExpr,
      optionalVars: optionalVars,
      start: start,
      end: end
    )
  }

  // MARK: - ExceptHandler

  public func exceptHandler(kind: ExceptHandlerKind,
                            body: NonEmptyArray<Statement>,
                            start: SourceLocation,
                            end: SourceLocation) -> ExceptHandler {
    return self.builder.exceptHandler(
      kind,
      body: body,
      start: start,
      end: end
    )
  }

  // MARK: - Slice

  public func slice(_ kind: SliceKind,
                    start: SourceLocation,
                    end: SourceLocation) -> Slice {
    return self.builder.slice(
      kind,
      start: start,
      end: end
    )
  }

  // MARK: - Comprehension

  // swiftlint:disable:next function_parameter_count
  public func comprehension(target: Expression,
                            iter: Expression,
                            ifs: [Expression],
                            isAsync: Bool,
                            start: SourceLocation,
                            end: SourceLocation) -> Comprehension {
    return self.builder.comprehension(
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
  public func arguments(args: [Arg],
                        defaults: [Expression],
                        vararg: Vararg,
                        kwOnlyArgs: [Arg],
                        kwOnlyDefaults: [Expression],
                        kwarg: Arg?,
                        start: SourceLocation,
                        end: SourceLocation) -> Arguments {
    return self.builder.arguments(
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

  public func arg(name: String,
                  annotation: Expression?,
                  start: SourceLocation,
                  end: SourceLocation) -> Arg {
    return self.builder.arg(
      name: name,
      annotation: annotation,
      start: start,
      end: end
    )
  }

  // MARK: - Keyword

  public func keyword(_ kind: KeywordKind,
                      value: Expression,
                      start: SourceLocation,
                      end: SourceLocation) -> Keyword {
    return self.builder.keyword(
      kind,
      value: value,
      start: start,
      end: end
    )
  }
}

import Core
import Parser

/// Create AST (without locations, because we don't need them most of the time).
internal protocol ASTCreator { }

extension ASTCreator {

  internal var startLocation: SourceLocation {
    return SourceLocation(line: 3, column: 5)
  }

  internal var endLocation: SourceLocation {
    return SourceLocation(line: 7, column: 9)
  }

  internal func ast(_ kind: ASTKind) -> AST {
    return AST(kind, start: startLocation, end: endLocation)
  }

  internal func statement(_ kind: StatementKind) -> Statement {
    return Statement(kind, start: startLocation, end: endLocation)
  }

  internal func expression(_ kind: ExpressionKind) -> Expression {
    return Expression(kind, start: startLocation, end: endLocation)
  }

  internal func slice(_ kind: SliceKind) -> Slice {
    return Slice(kind, start: startLocation, end: endLocation)
  }

  internal func alias(name: String, asName: String?) -> Alias {
    return Alias(name: name,
                 asName: asName,
                 start: startLocation,
                 end: endLocation)
  }

  internal func withItem(contextExpr: Expression,
                         optionalVars: Expression?) -> WithItem {
    return WithItem(id: .next,
                    contextExpr: contextExpr,
                    optionalVars: optionalVars,
                    start: startLocation,
                    end: endLocation)
  }

  internal func exceptHandler(type: Expression?,
                              name: String?,
                              body: NonEmptyArray<Statement>) -> ExceptHandler {
    return ExceptHandler(id: .next,
                         type: type,
                         name: name,
                         body: body,
                         start: startLocation,
                         end: endLocation)
  }

  internal func comprehension(target: Expression,
                              iter: Expression,
                              ifs: [Expression],
                              isAsync: Bool) -> Comprehension {
    return Comprehension(id: .next,
                         target: target,
                         iter: iter,
                         ifs: ifs,
                         isAsync: isAsync,
                         start: startLocation,
                         end: endLocation)
  }

  // swiftlint:disable:next function_parameter_count
  internal func arguments(args: [Arg],
                          defaults: [Expression],
                          vararg: Vararg,
                          kwOnlyArgs: [Arg],
                          kwOnlyDefaults: [Expression],
                          kwarg: Arg?) -> Arguments {
    return Arguments(id: .next,
                     args: args,
                     defaults: defaults,
                     vararg: vararg,
                     kwOnlyArgs: kwOnlyArgs,
                     kwOnlyDefaults: kwOnlyDefaults,
                     kwarg: kwarg,
                     start: startLocation,
                     end: endLocation)
  }

  internal func arg(_ name: String, annotation: Expression?) -> Arg {
    return Arg(id: .next,
               name: name,
               annotation: annotation,
               start: startLocation,
               end: endLocation)
  }

  internal func keyword(name: String?, value: Expression) -> Keyword {
    return Keyword(id: .next,
                   name: name,
                   value: value,
                   start: startLocation,
                   end: endLocation)
  }
}

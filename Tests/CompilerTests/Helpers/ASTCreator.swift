import Core
import Parser

/// Create AST (without locations, because we don't need them most of the time).
internal protocol ASTCreator { }

extension ASTCreator {

  /// Start location
  internal var start: SourceLocation {
    return SourceLocation(line: 3, column: 5)
  }

  /// End location
  internal var end: SourceLocation {
    return SourceLocation(line: 7, column: 9)
  }

  // MARK: - AST

  internal func ast(_ kind: ASTKind) -> AST {
    return AST(kind, start: start, end: end)
  }

  // MARK: - Statements

  internal func statement(_ kind: StatementKind,
                          start: SourceLocation? = nil) -> Statement {
    return Statement(kind, start: start ?? self.start, end: end)
  }

  internal func statement(expr kind: ExpressionKind,
                          start: SourceLocation? = nil) -> Statement {
    let stmtKind = StatementKind.expr(self.expression(kind))
    return Statement(stmtKind, start: start ?? self.start, end: end)
  }

  internal func forStmt(target: Expression,
                        iter:   Expression,
                        body:   Expression,
                        orElse: Expression) -> Statement {

    let b = self.statement(.expr(body))
    let e = self.statement(.expr(orElse))

    let kind = StatementKind.for(target: target,
                                 iter: iter,
                                 body: NonEmptyArray(first: b),
                                 orElse: [e])
    return self.statement(kind)
  }

  internal func tryStmt(body: Expression,
                        handlers: [ExceptHandler],
                        orElse: Expression,
                        finalBody: Expression) -> Statement {

    let kind = StatementKind.try(
      body: NonEmptyArray(first: self.statement(.expr(body))),
      handlers: handlers,
      orElse: [self.statement(.expr(orElse))],
      finalBody: [self.statement(.expr(finalBody))]
    )
    return self.statement(kind)
  }

  internal func whileStmt(test: Expression,
                          body: Expression,
                          orElse: Expression) -> Statement {

    let b = self.statement(.expr(body))
    let e = self.statement(.expr(orElse))

    let kind = StatementKind.while(test: test,
                                   body: NonEmptyArray(first: b),
                                   orElse: [e])

    return self.statement(kind)
  }

  internal func ifStmt(test: Expression,
                       body: Expression,
                       orElse: Expression) -> Statement {

    let b = self.statement(.expr(body))
    let e = self.statement(.expr(orElse))

    let kind = StatementKind.if(test: test,
                                body: NonEmptyArray(first: b),
                                orElse: [e])

    return self.statement(kind)
  }

  internal func functionDefStmt(name: String,
                                args: Arguments,
                                body: Statement? = nil,
                                decoratorList: [Expression] = [],
                                returns: Expression? = nil) -> StatementKind {
    let b = body ?? self.statement(.pass)
    return StatementKind.functionDef(name: name,
                                     args: args,
                                     body: NonEmptyArray(first: b),
                                     decoratorList: decoratorList,
                                     returns: returns)
  }

  // MARK: - Expressions

  internal func expression(_ kind: ExpressionKind,
                           start: SourceLocation? = nil) -> Expression {
    return Expression(kind, start: start ?? self.start, end: end)
  }

  // MARK: - Other

  internal func slice(_ kind: SliceKind) -> Slice {
    return Slice(kind, start: start, end: end)
  }

  internal func alias(name: String, asName: String?) -> Alias {
    return Alias(name: name,
                 asName: asName,
                 start: start,
                 end: end)
  }

  internal func withItem(contextExpr: Expression,
                         optionalVars: Expression?) -> WithItem {
    return WithItem(id: .next,
                    contextExpr: contextExpr,
                    optionalVars: optionalVars,
                    start: start,
                    end: end)
  }

  internal func exceptHandler(type: Expression,
                              name: String,
                              body: Statement,
                              start: SourceLocation) -> ExceptHandler {
    return ExceptHandler(id: .next,
                         type: type,
                         name: name,
                         body: NonEmptyArray(first: body),
                         start: start,
                         end: self.end)
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
                         start: start,
                         end: end)
  }

  internal func arguments(args: [Arg] = [],
                          defaults: [Expression] = [],
                          vararg: Vararg = .none,
                          kwOnlyArgs: [Arg] = [],
                          kwOnlyDefaults: [Expression] = [],
                          kwarg: Arg? = nil) -> Arguments {
    return Arguments(id: .next,
                     args: args,
                     defaults: defaults,
                     vararg: vararg,
                     kwOnlyArgs: kwOnlyArgs,
                     kwOnlyDefaults: kwOnlyDefaults,
                     kwarg: kwarg,
                     start: start,
                     end: end)
  }

  internal func arg(_ name: String,
                    annotation: Expression? = nil,
                    start: SourceLocation? = nil) -> Arg {
    return Arg(id: .next,
               name: name,
               annotation: annotation,
               start: start ?? self.start,
               end: end)
  }

  internal func keyword(name: String?, value: Expression) -> Keyword {
    return Keyword(id: .next,
                   name: name,
                   value: value,
                   start: start,
                   end: end)
  }
}

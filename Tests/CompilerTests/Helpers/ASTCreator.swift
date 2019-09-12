import Core
import Parser

// swiftlint:disable file_length

/// Create AST (without locations, because we don't need them most of the time).
internal protocol ASTCreator { }

extension ASTCreator {

  /// Start location
  internal var start: SourceLocation {
    return SourceLocation(line: 98, column: 5)
  }

  /// End location
  internal var end: SourceLocation {
    return SourceLocation(line: 99, column: 9)
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

  internal func `for`(target: Expression,
                      iter:   Expression,
                      body:   [Statement],
                      orElse: [Statement]) -> Statement {
    return self.statement(
      .for(
        target: target,
        iter: iter,
        body: self.toNonEmptyArray(body),
        orElse: orElse
      )
    )
  }

  internal func delete(_ exprs: Expression...) -> Statement {
    return self.statement(.delete(self.toNonEmptyArray(exprs)))
  }

  internal func `try`(body: Expression,
                      handlers:  [ExceptHandler],
                      orElse:    [Expression],
                      finalBody: [Expression]) -> Statement {
    return self.statement(
      .try(
        body: NonEmptyArray(first: self.statement(.expr(body))),
        handlers: handlers,
        orElse:   self.toStatements(orElse),
        finally:  self.toStatements(finalBody)
      )
    )
  }

  internal func with(items: [WithItem], body: [Statement]) -> Statement {
    return self.statement(
      .with(
        items: self.toNonEmptyArray(items),
        body: self.toNonEmptyArray(body)
      )
    )
  }

  internal func `while`(test: Expression,
                        body: [Statement],
                        orElse: [Statement]) -> Statement {
    return self.statement(
      .while(
        test: test,
        body: self.toNonEmptyArray(body),
        orElse: orElse
      )
    )
  }

  internal func `if`(test: Expression,
                     body: Expression,
                     orElse: Expression) -> Statement {
    return self.statement(
      .if(
        test: test,
        body: NonEmptyArray(first: self.statement(.expr(body))),
        orElse: [self.statement(.expr(orElse))]
      )
    )
  }

  internal func functionDef(name: String,
                            args: Arguments,
                            body: [Statement],
                            decorators: [Expression] = [],
                            returns: Expression? = nil,
                            start: SourceLocation? = nil) -> Statement {
    return self.statement(
      .functionDef(
        name: name,
        args: args,
        body: self.toNonEmptyArray(body),
        decorators: decorators,
        returns: returns
      ),
      start: start ?? self.start
    )
  }

  internal func asyncFunctionDef(name: String,
                                 args: Arguments,
                                 body: Statement? = nil,
                                 decorators: [Expression] = [],
                                 returns: Expression? = nil,
                                 start: SourceLocation? = nil) -> Statement {
    let b = body ?? self.statement(.pass)
    return self.statement(
      .asyncFunctionDef(
        name: name,
        args: args,
        body: NonEmptyArray(first: b),
        decorators: decorators,
        returns: returns
      ),
      start: start ?? self.start
    )
  }

  internal func `import`(_ aliasses: Alias...) -> Statement {
    return self.statement(.import(self.toNonEmptyArray(aliasses)))
  }

  internal func importFrom(moduleName: String?,
                           names: [Alias],
                           level: UInt8,
                           start: SourceLocation? = nil) -> Statement {
    return self.statement(
      .importFrom(
        moduleName: moduleName,
        names: self.toNonEmptyArray(names),
        level: level
      ),
      start: start
    )
  }

  internal func global(name: String, start: SourceLocation? = nil) -> Statement {
    let kind = StatementKind.global(NonEmptyArray(first: name))
    return self.statement(kind, start: start ?? self.start)
  }

  internal func nonlocal(name: String, start: SourceLocation? = nil) -> Statement {
    let kind = StatementKind.nonlocal(NonEmptyArray(first: name))
    return self.statement(kind, start: start ?? self.start)
  }

  internal func assign(target: Expression,
                       value: Expression,
                       start: SourceLocation? = nil) -> Statement {
    return self.assign(target: [target], value: value, start: start)
  }

  internal func assign(target: [Expression],
                       value: Expression,
                       start: SourceLocation? = nil) -> Statement {
    return self.statement(
      .assign(
        targets: self.toNonEmptyArray(target),
        value: value
      ),
      start: start ?? self.start
    )
  }

  internal func augAssign(target: Expression,
                          op: BinaryOperator,
                          value: Expression,
                          start: SourceLocation? = nil) -> Statement {
    return self.statement(
      .augAssign(
        target: target,
        op: op,
        value: value
      ),
      start: start ?? self.start
    )
  }

  internal func annAssign(target: Expression,
                          annotation: Expression,
                          value: Expression?,
                          isSimple: Bool,
                          start: SourceLocation? = nil) -> Statement {
    return self.statement(
      .annAssign(
        target: target,
        annotation: annotation,
        value: value,
        isSimple: isSimple
      ),
      start: start ?? self.start
    )
  }

  internal func `class`(name: String,
                        bases: [Expression],
                        keywords: [Keyword],
                        body: [Statement],
                        decorators: [Expression] = [],
                        start: SourceLocation? = nil) -> Statement {
    return self.statement(
      .classDef(
        name: name,
        bases: bases,
        keywords: keywords,
        body: self.toNonEmptyArray(body),
        decorators: decorators
      ),
      start: start ?? self.start
    )
  }

  // MARK: - Expressions

  internal func expression(_ kind: ExpressionKind,
                           start: SourceLocation? = nil) -> Expression {
    return Expression(kind, start: start ?? self.start, end: end)
  }

  internal func listComprehension(elt: Expression,
                                  generators: [Comprehension]) -> Expression {
    return self.expression(
      .listComprehension(
        elt: elt,
        generators: self.toNonEmptyArray(generators)
      )
    )
  }

  // MARK: - Other

  internal func slice(_ kind: SliceKind) -> Slice {
    return Slice(kind, start: start, end: end)
  }

  internal func alias(name: String,
                      asName: String?,
                      start: SourceLocation? = nil) -> Alias {
    return Alias(name: name,
                 asName: asName,
                 start: start ?? self.start,
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

  internal func exceptHandler(type: Expression?,
                              name: String?,
                              body: Statement,
                              start: SourceLocation? = nil) -> ExceptHandler {
    return ExceptHandler(id: .next,
                         type: type,
                         name: name,
                         body: NonEmptyArray(first: body),
                         start: start ?? self.start,
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

  internal func keyword(name: String?, value: String) -> Keyword {
    return self.keyword(
      name: name,
      value: self.identifierExpr(value)
    )
  }

  // MARK: - Other helpers

  internal func identifierExpr(_ value: String,
                               start: SourceLocation? = nil) -> Expression {
    return self.expression(
      .identifier(value),
      start: start ?? self.start
    )
  }

  internal func identifierStmt(_ value: String,
                               exprStart: SourceLocation? = nil) -> Statement {

    return self.statement(
      .expr(
        self.expression(.identifier(value), start: exprStart ?? self.start)
      )
    )
  }

  private func toStatements(_ exprs: [Expression]) -> [Statement] {
    return exprs.map { self.statement(.expr($0)) }
  }

  private func toNonEmptyArray<E>(_ array: [E]) -> NonEmptyArray<E> {
    assert(array.any)
    return NonEmptyArray(
      first: array[0],
      rest: Array(array.dropFirst())
    )
  }
}

import Core
import Parser

// swiftlint:disable file_length

// TODO: Clean this

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

  internal func `for`(target: Expression,
                      iter:   Expression,
                      body:   [Statement],
                      orElse: [Statement]) -> Statement {

    assert(body.any)
    return self.statement(.for(
      target: target,
      iter: iter,
      body: NonEmptyArray(first: body[0], rest: body[1...]),
      orElse: orElse
    ))
  }

  internal func delete(_ exprs: Expression...) -> Statement {
    assert(exprs.any)

    let kind = StatementKind.delete(NonEmptyArray(
      first: exprs[0],
      rest: Array(exprs.dropFirst())
    ))

    return self.statement(kind)
  }

  internal func tryStmt(body: Expression,
                        handlers: [ExceptHandler],
                        orElse: Expression,
                        finalBody: Expression) -> Statement {

    let kind = StatementKind.try(
      body: NonEmptyArray(first: self.statement(.expr(body))),
      handlers: handlers,
      orElse:   [self.statement(.expr(orElse))],
      finally:  [self.statement(.expr(finalBody))]
    )
    return self.statement(kind)
  }

  internal func `try`(body: Expression,
                      handlers:  [ExceptHandler],
                      orElse:    [Expression],
                      finalBody: [Expression]) -> Statement {

    let kind = StatementKind.try(
      body: NonEmptyArray(first: self.statement(.expr(body))),
      handlers: handlers,
      orElse:   self.toStatements(orElse),
      finally:  self.toStatements(finalBody)
    )
    return self.statement(kind)
  }

  internal func with(items: [WithItem], body: [Statement]) -> Statement {
    return self.statement(.with(
      items: self.toNonEmptyArray(items),
      body: self.toNonEmptyArray(body)
    ))
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

  internal func whileStmt(test: Expression,
                          body: Expression,
                          orElse: Expression?) -> Statement {

    let b = self.statement(.expr(body))
    let e = self.statement(orElse.map { .expr($0) } ?? .pass)

    let kind = StatementKind.while(test: test,
                                   body: NonEmptyArray(first: b),
                                   orElse: [e])

    return self.statement(kind)
  }

  internal func `while`(test: Expression,
                        body: [Statement],
                        orElse: [Statement]) -> Statement {
    assert(body.any)
    let b = NonEmptyArray(first: body[0], rest: body[1...])
    let kind = StatementKind.while(test: test,
                                   body: b,
                                   orElse: orElse)

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
                                decorators: [Expression] = [],
                                returns: Expression? = nil) -> StatementKind {
    let b = body ?? self.statement(.pass)
    return StatementKind.functionDef(name: name,
                                     args: args,
                                     body: NonEmptyArray(first: b),
                                     decorators: decorators,
                                     returns: returns)
  }

  internal func functionDefStmt(name: String,
                                args: Arguments,
                                body: [Statement],
                                decorators: [Expression] = [],
                                returns: Expression? = nil) -> StatementKind {
    assert(body.any)
    let arr = NonEmptyArray(first: body[0], rest: body[1...])
    return StatementKind.functionDef(name: name,
                                     args: args,
                                     body: arr,
                                     decorators: decorators,
                                     returns: returns)
  }

  internal func asyncFunctionDefStmt(name: String,
                                     args: Arguments,
                                     body: Statement? = nil,
                                     decorators: [Expression] = [],
                                     returns: Expression? = nil) -> StatementKind {
    let b = body ?? self.statement(.pass)
    return StatementKind.asyncFunctionDef(name: name,
                                          args: args,
                                          body: NonEmptyArray(first: b),
                                          decorators: decorators,
                                          returns: returns)
  }

  internal func importStmt(names: [Alias]) -> StatementKind {
    assert(names.any)
    let array = NonEmptyArray(first: names[0], rest: names[1...])
    return StatementKind.import(array)
  }

  internal func `import`(_ aliasses: Alias...) -> Statement {
    assert(aliasses.any)

    let kind = StatementKind.import(NonEmptyArray(
      first: aliasses[0],
      rest: Array(aliasses.dropFirst())
    ))

    return self.statement(kind)
  }

  internal func importFromStmt(moduleName: String?,
                               names: [Alias],
                               level: UInt8 = 0,
                               start: SourceLocation? = nil) -> Statement {
    assert(names.any)
    let array = NonEmptyArray(first: names[0], rest: names[1...])
    let kind = StatementKind.importFrom(moduleName: moduleName,
                                        names: array,
                                        level: level)

    return self.statement(kind, start: start)
  }

  internal func globalStmt(name: String,
                           location: SourceLocation? = nil) -> Statement {
    let kind = StatementKind.global(NonEmptyArray(first: name))
    return self.statement(kind, start: location ?? self.start)
  }

  internal func nonlocalStmt(name: String,
                             location: SourceLocation? = nil) -> Statement {
    let kind = StatementKind.nonlocal(NonEmptyArray(first: name))
    return self.statement(kind, start: location ?? self.start)
  }

  internal func assignStmt(target: Expression,
                           value: Expression,
                           location: SourceLocation? = nil) -> Statement {
    let kind = StatementKind.assign(
      targets: NonEmptyArray(first: target),
      value: value
    )
    return self.statement(kind, start: location ?? self.start)
  }

  internal func assign(target: [Expression],
                       value: Expression,
                       location: SourceLocation? = nil) -> Statement {
    return self.statement(
      .assign(
        targets: self.toNonEmptyArray(target),
        value: value
      ),
      start: location ?? self.start)
  }

  internal func augAssign(target: Expression,
                          op: BinaryOperator,
                          value: Expression,
                          location: SourceLocation? = nil) -> Statement {
    return self.statement(
      .augAssign(
        target: target,
        op: op,
        value: value
      ),
      start: location ?? self.start)
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
      value: self.expression(.identifier(value))
    )
  }
}

import Core

extension AST {

  public init(_ kind: ASTKind,
              start:  SourceLocation,
              end:    SourceLocation) {
    self.init(id: .next, kind: kind, start: start, end: end)
  }
}

extension Statement {

  public init(_ kind: StatementKind,
              start:  SourceLocation,
              end:    SourceLocation) {
    self.init(id: .next, kind: kind, start: start, end: end)
  }
}

extension Alias {

  public init(name: String,
              asName: String?,
              start: SourceLocation,
              end: SourceLocation) {
    self.init(id: .next, name: name, asName: asName, start: start, end: end)
  }
}

extension WithItem {

  public init(contextExpr: Expression,
              optionalVars: Expression?,
              start: SourceLocation,
              end: SourceLocation) {
    self.id = .next
    self.contextExpr = contextExpr
    self.optionalVars = optionalVars
    self.start = start
    self.end = end
  }
}

extension ExceptHandler {

  public init(type: Expression?,
              name: String?,
              body: NonEmptyArray<Statement>,
              start: SourceLocation,
              end: SourceLocation) {
    self.id = .next
    self.type = type
    self.name = name
    self.body = body
    self.start = start
    self.end = end
  }
}

extension Expression {

  public init(_ kind: ExpressionKind,
              start: SourceLocation,
              end: SourceLocation) {
    self.init(id: .next, kind: kind, start: start, end: end)
  }
}

extension Slice {

  public init(_ kind: SliceKind,
              start: SourceLocation,
              end: SourceLocation) {
    self.init(id: .next, kind: kind, start: start, end: end)
  }
}

extension Comprehension {

  public init(target: Expression,
              iter: Expression,
              ifs: [Expression],
              isAsync: Bool,
              start: SourceLocation,
              end: SourceLocation) {
    self.id = .next
    self.target = target
    self.iter = iter
    self.ifs = ifs
    self.isAsync = isAsync
    self.start = start
    self.end = end
  }
}

extension Arguments {

  public init(args: [Arg],
              defaults: [Expression],
              vararg: Vararg,
              kwOnlyArgs: [Arg],
              kwOnlyDefaults: [Expression],
              kwarg: Arg?,
              start: SourceLocation,
              end: SourceLocation) {
    self.id = .next
    self.args = args
    self.defaults = defaults
    self.vararg = vararg
    self.kwOnlyArgs = kwOnlyArgs
    self.kwOnlyDefaults = kwOnlyDefaults
    self.kwarg = kwarg
    self.start = start
    self.end = end
  }
}

extension Arg {

  public init(_ name: String,
              annotation: Expression?,
              start: SourceLocation,
              end: SourceLocation) {
    self.id = .next
    self.name = name
    self.annotation = annotation
    self.start = start
    self.end = end
  }
}

extension Keyword {

  public init(name: String?,
              value: Expression,
              start: SourceLocation,
              end: SourceLocation) {
    self.id = .next
    self.name = name
    self.value = value
    self.start = start
    self.end = end
  }
}

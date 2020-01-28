import Core

/// Set expression context.
public class ExpressionContextSetter: ExpressionVisitor {

  public typealias ExpressionResult = ()
  public typealias ExpressionPayload = ()

  private let context: ExpressionContext

  public init(context: ExpressionContext) {
    self.context = context
  }

  public static func set(expression: Expression, context: ExpressionContext) {
    let setter = ExpressionContextSetter(context: context)
    setter.visit(expression)
  }

  public static func set<S: Sequence>(
    expressions: S,
    context: ExpressionContext
  ) where S.Element: Expression {
    let setter = ExpressionContextSetter(context: context)
    setter.visit(expressions)
  }

  // MARK: - General

  public func visit(_ node: Expression) {
    try! node.accept(self, payload: ())
  }

  public func visit(_ node: Expression?) {
    if let n = node {
      self.visit(n)
    }
  }

  public func visit<S: Sequence>(_ nodes: S)
    where S.Element: Expression {

    for node in nodes {
      self.visit(node)
    }
  }

  // MARK: - Visitor

  public func visit(_ node: TrueExpr) {
    self.setContext(node)
  }

  public func visit(_ node: FalseExpr) {
    self.setContext(node)
  }

  public func visit(_ node: NoneExpr) {
    self.setContext(node)
  }

  public func visit(_ node: EllipsisExpr) {
    self.setContext(node)
  }

  public func visit(_ node: IdentifierExpr) {
    self.setContext(node)
  }

  public func visit(_ node: StringExpr) {
    self.setContext(node)
  }

  public func visit(_ node: IntExpr) {
    self.setContext(node)
  }

  public func visit(_ node: FloatExpr) {
    self.setContext(node)
  }

  public func visit(_ node: ComplexExpr) {
    self.setContext(node)
  }

  public func visit(_ node: BytesExpr) {
    self.setContext(node)
  }

  public func visit(_ node: UnaryOpExpr) {
    self.setContext(node)
    self.visit(node.right)
  }

  public func visit(_ node: BinaryOpExpr) {
    self.setContext(node)
    self.visit(node.left)
    self.visit(node.right)
  }

  public func visit(_ node: BoolOpExpr) {
    self.setContext(node)
    self.visit(node.left)
    self.visit(node.right)
  }

  public func visit(_ node: CompareExpr) {
    self.setContext(node)
    self.visit(node.left)

    for e in node.elements {
      self.visit(e.right)
    }
  }

  public func visit(_ node: TupleExpr) {
    self.setContext(node)
    self.visit(node.elements)
  }

  public func visit(_ node: ListExpr) {
    self.setContext(node)
    self.visit(node.elements)
  }

  public func visit(_ node: DictionaryExpr) {
    self.setContext(node)

    for e in node.elements {
      switch e {
      case let .unpacking(expr):
        self.visit(expr)
      case let .keyValue(key, value):
        self.visit(key)
        self.visit(value)
      }
    }
  }

  public func visit(_ node: SetExpr) {
    self.setContext(node)
    self.visit(node.elements)
  }

  public func visit(_ node: ListComprehensionExpr) {
    self.setContext(node)
    self.visit(node.element)
    self.visitComprehensions(node.generators)
  }

  public func visit(_ node: SetComprehensionExpr) {
    self.setContext(node)
    self.visit(node.element)
    self.visitComprehensions(node.generators)
  }

  public func visit(_ node: DictionaryComprehensionExpr) {
    self.setContext(node)
    self.visit(node.key)
    self.visit(node.value)
    self.visitComprehensions(node.generators)
  }

  public func visit(_ node: GeneratorExpr) {
    self.setContext(node)
    self.visit(node.element)
    self.visitComprehensions(node.generators)
  }

  private func visitComprehensions(
    _ comprehensions: NonEmptyArray<Comprehension>) {
    for c in comprehensions {
      self.visit(c.target)
      self.visit(c.iter)
      self.visit(c.ifs)
    }
  }

  public func visit(_ node: AwaitExpr) {
    self.setContext(node)
    self.visit(node.value)
  }

  public func visit(_ node: YieldExpr) {
    self.setContext(node)
    self.visit(node.value)
  }

  public func visit(_ node: YieldFromExpr) {
    self.setContext(node)
    self.visit(node.value)
  }

  public func visit(_ node: LambdaExpr) {
    self.setContext(node)
    self.visitArguments(node.args)
    self.visit(node.body)
  }

  public func visit(_ node: CallExpr) {
    self.setContext(node)
    self.visit(node.function)
    self.visit(node.args)
    self.visitKeywords(node.keywords)
  }

  private func visitArguments(_ args: Arguments) {
    self.visitArgs(args.args)
    self.visitVararg(args.vararg)
    self.visitArgs(args.kwOnlyArgs)
    self.visit(args.kwarg?.annotation)
    self.visit(args.defaults)
    self.visit(args.kwOnlyDefaults)
  }

  private func visitArgs(_ args: [Arg]) {
    for a in args {
      self.visit(a.annotation)
    }
  }

  private func visitVararg(_ arg: Vararg) {
    switch arg {
    case .none, .unnamed:
      break
    case let .named(arg):
      self.visit(arg.annotation)
    }
  }

  private func visitKeywords(_ keywords: [Keyword]) {
    for keyword in keywords {
      self.visit(keyword.value)
    }
  }

  public func visit(_ node: IfExpr) {
    self.setContext(node)
    self.visit(node.test)
    self.visit(node.body)
    self.visit(node.orElse)
  }

  public func visit(_ node: AttributeExpr) {
    self.setContext(node)
    self.visit(node.object)
  }

  public func visit(_ node: SubscriptExpr) {
    self.setContext(node)
    self.visit(node.object)
    self.visitSlice(node.slice)
  }

  private func visitSlice(_ slice: Slice) {
    switch slice.kind {
    case let .slice(lower, upper, step):
      if let lower = lower { self.visit(lower) }
      if let upper = upper { self.visit(upper) }
      if let step  = step { self.visit(step) }

    case let .extSlice(dims):
      // we don't have to check .isEmpty because of NonEmptyArray
      for slice in dims {
        self.visitSlice(slice)
      }

    case let .index(expr):
      self.visit(expr)
    }
  }

  public func visit(_ node: StarredExpr) {
    self.setContext(node)
    self.visit(node.expression)
  }

  // MARK: - Helpers

  private func setContext(_ node: Expression) {
    node.context = self.context
  }
}

import VioletCore

internal final class SetLoadExpressionContext: ExpressionVisitor {

  internal typealias ExpressionResult = ()
  internal typealias ExpressionPayload = ()

  internal static func run(expression: Expression) {
    let setter = SetLoadExpressionContext()
    setter.visit(expression)
  }

  internal static func run<S: Sequence>(expressions: S) where S.Element: Expression {
    for e in expressions {
      SetLoadExpressionContext.run(expression: e)
    }
  }

  // MARK: - General

  internal func visit(_ node: Expression) {
    // swiftlint:disable:next force_try
    try! node.accept(self)
  }

  internal func visit(_ node: Expression?) {
    if let n = node {
      self.visit(n)
    }
  }

  internal func visit<S: Sequence>(_ nodes: S)
    where S.Element: Expression {

    for node in nodes {
      self.visit(node)
    }
  }

  // MARK: - Visitor

  internal func visit(_ node: TrueExpr) {
    self.setContext(node)
  }

  internal func visit(_ node: FalseExpr) {
    self.setContext(node)
  }

  internal func visit(_ node: NoneExpr) {
    self.setContext(node)
  }

  internal func visit(_ node: EllipsisExpr) {
    self.setContext(node)
  }

  internal func visit(_ node: IdentifierExpr) {
    self.setContext(node)
  }

  internal func visit(_ node: StringExpr) {
    self.setContext(node)
  }

  internal func visit(_ node: IntExpr) {
    self.setContext(node)
  }

  internal func visit(_ node: FloatExpr) {
    self.setContext(node)
  }

  internal func visit(_ node: ComplexExpr) {
    self.setContext(node)
  }

  internal func visit(_ node: BytesExpr) {
    self.setContext(node)
  }

  internal func visit(_ node: UnaryOpExpr) {
    self.setContext(node)
    self.visit(node.right)
  }

  internal func visit(_ node: BinaryOpExpr) {
    self.setContext(node)
    self.visit(node.left)
    self.visit(node.right)
  }

  internal func visit(_ node: BoolOpExpr) {
    self.setContext(node)
    self.visit(node.left)
    self.visit(node.right)
  }

  internal func visit(_ node: CompareExpr) {
    self.setContext(node)
    self.visit(node.left)

    for e in node.elements {
      self.visit(e.right)
    }
  }

  internal func visit(_ node: TupleExpr) {
    self.setContext(node)
    self.visit(node.elements)
  }

  internal func visit(_ node: ListExpr) {
    self.setContext(node)
    self.visit(node.elements)
  }

  internal func visit(_ node: DictionaryExpr) {
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

  internal func visit(_ node: SetExpr) {
    self.setContext(node)
    self.visit(node.elements)
  }

  internal func visit(_ node: ListComprehensionExpr) {
    self.setContext(node)
    self.visit(node.element)
    self.visitComprehensions(node.generators)
  }

  internal func visit(_ node: SetComprehensionExpr) {
    self.setContext(node)
    self.visit(node.element)
    self.visitComprehensions(node.generators)
  }

  internal func visit(_ node: DictionaryComprehensionExpr) {
    self.setContext(node)
    self.visit(node.key)
    self.visit(node.value)
    self.visitComprehensions(node.generators)
  }

  internal func visit(_ node: GeneratorExpr) {
    self.setContext(node)
    self.visit(node.element)
    self.visitComprehensions(node.generators)
  }

  private func visitComprehensions(
    _ comprehensions: NonEmptyArray<Comprehension>) {
    for c in comprehensions {
      self.visit(c.target)
      self.visit(c.iterable)
      self.visit(c.ifs)
    }
  }

  internal func visit(_ node: AwaitExpr) {
    self.setContext(node)
    self.visit(node.value)
  }

  internal func visit(_ node: YieldExpr) {
    self.setContext(node)
    self.visit(node.value)
  }

  internal func visit(_ node: YieldFromExpr) {
    self.setContext(node)
    self.visit(node.value)
  }

  internal func visit(_ node: LambdaExpr) {
    self.setContext(node)
    self.visitArguments(node.args)
    self.visit(node.body)
  }

  internal func visit(_ node: CallExpr) {
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

  private func visitArgs(_ args: [Argument]) {
    for a in args {
      self.visit(a.annotation)
    }
  }

  private func visitVararg(_ arg: Vararg) {
    switch arg {
    case .none,
         .unnamed:
      break
    case let .named(arg):
      self.visit(arg.annotation)
    }
  }

  private func visitKeywords(_ keywords: [KeywordArgument]) {
    for keyword in keywords {
      self.visit(keyword.value)
    }
  }

  internal func visit(_ node: IfExpr) {
    self.setContext(node)
    self.visit(node.test)
    self.visit(node.body)
    self.visit(node.orElse)
  }

  internal func visit(_ node: AttributeExpr) {
    self.setContext(node)
    self.visit(node.object)
  }

  internal func visit(_ node: SubscriptExpr) {
    self.setContext(node)
    self.visit(node.object)
    self.visitSlice(node.slice)
  }

  private func visitSlice(_ slice: Slice) {
    switch slice.kind {
    case let .slice(lower, upper, step):
      if let lower = lower { self.visit(lower) }
      if let upper = upper { self.visit(upper) }
      if let step = step { self.visit(step) }

    case let .extSlice(dims):
      // we don't have to check .isEmpty because of NonEmptyArray
      for slice in dims {
        self.visitSlice(slice)
      }

    case let .index(expr):
      self.visit(expr)
    }
  }

  internal func visit(_ node: StarredExpr) {
    self.setContext(node)
    self.visit(node.expression)
  }

  // MARK: - Helpers

  private func setContext(_ node: Expression) {
    node.context = .load
  }
}

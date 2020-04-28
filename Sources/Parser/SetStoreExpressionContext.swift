import VioletCore

internal final class SetStoreExpressionContext: ExpressionVisitor {

  internal typealias ExpressionResult = ()
  internal typealias ExpressionPayload = ()

  internal static func run(expression: Expression) {
    let setter = SetStoreExpressionContext()
    setter.visit(expression)
  }

  internal static func run<S: Sequence>(expressions: S) where S.Element: Expression {
    for e in expressions {
      SetStoreExpressionContext.run(expression: e)
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

  internal func visit(_ node: TrueExpr) {}
  internal func visit(_ node: FalseExpr) {}
  internal func visit(_ node: NoneExpr) {}
  internal func visit(_ node: EllipsisExpr) {}

  internal func visit(_ node: IdentifierExpr) {
    self.setContext(node)
  }

  internal func visit(_ node: StringExpr) {}
  internal func visit(_ node: IntExpr) {}
  internal func visit(_ node: FloatExpr) {}
  internal func visit(_ node: ComplexExpr) {}
  internal func visit(_ node: BytesExpr) {}

  internal func visit(_ node: UnaryOpExpr) {}
  internal func visit(_ node: BinaryOpExpr) {}
  internal func visit(_ node: BoolOpExpr) {}
  internal func visit(_ node: CompareExpr) {}

  internal func visit(_ node: TupleExpr) {
    self.setContext(node)
    self.visit(node.elements)
  }

  internal func visit(_ node: ListExpr) {
    self.setContext(node)
    self.visit(node.elements)
  }

  internal func visit(_ node: DictionaryExpr) {}
  internal func visit(_ node: SetExpr) {}
  internal func visit(_ node: ListComprehensionExpr) {}

  internal func visit(_ node: SetComprehensionExpr) {}
  internal func visit(_ node: DictionaryComprehensionExpr) {}
  internal func visit(_ node: GeneratorExpr) {}

  internal func visit(_ node: AwaitExpr) {}
  internal func visit(_ node: YieldExpr) {}
  internal func visit(_ node: YieldFromExpr) {}

  internal func visit(_ node: LambdaExpr) {}
  internal func visit(_ node: CallExpr) {}

  internal func visit(_ node: IfExpr) {}

  internal func visit(_ node: AttributeExpr) {
    self.setContext(node)
    // We do not need to visit 'node.object'
  }

  internal func visit(_ node: SubscriptExpr) {
    self.setContext(node)
    // We do not need to visit 'node.object' or 'node.slice'
  }

  internal func visit(_ node: StarredExpr) {
    self.setContext(node)
    self.visit(node.expression)
  }

  // MARK: - Helpers

  private func setContext(_ node: Expression) {
    node.context = .store
  }
}

/// Instead of using one giant filter, we will use a few smaller ones.
protocol FilterImpl: DeclarationVisitor {
  func onWalkStart()
  func onWalkEnd()

  func onScopedDeclarationEnter(declaration: DeclarationWithScope)
  func onScopedDeclarationExit(declaration: DeclarationWithScope)

  func isAccepted(declaration: Declaration) -> Bool
}

extension FilterImpl {
  func onWalkStart() {}
  func onWalkEnd() {}

  func onScopedDeclarationEnter(declaration: DeclarationWithScope) {}
  func onScopedDeclarationExit(declaration: DeclarationWithScope) {}
}

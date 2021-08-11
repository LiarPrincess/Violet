/// Instead of using one giant filter, we will use a few smaller ones.
protocol FilterImpl: DeclarationVisitor {
  func onWalkStart()
  func onWalkEnd()

  func onScopedDeclarationEnter(_ node: DeclarationWithScope)
  func onScopedDeclarationExit(_ node: DeclarationWithScope)

  func isAccepted(_ node: Declaration) -> Bool
}

extension FilterImpl {
  func onWalkStart() {}
  func onWalkEnd() {}

  func onScopedDeclarationEnter(_ node: DeclarationWithScope) {}
  func onScopedDeclarationExit(_ node: DeclarationWithScope) {}
}

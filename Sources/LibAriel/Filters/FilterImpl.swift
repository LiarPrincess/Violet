/// Instead of using one giant filter, we will use a few smaller ones.
internal protocol FilterImpl: DeclarationVisitor {
  func onWalkStart()
  func onWalkEnd()

  func onScopedDeclarationEnter(_ node: DeclarationWithScope)
  func onScopedDeclarationExit(_ node: DeclarationWithScope)

  func isAccepted(_ node: Declaration) -> Bool
}

extension FilterImpl {
  internal func onWalkStart() {}
  internal func onWalkEnd() {}

  internal func onScopedDeclarationEnter(_ node: DeclarationWithScope) {}
  internal func onScopedDeclarationExit(_ node: DeclarationWithScope) {}
}

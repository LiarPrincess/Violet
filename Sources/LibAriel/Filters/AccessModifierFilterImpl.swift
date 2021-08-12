import SwiftSyntax

private let defaultAccessModifier = AccessModifier.internal

internal class AccessModifierFilterImpl: FilterImpl {

  private let minAccessModifier: AccessModifier
  private var nodeAcceptanceStatus = [DeclarationId: Bool]()

  internal init(minAccessModifier: AccessModifier) {
    self.minAccessModifier = minAccessModifier
  }

  // MARK: - Walk

  internal func onWalkStart() {
    self.nodeAcceptanceStatus.removeAll()
  }

  // MARK: - Visit

  internal func visit(_ node: Enumeration) {
    self.visit(id: node.id, accessModifier: node.accessModifier)
  }

  internal func visit(_ node: Structure) {
    self.visit(id: node.id, accessModifier: node.accessModifier)
  }

  internal func visit(_ node: Class) {
    self.visit(id: node.id, accessModifier: node.accessModifier)
  }

  internal func visit(_ node: Protocol) {
    self.visit(id: node.id, accessModifier: node.accessModifier)
  }

  internal func visit(_ node: Typealias) {
    self.visit(id: node.id, accessModifier: node.accessModifier)
  }

  internal func visit(_ node: Extension) {
    self.visit(id: node.id, accessModifier: node.accessModifier)
  }

  internal func visit(_ node: Variable) {
    self.visit(id: node.id, accessModifiers: node.accessModifiers)
  }

  internal func visit(_ node: Initializer) {
    self.visit(id: node.id, accessModifier: node.accessModifier)
  }

  internal func visit(_ node: Function) {
    self.visit(id: node.id, accessModifier: node.accessModifier)
  }

  internal func visit(_ node: Subscript) {
    self.visit(id: node.id, accessModifiers: node.accessModifiers)
  }

  internal func visit(_ node: Operator) {
    self.visit(id: node.id, accessModifier: node.accessModifier)
  }

  internal func visit(_ node: AssociatedType) {
    self.visit(id: node.id, accessModifier: node.accessModifier)
  }

  private func visit(id: DeclarationId, accessModifier: AccessModifier?) {
    let modifier = accessModifier ?? defaultAccessModifier

    assert(self.nodeAcceptanceStatus[id] == nil)
    let isAccepted = self.isAccepted(modifier)
    self.nodeAcceptanceStatus[id] = isAccepted
  }

  private func visit(id: DeclarationId, accessModifiers: GetSetAccessModifiers?) {
    let get = accessModifiers?.get ?? defaultAccessModifier
    let set = accessModifiers?.set ?? accessModifiers?.get ?? defaultAccessModifier

    assert(self.nodeAcceptanceStatus[id] == nil)
    let isAccepted = self.isAccepted(get) || self.isAccepted(set)
    self.nodeAcceptanceStatus[id] = isAccepted
  }

  private func isAccepted(_ accessModifier: AccessModifier) -> Bool {
    func toNumber(_ value: AccessModifier) -> Int {
      switch value {
      case .private: return 0
      case .fileprivate: return 1
      case .internal: return 2
      case .public: return 3
      case .open: return 4
      }
    }

    let num = toNumber(accessModifier)
    let min = toNumber(self.minAccessModifier)
    return num >= min
  }

  // MARK: - Scoped declaration

  internal func onScopedDeclarationExit(_ node: DeclarationWithScope) {
    self.ifChildIsAcceptedThenSoDoWe(node)
  }

  private func ifChildIsAcceptedThenSoDoWe(_ node: DeclarationWithScope) {
    let isAccepted = self.isAccepted(node)
    if isAccepted {
      // Already accepted, nothing to do.
      return
    }

    for child in node.children {
      let isChildAccepted = self.isAccepted(child)
      if isChildAccepted {
        self.nodeAcceptanceStatus[node.id] = true
        return
      }
    }
  }

  // MARK: - Is accepted

  internal func isAccepted(_ node: Declaration) -> Bool {
    guard let result = self.nodeAcceptanceStatus[node.id] else {
      trap("Node is missing from 'self.nodeAcceptanceStatus'")
    }

    return result
  }
}

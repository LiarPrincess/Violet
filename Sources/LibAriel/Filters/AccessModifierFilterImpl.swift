import SwiftSyntax

private let defaultAccessModifier = AccessModifier.internal

internal class AccessModifierFilterImpl: FilterImpl {

  private let minAccessModifier: AccessModifier
  private var nodeAcceptanceStatus = [SyntaxIdentifier: Bool]()

  internal init(minAccessModifier: AccessModifier) {
    self.minAccessModifier = minAccessModifier
  }

  // MARK: - Walk

  internal func onWalkStart() {
    self.nodeAcceptanceStatus.removeAll()
  }

  // MARK: - Visit

  internal func visit(_ node: Enumeration) { self.visitCommon(node) }
  internal func visit(_ node: Structure) { self.visitCommon(node) }
  internal func visit(_ node: Class) { self.visitCommon(node) }
  internal func visit(_ node: Protocol) { self.visitCommon(node) }
  internal func visit(_ node: Typealias) { self.visitCommon(node) }
  internal func visit(_ node: Extension) { self.visitCommon(node) }
  internal func visit(_ node: Variable) { self.visitCommon(node) }
  internal func visit(_ node: Initializer) { self.visitCommon(node) }
  internal func visit(_ node: Function) { self.visitCommon(node) }
  internal func visit(_ node: Subscript) { self.visitCommon(node) }
  internal func visit(_ node: Operator) { self.visitCommon(node) }
  internal func visit(_ node: AssociatedType) { self.visitCommon(node) }

  private func visitCommon(_ node: Declaration) {
    func toNumber(_ value: AccessModifier) -> Int {
      switch value {
      case .private: return 0
      case .fileprivate: return 1
      case .internal: return 2
      case .public: return 3
      case .open: return 4
      }
    }

    let accessModifiers = node.accessModifiers
    let get = accessModifiers?.get ?? defaultAccessModifier
    let set = accessModifiers?.set ?? accessModifiers?.get ?? defaultAccessModifier

    let getNum = toNumber(get)
    let setNum = toNumber(set)

    let min = toNumber(self.minAccessModifier)
    let isAccepted = getNum >= min || setNum >= min

    let id = node.id
    assert(self.nodeAcceptanceStatus[id] == nil)
    self.nodeAcceptanceStatus[id] = isAccepted
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

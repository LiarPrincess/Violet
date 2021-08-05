import SwiftSyntax

private let defaultAccessModifier = AccessModifier.internal

class AccessModifierFilterImpl: FilterImpl {

  private let minAccessModifier: AccessModifier
  private var nodeAcceptanceStatus = [SyntaxIdentifier: Bool]()

  init(minAccessModifier: AccessModifier) {
    self.minAccessModifier = minAccessModifier
  }

  // MARK: - Walk

  func onWalkStart() {
    self.nodeAcceptanceStatus.removeAll()
  }

  // MARK: - Visit

  func visit(_ node: Enumeration) { self.visitCommon(node) }
  func visit(_ node: Structure) { self.visitCommon(node) }
  func visit(_ node: Class) { self.visitCommon(node) }
  func visit(_ node: Protocol) { self.visitCommon(node) }
  func visit(_ node: Typealias) { self.visitCommon(node) }
  func visit(_ node: Extension) { self.visitCommon(node) }
  func visit(_ node: Variable) { self.visitCommon(node) }
  func visit(_ node: Initializer) { self.visitCommon(node) }
  func visit(_ node: Function) { self.visitCommon(node) }
  func visit(_ node: Subscript) { self.visitCommon(node) }
  func visit(_ node: Operator) { self.visitCommon(node) }
  func visit(_ node: AssociatedType) { self.visitCommon(node) }

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

  func onScopedDeclarationExit(declaration: DeclarationWithScope) {
    self.ifChildIsAcceptedThenSoDoWe(declaration: declaration)
  }

  private func ifChildIsAcceptedThenSoDoWe(declaration: DeclarationWithScope) {
    let isAccepted = self.isAccepted(declaration: declaration)
    if isAccepted {
      // Already accepted, nothing to do.
      return
    }

    for child in declaration.childScope.all {
      let isChildAccepted = self.isAccepted(declaration: child)
      if isChildAccepted {
        self.nodeAcceptanceStatus[declaration.id] = true
        return
      }
    }
  }

  // MARK: - Is accepted

  func isAccepted(declaration: Declaration) -> Bool {
    guard let result = self.nodeAcceptanceStatus[declaration.id] else {
      fatalError("Node is missing from 'self.nodeAcceptanceStatus'")
    }

    return result
  }
}

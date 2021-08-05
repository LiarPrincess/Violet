import SwiftSyntax

private let defaultAccessModifier = AccessModifier.internal

class DeclarationFilter {

  private let minAccessModifier: AccessModifier
  private var implementation: Implementation?

  init(minAccessModifier: AccessModifier) {
    self.minAccessModifier = minAccessModifier
  }

  func walk(scope: DeclarationScope) {
    let implementation = Implementation(
      minAccessModifier: self.minAccessModifier
    )

    for declaration in scope.all {
      implementation.visit(declaration)
    }

    self.implementation = implementation
  }

  func isAccepted(declaration: Declaration) -> Bool {
    guard let implementation = self.implementation else {
      fatalError("'self.walk' has to be called before")
    }

    return implementation.isAccepted(declaration)
  }
}

// We don't want to have all of the `DeclarationVisitor` methods visible outside
// of `Implementation`.
private class Implementation: DeclarationVisitor {

  private let minAccessModifier: AccessModifier
  private var nodeAcceptanceStatus = [SyntaxIdentifier: Bool]()

  init(minAccessModifier: AccessModifier) {
    self.minAccessModifier = minAccessModifier
  }

  func isAccepted(_ node: Declaration) -> Bool {
    guard let result = self.nodeAcceptanceStatus[node.id] else {
      fatalError("Node is missing from 'self.nodeAcceptanceStatus'")
    }

    return result
  }

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
    let isNodeAccepted = self.isAccepted(declaration: node)

    var isAnyChildrenAccepted = false
    if let scopedDeclaration = node as? DeclarationWithScope {
      let childDeclarations = scopedDeclaration.childScope.all

      for child in childDeclarations {
        self.visit(child)
        let isChildAccepted = self.isAccepted(child)
        isAnyChildrenAccepted = isAnyChildrenAccepted || isChildAccepted
      }
    }

    self.nodeAcceptanceStatus[node.id] = isNodeAccepted || isAnyChildrenAccepted
  }

  private func isAccepted(declaration: Declaration) -> Bool {
    func toNumber(_ value: AccessModifier) -> Int {
      switch value {
      case .private: return 0
      case .fileprivate: return 1
      case .internal: return 2
      case .public: return 3
      case .open: return 4
      }
    }

    let accessModifiers = declaration.accessModifiers
    let get = accessModifiers?.get ?? defaultAccessModifier
    let set = accessModifiers?.set ?? accessModifiers?.get ?? defaultAccessModifier

    let getNum = toNumber(get)
    let setNum = toNumber(set)

    let min = toNumber(self.minAccessModifier)
    return getNum >= min || setNum >= min
  }
}

import SwiftSyntax

class Filter {

  // Instead of using one giant filter, we will use a few smaller ones.
  fileprivate let implementations: [FilterImpl]

  init(minAccessModifier: AccessModifier) {
    var implementations = [FilterImpl]()

    let filter0 = AccessModifierFilterImpl(minAccessModifier: minAccessModifier)
    implementations.append(filter0)

    self.implementations = implementations
  }

  // MARK: - Walk

  func walk(scope: DeclarationScope) {
    for impl in self.implementations {
      impl.onWalkStart()
    }

    self.visit(scope: scope)

    for impl in self.implementations {
      impl.onWalkEnd()
    }
  }

  private func visit(scope: DeclarationScope) {
    for declaration in scope.all {
      self.visit(declaration: declaration)
    }
  }

  private func visit(declaration: Declaration) {
    for impl in self.implementations {
      impl.visit(declaration)
    }

    if let scopedDeclaration = declaration as? DeclarationWithScope {
      for impl in self.implementations {
        impl.onScopedDeclarationEnter(declaration: scopedDeclaration)
      }

      let childScope = scopedDeclaration.childScope
      self.visit(scope: childScope)

      for impl in self.implementations {
        impl.onScopedDeclarationExit(declaration: scopedDeclaration)
      }
    }
  }

  // MARK: - Is accepted

  func isAccepted(declaration: Declaration) -> Bool {
    for impl in self.implementations {
      let isAccepted = impl.isAccepted(declaration: declaration)
      if !isAccepted {
        return false
      }
    }

    // This will also handle empty 'self.implementations'.
    return true
  }
}

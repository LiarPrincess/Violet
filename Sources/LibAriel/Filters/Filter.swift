import SwiftSyntax

public class Filter {

  // Instead of using one giant filter, we will use a few smaller ones.
  private let implementations: [FilterImpl]

  public init(minAccessModifier: AccessModifier?) {
    var implementations = [FilterImpl]()

    if let am = minAccessModifier {
      let filter = AccessModifierFilterImpl(minAccessModifier: am)
      implementations.append(filter)
    }

    self.implementations = implementations
  }

  // MARK: - Walk

  public func walk(nodes: [Declaration]) {
    for impl in self.implementations {
      impl.onWalkStart()
    }

    self.visit(nodes)

    for impl in self.implementations {
      impl.onWalkEnd()
    }
  }

  private func visit(_ nodes: [Declaration]) {
    for node in nodes {
      self.visit(node)
    }
  }

  private func visit(_ node: Declaration) {
    for impl in self.implementations {
      impl.visit(node)
    }

    if let withChildren = node as? DeclarationWithScope {
      for impl in self.implementations {
        impl.onScopedDeclarationEnter(withChildren)
      }

      self.visit(withChildren.children)

      for impl in self.implementations {
        impl.onScopedDeclarationExit(withChildren)
      }
    }
  }

  // MARK: - Is accepted

  public func isAccepted(_ node: Declaration) -> Bool {
    for impl in self.implementations {
      let isAccepted = impl.isAccepted(node)
      if !isAccepted {
        return false
      }
    }

    // This will also handle empty 'self.implementations'.
    return true
  }
}

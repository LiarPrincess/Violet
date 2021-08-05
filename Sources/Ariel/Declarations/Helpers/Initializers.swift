import SwiftSyntax

struct TypeInitializer {

  let value: String

  init(_ node: TypeInitializerClauseSyntax) {
    self.value = node.value.description.trimmed
  }
}

struct VariableInitializer {

  let value: String

  init(_ node: InitializerClauseSyntax) {
    self.value = node.value.description.trimmed
  }
}

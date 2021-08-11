import SwiftSyntax

/// Value for `associatedtype` or `typealias`.
struct TypeInitializer {

  let value: String

  init(_ node: TypeInitializerClauseSyntax) {
    self.value = node.value.description.trimmed
  }
}

/// Value for variable or parameter.
struct VariableInitializer {

  let value: String

  init(_ node: InitializerClauseSyntax) {
    self.value = node.value.description.trimmed
  }
}

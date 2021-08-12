import SwiftSyntax

/// Value for `associatedtype` or `typealias`.
public struct TypeInitializer {

  public let value: String

  public init(value: String) {
    self.value = value
  }

  internal init(_ node: TypeInitializerClauseSyntax) {
    self.value = node.value.description.trimmed
  }
}

/// Value for variable or parameter.
public struct VariableInitializer {

  public let value: String

  public init(value: String) {
    self.value = value
  }

  internal init(_ node: InitializerClauseSyntax) {
    self.value = node.value.description.trimmed
  }
}

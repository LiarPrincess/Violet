import SwiftSyntax

public class Variable: Declaration {

  public let id: SyntaxIdentifier
  public let name: String
  public let keyword: String
  public let accessModifiers: GetSetAccessModifiers?
  public let modifiers: [Modifier]
  public let typeAnnotation: TypeAnnotation?
  public let initializer: VariableInitializer?
  public let accessors: [Accessor]

  public let attributes: [Attribute]

  internal init(_ node: VariableDeclSyntax, binding: PatternBindingSyntax) {
    self.id = binding.id
    self.name = binding.pattern.description.trimmed
    self.keyword = node.letOrVarKeyword.text.trimmed

    let modifiers = ParseModifiers.list(node.modifiers)
    self.accessModifiers = modifiers.access
    self.modifiers = modifiers.values

    self.typeAnnotation = binding.typeAnnotation.map(TypeAnnotation.init)
    self.initializer = binding.initializer.map(VariableInitializer.init)
    self.accessors = binding.accessor.map(Accessor.initMany(_:)) ?? []

    self.attributes = node.attributes?.map(Attribute.init) ?? []
  }

  public func accept(visitor: DeclarationVisitor) {
    visitor.visit(self)
  }
}

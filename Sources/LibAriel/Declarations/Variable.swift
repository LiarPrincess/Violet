import SwiftSyntax

public class Variable: Declaration {

  public let id: DeclarationId
  public let name: String
  public let keyword: String
  public let accessModifiers: GetSetAccessModifiers?
  public let modifiers: [Modifier]
  public let typeAnnotation: TypeAnnotation?
  public let initializer: VariableInitializer?
  public let accessors: [Accessor]

  public let attributes: [Attribute]

  public init(id: DeclarationId,
              name: String,
              keyword: String,
              accessModifiers: GetSetAccessModifiers?,
              modifiers: [Modifier],
              typeAnnotation: TypeAnnotation?,
              initializer: VariableInitializer?,
              accessors: [Accessor],
              attributes: [Attribute]
  ) {
    self.id = id
    self.name = name
    self.keyword = keyword
    self.accessModifiers = accessModifiers
    self.modifiers = modifiers
    self.typeAnnotation = typeAnnotation
    self.initializer = initializer
    self.accessors = accessors
    self.attributes = attributes
  }

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

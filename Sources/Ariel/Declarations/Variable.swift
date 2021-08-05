import SwiftSyntax

class Variable: Declaration {

  let id: SyntaxIdentifier
  let name: String
  let keyword: String
  let accessModifiers: AccessModifiers?
  let modifiers: [Modifier]
  let typeAnnotation: TypeAnnotation?
  let initializer: VariableInitializer?
  let accessors: [Accessor]

  let attributes: [Attribute]

  var description: String {
    let formatter = Formatter.forDescription
    return formatter.format(self)
  }

  init(_ node: VariableDeclSyntax, binding: PatternBindingSyntax) {
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

  func accept(visitor: DeclarationVisitor) {
    visitor.visit(self)
  }
}

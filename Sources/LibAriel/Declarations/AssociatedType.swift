import SwiftSyntax

class AssociatedType: Declaration {

  let id: SyntaxIdentifier
  let name: String
  let accessModifiers: GetSetAccessModifiers?
  let modifiers: [Modifier]
  let inheritance: [InheritedType]
  let initializer: TypeInitializer?

  let attributes: [Attribute]
  let genericRequirements: [GenericRequirement]

  init(_ node: AssociatedtypeDeclSyntax) {
    self.id = node.id
    self.name = node.identifier.text.trimmed
    self.initializer = node.initializer.map(TypeInitializer.init)

    let modifiers = ParseModifiers.list(node.modifiers)
    self.accessModifiers = modifiers.access
    self.modifiers = modifiers.values

    let inheritedTypes = node.inheritanceClause?.inheritedTypeCollection
    self.inheritance = inheritedTypes?.map(InheritedType.init) ?? []

    self.attributes = node.attributes?.map(Attribute.init) ?? []

    let requirementList = node.genericWhereClause?.requirementList
    self.genericRequirements = requirementList?.map(GenericRequirement.init) ?? []
  }

  func accept(visitor: DeclarationVisitor) {
    visitor.visit(self)
  }
}

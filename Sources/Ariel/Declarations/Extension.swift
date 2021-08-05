import SwiftSyntax

class Extension: DeclarationWithScope {

  let id: SyntaxIdentifier
  let extendedType: String
  let accessModifiers: GetSetAccessModifiers?
  let modifiers: [Modifier]
  let inheritance: [InheritedType]

  let attributes: [Attribute]
  let genericRequirements: [GenericRequirement]

  let childScope = DeclarationScope()

  init(_ node: ExtensionDeclSyntax) {
    self.id = node.id
    self.extendedType = node.extendedType.description.trimmed

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

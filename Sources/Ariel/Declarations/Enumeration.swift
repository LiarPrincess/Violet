import SwiftSyntax

class Enumeration: DeclarationWithScope {

  let id: SyntaxIdentifier
  let name: String
  let accessModifiers: AccessModifiers?
  let modifiers: [Modifier]
  let inheritance: [InheritedType]

  let attributes: [Attribute]
  let genericParameters: [GenericParameter]
  let genericRequirements: [GenericRequirement]

  let childScope = DeclarationScope()

  var description: String {
    let formatter = Formatter.forDescription
    return formatter.format(self)
  }

  init(_ node: EnumDeclSyntax) {
    self.id = node.id
    self.name = node.identifier.text.trimmed

    let modifiers = ParseModifiers.list(node.modifiers)
    self.accessModifiers = modifiers.access
    self.modifiers = modifiers.values

    let inheritedTypes = node.inheritanceClause?.inheritedTypeCollection
    self.inheritance = inheritedTypes?.map(InheritedType.init) ?? []

    self.attributes = node.attributes?.map(Attribute.init) ?? []

    let genericParameters = node.genericParameters?.genericParameterList
    self.genericParameters = genericParameters?.map(GenericParameter.init) ?? []

    let requirementList = node.genericWhereClause?.requirementList
    self.genericRequirements = requirementList?.map(GenericRequirement.init) ?? []
  }

  func accept(visitor: DeclarationVisitor) {
    visitor.visit(self)
  }
}

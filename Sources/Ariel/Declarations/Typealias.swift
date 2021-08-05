import SwiftSyntax

class Typealias: Declaration {

  let id: SyntaxIdentifier
  let name: String
  let accessModifiers: AccessModifiers?
  let modifiers: [Modifier]
  let initializer: TypeInitializer?

  let attributes: [Attribute]
  let genericParameters: [GenericParameter]
  let genericRequirements: [GenericRequirement]

  var description: String {
    let formatter = Formatter.forDescription
    return formatter.format(self)
  }

  init(_ node: TypealiasDeclSyntax) {
    self.id = node.id
    self.name = node.identifier.text.trimmed
    self.initializer = node.initializer.map(TypeInitializer.init)

    let modifiers = ParseModifiers.list(node.modifiers)
    self.accessModifiers = modifiers.access
    self.modifiers = modifiers.values

    self.attributes = node.attributes?.map(Attribute.init) ?? []

    let genericParameters = node.genericParameterClause?.genericParameterList
    self.genericParameters = genericParameters?.map(GenericParameter.init) ?? []

    let requirementList = node.genericWhereClause?.requirementList
    self.genericRequirements = requirementList?.map(GenericRequirement.init) ?? []
  }

  func accept(visitor: DeclarationVisitor) {
    visitor.visit(self)
  }
}

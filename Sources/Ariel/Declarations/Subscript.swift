import SwiftSyntax

class Subscript: Declaration {

  let id: SyntaxIdentifier
  let accessModifiers: AccessModifiers?
  let modifiers: [Modifier]
  let indices: [Parameter]
  let result: Type
  let accessors: [Accessor]

  let attributes: [Attribute]
  let genericParameters: [GenericParameter]
  let genericRequirements: [GenericRequirement]

  var description: String {
    let formatter = Formatter.forDescription
    return formatter.format(self)
  }

  init(_ node: SubscriptDeclSyntax) {
    self.id = node.id

    let modifiers = ParseModifiers.list(node.modifiers)
    self.accessModifiers = modifiers.access
    self.modifiers = modifiers.values

    self.indices = node.indices.parameterList.map(Parameter.init)
    self.result = Type(node.result.returnType)
    self.accessors = node.accessor.map(Accessor.initMany(_:)) ?? []

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

import SwiftSyntax

class Initializer: Declaration {

  let id: SyntaxIdentifier
  let accessModifiers: GetSetAccessModifiers?
  let modifiers: [Modifier]
  let isOptional: Bool
  let parameters: [Parameter]
  let `throws`: ThrowingStatus?

  let attributes: [Attribute]
  let genericParameters: [GenericParameter]
  let genericRequirements: [GenericRequirement]

  init(_ node: InitializerDeclSyntax) {
    self.id = node.id

    let modifiers = ParseModifiers.list(node.modifiers)
    self.accessModifiers = modifiers.access
    self.modifiers = modifiers.values

    self.isOptional = node.optionalMark != nil
    self.parameters = node.parameters.parameterList.map(Parameter.init)
    self.throws = node.throwsOrRethrowsKeyword.map(ThrowingStatus.init)

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

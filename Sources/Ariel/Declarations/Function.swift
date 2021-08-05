import SwiftSyntax

class Function: Declaration {

  let id: SyntaxIdentifier
  let name: String
  let accessModifiers: AccessModifiers?
  let modifiers: [Modifier]
  let parameters: [Parameter]
  let output: Type?
  let `throws`: ThrowingStatus?

  let attributes: [Attribute]
  let genericParameters: [GenericParameter]
  let genericRequirements: [GenericRequirement]

  var description: String {
    let formatter = Formatter.forDescription
    return formatter.format(self)
  }

  init(_ node: FunctionDeclSyntax) {
    self.id = node.id
    self.name = node.identifier.text.trimmed

    let modifiers = ParseModifiers.list(node.modifiers)
    self.accessModifiers = modifiers.access
    self.modifiers = modifiers.values

    let signature = node.signature
    self.parameters = signature.input.parameterList.map(Parameter.init)
    self.output = (signature.output?.returnType).map(Type.init) // Parens, because reasons
    self.throws = signature.throwsOrRethrowsKeyword.map(ThrowingStatus.init)

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

import SwiftSyntax

public class Function: Declaration {

  public let id: SyntaxIdentifier
  public let name: String
  public let accessModifiers: GetSetAccessModifiers?
  public let modifiers: [Modifier]
  public let parameters: [Parameter]
  public let output: Type?
  public let `throws`: ThrowingStatus?

  public let attributes: [Attribute]
  public let genericParameters: [GenericParameter]
  public let genericRequirements: [GenericRequirement]

  internal init(_ node: FunctionDeclSyntax) {
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

  public func accept(visitor: DeclarationVisitor) {
    visitor.visit(self)
  }
}

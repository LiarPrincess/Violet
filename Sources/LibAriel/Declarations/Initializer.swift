import SwiftSyntax

public class Initializer: Declaration {

  public let id: SyntaxIdentifier
  public let accessModifiers: GetSetAccessModifiers?
  public let modifiers: [Modifier]
  public let isOptional: Bool
  public let parameters: [Parameter]
  public let `throws`: ThrowingStatus?

  public let attributes: [Attribute]
  public let genericParameters: [GenericParameter]
  public let genericRequirements: [GenericRequirement]

  internal init(_ node: InitializerDeclSyntax) {
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

  public func accept(visitor: DeclarationVisitor) {
    visitor.visit(self)
  }
}

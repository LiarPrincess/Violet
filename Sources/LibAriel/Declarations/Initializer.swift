import SwiftSyntax

public class Initializer: Declaration {

  public let id: DeclarationId
  public let accessModifier: AccessModifier?
  public let modifiers: [Modifier]
  public let isOptional: Bool
  public let parameters: [Parameter]
  public let `throws`: ThrowingStatus?

  public let attributes: [Attribute]
  public let genericParameters: [GenericParameter]
  public let genericRequirements: [GenericRequirement]

  public init(id: DeclarationId,
              accessModifier: AccessModifier?,
              modifiers: [Modifier],
              isOptional: Bool,
              parameters: [Parameter],
              throws: ThrowingStatus?,
              attributes: [Attribute],
              genericParameters: [GenericParameter],
              genericRequirements: [GenericRequirement]
  ) {
    self.id = id
    self.accessModifier = accessModifier
    self.modifiers = modifiers
    self.isOptional = isOptional
    self.parameters = parameters
    self.throws = `throws`
    self.attributes = attributes
    self.genericParameters = genericParameters
    self.genericRequirements = genericRequirements
  }

  internal init(_ node: InitializerDeclSyntax) {
    self.id = DeclarationId(node.id)

    let modifiers = ParseModifiers.list(node.modifiers)
    assert(modifiers.access?.set == nil)
    self.accessModifier = modifiers.access?.get
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

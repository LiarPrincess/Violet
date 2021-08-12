import SwiftSyntax

public class Function: Declaration {

  public let id: DeclarationId
  public let name: String
  public let accessModifier: AccessModifier?
  public let modifiers: [Modifier]
  public let parameters: [Parameter]
  public let output: Type?
  public let `throws`: ThrowingStatus?

  public let attributes: [Attribute]
  public let genericParameters: [GenericParameter]
  public let genericRequirements: [GenericRequirement]

  public init(id: DeclarationId,
              name: String,
              accessModifier: AccessModifier?,
              modifiers: [Modifier],
              parameters: [Parameter],
              output: Type?,
              throws: ThrowingStatus?,
              attributes: [Attribute],
              genericParameters: [GenericParameter],
              genericRequirements: [GenericRequirement]
  ) {
    self.id = id
    self.name = name
    self.accessModifier = accessModifier
    self.modifiers = modifiers
    self.parameters = parameters
    self.output = output
    self.throws = `throws`
    self.attributes = attributes
    self.genericParameters = genericParameters
    self.genericRequirements = genericRequirements
  }

  internal init(_ node: FunctionDeclSyntax) {
    self.id = DeclarationId(node.id)
    self.name = node.identifier.text.trimmed

    let modifiers = ParseModifiers.list(node.modifiers)
    assert(modifiers.access?.set == nil)
    self.accessModifier = modifiers.access?.get
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

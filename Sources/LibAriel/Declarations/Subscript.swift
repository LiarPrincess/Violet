import SwiftSyntax

public class Subscript: Declaration {

  public let id: DeclarationId
  public let accessModifiers: GetSetAccessModifiers?
  public let modifiers: [Modifier]
  public let indices: [Parameter]
  public let result: Type
  public let accessors: [Accessor]

  public let attributes: [Attribute]
  public let genericParameters: [GenericParameter]
  public let genericRequirements: [GenericRequirement]

  public init(id: DeclarationId,
              accessModifiers: GetSetAccessModifiers?,
              modifiers: [Modifier],
              indices: [Parameter],
              result: Type,
              accessors: [Accessor],
              attributes: [Attribute],
              genericParameters: [GenericParameter],
              genericRequirements: [GenericRequirement]) {
    self.id = id
    self.accessModifiers = accessModifiers
    self.modifiers = modifiers
    self.indices = indices
    self.result = result
    self.accessors = accessors
    self.attributes = attributes
    self.genericParameters = genericParameters
    self.genericRequirements = genericRequirements
  }

  internal init(_ node: SubscriptDeclSyntax) {
    self.id = DeclarationId(node.id)

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

  public func accept(visitor: DeclarationVisitor) {
    visitor.visit(self)
  }
}

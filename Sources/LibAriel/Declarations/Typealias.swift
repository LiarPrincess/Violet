import SwiftSyntax

public class Typealias: Declaration {

  public let id: DeclarationId
  public let name: String
  public let accessModifier: AccessModifier?
  public let modifiers: [Modifier]
  public let initializer: TypeInitializer?

  public let attributes: [Attribute]
  public let genericParameters: [GenericParameter]
  public let genericRequirements: [GenericRequirement]

  public init(id: DeclarationId,
              name: String,
              accessModifier: AccessModifier?,
              modifiers: [Modifier],
              initializer: TypeInitializer?,
              attributes: [Attribute],
              genericParameters: [GenericParameter],
              genericRequirements: [GenericRequirement]
  ) {
    self.id = id
    self.name = name
    self.accessModifier = accessModifier
    self.modifiers = modifiers
    self.initializer = initializer
    self.attributes = attributes
    self.genericParameters = genericParameters
    self.genericRequirements = genericRequirements
  }

  internal init(_ node: TypealiasDeclSyntax) {
    self.id = DeclarationId(node.id)
    self.name = node.identifier.text.trimmed
    self.initializer = node.initializer.map(TypeInitializer.init)

    let modifiers = ParseModifiers.list(node.modifiers)
    assert(modifiers.access?.set == nil)
    self.accessModifier = modifiers.access?.get
    self.modifiers = modifiers.values

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

import SwiftSyntax

public class Structure: DeclarationWithScope {

  public let id: DeclarationId
  public let name: String
  public let accessModifier: AccessModifier?
  public let modifiers: [Modifier]
  public let inheritance: [InheritedType]

  public let attributes: [Attribute]
  public let genericParameters: [GenericParameter]
  public let genericRequirements: [GenericRequirement]

  public var children = [Declaration]()

  public init(id: DeclarationId,
              name: String,
              accessModifier: AccessModifier?,
              modifiers: [Modifier],
              inheritance: [InheritedType],
              attributes: [Attribute],
              genericParameters: [GenericParameter],
              genericRequirements: [GenericRequirement]
  ) {
    self.id = id
    self.name = name
    self.accessModifier = accessModifier
    self.modifiers = modifiers
    self.inheritance = inheritance
    self.attributes = attributes
    self.genericParameters = genericParameters
    self.genericRequirements = genericRequirements
  }

  internal init(_ node: StructDeclSyntax) {
    self.id = DeclarationId(node.id)
    self.name = node.identifier.text.trimmed

    let modifiers = ParseModifiers.list(node.modifiers)
    assert(modifiers.access?.set == nil)
    self.accessModifier = modifiers.access?.get
    self.modifiers = modifiers.values

    let inheritedTypes = node.inheritanceClause?.inheritedTypeCollection
    self.inheritance = inheritedTypes?.map(InheritedType.init) ?? []

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

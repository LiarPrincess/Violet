import SwiftSyntax

public class AssociatedType: Declaration {

  public let id: DeclarationId
  public let name: String
  public let accessModifier: AccessModifier?
  public let modifiers: [Modifier]
  public let inheritance: [InheritedType]
  public let initializer: TypeInitializer?

  public let attributes: [Attribute]
  public let genericRequirements: [GenericRequirement]

  public init(id: DeclarationId,
              name: String,
              accessModifier: AccessModifier?,
              modifiers: [Modifier],
              inheritance: [InheritedType],
              initializer: TypeInitializer?,
              attributes: [Attribute],
              genericRequirements: [GenericRequirement]
  ) {
    self.id = id
    self.name = name
    self.accessModifier = accessModifier
    self.modifiers = modifiers
    self.inheritance = inheritance
    self.initializer = initializer
    self.attributes = attributes
    self.genericRequirements = genericRequirements
  }

  internal init(_ node: AssociatedtypeDeclSyntax) {
    self.id = DeclarationId(node.id)
    self.name = node.identifier.text.trimmed
    self.initializer = node.initializer.map(TypeInitializer.init)

    let modifiers = ParseModifiers.list(node.modifiers)
    assert(modifiers.access?.set == nil)
    self.accessModifier = modifiers.access?.get
    self.modifiers = modifiers.values

    let inheritedTypes = node.inheritanceClause?.inheritedTypeCollection
    self.inheritance = inheritedTypes?.map(InheritedType.init) ?? []

    self.attributes = node.attributes?.map(Attribute.init) ?? []

    let requirementList = node.genericWhereClause?.requirementList
    self.genericRequirements = requirementList?.map(GenericRequirement.init) ?? []
  }

  public func accept(visitor: DeclarationVisitor) {
    visitor.visit(self)
  }
}

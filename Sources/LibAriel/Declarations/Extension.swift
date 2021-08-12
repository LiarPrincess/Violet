import SwiftSyntax

public class Extension: DeclarationWithScope {

  public let id: DeclarationId
  public let extendedType: String
  public let accessModifier: AccessModifier?
  public let modifiers: [Modifier]
  public let inheritance: [InheritedType]

  public let attributes: [Attribute]
  public let genericRequirements: [GenericRequirement]

  public var children = [Declaration]()

  public init(id: DeclarationId,
              extendedType: String,
              accessModifier: AccessModifier?,
              modifiers: [Modifier],
              inheritance: [InheritedType],
              attributes: [Attribute],
              genericRequirements: [GenericRequirement]
  ) {
    self.id = id
    self.extendedType = extendedType
    self.accessModifier = accessModifier
    self.modifiers = modifiers
    self.inheritance = inheritance
    self.attributes = attributes
    self.genericRequirements = genericRequirements
  }

  internal init(_ node: ExtensionDeclSyntax) {
    self.id = DeclarationId(node.id)
    self.extendedType = node.extendedType.description.trimmed

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

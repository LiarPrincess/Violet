import SwiftSyntax

public class AssociatedType: Declaration {

  public let id: SyntaxIdentifier
  public let name: String
  public let accessModifier: AccessModifier?
  public let modifiers: [Modifier]
  public let inheritance: [InheritedType]
  public let initializer: TypeInitializer?

  public let attributes: [Attribute]
  public let genericRequirements: [GenericRequirement]

  internal init(_ node: AssociatedtypeDeclSyntax) {
    self.id = node.id
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

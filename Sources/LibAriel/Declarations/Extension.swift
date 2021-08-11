import SwiftSyntax

public class Extension: DeclarationWithScope {

  public let id: SyntaxIdentifier
  public let extendedType: String
  public let accessModifiers: GetSetAccessModifiers?
  public let modifiers: [Modifier]
  public let inheritance: [InheritedType]

  public let attributes: [Attribute]
  public let genericRequirements: [GenericRequirement]

  public internal(set) var children = [Declaration]()

  internal init(_ node: ExtensionDeclSyntax) {
    self.id = node.id
    self.extendedType = node.extendedType.description.trimmed

    let modifiers = ParseModifiers.list(node.modifiers)
    self.accessModifiers = modifiers.access
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

import SwiftSyntax

public class Enumeration: DeclarationWithScope {

  public let id: SyntaxIdentifier
  public let name: String
  public let accessModifiers: GetSetAccessModifiers?
  public let modifiers: [Modifier]
  public let inheritance: [InheritedType]

  public let attributes: [Attribute]
  public let genericParameters: [GenericParameter]
  public let genericRequirements: [GenericRequirement]

  public internal(set) var children = [Declaration]()

  internal init(_ node: EnumDeclSyntax) {
    self.id = node.id
    self.name = node.identifier.text.trimmed

    let modifiers = ParseModifiers.list(node.modifiers)
    self.accessModifiers = modifiers.access
    self.modifiers = modifiers.values

    let inheritedTypes = node.inheritanceClause?.inheritedTypeCollection
    self.inheritance = inheritedTypes?.map(InheritedType.init) ?? []

    self.attributes = node.attributes?.map(Attribute.init) ?? []

    let genericParameters = node.genericParameters?.genericParameterList
    self.genericParameters = genericParameters?.map(GenericParameter.init) ?? []

    let requirementList = node.genericWhereClause?.requirementList
    self.genericRequirements = requirementList?.map(GenericRequirement.init) ?? []
  }

  public func accept(visitor: DeclarationVisitor) {
    visitor.visit(self)
  }
}

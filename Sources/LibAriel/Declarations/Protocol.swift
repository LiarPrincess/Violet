import SwiftSyntax

// swiftlint:disable:next type_name
internal typealias ProtocolAliasBecauseOtherwiseItFailsToCompileTests = Protocol

public class Protocol: DeclarationWithScope {

  public let id: SyntaxIdentifier
  public let name: String
  public let accessModifier: AccessModifier?
  public let modifiers: [Modifier]
  public let inheritance: [InheritedType]

  public let attributes: [Attribute]
  public let genericRequirements: [GenericRequirement]

  public internal(set) var children = [Declaration]()

  internal init(_ node: ProtocolDeclSyntax) {
    self.id = node.id
    self.name = node.identifier.text.trimmed

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

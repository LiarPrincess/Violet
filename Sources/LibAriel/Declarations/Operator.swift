import SwiftSyntax

public class Operator: Declaration {

  public enum Kind: String {
    case prefix
    case infix
    case postfix
  }

  public let id: SyntaxIdentifier
  public let name: String
  public let accessModifier: AccessModifier?
  public let modifiers: [Modifier]
  public let kind: Kind
  public let operatorPrecedenceAndTypes: [String]

  public let attributes: [Attribute]

  internal init(_ node: OperatorDeclSyntax) {
    self.id = node.id
    self.name = node.identifier.text.trimmed

    let modifiers = ParseModifiers.list(node.modifiers)
    assert(modifiers.access?.set == nil)
    self.accessModifier = modifiers.access?.get
    self.modifiers = modifiers.values

    guard let kind = modifiers.operatorKind else {
      trap("Operator without 'prefix/infix/postfix' modifier")
    }
    self.kind = kind

    let precedenceGroups = node.operatorPrecedenceAndTypes?.precedenceGroupAndDesignatedTypes
    self.operatorPrecedenceAndTypes = precedenceGroups?.map { $0.text.trimmed } ?? []

    self.attributes = node.attributes?.map(Attribute.init) ?? []
  }

  public func accept(visitor: DeclarationVisitor) {
    visitor.visit(self)
  }
}

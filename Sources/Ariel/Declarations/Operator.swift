import SwiftSyntax

class Operator: Declaration {

  enum Kind: String {
    case prefix
    case infix
    case postfix
  }

  let id: SyntaxIdentifier
  let name: String
  let accessModifiers: GetSetAccessModifiers?
  let modifiers: [Modifier]
  let kind: Kind
  let operatorPrecedenceAndTypes: [String]

  let attributes: [Attribute]

  init(_ node: OperatorDeclSyntax) {
    self.id = node.id
    self.name = node.identifier.text.trimmed

    let modifiers = ParseModifiers.list(node.modifiers)
    self.accessModifiers = modifiers.access
    self.modifiers = modifiers.values

    guard let kind = modifiers.operatorKind else {
      fatalError("Operator without 'prefix/infix/postfix' modifier")
    }
    self.kind = kind

    let precedenceGroups = node.operatorPrecedenceAndTypes?.precedenceGroupAndDesignatedTypes
    self.operatorPrecedenceAndTypes = precedenceGroups?.map { $0.text.trimmed } ?? []

    self.attributes = node.attributes?.map(Attribute.init) ?? []
  }

  func accept(visitor: DeclarationVisitor) {
    visitor.visit(self)
  }
}

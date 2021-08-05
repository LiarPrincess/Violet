import SwiftSyntax

protocol Declaration: AnyObject, CustomStringConvertible {
  var id: SyntaxIdentifier { get }
  var accessModifiers: AccessModifiers? { get }

  func accept(visitor: DeclarationVisitor)
}

/// `Declaration` that can contain nested `Declarations`
protocol DeclarationWithScope: Declaration {
  var childScope: DeclarationScope { get }
}

protocol DeclarationVisitor: AnyObject {
  func visit(_ node: Enumeration)
  func visit(_ node: Structure)
  func visit(_ node: Class)
  func visit(_ node: Protocol)
  func visit(_ node: Typealias)
  func visit(_ node: Extension)
  func visit(_ node: Variable)
  func visit(_ node: Initializer)
  func visit(_ node: Function)
  func visit(_ node: Subscript)
  func visit(_ node: Operator)
  func visit(_ node: AssociatedType)
}

extension DeclarationVisitor {
  func visit(_ node: Declaration) {
    node.accept(visitor: self)
  }
}

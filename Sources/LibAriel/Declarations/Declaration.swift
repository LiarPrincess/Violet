import SwiftSyntax

// MARK: - Declaration

public typealias DeclarationId = AnyHashable

public protocol Declaration: AnyObject, CustomStringConvertible {
  var id: DeclarationId { get }

  func accept(visitor: DeclarationVisitor)
}

extension Declaration {

  public var description: String {
    let formatter = Formatter.forDescription
    return formatter.format(self)
  }
}

/// `Declaration` that contains nested `Declarations`
internal protocol DeclarationWithScope: Declaration {
  var children: [Declaration] { get set }
}

// MARK: - Visitor

public protocol DeclarationVisitor: AnyObject {
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
  public func visit(_ node: Declaration) {
    node.accept(visitor: self)
  }
}

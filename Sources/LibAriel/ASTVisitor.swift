import SwiftSyntax

// swiftlint:disable line_length

public class ASTVisitor: SyntaxVisitor {

  /// Result of the whole thing
  public private(set) var topLevelDeclarations = [Declaration]()
  /// For nested declarations, so we can properly determine parent
  private var scopeStack = [DeclarationWithScope]()
  /// All of the visited declarations by their `id`
  private var declarationsById = [DeclarationId: Declaration]()

  // MARK: - Handle

  private func handle(_ node: Declaration) -> SyntaxVisitorContinueKind {
    self.declarationsById[node.id] = node

    if let last = self.scopeStack.last {
      last.children.append(node)
    } else {
      self.topLevelDeclarations.append(node)
    }

    if let withChildren = node as? DeclarationWithScope {
      self.scopeStack.append(withChildren)
      return .visitChildren
    }

    return .skipChildren
  }

  private func handlePost(_ id: SyntaxIdentifier) {
    guard let declaration = self.declarationsById[id] else {
      trap("Visiting unknown declaration")
    }

    if let withChildren = declaration as? DeclarationWithScope {
      let popResult = self.scopeStack.popLast()
      assert(popResult === withChildren)
    }
  }

  // MARK: - Visit

  public typealias Continue = SyntaxVisitorContinueKind

  override public func visit(_ node: EnumDeclSyntax) -> Continue { self.handle(Enumeration(node)) }
  override public func visit(_ node: StructDeclSyntax) -> Continue { self.handle(Structure(node)) }
  override public func visit(_ node: ClassDeclSyntax) -> Continue { self.handle(Class(node)) }
  override public func visit(_ node: ProtocolDeclSyntax) -> Continue { self.handle(Protocol(node)) }
  override public func visit(_ node: ExtensionDeclSyntax) -> Continue { self.handle(Extension(node)) }
  override public func visit(_ node: FunctionDeclSyntax) -> Continue { self.handle(Function(node)) }
  override public func visit(_ node: InitializerDeclSyntax) -> Continue { self.handle(Initializer(node)) }
  override public func visit(_ node: SubscriptDeclSyntax) -> Continue { self.handle(Subscript(node)) }
  override public func visit(_ node: OperatorDeclSyntax) -> Continue { self.handle(Operator(node)) }
  override public func visit(_ node: TypealiasDeclSyntax) -> Continue { self.handle(Typealias(node)) }
  override public func visit(_ node: AssociatedtypeDeclSyntax) -> Continue { self.handle(AssociatedType(node)) }

  override public func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
    // This will produce multiple bindings:
    // let a = 1, b = 2
    for binding in node.bindings {
      let result = self.handle(Variable(node, binding: binding))
      assert(result == .skipChildren)
    }

    return .skipChildren
  }

  override public func visitPost(_ node: EnumDeclSyntax) { self.handlePost(node.id) }
  override public func visitPost(_ node: StructDeclSyntax) { self.handlePost(node.id) }
  override public func visitPost(_ node: ClassDeclSyntax) { self.handlePost(node.id) }
  override public func visitPost(_ node: ProtocolDeclSyntax) { self.handlePost(node.id) }
  override public func visitPost(_ node: ExtensionDeclSyntax) { self.handlePost(node.id) }
  override public func visitPost(_ node: FunctionDeclSyntax) { self.handlePost(node.id) }
  override public func visitPost(_ node: InitializerDeclSyntax) { self.handlePost(node.id) }
  override public func visitPost(_ node: SubscriptDeclSyntax) { self.handlePost(node.id) }
  override public func visitPost(_ node: OperatorDeclSyntax) { self.handlePost(node.id) }
  override public func visitPost(_ node: TypealiasDeclSyntax) { self.handlePost(node.id) }
  override public func visitPost(_ node: AssociatedtypeDeclSyntax) { self.handlePost(node.id) }

  override public func visitPost(_ node: VariableDeclSyntax) {
    for binding in node.bindings {
      self.handlePost(binding.id)
    }
  }
}

import SwiftSyntax

class ASTVisitor: SyntaxVisitor {

  /// Result of the whole thing
  private(set) var topLevelScope = DeclarationScope()
  /// For nested declarations, so we can properly determine parent
  private var scopeStack = [DeclarationScope]()
  /// All of the visited declarations by their `id`
  private var declarationsById = [SyntaxIdentifier: Declaration]()

  private func handle(_ declaration: Declaration) -> SyntaxVisitorContinueKind {
    self.declarationsById[declaration.id] = declaration

    let scope = self.scopeStack.last ?? self.topLevelScope
    scope.append(declaration)

    if let scopedDeclaration = declaration as? DeclarationWithScope {
      self.scopeStack.append(scopedDeclaration.childScope)
      return .visitChildren
    }

    return .skipChildren
  }

  private func handlePost(_ id: SyntaxIdentifier) {
    guard let declaration = self.declarationsById[id] else {
      fatalError("Visiting unknown declaration")
    }

    if let scopedDeclaration = declaration as? DeclarationWithScope {
      let scope = self.scopeStack.popLast()
      assert(scope === scopedDeclaration.childScope)
    }
  }

  // MARK: - Visit

  typealias Continue = SyntaxVisitorContinueKind

  // swiftlint:disable line_length
  override func visit(_ node: EnumDeclSyntax) -> Continue { self.handle(Enumeration(node)) }
  override func visit(_ node: StructDeclSyntax) -> Continue { self.handle(Structure(node)) }
  override func visit(_ node: ClassDeclSyntax) -> Continue { self.handle(Class(node)) }
  override func visit(_ node: ProtocolDeclSyntax) -> Continue { self.handle(Protocol(node)) }
  override func visit(_ node: ExtensionDeclSyntax) -> Continue { self.handle(Extension(node)) }
  override func visit(_ node: FunctionDeclSyntax) -> Continue { self.handle(Function(node)) }
  override func visit(_ node: InitializerDeclSyntax) -> Continue { self.handle(Initializer(node)) }
  override func visit(_ node: SubscriptDeclSyntax) -> Continue { self.handle(Subscript(node)) }
  override func visit(_ node: OperatorDeclSyntax) -> Continue { self.handle(Operator(node)) }
  override func visit(_ node: TypealiasDeclSyntax) -> Continue { self.handle(Typealias(node)) }
  override func visit(_ node: AssociatedtypeDeclSyntax) -> Continue { self.handle(AssociatedType(node)) }
  // swiftlint:enable line_length

  override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
    // This will produce multiple bindings:
    // let a = 1, b = 2
    for binding in node.bindings {
      let result = self.handle(Variable(node, binding: binding))
      assert(result == .skipChildren)
    }

    return .skipChildren
  }

  override func visitPost(_ node: EnumDeclSyntax) { self.handlePost(node.id) }
  override func visitPost(_ node: StructDeclSyntax) { self.handlePost(node.id) }
  override func visitPost(_ node: ClassDeclSyntax) { self.handlePost(node.id) }
  override func visitPost(_ node: ProtocolDeclSyntax) { self.handlePost(node.id) }
  override func visitPost(_ node: ExtensionDeclSyntax) { self.handlePost(node.id) }
  override func visitPost(_ node: FunctionDeclSyntax) { self.handlePost(node.id) }
  override func visitPost(_ node: InitializerDeclSyntax) { self.handlePost(node.id) }
  override func visitPost(_ node: SubscriptDeclSyntax) { self.handlePost(node.id) }
  override func visitPost(_ node: OperatorDeclSyntax) { self.handlePost(node.id) }
  override func visitPost(_ node: TypealiasDeclSyntax) { self.handlePost(node.id) }
  override func visitPost(_ node: AssociatedtypeDeclSyntax) { self.handlePost(node.id) }

  override func visitPost(_ node: VariableDeclSyntax) {
    for binding in node.bindings {
      self.handlePost(binding.id)
    }
  }
}

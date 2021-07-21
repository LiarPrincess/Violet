/// Common stuff for all `AST` visitors.
class AstSourceFileVisitor: SourceFileVisitor {

  // MARK: - Is AST node

  func isASTNode(_ def: ProductType) -> Bool {
    if def.bases.contains(type: "ASTNode") {
      return true
    }

    let superclasses = self.collectSuperclasses(of: def)
    return superclasses.contains(where: self.isASTNode(_:))
  }

  // MARK: - Node kind

  enum ASTNodeKind {
    case ast
    case astSubclass
    case statement
    case statementSubclass
    case expression
    case expressionSubclass

    fileprivate var asSubclass: ASTNodeKind {
      switch self {
      case .ast,
           .astSubclass:
        return .astSubclass
      case .statement,
           .statementSubclass:
        return .statementSubclass
      case .expression,
           .expressionSubclass:
        return .expressionSubclass
      }
    }
  }

  func getASTNodeKind(_ def: ProductType) -> ASTNodeKind? {
    let name = def.name.afterResolvingAlias

    switch name {
    case "AST":
      return .ast
    case "Statement":
      return .statement
    case "Expression":
      return .expression
    default:
      let superclasses = self.collectSuperclasses(of: def)
      for s in superclasses {
        if let superKind = self.getASTNodeKind(s) {
          return superKind.asSubclass
        }
      }

      return nil
    }
  }

  // MARK: - Group

  struct GroupedAST {
    fileprivate(set) var asts = [ProductType]()
    fileprivate(set) var astSubclasses = [ProductType]()
    fileprivate(set) var statements = [ProductType]()
    fileprivate(set) var statementSubclasses = [ProductType]()
    fileprivate(set) var expressions = [ProductType]()
    fileprivate(set) var expressionSubclasses = [ProductType]()
  }

  // swiftlint:disable:next function_body_length
  func groupASTNodes() -> GroupedAST {
    var result = GroupedAST()

    for definition in self.sourceFile.definitions {
      switch definition {
      case let .class(c),
           let .finalClass(c):
        switch self.getASTNodeKind(c) {
        case .ast:
          self.ensureNameHasSuffix(c, suffix: "AST")
          result.asts.append(c)
        case .astSubclass:
          self.ensureNameHasSuffix(c, suffix: "AST")
          result.astSubclasses.append(c)
        case .statement:
          self.ensureNameHasSuffix(c, suffix: "Statement")
          result.statements.append(c)
        case .statementSubclass:
          self.ensureNameHasSuffix(c, suffix: "Stmt")
          result.statementSubclasses.append(c)
        case .expression:
          self.ensureNameHasSuffix(c, suffix: "Expression")
          result.expressions.append(c)
        case .expressionSubclass:
          self.ensureNameHasSuffix(c, suffix: "Expr")
          result.expressionSubclasses.append(c)
        case .none:
          break
        }
      case .alias,
           .enum,
           .indirectEnum,
           .struct:
        break
      }
    }

    return result
  }

  private func ensureNameHasSuffix(_ def: ProductType, suffix: String) {
    let name = def.name.afterResolvingAlias
    if name.hasSuffix(suffix) {
      return
    }

    trap("Node '\(name)' does not have required '\(suffix)' suffix")
  }

  // MARK: - Init properties

  // `start` and `end` should always be last
  override func sortInitProperties(
    _ properties: [InitProperties.Property]
  ) -> [InitProperties.Property] {
    var start: InitProperties.Property?
    var end: InitProperties.Property?
    var expressionContext: InitProperties.Property?
    var result = [InitProperties.Property]()

    for p in properties {
      var property = p
      let name = property.name
      let type = property.type
      property.isLast = false // We will fix it later

      switch name {
      case "start": start = property
      case "end": end = property
      case "context" where type == "ExpressionContext": expressionContext = property
      default: result.append(property)
      }
    }

    if let context = expressionContext { result.append(context) }
    if let start = start { result.append(start) }
    if let end = end { result.append(end) }

    if !result.isEmpty {
      let lastIndex = result.count - 1
      result[lastIndex].isLast = true
    }

    return result
  }
}

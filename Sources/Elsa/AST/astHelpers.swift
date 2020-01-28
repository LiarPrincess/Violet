import Foundation

// MARK: - Group AST nodes

internal struct GroupedAST {
  internal fileprivate(set) var astSubclasses = [ClassDef]()
  internal fileprivate(set) var statementSubclasses = [ClassDef]()
  internal fileprivate(set) var expressionSubclasses = [ClassDef]()
}

internal func groupASTNodes(entities: [Entity]) -> GroupedAST {
  var result = GroupedAST()
  for entity in entities {
    switch entity {
    case let .class(c) where c.isASTSubclass:
      checkSuffix(c, suffix: "AST")
      result.astSubclasses.append(c)
    case let .class(c) where c.isStmtSubclass:
      checkSuffix(c, suffix: "Stmt")
      result.statementSubclasses.append(c)
    case let .class(c) where c.isExprSubclass:
      checkSuffix(c, suffix: "Expr")
      result.expressionSubclasses.append(c)
    case .enum, .struct, .class:
      break
    }
  }
  return result
}

private func checkSuffix(_ def: ClassDef, suffix: String) {
  if def.name.hasSuffix(suffix) {
    return
  }

  printErr("Node '\(def.name)' does not have '\(suffix)' suffix")
  exit(EXIT_FAILURE)
}

extension ProductType {

  internal var isAST: Bool {
    return self.name == "AST"
  }

  internal var isASTSubclass: Bool {
    return self.bases.contains("AST")
  }

  internal var isStmt: Bool {
    return self.name == "Statement"
  }

  internal var isStmtSubclass: Bool {
    return self.bases.contains("Statement")
  }

  internal var isExpr: Bool {
    return self.name == "Expression"
  }

  internal var isExprSubclass: Bool {
    return self.bases.contains("Expression")
  }

  internal var isASTNode: Bool {
    return self.bases.contains("ASTNode")
      || self.isASTSubclass
      || self.isStmtSubclass
      || self.isExprSubclass
  }

  internal var visitorPrefix: String? {
    if self.isAST || self.isASTSubclass {
      return "AST"
    }

    if self.isStmt || self.isStmtSubclass {
      return "Statement"
    }

    if self.isExpr || self.isExprSubclass {
      return "Expression"
    }

    return nil
  }
}


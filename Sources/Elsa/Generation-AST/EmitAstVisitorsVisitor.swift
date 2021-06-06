import Foundation

class EmitAstVisitorsVisitor: AstSourceFileVisitor {

  override func printFileContent() {
    print("import Foundation")
    print("import VioletCore")
    print()

    print("// swiftlint:disable line_length")
    print("// swiftlint:disable trailing_newline")
    print()

    let groups = self.groupASTNodes()
    self.printVisitor(type: "AST", classes: groups.astSubclasses)
    self.printVisitor(type: "Statement", classes: groups.statementSubclasses)
    self.printVisitor(type: "Expression", classes: groups.expressionSubclasses)
  }

  private func printVisitor(type: String, classes: [ProductType]) {
    print("// MARK: - \(type)")
    print()

    print("/// Visitor for AST nodes.")
    print("public protocol \(type)Visitor {")
    print()
    print("  /// Visit result.")
    print("  associatedtype \(type)Result")
    print()

    for c in classes {
      let name = c.name.afterResolvingAlias
      print("  func visit(_ node: \(name)) throws -> \(type)Result")
    }
    print("}")
    print()

    print("/// Visitor for AST nodes.")
    print("///")
    print("/// Each function has an additional `payload` argument to pass data between")
    print("/// nodes (so that we don't have to use fields/globals which is always awkward).")
    print("public protocol \(type)VisitorWithPayload: AnyObject {")
    print()
    print("  /// Visit result.")
    print("  associatedtype \(type)Result")
    print("  /// Additional value passed to all of the calls.")
    print("  associatedtype \(type)Payload")
    print()

    for c in classes {
      let name = c.name.afterResolvingAlias
      print("  func visit(_ node: \(name), payload: \(type)Payload) throws -> \(type)Result")
    }
    print("}")
    print()
  }
}

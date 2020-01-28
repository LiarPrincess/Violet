import Foundation

public func emitAstVisitors(inputFile: URL, outputFile: URL) {
  withRedirectedStandardOutput(to: outputFile) {
    emitAstVisitors(inputFile: inputFile)
  }
}

private func emitAstVisitors(inputFile: URL) {
  print(createHeader(inputFile: inputFile))

  print("import Core")
  print("import Foundation")
  print()

  print("// swiftlint:disable file_length")
  print()

  let entities = parse(url: inputFile)
  let groups = groupASTNodes(entities: entities)
  printVisitor(type: "AST", classes: groups.astSubclasses)
  printVisitor(type: "Statement", classes: groups.statementSubclasses)
  printVisitor(type: "Expression", classes: groups.expressionSubclasses)
}

private func printVisitor(type: String, classes: [ClassDef]) {
  print("// MARK: - \(type)")
  print()

  print("/// Visitor for AST nodes.")
  print("public protocol \(type)Visitor: \(type)VisitorWithPayload {")
  print("  /// Visit result.")
  print("  associatedtype \(type)Result")
  print()

  for c in classes {
    let name = c.name
    print("  func visit(_ node: \(name)) throws -> \(type)Result")
  }
  print("}")
  print()

  print("/// Visitor for AST nodes.")
  print("///")
  print("/// Each function has additional `payload` argument to pass data between")
  print("/// nodes (so that we don't have to use fileds/globals which is always awkard).")
  print("public protocol \(type)VisitorWithPayload: AnyObject {")
  print("  /// Visit result.")
  print("  associatedtype \(type)Result")
  print("  /// Additional value passed to all of the calls.")
  print("  associatedtype \(type)Payload")
  print()

  for c in classes {
    let name = c.name
    print("  func visit(_ node: \(name), payload: \(type)Payload) throws -> \(type)Result")
  }
  print("}")
  print()

  print("// \(type)Visitor is also \(type)VisitorWithPayload, but with Void payload.")
  print("extension \(type)Visitor {")
  for c in classes {
    let name = c.name
    print()
    print("  public func visit(_ node: \(name), payload: \(type)Payload) throws -> \(type)Result {")
    print("    return try self.visit(node)")
    print("  }")
  }
  print("}")
  print()
}

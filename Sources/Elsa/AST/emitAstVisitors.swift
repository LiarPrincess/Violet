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

  print("// swiftlint:disable line_length")
  print("// swiftlint:disable trailing_newline")
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
  print("public protocol \(type)Visitor {")
  print()
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
  print("/// Each function has an additional `payload` argument to pass data between")
  print("/// nodes (so that we don't have to use fileds/globals which is always awkward).")
  print("public protocol \(type)VisitorWithPayload: AnyObject {")
  print()
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
}

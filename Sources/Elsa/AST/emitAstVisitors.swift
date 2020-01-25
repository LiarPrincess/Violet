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

  print("public protocol \(type)Visitor: AnyObject {")
  print("  associatedtype PassResult")
  for c in classes {
    let name = c.name
    print("  func visit(_ node: \(name)) throws -> PassResult")
  }
  print("}")
  print()
}

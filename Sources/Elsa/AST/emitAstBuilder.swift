import Foundation

public func emitAstBuilder(inputFile: URL, outputFile: URL) {
  withRedirectedStandardOutput(to: outputFile) {
    emitAstBuilder(inputFile: inputFile)
  }
}

private func emitAstBuilder(inputFile: URL) {
  print(createHeader(inputFile: inputFile))

  print("import Core")
  print("import Foundation")
  print()

  print("// swiftlint:disable file_length")
  print("// swiftlint:disable trailing_newline")
  print("// swiftlint:disable function_parameter_count")
  print("// swiftlint:disable vertical_whitespace_closing_braces")
  print()

  let entities = parse(url: inputFile)
  printBuilder(entities: entities)
}

// MARK: - Builder

private func printBuilder(entities: [Entity]) {
  print("""
    /// Helper for creating AST nodes with increasing id.
    public struct ASTBuilder {

      public private(set) var nextId: ASTNodeId = 0

      private mutating func getNextId() -> ASTNodeId {
        let max = ASTNodeId.max
        guard self.nextId != max else {
          fatalError("ASTBuilder: Reached maximim number of AST nodes: (\\(max)).")
        }

        let result = self.nextId
        self.nextId += 1
        return result
      }

      public init() { }

    """)

  for e in entities {
    switch e {
    case let .class(c) where c.isASTNode:
      printBuilder(c)
    case let .struct(s) where s.isASTNode:
      printBuilder(s)
    case .enum, .struct, .class:
      break
    }
  }

  print("}")
  print()
}

private struct Property {
  let name: String
  let type: String
}

private func printBuilder<T: ProductType>(_ def: T) {
  // We don't need builders for abstract classes
  if def.isAST || def.isStmt || def.isExpr {
    return
  }

  var properties = [Property]()
  for prop in def.properties where prop.name != "id" {
    properties.append(Property(name: prop.name, type: prop.type))
  }
  if !properties.contains(where: { $0.name == "context" }) && def.isExprSubclass {
    properties.append(Property(name: "context", type: "ExpressionContext"))
  }
  if !properties.contains(where: { $0.name == "start" }) {
    properties.append(Property(name: "start", type: "SourceLocation"))
  }
  if !properties.contains(where: { $0.name == "end" }) {
    properties.append(Property(name: "end", type: "SourceLocation"))
  }

  print("  // MARK: - \(def.name)")
  print()

  print("  public mutating func \(camelCase(def.name))(")
  for (index, prop) in properties.enumerated() {
    let isLast = index == properties.count - 1
    let comma = isLast ? "" : ","
    print("    \(prop.name): \(prop.type)\(comma)")
  }
  print("  ) -> \(def.name) {")

  print("    return \(def.name)(")
  print("      id: self.getNextId(),")
  for (index, prop) in properties.enumerated() {
    let isLast = index == properties.count - 1
    let comma = isLast ? "" : ","
    print("      \(prop.name): \(prop.name)\(comma)")
  }
  print("    )")

  print("  }")
  print()
}

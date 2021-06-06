import Foundation

class EmitAstBuilderVisitor: AstSourceFileVisitor {

  // MARK: - Header

  override func printHeader() {
    print("""
      import Foundation
      import BigInt
      import VioletCore

      // swiftlint:disable file_length
      // swiftlint:disable trailing_newline
      // swiftlint:disable function_parameter_count
      // swiftlint:disable vertical_whitespace_closing_braces

      /// Helper for creating AST nodes with increasing id.
      public struct ASTBuilder {

        /// See `ASTNodeId` doc.
        public private(set) var nextId: ASTNodeId = 0

        private mutating func getNextId() -> ASTNodeId {
          let max = ASTNodeId.max
          guard self.nextId != max else {
            trap("ASTBuilder: Reached maximum number of AST nodes: (\\(max)).")
          }

          let result = self.nextId
          self.nextId += 1
          return result
        }

        public init() {}

      """)
  }

  // MARK: - Footer

  override func printFooter() {
    print("}")
    print()
  }

  // MARK: - Product type

  override func printStruct(_ def: ProductType) {
    self.printBuilder(def)
  }

  override func printClass(_ def: ProductType) {
    self.printBuilder(def)
  }

  override func printFinalClass(_ def: ProductType) {
    self.printBuilder(def)
  }

  private func printBuilder(_ def: ProductType) {
    guard self.isASTNode(def) else {
      return
    }

    // We don't need builders for abstract classes
    let kind = self.getASTNodeKind(def)
    switch kind {
    case .some(.ast),
         .some(.statement),
         .some(.expression):
      return
    default:
      break
    }

    let name = def.name.afterResolvingAlias
    print("  // MARK: - \(name)")
    print()

    let initProperties = self.getInitProperties(def)
    let properties = initProperties.all.filter { prop in
      return prop.name != "id"
    }

    let functionName = name.camelCase
    print("  public mutating func \(functionName)(")
    for prop in properties {
      let comma = prop.isLast ? "" : ","
      print("    \(prop.name): \(prop.type)\(comma)")
    }
    print("  ) -> \(name) {")

    print("    return \(name)(")
    print("      id: self.getNextId(),")
    for prop in properties {
      let comma = prop.isLast ? "" : ","
      print("      \(prop.name): \(prop.name)\(comma)")
    }
    print("    )")

    print("  }")
    print()
  }
}

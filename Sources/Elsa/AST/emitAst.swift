import Foundation

public func emitAst(inputFile: URL, outputFile: URL) {
  withRedirectedStandardOutput(to: outputFile) {
    emitAst(inputFile: inputFile)
  }
}

private func emitAst(inputFile: URL) {
  print(createHeader(inputFile: inputFile))

  print("import Core")
  print("import Lexer")
  print("import Foundation")
  print()

  print("// swiftlint:disable superfluous_disable_command")
  print("// swiftlint:disable line_length")
  print("// swiftlint:disable file_length")
  print("// swiftlint:disable trailing_newline")
  print("// swiftlint:disable vertical_whitespace_closing_braces")
  print("")

  for entity in parse(url: inputFile) {
    switch entity {
    case let .enum(e):
      emitEnum(e)
    case let .struct(s):
      emitProduct(keyword: "struct", def: s)
    case let .class(c):
      emitProduct(keyword: "class", def: c)
      printEquatable(c)
    }
  }
}

// MARK: - Enum

private func emitEnum(_ def: EnumDef) {
  printDoc(def.doc)

  let bases = createBases(def.bases)
  let indirect = def.isIndirect ? "indirect " : ""
  print("public \(indirect)enum \(def.name)\(bases) {")

  // emit `case xxx([Statement])`
  for caseDef in def.cases {
    printDoc(caseDef.doc, indent: 2)

    var properties = ""
    if !caseDef.properties.isEmpty {
      properties += "("
      properties += caseDef.properties.map { $0.nameColonType ?? $0.type }.joined(", ")
      properties += ")"
    }

    print("  case \(caseDef.escapedName)\(properties)")
  }
  print("")

  // emit `var isXXX: Bool {`
  for caseDef in def.cases where !caseDef.properties.isEmpty {
    print("""
        public var is\(pascalCase(caseDef.name)): Bool {
          if case .\(caseDef.name) = self { return true }
          return false
        }

      """)
  }

  print("}")
  print()
}

// MARK: - Product

private func emitProduct<T: ProductType>(keyword: String, def: T) {
  let bases = createBases(def.bases)

  print("// MARK: - \(def.name)")
  print()

  printDoc(def.doc)
  print("public \(keyword) \(def.name)\(bases) {")
  print()

  for property in def.properties {
    printDoc(property.doc, indent: 2)
    print("  public var \(property.nameColonType)")
  }
  print()

  printInit(def: def)
  printVisitor(def: def)

  print("}")
  print()
}

// MARK: - Init

private func printInit<T: ProductType>(def: T) {
  if def.isASTSubclass || def.isStmtSubclass || def.isExprSubclass {
    printSubclassInit(def: def)
    return
  }


  print("  public init(")
  for (index, prop) in def.properties.enumerated() {
    let isLast = index == def.properties.count - 1
    let comma = isLast ? "" : ","
    print("    \(prop.nameColonType)\(comma)")
  }
  print("  ) {")

  for property in def.properties {
    print("    self.\(property.name) = \(property.name)")
  }

  print("  }")
  print()
}

private func printSubclassInit<T: ProductType>(def: T) {
  let isUsingSuperInit = def.properties.isEmpty
  if isUsingSuperInit {
    return
  }

   print("  public init(")
   print("    id: ASTNodeId,")
   for prop in def.properties {
     print("    \(prop.nameColonType),")
   }
   print("    start: SourceLocation,")
   print("    end: SourceLocation")
   print("  ) {")

   for property in def.properties {
     print("    self.\(property.name) = \(property.name)")
   }

  print("    super.init(id: id, start: start, end: end)")
   print("  }")
   print()
}

private func productPropertyInit(_ prop: ProductProperty) -> String {
  let prefix = prop.underscoreInit ? "_ " : ""
  return prefix + prop.nameColonType
}

// MARK: - Visitor

private func printVisitor<T: ProductType>(def: T) {
  let visitorType = def.astVisitorTypeName

  if def.isAST || def .isStmt || def.isExpr {
    print("""
  public func accept<V: \(visitorType)>(_ visitor: V) throws -> V.PassResult {
    trap("'accept' method should be overriden in subclass")
  }

""")
  }

  if def.isASTSubclass || def.isStmtSubclass || def.isExprSubclass {
    print("""
  override public func accept<V: \(visitorType)>(_ visitor: V) throws -> V.PassResult {
    try visitor.visit(self)
  }

""")
  }
}

// MARK: - Equatable

private func printEquatable(_ def: ClassDef) {
  guard def.bases.contains("Equatable") else {
    return
  }

  let type = def.name
  print("extension \(type) {")
  print("  public static func == (lhs: \(type), rhs: \(type)) -> Bool {")

  for prop in def.properties {
    let name = prop.name
    print("    guard lhs.\(name) == rhs.\(name) else { return false }")
  }

  print("    return true")
  print("  }")

  print("}")
  print()
}
// MARK: - Common

private func createBases(_ bases: [String]) -> String {
  return bases.isEmpty ? "" : ": " + bases.joined(", ")
}

private func printDoc(_ doc: String?, indent indentCount: Int = 0) {
  guard let doc = doc else { return }

  let indent = String(repeating: " ", count: indentCount)
  let split = doc.split(separator: "\n",
                        maxSplits: .max,
                        omittingEmptySubsequences: false)

  for line in split {
    print("\(indent)/// \(line)")
  }
}

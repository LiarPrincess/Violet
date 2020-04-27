import Foundation

public func emitAst(inputFile: URL, outputFile: URL) {
  withRedirectedStandardOutput(to: outputFile) {
    emitAst(inputFile: inputFile)
  }
}

private func emitAst(inputFile: URL) {
  print(createHeader(inputFile: inputFile))

  print("import VioletCore")
  print("import VioletLexer")
  print("import Foundation")
  print()

  print("// swiftlint:disable file_length")
  print("// swiftlint:disable trailing_newline")
  print("// swiftlint:disable vertical_whitespace")
  print("// swiftlint:disable vertical_whitespace_closing_braces")
  print("")

  let entities = parse(url: inputFile)
  for entity in entities {
    switch entity {
    case let .enum(e):
      printEnum(e)
    case let .struct(s):
      printProduct(keyword: "struct", def: s)
    case let .class(c):
      let keyword = hasSubclass(class: c, in: entities) ? "class" : "final class"
      printProduct(keyword: keyword, def: c)
      printEquatable(c)
    }
  }
}

private func hasSubclass(class: ClassDef, in other: [Entity]) -> Bool {
  let className = `class`.name

  for entity in other {
    switch entity {
    case let .class(c):
      if c.bases.contains(className) {
        return true
      }
    case .enum,
         .struct:
      break
    }
  }

  return false
}

// MARK: - Enum

private func printEnum(_ def: EnumDef) {
  printDoc(def.doc)

  let bases = createBases(def.bases)
  let indirect = def.isIndirect ? "indirect " : ""
  print("public \(indirect)enum \(def.name)\(bases), CustomStringConvertible {")

  // print `case xxx([Statement])`
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

  // print `var isXXX: Bool {`
  for caseDef in def.cases where !caseDef.properties.isEmpty {
    print("""
        public var is\(pascalCase(caseDef.name)): Bool {
          if case .\(caseDef.name) = self { return true }
          return false
        }

      """)
  }

  printDescription()

  print("}")
  print()
}

// MARK: - Product

private func printProduct<T: ProductType>(keyword: String, def: T) {
  let bases = createBases(def.bases)

  print("// MARK: - \(def.name)")
  print()

  let isSubclass = def.isASTSubclass || def.isStmtSubclass || def.isExprSubclass
  let hasDescr = !isSubclass
  let descrProtocol = hasDescr ? ", CustomStringConvertible" : ""

  printDoc(def.doc)
  print("public \(keyword) \(def.name)\(bases)\(descrProtocol) {")
  print()

  for property in def.properties {
    printDoc(property.doc, indent: 2)
    print("  public var \(property.nameColonType)")
  }
  print()

  if hasDescr {
    printDescription()
  }

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

  let isExpr = def.isExprSubclass

  print("  public init(")
  print("    id: ASTNodeId,")
  for prop in def.properties {
    print("    \(prop.nameColonType),")
  }
  if isExpr {
    print("    context: ExpressionContext,")
  }
  print("    start: SourceLocation,")
  print("    end: SourceLocation")
  print("  ) {")

  for property in def.properties {
    print("    self.\(property.name) = \(property.name)")
  }

  if isExpr {
    print("    super.init(id: id, context: context, start: start, end: end)")
  } else {
    print("    super.init(id: id, start: start, end: end)")
  }
  print("  }")
  print()
}

private func productPropertyInit(_ prop: ProductProperty) -> String {
  let prefix = prop.underscoreInit ? "_ " : ""
  return prefix + prop.nameColonType
}

// MARK: - Visitor

// swiftlint:disable:next function_body_length
private func printVisitor<T: ProductType>(def: T) {
  guard let prefix = def.visitorPrefix else { return }

  if def.isAST || def .isStmt || def.isExpr {
    print("""
      public func accept<V: \(prefix)Visitor>(
          _ visitor: V
      ) throws -> V.\(prefix)Result {
        trap("'accept' method should be overriden in subclass")
      }

      public func accept<V: \(prefix)VisitorWithPayload>(
          _ visitor: V,
          payload: V.\(prefix)Payload
      ) throws -> V.\(prefix)Result {
        trap("'accept' method should be overriden in subclass")
      }

    """)
  }

  if def.isASTSubclass || def.isStmtSubclass || def.isExprSubclass {
    print("""
      override public func accept<V: \(prefix)Visitor>(
          _ visitor: V
      ) throws -> V.\(prefix)Result {
        try visitor.visit(self)
      }

      override public func accept<V: \(prefix)VisitorWithPayload>(
          _ visitor: V,
          payload: V.\(prefix)Payload
      ) throws -> V.\(prefix)Result {
        try visitor.visit(self, payload: payload)
      }

    """)
  }
}

// MARK: - Description

private func printDescription() {
  print("""
    public var description: String {
      let printer = ASTPrinter()
      let doc = printer.visit(self)
      return doc.layout()
    }

  """)
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

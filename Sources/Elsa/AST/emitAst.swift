import Foundation

// cSpell:ignore kwonlyargs

public func emitAst(inputFile: URL, outputFile: URL) {
  withRedirectedStandardOutput(to: outputFile) {
    emitAst(inputFile: inputFile)
  }
}

private func emitAst(inputFile: URL) {
  print(createHeader(inputFile: inputFile))

  print("import Foundation")
  print("import BigInt")
  print("import VioletCore")
  print("import VioletLexer")
  print()

  print("// swiftlint:disable file_length")
  print("// swiftlint:disable trailing_newline")
  print("// swiftlint:disable vertical_whitespace")
  print("// swiftlint:disable vertical_whitespace_closing_braces")
  print("// cSpell:ignore kwonlyargs")
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
    }
  }
}

// MARK: - Enum

private func printEnum(_ def: EnumDef) {
  print("// MARK: - \(def.name)")
  print()

  var indent = ""
  if let parent = def.nestedInside {
    indent = "  "
    print("extension \(parent) {")
    print()
  }

  let indirect = def.isIndirect ? "indirect " : ""
  let bases = joinBases(def.bases + ["CustomStringConvertible"])

  printDoc(def.doc, indent: indent)
  print("\(indent)public \(indirect)enum \(def.name)\(bases) {")
  print()

  printCases(def, indent: indent)
  print()

  printCustomStringConvertible(indent: indent)

  if def.nestedInside != nil {
    print("  }")
  }
  print("}")
  print()
}

private func printCases(_ def: EnumDef, indent: String) {
  for caseDef in def.cases {
    printDoc(caseDef.doc, indent: indent + "  ")

    var properties = ""
    if !caseDef.properties.isEmpty {
      properties += "("
      properties += caseDef.properties
        .map { $0.nameColonType ?? $0.type }
        .joined(", ")
      properties += ")"
    }

    let name = caseDef.escapedName
    print("  \(indent)case \(name)\(properties)")
  }
}

// MARK: - Product

private func printProduct<T: ProductType>(keyword: String, def: T) {
  print("// MARK: - \(def.name)")
  print()

  var indent = ""
  if let parent = def.nestedInside {
    indent = "  "
    print("extension \(parent) {")
    print()
  }

  printDoc(def.doc, indent: indent)

  // Avoid repeated conformance to 'CustomStringConvertible'
  let isSubclass = def.isASTSubclass || def.isStmtSubclass || def.isExprSubclass
  let hasCustomStringConvertible = !isSubclass

  printName(keyword: keyword,
            def: def,
            hasCustomStringConvertible: hasCustomStringConvertible,
            indent: indent)
  print()

  if !def.properties.isEmpty {
    printProperties(def: def, indent: indent)
    print()
  }

  if hasCustomStringConvertible {
    printCustomStringConvertible(indent: indent)
    print()
  }

  printInit(def: def, indent: indent)
  print()
  printVisitor(def: def)
  print()

  if def.nestedInside != nil {
    print("  }")
  }
  print("}")
  print()
}

private func printName<T: ProductType>(keyword: String,
                                       def: T,
                                       hasCustomStringConvertible: Bool,
                                       indent: String) {
  var baseClassNames = def.bases
  if hasCustomStringConvertible {
    baseClassNames.append("CustomStringConvertible")
  }

  let bases = joinBases(baseClassNames)
  print("\(indent)public \(keyword) \(def.name)\(bases) {")
}

private func printProperties<T: ProductType>(def: T, indent: String) {
  for propertyDef in def.properties {
    printDoc(propertyDef.doc, indent: indent + "  ")
    print("  \(indent)public var \(propertyDef.nameColonType)")
  }
}

// MARK: - Init

private func printInit<T: ProductType>(def: T, indent: String) {
  if def.isASTSubclass || def.isStmtSubclass || def.isExprSubclass {
    printSubclassInit(def: def, indent: indent)
    return
  }

  print("  \(indent)public init(")
  for (index, prop) in def.properties.enumerated() {
    let isLast = index == def.properties.count - 1
    let comma = isLast ? "" : ","
    print("    \(indent)\(prop.nameColonType)\(comma)")
  }
  print("  \(indent)) {")

  for property in def.properties {
    print("    \(indent)self.\(property.name) = \(property.name)")
  }

  print("  \(indent)}")
}

private func printSubclassInit<T: ProductType>(def: T, indent: String) {
  let isUsingSuperInit = def.properties.isEmpty
  if isUsingSuperInit {
    return
  }

  let isExpr = def.isExprSubclass

  print("  \(indent)public init(")
  print("    \(indent)id: ASTNodeId,")
  for prop in def.properties {
    print("    \(indent)\(prop.nameColonType),")
  }
  if isExpr {
    print("    \(indent)context: ExpressionContext,")
  }
  print("    \(indent)start: SourceLocation,")
  print("    \(indent)end: SourceLocation")
  print("  \(indent)) {")

  for property in def.properties {
    print("    \(indent)self.\(property.name) = \(property.name)")
  }

  if isExpr {
    print("    \(indent)super.init(id: id, context: context, start: start, end: end)")
  } else {
    print("    \(indent)super.init(id: id, start: start, end: end)")
  }
  print("  \(indent)}")
}

private func productPropertyInit(_ prop: ProductProperty) -> String {
  let prefix = prop.underscoreInit ? "_ " : ""
  return prefix + prop.nameColonType
}

// MARK: - Visitor

// swiftlint:disable:next function_body_length
private func printVisitor<T: ProductType>(def: T) {
  guard let prefix = getVisitorPrefix(def: def) else { return }

  if def.isAST || def.isStmt || def.isExpr {
    print("""
      public func accept<V: \(prefix)Visitor>(
          _ visitor: V
      ) throws -> V.\(prefix)Result {
        trap("'accept' method should be overridden in subclass")
      }

      public func accept<V: \(prefix)VisitorWithPayload>(
          _ visitor: V,
          payload: V.\(prefix)Payload
      ) throws -> V.\(prefix)Result {
        trap("'accept' method should be overridden in subclass")
      }
    """)
  } else if def.isASTSubclass || def.isStmtSubclass || def.isExprSubclass {
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

private func getVisitorPrefix<T: ProductType>(def: T) -> String? {
  if def.isAST || def.isASTSubclass {
    return "AST"
  }

  if def.isStmt || def.isStmtSubclass {
    return "Statement"
  }

  if def.isExpr || def.isExprSubclass {
    return "Expression"
  }

  return nil
}

// MARK: - Description

private func printCustomStringConvertible(indent: String) {
  print("""
    \(indent)public var description: String {
    \(indent)  let printer = ASTPrinter()
    \(indent)  let doc = printer.visit(self)
    \(indent)  return doc.layout()
    \(indent)}
  """)
}

// MARK: - Common

private func joinBases(_ bases: [String]) -> String {
  return bases.isEmpty ? "" : ": " + bases.joined(", ")
}

import Foundation

public func emitBytecode(inputFile: URL, outputFile: URL) {
  withRedirectedStandardOutput(to: outputFile) {
    emitBytecode(inputFile: inputFile)
  }
}

private func emitBytecode(inputFile: URL) {
  print(createHeader(inputFile: inputFile))

  print("import Foundation")
  print("import VioletCore")
  print()

  print("// swiftlint:disable superfluous_disable_command")
  print("// swiftlint:disable line_length")
  print("// swiftlint:disable file_length")
  print("// swiftlint:disable trailing_newline")
  print("// swiftlint:disable vertical_whitespace_closing_braces")
  print("")

  let entities = parse(url: inputFile)

  for entity in entities {
    switch entity {
    case let .enum(e):
      emitEnum(e)
    case let .struct(s):
      emitProduct(keyword: "struct", def: s)
    case let .class(c):
      let keyword = hasSubclass(class: c, in: entities) ? "class" : "final class"
      emitProduct(keyword: keyword, def: c)
    }
  }
}

// MARK: - Enum

private func emitEnum(_ def: EnumDef) {
  var indent = ""
  if let parent = def.nestedInside {
    indent = "  "
    print("extension \(parent) {")
    print()
  }

  let bases = createBases(def.bases)
  let indirect = def.isIndirect ? "indirect " : ""

  printDoc(def.doc, indent: indent)
  print("\(indent)public \(indirect)enum \(def.name)\(bases) {")

  for caseDef in def.cases {
    printDoc(caseDef.doc, indent: indent + "  ")

    var properties = ""
    if !caseDef.properties.isEmpty {
      properties += "("
      properties += caseDef.properties.map { $0.nameColonType ?? $0.type }.joined(", ")
      properties += ")"
    }

    print("\(indent)  case \(caseDef.escapedName)\(properties)")
  }

  if def.nestedInside != nil {
    print("  }")
  }
  print("}")
  print()
}

// MARK: - Product

private func emitProduct<T: ProductType>(keyword: String, def: T) {
  assert(def.nestedInside == nil)
  let bases = createBases(def.bases)

  printDoc(def.doc, indent: "")
  print("public \(keyword) \(def.name)\(bases) {")
  print()

  for property in def.properties {
    printDoc(property.doc, indent: "  ")
    print("  public let \(property.nameColonType)")
  }
  print()

  let initArgs = def.properties.map(productPropertyInit).joined(", ")
  print("  public init(\(initArgs)) {")
  for property in def.properties {
    print("    self.\(property.name) = \(property.name)")
  }
  print("  }")

  print("}")
  print()
}

private func productPropertyInit(_ prop: ProductProperty) -> String {
  let prefix = prop.underscoreInit ? "_ " : ""
  return prefix + prop.nameColonType
}

// MARK: - Common

private func createBases(_ bases: [String]) -> String {
  return bases.isEmpty ? "" : ": " + bases.joined(", ")
}

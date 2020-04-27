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

  for entity in parse(url: inputFile) {
    switch entity {
    case let .enum(e):
      emitEnum(e)
    case let .struct(s):
      emitProduct(keyword: "struct", def: s)
    case let .class(c):
      emitProduct(keyword: "class", def: c)
      emitEquatable(c)
    }
  }
}

// MARK: - Enum

private func emitEnum(_ def: EnumDef) {
  printDoc(def.doc)

  var indent = ""
  if let parent = def.nestedInside {
    indent = "  "
    print("extension \(parent) {")
  }

  let bases = createBases(def.bases)
  let indirect = def.isIndirect ? "indirect " : ""
  print("\(indent)public \(indirect)enum \(def.name)\(bases) {")

  // emit `case single([Statement])`
  for caseDef in def.cases {
    printDoc(caseDef.doc, indent: indent.count + 2)

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
  let bases = createBases(def.bases)

  printDoc(def.doc)
  print("public \(keyword) \(def.name)\(bases) {")
  print()

  for property in def.properties {
    printDoc(property.doc, indent: 2)
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

private func emitEquatable(_ def: ClassDef) {
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

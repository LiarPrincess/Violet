// We could go with fancy 'String.StringInterpolation', but it always looks
// like an hack.

internal func emitCode(entities: [Entity]) {
  print("import Foundation")
  print("import Core")
  print("import Lexer")
  print()

  print("// swiftlint:disable line_length")
  print("// swiftlint:disable trailing_newline")
  print()

  for entity in entities {
    switch entity {
    case .enum(let e): emitEnum(e)
    case .struct(let s): emitStruct(s)
    }
  }
}

private func emitEnum(_ enumDef: EnumDef) {
  emitDoc(enumDef.doc, indent: 0)
  let indirect = enumDef.indirect ? "indirect " : ""
  print("public \(indirect)enum \(enumDef.name): Equatable {")

  for caseDef in enumDef.cases {
    emitDoc(caseDef.doc, indent: 2)

    var properties = ""
    if !caseDef.properties.isEmpty {
      properties += "("
      properties += caseDef.properties.map { $0.nameColonType ?? $0.type }.joined(", ")
      properties += ")"
    }

    print("  case \(caseDef.escapedName)\(properties)")
  }

  print("}")
  print()
}

private func emitStruct(_ structDef: StructDef) {
  emitDoc(structDef.doc, indent: 0)
  print("public struct \(structDef.name): Equatable {")
  print()

  for property in structDef.properties {
    emitDoc(property.doc, indent: 2)
    print("  public let \(property.nameColonType)")
  }
  print()

  let initArgs = structDef.properties.map { $0.nameColonType }.joined(", ")
  print("  public init(\(initArgs)) {")
  for property in structDef.properties {
    print("    self.\(property.name) = \(property.name)")
  }
  print("  }")

  print("}")
  print()
}

private func emitDoc(_ doc: String?, indent indentCount: Int) {
  guard let doc = doc else { return }

  let indent = String(repeating: " ", count: indentCount)
  for line in doc.split(separator: "\n") {
    print("\(indent)/// \(line)")
  }
}

// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// We could go with fancy 'String.StringInterpolation', but it always looks
// like an hack.

// TODO: (Elsa) _ in init
// TODO: (Elsa) @str
// TODO: To class and line() write()

internal func emitCode(entities: [Entity]) {
  print("import Foundation")
  print("import Core")
  print("import Lexer")
  print()

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
  let indirect = enumDef.indirect ? "indirect " : ""
  print("public \(indirect)enum \(enumDef.name): Equatable {")

  for caseDef in enumDef.cases {
    emitDoc(caseDef.doc, indent: 2)

    var properties = ""
    if !caseDef.properties.isEmpty {
      properties += "("
      properties += caseDef.properties.map { nameColonType($0) }.joined(", ")
      properties += ")"
    }

    print("  case \(caseDef.escapedName)\(properties)")
  }

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

private func emitStruct(_ structDef: StructDef) {
  print("public struct \(structDef.name): Equatable {")
  print()

  for property in structDef.properties {
    print("  public let \(nameColonType(property))")
  }
  print()

  let initArgs = structDef.properties.map { nameColonType($0) }.joined(", ")
  print("  public init(\(initArgs)) {")
  for property in structDef.properties {
    guard let name = property.name else { fatalError() }
    print("    self.\(name) = \(name)")
  }
  print("  }")

  print("}")
  print()
}

private func nameColonType(_ p: Property) -> String {
  return p.name.map { "\($0): \(p.type)" } ?? p.type
}

// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable trailing_closure

// We could go with fancy 'String.StringInterpolation', but it always looks
// like an hack.

// TODO: (Elsa) _ in init
// TODO: (Elsa) @str

internal func emitCode(entities: [Entity]) {
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
  print("""
  public \(indirect)enum \(enumDef.name) {
  \(enumDef.cases.map(enumCase).joined(separator: "\n"))
  }

  """)
}

private func enumCase(_ caseDef: EnumCaseDef) -> String {
  var result = ""

  if let doc = caseDef.doc {
    for line in doc.split(separator: "\n") {
      result += "  /// \(line)\n"
    }
  }

  result += "  case \(caseDef.escapedName)"

  if !caseDef.properties.isEmpty {
    result += "("
    result += caseDef.properties.map { $0.nameColonType }.joined(", ")
    result += ")"
  }

  return result
}

private func emitStruct(_ structDef: StructDef) {
  func forEachProperty(_ f: (Property) -> String, separator: String = "\n") -> String {
    return structDef.properties.map(f).joined(separator)
  }

  print("""
  public struct \(structDef.name) {

  \(forEachProperty({ "  public let \($0.nameColonType)" }))

    public init(\(forEachProperty({ $0.nameColonType }, separator: ", "))) {
  \(forEachProperty({ "    self.\($0.name) = \($0.name)" }))
    }
  }

  """)
}

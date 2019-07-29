// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

internal func emitDescription(entities: [Entity]) {
  print("import Foundation")
  print("import Core")
  print("import Lexer")
  print()

  print("// swiftlint:disable trailing_newline")
  print("// swiftlint:disable line_length")
  print()

  for entity in entities {
    switch entity {
    case .enum(let e): emitEnum(e)
    case .struct(let s): emitStruct(s)
    }
  }
}

// swiftlint:disable:next function_body_length
private func emitEnum(_ enumDef: EnumDef) {
  print("extension \(enumDef.name): CustomStringConvertible {")

  print("  public var description: String {")
  print("    switch self {")
  for caseDef in enumDef.cases {
    if caseDef.properties.isEmpty {
      print("    case .\(caseDef.name): return \"\(caseDef.name)\"")
    } else {
      var bindings = ""
      var values = ""

      for (index, property) in caseDef.properties.enumerated() {
        if let name = property.name {
          let variableName = camelCase(name)
          bindings += "\(name): \(variableName)"
          values += "\(name): \\(\(variableName)))"
        } else {
          let variableName = "p\(index)"
          bindings += variableName
          values += "\\(\(variableName))"
        }

        let isLast = index == caseDef.properties.count - 1
        bindings = isLast ? bindings : bindings + ", "
        values = isLast ? values : values + ", "
      }

      print("    case let .\(caseDef.name)(\(bindings)):")
      print("      return \"\(caseDef.name)(\(values))\"")
    }
  }
  print("    }")

  print("  }")
  print("}")
  print()
}

private func emitStruct(_ structDef: StructDef) {
  print("extension \(structDef.name): CustomStringConvertible {")

  print("  public var description: String {")

  // we could use .join, but for simetry with enum we use .enumerated()
  var properties = ""
  for (index, property) in structDef.properties.enumerated() {
    properties += "\(property.name): \\(self.\(property.name))"

    let isLast = index == structDef.properties.count - 1
    properties = isLast ? properties : properties + ", "
  }
  print("    return \"\(structDef.name)(\(properties))\"")
  print("  }")

  print("}")
  print()
}

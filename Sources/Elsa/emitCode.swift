// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

internal func emitCode(entities: [Entity]) {
  for entity in entities {
    switch entity {
    case .enum(let e): emitEnum(e)
    case .struct: break
    }
  }
}

private func emitEnum(_ enum: Enum) {
  print("public enum \(`enum`.name) {")
  `enum`.cases.forEach(emitEnumCase(_:))
  print("}")
  print()
}

private func emitEnumCase(_ enumCase: EnumCase) {
  printInline("  case \(enumCase.name)")

  if !enumCase.properties.isEmpty {
    print("(")
    for (index, property) in enumCase.properties.enumerated() {
      let type = getType(property)
      print("    \(property.name): \(type),")

//      let isLast = index == enumCase.properties.count - 1
//      if !isLast {
//        printInline(", ")
//      }
    }
    printInline("  )")
  }

  print()
}

private func getType(_ property: Property) -> String {
  switch property.kind {
  case .default:  return property.type
  case .many:     return "[\(property.type)]"
  case .optional: return property.type + "?"
  }
}

func printInline(_ item: Any) {
  print(item, terminator: "")
}

import Foundation

/// Case name -> value to print
private let specialCases = [
  // Instruction.CompareType
  "equal" : "==",
  "notEqual" : "!=",
  "less" : "<",
  "lessEqual" : "<=",
  "greater" : ">",
  "greaterEqual" : ">="
]

class EmitBytecodeDescriptionVisitor: BytecodeFileVisitor {

  // MARK: - Header

  override func printHeader() {
    print("import VioletCore")
    print("import Foundation")
    print()

    print("// swiftlint:disable file_length")
    print()
  }

  // MARK: - Footer

  override func printFooter() {
    print("""
    private func hex(_ value: UInt8) -> String {
      let s = String(value, radix: 16, uppercase: false)
      let prefix = s.count < 2 ? \"0\" : \"\"
      return \"0x\" + prefix + s
    }
    """)
  }

  // MARK: - Enum

  override func printIndirectEnum(_ def: Enumeration) {
    self.printEnum(def)
  }

  override func printEnum(_ def: Enumeration) {
    let name = def.name.afterResolvingAlias
    let parentDot = def.enclosingTypeName.map { $0.afterResolvingAlias + "." } ?? ""
    print("extension \(parentDot)\(name): CustomStringConvertible {")

    print("  public var description: String {")
    print("    switch self {")

    for caseDef in def.cases {
      let name = caseDef.name
      let escapedName = caseDef.escapedName

      if let specialCase = specialCases[name] {
        print("    case .\(escapedName):")
        print("      return \"\(specialCase)\"")
      } else if caseDef.properties.isEmpty {
        print("    case .\(escapedName):")
        print("      return \"\(name)\"")
      } else {
        let properties = createCasePropertyBinding(caseDef)
        print("    case let .\(escapedName)(\(properties.bindings)):")
        print("      return \"\(name)(\(properties.description))\"")
      }
    }

    print("    }") // switch
    print("  }") // var description
    print("}")
    print("")
  }
}

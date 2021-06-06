class EmitBytecodeFilledDescriptionVisitor: BytecodeFileVisitor {

  override func printFileContent() {
    print("import Foundation")
    print("import VioletCore")
    print()

    let instructionsName = Self.instructionEnumName
    let filledName = Self.filledEnumName
    print("extension \(instructionsName).\(filledName): CustomStringConvertible {")
    print()
    print("  public var description: String {")
    print("    switch self {")
    self.printSwitchCases()
    print("    }") // switch end
    print("  }") // 'Filled' end
    print("}") // extension end
  }

  private func printSwitchCases() {
    let filledInstructions = self.getFilledInstructions()
    for instruction in filledInstructions {
      let name = instruction.name
      let escapedName = instruction.escapedName

      var `let` = ""
      var propBinding = ""
      var propPrinting = ""
      if !instruction.properties.isEmpty {
        `let` = "let "
        propBinding += "("
        propPrinting += "("

        for p in instruction.properties {
          let comma = p.isLast ? "" : ", "
          let labelColonSpace = p.label.map { $0 + ": " } ?? ""
          let bindingName = "value" + String(describing: p.index)

          // 'label: value0, '
          propBinding += "\(labelColonSpace)\(bindingName)\(comma)"
          // 'label: \(format(value0)), '
          propPrinting += "\(labelColonSpace)\\(\(bindingName))\(comma)"
        }

        propBinding += ")"
        propPrinting += ")"
      }

      let indent = "    "
      print("\(indent)case \(`let`).\(escapedName)\(propBinding):")
      print("\(indent)  return \"\(name)\(propPrinting)\"")
    }
  }
}

class EmitBytecodeFilledVisitor: BytecodeFileVisitor {

  override func printFileContent() {
    print("import Foundation")
    print("import VioletCore")
    print()

    print("// swiftlint:disable line_length")
    print()

    print("extension \(Self.instructionEnumName) {")
    print()
    print("  /// Instruction with proper typed argument taken from `CodeObject`.")
    print("  ///")
    print("  /// Can be used for utility functionality (like printing),")
    print("  /// but the performance is not adequate for `VM` use.")
    print("  public enum \(Self.filledEnumName): Equatable {")

    let filledInstructions = self.getFilledInstructions()
    for instruction in filledInstructions {
      let escapedName = instruction.escapedName

      var properties = ""
      if !instruction.properties.isEmpty {
        properties += "("
        for p in instruction.properties {
          let comma = p.isLast ? "" : ", "
          let label = p.label.map { $0 + ": " } ?? ""
          properties += label + p.type + comma
        }
        properties += ")"
      }

      let indent = "      "
      printDoc(instruction.doc, indent: indent)
      print("\(indent)case \(escapedName)\(properties)")
    }

    print("  }") // 'Filled' end
    print("}") // extension end
  }
}

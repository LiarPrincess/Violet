class EmitBytecodeDocumentationVisitor: BytecodeFileVisitor {

  /// Warning at the top of the file
  override func createDoNotEditWarning() -> String {
    return """
    (This file was auto-generated by Elsa from `\(self.filename).`
    DO NOT EDIT!)

    Nomenclature:
    - `TOS` - top of the stack
    - `TOS1` - item after `TOS`
    - `TOS2` - item after after `TOS`

    """
  }

  override func printFileContent() {
    print("|Instruction|Description|")
    print("|-----------|-----------|")

    let instructionsEnum = self.getInstructionEnum()
    for c in instructionsEnum.cases {
      let name = c.name
      let doc = c.doc?.formatForPrintingInMarkdownTable(indent: "") ?? ""

      var properties = ""
      if !c.properties.isEmpty {
        properties += "("
        for (index, p) in c.properties.enumerated() {
          let isLast = index == c.properties.count - 1
          let commaSpace = isLast ? "" : ", "

          let labelColonSpace = p.name.map { $0 + ": " } ?? ""
          let type = p.type.inFile
          properties += labelColonSpace + type + commaSpace
        }
        properties += ")"
      }

      let instruction = "\(name)\(properties)"
      print("|\(instruction)|\(doc)|")
    }
  }
}

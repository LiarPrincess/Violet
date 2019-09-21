// Used when generating 'Frame ceval'.
// NOT USED ANYMORE!

private struct Instruction {
  fileprivate let name: String
  fileprivate let argName: String
  fileprivate let argType: String
}

public final class CodeObjectEvalEmitter: EmitterBase {

  public func emit(entities: [Entity], imports: [String]) {
    let instructions = self.getInstructions(from: entities)

    for instruction in instructions.cases {
      self.emitCases(instruction: instruction)
    }

    self.write("")
    self.write("")
    self.write("")
    self.write("")

    for instruction in instructions.cases {
      self.emitFunc(instruction: instruction)
    }
  }

  private func getInstructions(from entities: [Entity]) -> EnumDef {
    for entity in entities {
      switch entity {
      case let .enum(e) where e.name == "Instruction":
        return e
      default:
        break
      }
    }
    fatalError("[CodeObjectEvalEmitter] Unable to find `Instructions` enum.")
  }

  private func emitCases(instruction: EnumCaseDef) {
    if instruction.properties.isEmpty {
      self.write("case .\(instruction.escapedName):")
      self.write("  try self.\(instruction.escapedName)()")
    } else {
      let binding = instruction.properties[0].name ?? "value"
      self.write("case let .\(instruction.escapedName)(\(binding)):")
      let arg = "extendedArg + Int(\(binding))"
      self.write("  try self.\(instruction.escapedName)(\(binding): \(arg))")
    }
  }

  private func emitFunc(instruction: EnumCaseDef) {
    self.emitDoc(instruction.doc, indent: 0)

    if instruction.properties.isEmpty {
      self.write("internal func \(instruction.escapedName)() throws {")
      self.write("}")
    } else {
      let binding = instruction.properties[0].name ?? "value"
      self.write("internal func \(instruction.escapedName)(\(binding): Int) throws {")
      self.write("}")
    }
    self.write("")
  }

  private func emitDoc(_ doc: String?, indent indentCount: Int) {
    guard let doc = doc else { return }

    let indent = String(repeating: " ", count: indentCount)
    for line in doc.split(separator: "\n", maxSplits: .max, omittingEmptySubsequences: false) {
      self.write("\(indent)/// \(line)")
    }
  }
}

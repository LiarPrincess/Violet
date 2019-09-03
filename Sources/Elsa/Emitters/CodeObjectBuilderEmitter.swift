public final class CodeObjectBuilderEmitter: EmitterBase {

  public func emit(entities: [Entity], imports: [String]) {
    self.writeHeader(command: "code-object-builder")

    self.write("public struct CodeObjectBuilder {")
    for entity in entities {
      switch entity {
      case let .enum(e) where e.name == "Instruction":
        for instruction in e.cases {
          self.emitBuilder(instruction: instruction)
        }
      default:
        break
      }
    }
    self.write("}")
  }

  private struct Argument {
    fileprivate var name: String
    fileprivate var type: String
  }

  private func emitBuilder(instruction: EnumCaseDef) {
    let pascalName = pascalCase(instruction.name)
    let article = getArticle(instruction.name)

    var arguments = [Argument]()
    for property in instruction.properties {
      let name = property.name ?? "value"
      arguments.append(Argument(name: name, type: property.type))
    }
    arguments.append(Argument(name: "location", type: "SourceLocation"))

    self.write("")
    self.write("  /// Append \(article) `\(instruction.name)` instruction to code object.")
    self.write("  public func emit\(pascalName)(", terminator: "")
    self.write(arguments.map { $0.name + ": " + $0.type }.joined(", "), terminator: "")
    self.write(") throws {")

    if instruction.properties.isEmpty {
      self.write("    try self.emit(.\(instruction.name), location: location)")
    } else {
      self.write("    // try self.emit(.\(instruction.name), location: location)")
      self.write("    throw self.unimplemented()")
    }

    self.write("  }")
  }
}

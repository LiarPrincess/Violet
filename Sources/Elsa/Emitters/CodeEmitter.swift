// Emit code for given entities (the same for AST, bytecode etc.).

public final class CodeEmitter: EmitterBase {

  public func emit(entities: [Entity], imports: [String]) {
    self.writeHeader(command: "code")

    for i in imports {
      self.write("import \(i)")
    }
    self.write()

    self.write("// swiftlint:disable superfluous_disable_command")
    self.write("// swiftlint:disable type_body_length")
    self.write("// swiftlint:disable line_length")
    self.write("// swiftlint:disable file_length")
    self.write("// swiftlint:disable trailing_newline")
    self.write("// swiftlint:disable vertical_whitespace_closing_braces")
    self.write()

    for entity in entities {
      switch entity {
      case .enum(let e): self.emitEnum(e)
      case .struct(let s): self.emitStruct(s)
      }
    }
  }

  // MARK: - Enum

  private func emitEnum(_ enumDef: EnumDef) {
    self.emitDoc(enumDef.doc, indent: 0)

    let bases = self.compileBases(enumDef.bases)
    let indirect = enumDef.indirect ? "indirect " : ""
    self.write("public \(indirect)enum \(enumDef.name)\(bases) {")

    // emit `case single([Statement])`
    for caseDef in enumDef.cases {
      self.emitDoc(caseDef.doc, indent: 2)

      var properties = ""
      if !caseDef.properties.isEmpty {
        properties += "("
        properties += caseDef.properties.map { $0.nameColonType ?? $0.type }.joined(", ")
        properties += ")"
      }

      self.write("  case \(caseDef.escapedName)\(properties)")
    }
    self.write()

    // emit `var isSingle: Bool {`
    for caseDef in enumDef.cases where !caseDef.properties.isEmpty {
      self.write("  public var is\(pascalCase(caseDef.name)): Bool {")
      self.write("    if case .\(caseDef.name) = self { return true }")
      self.write("    return false")
      self.write("  }")
      self.write()
    }

    self.write("}")
    self.write()
  }

  // MARK: - Struct

  private func emitStruct(_ structDef: StructDef) {
    let bases = self.compileBases(structDef.bases)

    self.emitDoc(structDef.doc, indent: 0)
    self.write("public struct \(structDef.name)\(bases) {")
    self.write()

    for property in structDef.properties {
      self.emitDoc(property.doc, indent: 2)
      self.write("  public let \(property.nameColonType)")
    }
    self.write()

    let initArgs = structDef.properties.map(structPropertyInit).joined(", ")
    self.write("  public init(\(initArgs)) {")
    for property in structDef.properties {
      self.write("    self.\(property.name) = \(property.name)")
    }
    self.write("  }")

    self.write("}")
    self.write()
  }

  private func structPropertyInit(_ prop: StructProperty) -> String {
    let prefix = prop.underscoreInit ? "_ " : ""
    return prefix + prop.nameColonType
  }

  // MARK: - Common

  private func compileBases(_ bases: [String]) -> String {
    return bases.isEmpty ? "" : ": " + bases.joined(", ")
  }

  private func emitDoc(_ doc: String?, indent indentCount: Int) {
    guard let doc = doc else { return }

    let indent = String(repeating: " ", count: indentCount)
    for line in doc.split(separator: "\n", maxSplits: .max, omittingEmptySubsequences: false) {
      self.write("\(indent)/// \(line)")
    }
  }
}

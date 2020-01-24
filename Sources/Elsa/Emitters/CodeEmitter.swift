// Emit code for given entities (the same for AST, bytecode etc.).

public final class CodeEmitter: EmitterBase {

  public func emit(entities: [Entity], imports: [String]) {
    self.writeHeader(command: "code")

    for i in imports {
      self.write("import \(i)")
    }
    self.write()

    self.write("// swiftlint:disable superfluous_disable_command")
    self.write("// swiftlint:disable line_length")
    self.write("// swiftlint:disable file_length")
    self.write("// swiftlint:disable trailing_newline")
    self.write("// swiftlint:disable vertical_whitespace_closing_braces")
    self.write()

    for entity in entities {
      switch entity {
      case let .enum(e):
        self.emitEnum(e)
      case let .struct(s):
        self.emitProduct(s)
      case let .class(c):
        self.emitProduct(c)
        self.emitEquatable(c)
      }
    }
  }

  // MARK: - Enum

  private func emitEnum(_ def: EnumDef) {
    self.emitDoc(def.doc, indent: 0)

    let bases = self.compileBases(def.bases)
    let indirect = def.isIndirect ? "indirect " : ""
    self.write("public \(indirect)enum \(def.name)\(bases) {")

    // emit `case single([Statement])`
    for caseDef in def.cases {
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
    for caseDef in def.cases where !caseDef.properties.isEmpty {
      self.write("  public var is\(pascalCase(caseDef.name)): Bool {")
      self.write("    if case .\(caseDef.name) = self { return true }")
      self.write("    return false")
      self.write("  }")
      self.write()
    }

    self.write("}")
    self.write()
  }

  // MARK: - Product

  private func emitProduct<T: ProductType>(_ def: T) {
    let bases = self.compileBases(def.bases)

    self.emitDoc(def.doc, indent: 0)
    self.write("public \(T.swiftKeyword) \(def.name)\(bases) {")
    self.write()

    for property in def.properties {
      self.emitDoc(property.doc, indent: 2)
      self.write("  public let \(property.nameColonType)")
    }
    self.write()

    let initArgs = def.properties.map(structPropertyInit).joined(", ")
    self.write("  public init(\(initArgs)) {")
    for property in def.properties {
      self.write("    self.\(property.name) = \(property.name)")
    }
    self.write("  }")

    self.write("}")
    self.write()
  }

  private func structPropertyInit(_ prop: ProductProperty) -> String {
    let prefix = prop.underscoreInit ? "_ " : ""
    return prefix + prop.nameColonType
  }

  private func emitEquatable(_ def: ClassDef) {
    guard def.bases.contains("Equatable") else {
      return
    }

    let type = def.name
    self.write("extension \(type) {")
    self.write("  public static func == (lhs: \(type), rhs: \(type)) -> Bool {")

    for prop in def.properties {
      let name = prop.name
      self.write("    guard lhs.\(name) == rhs.\(name) else { return false }")
    }

    self.write("    return true")
    self.write("  }")

    self.write("}")
    self.write()
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

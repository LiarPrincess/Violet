private let argNames: [String: String] = [
  "AST":                "ast",
  "StatementKind":      "stmt",
  "ExpressionKind":     "expr",
  "UnaryOperator":      "op",
  "BooleanOperator":    "op",
  "BinaryOperator":     "op",
  "ComparisonOperator": "op",
  "DictionaryElement":  "element",
  "StringGroup":        "group",
  "ConversionFlag":     "flag",
  "SliceKind":          "slice",
  "Vararg":             "arg",

  "Statement":         "stmt",
  "Alias":             "alias",
  "WithItem":          "item",
  "ExceptHandler":     "handler",
  "Expression":        "expr",
  "ComparisonElement": "stmt",
  "Slice":             "slice",
  "Comprehension":     "comprehension",
  "Arguments":         "args",
  "Arg":               "arg",
  "Keyword":           "keyword"
]

public final class AstPassEmitter: EmitterBase {

  public func emit(entities: [Entity]) {
    self.writeHeader(command: "ast-pass")

    self.write("import Foundation")
    self.write("import Core")
    self.write("import Lexer")
    self.write()

    self.write("// swiftlint:disable function_body_length")
    self.write("// swiftlint:disable cyclomatic_complexity")
    self.write("// swiftlint:disable file_length")
    self.write()

    self.write("public class ASTValidationPass: ASTPass {")
    self.write()
    self.write("  public typealias PassResult = Void")
    self.write()

    for entity in entities {
      switch entity {
      case let .enum(e): self.emitEnum(e)
      case let .struct(s): self.emitStruct(s)
      }
    }

    self.write("}")
  }

  private func emitEnum(_ enumDef: EnumDef) {
    let argName = argNames[enumDef.name] ?? camelCase(enumDef.name)
    let accessModifier = enumDef.name == "AST" ? "public" : "private"
    self.write("  \(accessModifier) func visit(_ \(argName): \(enumDef.name)) throws {")

    self.write("    switch \(argName) {")
    for caseDef in enumDef.cases {
      if caseDef.properties.isEmpty {
        self.write("    case .\(caseDef.name):")
      } else {
        let properties = caseDef.properties
          .enumerated()
          .map {
            $0.element.name ??
              argNames[$0.element.type] ??
              (caseDef.properties.count == 1 ? "value" : "value\($0.offset)")
          }
          .map(escaped)
          .joined(", ")

        self.write("    case let .\(caseDef.name)(\(properties)):")
      }

      self.write("      break")
      self.write()
    }
    self.write("    }")

    self.write("  }")
    self.write()
  }

  private func emitStruct(_ structDef: StructDef) {
    let argName = argNames[structDef.name] ?? camelCase(structDef.name)
    self.write("  private func visit(_ \(argName): \(structDef.name)) throws {")
    self.write("  }")
    self.write()
  }
}

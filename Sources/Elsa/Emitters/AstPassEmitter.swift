// Generate dummy AST pass (mostly giant switches for stmt and expr kind).

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

    self.write("")
    self.write("")
    self.write("// swiftlint:disable file_length")
    self.write()

    self.write("public class ASTValidationPass: ASTPass {")
    self.write()
    self.write("  public typealias PassResult = Void")
    self.write()

    for entity in entities {
      switch entity {
      case let .enum(e) where e.name == "AST"
                           || e.name == "StatementKind"
                           || e.name == "ExpressionKind":
        self.emitFunctionWithSingleSwitch(e)
        self.emitFunctionPerCase(e)
      case .enum: // Other enum types
        break
      case let .struct(s):
        self.emitProduct(s)
      case let .class(c):
        self.emitProduct(c)
      }
    }

    self.write("}")
  }

  // MARK: - Enum

  private func emitFunctionWithSingleSwitch(_ enumDef: EnumDef) {
    let pascalName = pascalCase(enumDef.name)
    let argName = argNames[enumDef.name] ?? camelCase(enumDef.name)
    let accessModifier = enumDef.name == "AST" ? "public" : "private"
    self.write(
      "  \(accessModifier) func visit\(pascalName)(_ \(argName): \(enumDef.name)) throws {"
    )

    self.write("    switch \(argName) {")
    for caseDef in enumDef.cases {
      let casePascalName = pascalCase(caseDef.name)

      if caseDef.properties.isEmpty {
        self.write("    case .\(caseDef.name):")
        self.write("      try self.visit\(casePascalName)()")
      } else {
        let propertyInfos = self.getPropertyInfos(caseDef.properties)
        let binds = propertyInfos
          .map { $0.bind }
          .joined(", ")

        let args = propertyInfos
          .map { $0.arg + ": " + $0.bind }
          .joined(", ")

        self.write("    case let .\(caseDef.name)(\(binds)):")
        self.write("      try self.visit\(casePascalName)(\(args))")
      }
    }
    self.write("    }")

    self.write("  }")
    self.write()
  }

  private func emitFunctionPerCase(_ enumDef: EnumDef) {
    for caseDef in enumDef.cases {
      let namePascal = pascalCase(caseDef.name)

      let propertyInfos = self.getPropertyInfos(caseDef.properties)
      let args = propertyInfos
        .map { $0.arg + ": " + $0.type }
        .joined(",\n")

      self.write("  private func visit\(namePascal)(\(args)) throws {")
      self.write("  }")
      self.write()
    }
  }

  private struct EnumCaseInfo {
    /// Binding in `case let`
    fileprivate let bind: String
    /// Name of the argument
    fileprivate let arg: String
    /// Swift type
    fileprivate let type: String
  }

  private func getPropertyInfos(_ properties: [EnumCaseProperty]) -> [EnumCaseInfo] {
    var result = [EnumCaseInfo]()
    for (index, property) in properties.enumerated() {
      let bind = property.name ??
        argNames[property.type] ??
        (index == 0 ? "value" : "value\(index)")

      let arg = property.name ??
        argNames[property.type] ??
        (properties.count == 1 ? "value" : "value\(index)")

      let type = property.type

      let info = EnumCaseInfo(bind: bind, arg: arg, type: type)
      result.append(info)
    }
    return result
  }

  // MARK: - Struct

  private func emitProduct<T: ProductType>(_ def: T) {
    let pascalName = pascalCase(def.name)
    let argName = argNames[def.name] ?? camelCase(def.name)
    self.write("  private func visit\(pascalName)(_ \(argName): \(def.name)) throws {")
    self.write("  }")
    self.write()
  }
}

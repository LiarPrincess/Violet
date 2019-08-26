// swiftlint:disable function_body_length
// swiftlint:disable file_length

/// Extract associated values from enums. For unit tests.
public final class AstPatternMatchingEmitter: EmitterBase {

  public func emit(entities: [Entity]) {
    self.writeHeader(command: "ast-destruct")

    self.write("import XCTest")
    self.write("import Core")
    self.write("import Lexer")
    self.write("import Parser")
    self.write()

    self.write("// swiftlint:disable file_length")
    self.write("// swiftlint:disable line_length")
    self.write("// swiftlint:disable large_tuple")
    self.write("// swiftlint:disable vertical_whitespace_closing_braces")
    self.write("// swiftlint:disable trailing_newline")
    self.write()

    for entity in entities {
      switch entity {
      case .enum(let e):
        switch e.name {
        case "ASTKind": emitASTMatcher(e)
        case "StatementKind": emitStatementMatcher(e)
        case "ExpressionKind": emitExpressionMatcher(e)
        case "SliceKind": emitSliceMatcher(e)
        case "StringGroup": emitStringMatcher(e)
        default: break
        }

      case .struct:
        break
      }
    }
  }

  private func emitASTMatcher(_ enumDef: EnumDef) {
    self.write("// MARK: - ASTMatcher")
    self.write()

    self.write("internal protocol ASTMatcher { }")
    self.write()

    self.write("extension ASTMatcher {")
    self.write()

    for caseDef in enumDef.cases where !caseDef.properties.isEmpty {
      let namePascal = pascalCase(caseDef.name)
      let paramIndent = repeating(" ", count: 20 + namePascal.count)

      let destruction = getEnumMatcher(caseDef)

      self.write("""
        internal func match\(namePascal)(_ ast: AST,
        \(paramIndent)file: StaticString = #file,
        \(paramIndent)line: UInt         = #line) ->
        (\(destruction.resultType))? {

          if case let \(enumDef.name).\(caseDef.name)(\(destruction.bindings)) = ast.kind {
            return (\(destruction.returnValue))
          }

          XCTAssertTrue(false, String(describing: ast), file: file, line: line)
          return nil
        }

      """)
    }

    self.write("}")
    self.write()
  }

  private func emitStatementMatcher(_ enumDef: EnumDef) {
    self.write("// MARK: - StatementMatcher")
    self.write()

    self.write("internal protocol StatementMatcher { }")
    self.write()

    self.write("extension StatementMatcher {")
    self.write()

    for caseDef in enumDef.cases where !caseDef.properties.isEmpty {
      let namePascal = pascalCase(caseDef.name)
      let paramIndent = repeating(" ", count: 20 + namePascal.count)

      let destruction = getEnumMatcher(caseDef)

      self.write("""
        internal func match\(namePascal)(_ stmt: Statement,
        \(paramIndent)file: StaticString = #file,
        \(paramIndent)line: UInt         = #line) ->
        (\(destruction.resultType))? {

          if case let \(enumDef.name).\(caseDef.name)(\(destruction.bindings)) = stmt.kind {
            return (\(destruction.returnValue))
          }

          XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
          return nil
        }

      """)
    }

    self.write("}")
    self.write()
  }

  private func emitExpressionMatcher(_ enumDef: EnumDef) {
    self.write("// MARK: - ExpressionMatcher")
    self.write()

    self.write("internal protocol ExpressionMatcher { }")
    self.write()

    self.write("extension ExpressionMatcher {")
    self.write()

    for caseDef in enumDef.cases where !caseDef.properties.isEmpty {
      let namePascal = pascalCase(caseDef.name)
      let paramIndent = repeating(" ", count: 20 + namePascal.count)

      let destruction = getEnumMatcher(caseDef)

      self.write("""
        internal func match\(namePascal)(_ expr: Expression,
        \(paramIndent)file: StaticString = #file,
        \(paramIndent)line: UInt         = #line) ->
          (\(destruction.resultType))? {

          if case let \(enumDef.name).\(caseDef.name)(\(destruction.bindings)) = expr.kind {
            return (\(destruction.returnValue))
          }

          XCTAssertTrue(false, expr.kind.description, file: file, line: line)
          return nil
        }

      """)
    }

    self.write("}")
    self.write()
  }

  private func emitSliceMatcher(_ enumDef: EnumDef) {
    self.write("// MARK: - SliceMatcher")
    self.write()

    self.write("internal protocol SliceMatcher { }")
    self.write()

    self.write("extension SliceMatcher {")
    self.write()

    for caseDef in enumDef.cases where !caseDef.properties.isEmpty {
      let namePascal = pascalCase(caseDef.name)
      let paramIndent = repeating(" ", count: 29 + namePascal.count)

      let destruction = getEnumMatcher(caseDef)

      self.write("""
        internal func matchSubscript\(namePascal)(_ expr: Expression,
        \(paramIndent)file: StaticString = #file,
        \(paramIndent)line: UInt         = #line) ->
          (slice: Slice, \(destruction.resultType))? {

          guard case let ExpressionKind.subscript(_, slice: slice) = expr.kind else {
            XCTAssertTrue(false, expr.kind.description, file: file, line: line)
            return nil
          }

          switch slice.kind {
          case let .\(caseDef.name)(\(destruction.bindings)):
            return (slice, \(destruction.returnValue))
          default:
            XCTAssertTrue(false, slice.kind.description, file: file, line: line)
            return nil
          }
        }

      """)
    }

    self.write("}")
    self.write()
  }

  private func emitStringMatcher(_ enumDef: EnumDef) {
    self.write("// MARK: - \(enumDef.name)")
    self.write()

    self.write("internal protocol StringMatcher { }")
    self.write()

    self.write("extension StringMatcher {")
    self.write()

    for caseDef in enumDef.cases where !caseDef.properties.isEmpty {
      let namePascal = caseDef.name == "string" ? "Simple" : pascalCase(caseDef.name)
      let paramIndent = repeating(" ", count: 26 + namePascal.count)

      let destruction = getEnumMatcher(caseDef)

      self.write("""
        internal func matchString\(namePascal)(_ group: StringGroup,
        \(paramIndent)file: StaticString = #file,
        \(paramIndent)line: UInt         = #line) ->
          (\(destruction.resultType))? {

          switch group {
          case let .\(caseDef.name)(\(destruction.bindings)):
            return (\(destruction.returnValue))
          default:
            XCTAssertTrue(false, String(describing: group), file: file, line: line)
            return nil
          }
        }

      """)
    }

    self.write("}")
    self.write()
  }
}

// MARK: - EnumDestruction

private struct EnumMatcher {
  /// e.g. BinaryOperator, left: Expression, right: Expression
  fileprivate var resultType:  String = ""
  /// e.g. value0, left: value1, right: value2
  fileprivate var bindings:    String = ""
  /// e.g. value0, value1, value2
  fileprivate var returnValue: String = ""
}

private func getEnumMatcher(_ caseDef: EnumCaseDef) -> EnumMatcher {
  var destruction = EnumMatcher()

  for (i, property) in caseDef.properties.enumerated() {
    let isLast = i == caseDef.properties.count - 1
    let comma = isLast ? "" : ", "

    // destruct Min1 as Array (because it it simpler)
    let isMin1 = property.kind == .min1
    let type = isMin1 ? "[" + property.baseType + "]" : property.type

    let resultType = property.name.map { "\($0): \(type)" } ?? type
    destruction.resultType += resultType + comma

    let binding = "value\(i)"
    let bindingsLabel = property.name.map { $0 + ": " } ?? ""
    destruction.bindings += "\(bindingsLabel)\(binding)\(comma)"

    let retVal = isMin1 ? "Array(\(binding))" : binding
    destruction.returnValue += "\(retVal)\(comma)"
  }

  return destruction
}

// swiftlint:disable function_body_length

/// Extract associated values from enums. For unit tests.
internal func emitAstDestruction(entities: [Entity]) {
  print("import XCTest")
  print("import Core")
  print("import Lexer")
  print("import Parser")
  print()

  print("// swiftlint:disable file_length")
  print("// swiftlint:disable line_length")
  print("// swiftlint:disable large_tuple")
  print("// swiftlint:disable vertical_whitespace_closing_braces")
  print("// swiftlint:disable trailing_newline")
  print()

  for entity in entities {
    switch entity {
    case .enum(let e):
      switch e.name {
      case "AST": emitASTDestruction(e)
      case "StatementKind": emitStatementDestruct(e)
      case "ExpressionKind": emitExpressionDestruct(e)
      case "SliceKind": emitSliceDestruct(e)
      case "StringGroup": emitStringDestruct(e)
      default: break
      }

    case .struct:
      break
    }
  }
}

// MARK: - Common

private struct EnumDestruction {
  fileprivate var resultType:  String = ""
  fileprivate var bindings:    String = ""
  fileprivate var returnValue: String = ""
}

private func getEnumDestruction(_ caseDef: EnumCaseDef) -> EnumDestruction {
  var destruction = EnumDestruction()

  for (i, property) in caseDef.properties.enumerated() {
    let isLast = i == caseDef.properties.count - 1
    let comma = isLast ? "" : ", "

    let resultType = property.nameColonType ?? property.type
    destruction.resultType += resultType + comma

    let binding = "value\(i)"
    let bindingsLabel = property.name.map { $0 + ": " } ?? ""
    destruction.bindings += "\(bindingsLabel)\(binding)\(comma)"

    destruction.returnValue += "\(binding)\(comma)"
  }

  return destruction
}

// MARK: - Specifics

private func emitASTDestruction(_ enumDef: EnumDef) {
  print("// MARK: - \(enumDef.name)")
  print()

  print("protocol Destruct\(enumDef.name) { }")
  print()

  print("extension Destruct\(enumDef.name) {")
  print()

  for caseDef in enumDef.cases where !caseDef.properties.isEmpty {
    let namePascal = pascalCase(caseDef.name)
    let paramIndent = repeating(" ", count: 23 + namePascal.count)

    let destruction = getEnumDestruction(caseDef)

    print("""
      internal func destruct\(namePascal)(_ ast: AST,
      \(paramIndent)file:   StaticString = #file,
      \(paramIndent)line:   UInt         = #line) ->
      (\(destruction.resultType))? {

        if case let \(enumDef.name).\(caseDef.name)(\(destruction.bindings)) = ast {
          return (\(destruction.returnValue))
        }

        XCTAssertTrue(false, String(describing: ast), file: file, line: line)
        return nil
      }

    """)
  }

  print("}")
  print()
}

private func emitStatementDestruct(_ enumDef: EnumDef) {
  print("// MARK: - \(enumDef.name)")
  print()

  print("protocol Destruct\(enumDef.name) { }")
  print()

  print("extension Destruct\(enumDef.name) {")
  print()

  for caseDef in enumDef.cases where !caseDef.properties.isEmpty {
    let namePascal = pascalCase(caseDef.name)
    let paramIndent = repeating(" ", count: 23 + namePascal.count)

    let destruction = getEnumDestruction(caseDef)

    print("""
      internal func destruct\(namePascal)(_ stmt: Statement,
      \(paramIndent)file:   StaticString = #file,
      \(paramIndent)line:   UInt         = #line) ->
      (\(destruction.resultType))? {

        if case let \(enumDef.name).\(caseDef.name)(\(destruction.bindings)) = stmt.kind {
          return (\(destruction.returnValue))
        }

        XCTAssertTrue(false, stmt.kind.description, file: file, line: line)
        return nil
      }

    """)
  }

  print("}")
  print()
}

private func emitExpressionDestruct(_ enumDef: EnumDef) {
  print("// MARK: - \(enumDef.name)")
  print()

  print("protocol Destruct\(enumDef.name) { }")
  print()

  print("extension Destruct\(enumDef.name) {")
  print()

  for caseDef in enumDef.cases where !caseDef.properties.isEmpty {
    let namePascal = pascalCase(caseDef.name)
    let paramIndent = repeating(" ", count: 23 + namePascal.count)

    let destruction = getEnumDestruction(caseDef)

    print("""
      internal func destruct\(namePascal)(_ expr: Expression,
      \(paramIndent)file:   StaticString = #file,
      \(paramIndent)line:   UInt         = #line) ->
        (\(destruction.resultType))? {

        if case let \(enumDef.name).\(caseDef.name)(\(destruction.bindings)) = expr.kind {
          return (\(destruction.returnValue))
        }

        XCTAssertTrue(false, expr.kind.description, file: file, line: line)
        return nil
      }

    """)
  }

  print("}")
  print()
}

private func emitSliceDestruct(_ enumDef: EnumDef) {
  print("// MARK: - \(enumDef.name)")
  print()

  print("protocol Destruct\(enumDef.name) { }")
  print()

  print("extension Destruct\(enumDef.name) {")
  print()

  for caseDef in enumDef.cases where !caseDef.properties.isEmpty {
    let namePascal = pascalCase(caseDef.name)
    let paramIndent = repeating(" ", count: 32 + namePascal.count)

    let destruction = getEnumDestruction(caseDef)

    print("""
      internal func destructSubscript\(namePascal)(_ expr: Expression,
      \(paramIndent)file:   StaticString = #file,
      \(paramIndent)line:   UInt         = #line) ->
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

  print("}")
  print()
}

private func emitStringDestruct(_ enumDef: EnumDef) {
  print("// MARK: - \(enumDef.name)")
  print()

  print("protocol Destruct\(enumDef.name) { }")
  print()

  print("extension Destruct\(enumDef.name) {")
  print()

  for caseDef in enumDef.cases where !caseDef.properties.isEmpty {
    let namePascal = caseDef.name == "string" ? "Simple" : pascalCase(caseDef.name)
    let paramIndent = repeating(" ", count: 27 + namePascal.count)

    let destruction = getEnumDestruction(caseDef)

    print("""
      internal func destructString\(namePascal)(_ group: StringGroup,
        \(paramIndent)file:   StaticString = #file,
        \(paramIndent)line:   UInt         = #line) ->
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

  print("}")
  print()
}

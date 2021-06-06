import Foundation

let elsaDir = URL(fileURLWithPath: #file).deletingLastPathComponent()
let sourcesDir = elsaDir.deletingLastPathComponent()
let rootDir = sourcesDir.deletingLastPathComponent()
let testsDir = rootDir.appendingPathComponent("Tests")

private func parse(file: URL) -> SourceFile {
  do {
    let content = try String(contentsOf: file, encoding: .utf8)
    let lexer = Lexer(source: content)
    let parser = Parser(url: file, lexer: lexer)
    return parser.parse()
  } catch {
    trap("Unable to read '\(file)'")
  }
}

private func generateAST() {
  let parserDir = sourcesDir
    .appendingPathComponent("Parser", isDirectory: true)
    .appendingPathComponent("Generated", isDirectory: true)

  let definitionFile = rootDir
    .appendingPathComponent("Definitions", isDirectory: true)
    .appendingPathComponent("ast.letitgo", isDirectory: false)

  let sourceFile = parse(file: definitionFile)

  EmitAstVisitor(
    sourceFile: sourceFile,
    outputFile: parserDir.appendingPathComponent("AST.swift")
  ).walk()

  EmitAstVisitorsVisitor(
    sourceFile: sourceFile,
    outputFile: parserDir.appendingPathComponent("ASTVisitors.swift")
  ).walk()

  EmitAstBuilderVisitor(
    sourceFile: sourceFile,
    outputFile: parserDir.appendingPathComponent("ASTBuilder.swift")
  ).walk()
}

// swiftlint:disable:next function_body_length
private func generateBytecode() {
  let bytecodeDir = sourcesDir
    .appendingPathComponent("Bytecode", isDirectory: true)
    .appendingPathComponent("Generated", isDirectory: true)

  let compilerTestsDir = testsDir
    .appendingPathComponent("CompilerTests", isDirectory: true)

  let definitionFile = rootDir
    .appendingPathComponent("Definitions", isDirectory: true)
    .appendingPathComponent("opcodes.letitgo", isDirectory: false)

  let sourceFile = parse(file: definitionFile)

  EmitBytecodeVisitor(
    sourceFile: sourceFile,
    outputFile: bytecodeDir.appendingPathComponent("Instructions.swift")
  ).walk()

  EmitBytecodeDescriptionVisitor(
    sourceFile: sourceFile,
    outputFile: bytecodeDir.appendingPathComponent("Instructions+Description.swift")
  ).walk()

  EmitBytecodeFilledVisitor(
    sourceFile: sourceFile,
    outputFile: bytecodeDir.appendingPathComponent("Instructions+Filled.swift")
  ).walk()

  EmitBytecodeFilledDescriptionVisitor(
    sourceFile: sourceFile,
    outputFile: bytecodeDir.appendingPathComponent("Instructions+Filled+Description.swift")
  ).walk()

  EmitBytecodeTestHelpersVisitor(
    sourceFile: sourceFile,
    outputFile: compilerTestsDir
      .appendingPathComponent("Helpers")
      .appendingPathComponent("EmittedInstruction.swift")
  ).walk()
}

generateAST()
generateBytecode()

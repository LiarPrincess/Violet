import Foundation

let elsaDir = URL(fileURLWithPath: #file).deletingLastPathComponent()
let sourcesDir  = elsaDir.deletingLastPathComponent()
let rootDir = sourcesDir.deletingLastPathComponent()
let testsDir = rootDir .appendingPathComponent("Tests")

private func generateAST() {
  let parserDir = sourcesDir
    .appendingPathComponent("Parser")
    .appendingPathComponent("Generated")

  let definition = rootDir
    .appendingPathComponent("Definitions", isDirectory: true)
    .appendingPathComponent("ast.letitgo", isDirectory: false)

  emitAst(
    inputFile: definition,
    outputFile: parserDir.appendingPathComponent("AST.swift")
  )

  emitAstVisitors(
    inputFile: definition,
    outputFile: parserDir.appendingPathComponent("ASTVisitors.swift")
  )

  emitAstBuilder(
    inputFile: definition,
    outputFile: parserDir.appendingPathComponent("ASTBuilder.swift")
  )
}

private func generateBytecode() {
  let bytecodeDir = sourcesDir.appendingPathComponent("Bytecode")
  let compilerTestsDir = testsDir .appendingPathComponent("CompilerTests")

  let definition = rootDir
    .appendingPathComponent("Definitions", isDirectory: true)
    .appendingPathComponent("opcodes.letitgo", isDirectory: false)

  emitBytecode(
    inputFile: definition,
    outputFile: bytecodeDir.appendingPathComponent("Instructions.swift")
  )

  emitBytecodeDescription(
    inputFile: definition,
    outputFile: bytecodeDir.appendingPathComponent("Instructions+Description.swift")
  )

  emitBytecodeTestHelpers(
    inputFile: definition,
    outputFile: compilerTestsDir
      .appendingPathComponent("Helpers")
      .appendingPathComponent("EmittedInstruction.swift")
  )
}

generateAST()
generateBytecode()

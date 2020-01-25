import Foundation

let elsaDir = URL(fileURLWithPath: #file).deletingLastPathComponent()
let sourcesDir  = elsaDir.deletingLastPathComponent()
let rootDir = sourcesDir.deletingLastPathComponent()
let testsDir = rootDir .appendingPathComponent("Tests")

private func generateAST() {
  let parserDir = sourcesDir
    .appendingPathComponent("Parser")
    .appendingPathComponent("Generated")
  let parserTestsDir = testsDir
    .appendingPathComponent("ParserTests")

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

  // Destruct
  let entities = parseLetItGo(file: definition)
  let patternFile = parserTestsDir
    .appendingPathComponent("Helpers")
    .appendingPathComponent("PatternMatching.swift")
  let patternEmitter = try! AstPatternMatchingEmitter(letItGo: definition,
                                                      output: patternFile)
  patternEmitter.emit(entities: entities)
}

private func parseLetItGo(file: URL) -> [Entity] {
  // swiftlint:disable:next force_try
  let content = try! String(contentsOf: file, encoding: .utf8)
  let lexer = Lexer(source: content)
  let parser = Parser(lexer: lexer)
  return parser.parse()
}

private func generateBytecode() {
  let bytecodeDir = sourcesDir.appendingPathComponent("Bytecode")
  let compilerTestsDir = testsDir .appendingPathComponent("CompilerTests")

  let definition = rootDir
    .appendingPathComponent("Definitions", isDirectory: true)
    .appendingPathComponent("opcodes.letitgo", isDirectory: false)

  emitTypes(
    inputFile: definition,
    outputFile: bytecodeDir.appendingPathComponent("Instructions.swift"),
    imports: ["Foundation", "Core"]
  )

  emitCodeObjectDescription(
    inputFile: definition,
    outputFile: bytecodeDir.appendingPathComponent("Instructions+Description.swift")
  )

  emitCodeObjectTestHelpers(
    inputFile: definition,
    outputFile: compilerTestsDir
      .appendingPathComponent("Helpers")
      .appendingPathComponent("EmittedInstruction.swift")
  )
}

generateAST()
generateBytecode()

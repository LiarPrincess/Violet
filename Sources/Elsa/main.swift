import Foundation

let elsaDir = URL(fileURLWithPath: #file).deletingLastPathComponent()

let sourcesDir  = elsaDir.deletingLastPathComponent()
let parserDir   = sourcesDir.appendingPathComponent("Parser")
let bytecodeDir = sourcesDir.appendingPathComponent("Bytecode")

let rootDir = sourcesDir.deletingLastPathComponent()
let testsDir = rootDir .appendingPathComponent("Tests")
let parserTestsDir = testsDir.appendingPathComponent("ParserTests")
let compilerTestsDir = testsDir .appendingPathComponent("CompilerTests")

private func parseLetItGo(file: URL) -> [Entity] {
  // swiftlint:disable:next force_try
  let content = try! String(contentsOf: file, encoding: .utf8)
  let lexer = Lexer(source: content)
  let parser = Parser(lexer: lexer)
  return parser.parse()
}

private func generateAST() {
  let definition = rootDir
    .appendingPathComponent("Definitions", isDirectory: true)
    .appendingPathComponent("ast.letitgo", isDirectory: false)

  emitTypes(
    inputFile: definition,
    outputFile: parserDir.appendingPathComponent("AST.swift"),
    imports: ["Foundation", "Core", "Lexer"]
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

private func generateBytecode() {
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

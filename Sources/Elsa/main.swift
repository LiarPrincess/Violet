// swiftlint:disable force_try

import Foundation

let elsaDir = URL(fileURLWithPath: #file).deletingLastPathComponent()

let sourcesDir  = elsaDir.deletingLastPathComponent()
let parserDir   = sourcesDir.appendingPathComponent("Parser")
let bytecodeDir = sourcesDir.appendingPathComponent("Bytecode")

let rootDir = sourcesDir.deletingLastPathComponent()
let testsDir = rootDir .appendingPathComponent("Tests")
let parserTestsDir = testsDir.appendingPathComponent("ParserTests")

private func parseLetItGo(file: URL)  -> [Entity] {
  let content = try! String(contentsOf: file, encoding: .utf8)
  let lexer = Lexer(source: content)
  let parser = Parser(lexer: lexer)
  return parser.parse()
}

private func generateAST() throws {
  let input = rootDir
    .appendingPathComponent("Definitions", isDirectory: true)
    .appendingPathComponent("ast.letitgo", isDirectory: false)

  let entities = parseLetItGo(file: input)

  // Definitions
  let defFile = parserDir.appendingPathComponent("AST.swift")
  let codeEmitter = try CodeEmitter(letItGo: input, output: defFile)
  codeEmitter.emit(entities: entities, imports: ["Foundation", "Core", "Lexer"])

  // Pass
//  let passFile = rootDir.appendingPathComponent("DummyPass.swift")
//  let astPassEmitter = try AstPassEmitter(letItGo: input, output: passFile)
//  astPassEmitter.emit(entities: entities)

  // Destruct
  let destructFile = parserTestsDir
    .appendingPathComponent("Helpers")
    .appendingPathComponent("PatternMatching.swift")
  let patternEmitter = try AstPatternMatchingEmitter(letItGo: input, output: destructFile)
  patternEmitter.emit(entities: entities)
}

private func generateBytecode() throws {
  let input = rootDir
    .appendingPathComponent("Definitions", isDirectory: true)
    .appendingPathComponent("opcodes.letitgo", isDirectory: false)

  let entities = parseLetItGo(file: input)

  // Definitions
  let codeFile = bytecodeDir.appendingPathComponent("Instructions.swift")
  let codeEmitter = try CodeEmitter(letItGo: input, output: codeFile)
  codeEmitter.emit(entities: entities, imports: ["Foundation", "Core"])
}

try generateAST()
try generateBytecode()

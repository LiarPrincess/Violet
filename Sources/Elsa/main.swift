// swiftlint:disable force_try

import Foundation

// TODO: Lexer and parser to `class`

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

private func generateAST() {
  let input = rootDir
    .appendingPathComponent("Definitions", isDirectory: true)
    .appendingPathComponent("ast.letitgo", isDirectory: false)

  let entities = parseLetItGo(file: input)

  // Nodes
  let astFile = parserDir.appendingPathComponent("AST.swift")
  let codeEmitter = CodeEmitter(for: astFile)
  codeEmitter.emit(entities: entities)

  // Pass
  // let passFile = parserDir.appendingPathComponent("ASTValidationPass.swift")
  // redirectStdout(to: passFile.path)
  // emitPass(entities: entities)

  // Destruct
  let destructFile = parserTestsDir
    .appendingPathComponent("Helpers")
    .appendingPathComponent("Destruct.swift")
  let destructEmitter = AstDestructionEmitter(for: destructFile)
  destructEmitter.emit(entities: entities)
}

//private func generateBytecode() {
//  let input = rootDir
//    .appendingPathComponent("Definitions", isDirectory: true)
//    .appendingPathComponent("opcodes.letitgo", isDirectory: false)
//
//  let entities = parseLetItGo(file: input)
//}

generateAST()
//generateBytecode()

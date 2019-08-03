// swiftlint:disable force_try

// TODO: (Elsa) _ in init
// TODO: (Elsa.emit) To class and line() write() (as in slip)

import Foundation

let elsaDir = URL(fileURLWithPath: #file).deletingLastPathComponent()
let letitgoFile = elsaDir.appendingPathComponent("ast.letitgo", isDirectory: false)
let letitgoContent = try! String(contentsOf: letitgoFile, encoding: .utf8)

let sourcesDir = elsaDir.deletingLastPathComponent()
let parserDir = sourcesDir.appendingPathComponent("Parser")

let testsDir = elsaDir
  .deletingLastPathComponent()
  .deletingLastPathComponent()
  .appendingPathComponent("Tests")
let parserTestsDir = testsDir.appendingPathComponent("ParserTests")

let lexer = Lexer(source: letitgoContent)
var parser = Parser(lexer: lexer)
let entities = parser.parse()

defer { fclose(stdout) }

// MARK: - Code

let astFile = parserDir.appendingPathComponent("AST.swift")
freopen(astFile.path, "w", stdout)

emitHeader(sourceFile: letitgoFile, command: "ast")
emitCode(entities: entities)

// MARK: - Destruct

let destructFile = parserTestsDir
  .appendingPathComponent("Helpers")
  .appendingPathComponent("Destruct.swift")
freopen(destructFile.path, "w", stdout)

emitHeader(sourceFile: letitgoFile, command: "ast-destruct")
emitAstDestruction(entities: entities)

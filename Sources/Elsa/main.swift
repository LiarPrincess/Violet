// swiftlint:disable force_try

// TODO: (Elsa) _ in init
// TODO: (Elsa.emit) To class and line() write() (as in slip)
// TODO: (Elsa) Resolve ambiguity for @enum a|b @doc @struct. is it @doc for last case or @struct?

import Foundation

let elsaDir = URL(fileURLWithPath: #file).deletingLastPathComponent()
let sourceFile = elsaDir.appendingPathComponent("ast.letitgo", isDirectory: false)
let source = try! String(contentsOf: sourceFile, encoding: .utf8)

let parserDir = elsaDir.deletingLastPathComponent().appendingPathComponent("Parser")

var lexer = Lexer(source: source)
//lexer.dumpTokens()
var parser = Parser(lexer: lexer)
let entities = parser.parse()

// MARK: - Code

let astFile = parserDir.appendingPathComponent("AST.swift")
freopen(astFile.path, "w", stdout)
defer { fclose(stdout) }

emitHeader(sourceFile: sourceFile, command: "ast")
emitCode(entities: entities)

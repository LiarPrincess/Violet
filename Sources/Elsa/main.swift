// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable force_try

import Foundation

let elsaDir = URL(fileURLWithPath: #file).deletingLastPathComponent()
let sourceFile = elsaDir.appendingPathComponent("ast.letitgo", isDirectory: false)
let source = try! String(contentsOf: sourceFile, encoding: .utf8)

let parserDir = elsaDir.deletingLastPathComponent().appendingPathComponent("Parser")

var lexer = Lexer(source: source)
var parser = Parser(lexer: lexer)
let entities = parser.parse()

// MARK: - Code

let astFile = parserDir.appendingPathComponent("AST.swift")
freopen(astFile.path, "w", stdout)
defer { fclose(stdout) }

emitHeader(sourceFile: sourceFile, command: "ast")
emitCode(entities: entities)

// MARK: - Description

let astDescriptionFile = parserDir.appendingPathComponent("AST+Description.swift")
freopen(astDescriptionFile.path, "w", stdout)
defer { fclose(stdout) }

emitHeader(sourceFile: sourceFile, command: "ast-desc")
emitDescription(entities: entities)

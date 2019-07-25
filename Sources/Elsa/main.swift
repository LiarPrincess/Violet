// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

let dir = URL(fileURLWithPath: #file).deletingLastPathComponent()
let astFile = dir.appendingPathComponent("ast.letitgo", isDirectory: false)
let astSource = try! String(contentsOf: astFile, encoding: .utf8)

var lexer = Lexer(source: astSource)
var parser = Parser(lexer: lexer)
let entities = parser.parse()

emitCode(entities: entities)

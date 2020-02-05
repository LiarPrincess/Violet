import XCTest
import Core
import Lexer
import Parser
import Bytecode
import Compiler

internal func XCTAssertCode(_ code: CodeObject,
                            name: String,
                            qualified: String,
                            type: CodeObjectType,
                            _ message:  String = "",
                            file: StaticString = #file,
                            line: UInt         = #line) {
  XCTAssertEqual(code.name,          name,      message, file: file, line: line)
  XCTAssertEqual(code.qualifiedName, qualified, message, file: file, line: line)
  XCTAssertEqual(code.type,          type,      message, file: file, line: line)
}

internal func XCTAssertCode(_ code: CodeObject,
                            name: String,
                            type: CodeObjectType,
                            _ message:  String = "",
                            file: StaticString = #file,
                            line: UInt         = #line) {
  XCTAssertEqual(code.name, name, message, file: file, line: line)
  XCTAssertEqual(code.type, type, message, file: file, line: line)
}

internal func XCTAssertInstructions(_ code: CodeObject,
                                    _ expected: [EmittedInstruction],
                                    _ message: String = "",
                                    file: StaticString = #file,
                                    line: UInt         = #line) {
  XCTAssertEqual(code.instructions.count,
                 expected.count,
                 "\(message) (count)",
                 file: file,
                 line: line)

  var index = 0
  for (emitted, exp) in zip(code.emittedInstructions, expected) {
    let kindDetails = "(emitted: \(emitted.kind), expected: \(exp.kind))"
    XCTAssertEqual(emitted.kind,
                   exp.kind,
                   "Invalid instruction kind at \(index) \(kindDetails) \(message)",
                   file: file,
                   line: line)

    let argDetails = "(emitted: \(emitted.arg ?? "empty"), expected: \(exp.arg ?? "empty"))"
    XCTAssertEqual(emitted.arg,
                   exp.arg,
                   "Invalid instruction arg at \(index) \(argDetails) \(message)",
                   file: file,
                   line: line)

    index += 1
  }
}

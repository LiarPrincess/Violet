import XCTest
import Core
import Lexer
import Parser
import Bytecode
import Compiler

// swiftlint:disable multiline_arguments

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

internal func XCTAssertInstructions(_ code: CodeObject,
                                    _ expected: [EmittedInstruction],
                                    _ message: String = "",
                                    file: StaticString = #file,
                                    line: UInt         = #line) {

  XCTAssertEqual(code.instructions.count, expected.count,
                 "\(message) (count)", file: file, line: line)

  for (instruction, exp) in zip(code.instructions, expected) {
    let emitted = instruction.asEmitted

    XCTAssertEqual(emitted.kind, exp.kind,
                   "\(message) (kind)", file: file, line: line)
    XCTAssertEqual(emitted.arg, exp.arg,
                   "\(message) (argument for \(exp.kind))", file: file, line: line)
  }
}

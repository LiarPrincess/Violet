import XCTest
import VioletCore
import VioletLexer
import VioletParser
import VioletBytecode
import VioletCompiler

internal func XCTAssertCode(_ code: CodeObject,
                            name: String,
                            qualified: String,
                            kind: CodeObject.Kind,
                            _ message: String = "",
                            file: StaticString = #file,
                            line: UInt = #line) {
  XCTAssertEqual(code.name, name, message, file: file, line: line)
  XCTAssertEqual(code.qualifiedName, qualified, message, file: file, line: line)
  XCTAssertEqual(code.kind, kind, message, file: file, line: line)
}

internal func XCTAssertCode(_ code: CodeObject,
                            name: String,
                            kind: CodeObject.Kind,
                            _ message: String = "",
                            file: StaticString = #file,
                            line: UInt = #line) {
  XCTAssertEqual(code.name, name, message, file: file, line: line)
  XCTAssertEqual(code.kind, kind, message, file: file, line: line)
}

internal func XCTAssertInstructions(_ code: CodeObject,
                                    _ expected: [EmittedInstruction],
                                    _ message: String = "",
                                    file: StaticString = #file,
                                    line: UInt = #line) {
  XCTAssertEqual(code.instructions.count,
                 expected.count,
                 "\(message) (count)",
                 file: file,
                 line: line)

  var index = 0
  for (emitted, exp) in zip(code.emittedInstructions, expected) {
    let details = "(emitted: \(toString(emitted)), expected: \(toString(exp)))"
    XCTAssertEqual(emitted.kind,
                   exp.kind,
                   "Invalid instruction kind at \(index) \(details) \(message)",
                   file: file,
                   line: line)

    XCTAssertEqual(emitted.arg,
                   exp.arg,
                   "Invalid instruction argument at \(index) \(details) \(message)",
                   file: file,
                   line: line)

    index += 1
  }
}

private func toString(_ instruction: EmittedInstruction) -> String {
  return "'\(instruction.kind) \(instruction.arg ?? "")'"
}

import XCTest
import BigInt
import VioletCore
import VioletLexer
import VioletParser
import VioletBytecode
import VioletCompiler

// MARK: - Helpers

extension Instruction.Filled {

  static func loadConst(_ value: String) -> Instruction.Filled {
    return .loadConst(.string(value))
  }

  static func loadConst(_ value: Data) -> Instruction.Filled {
    return .loadConst(.bytes(value))
  }

  static func loadConst(_ value: Int) -> Instruction.Filled {
    return .loadConst(.integer(BigInt(value)))
  }

  static func loadConst(_ value: BigInt) -> Instruction.Filled {
    return .loadConst(.integer(value))
  }

  static func loadConst(_ value: Double) -> Instruction.Filled {
    return .loadConst(.float(value))
  }

  static func loadConst(real: Double, imag: Double) -> Instruction.Filled {
    return .loadConst(.complex(real: real, imag: imag))
  }
}

// MARK: - Assert code object

func XCTAssertCodeObject(_ code: CodeObject,
                         name: String,
                         qualifiedName: String,
                         kind: CodeObject.Kind,
                         flags: CodeObject.Flags,
                         instructions: [Instruction.Filled],
                         argCount: Int = 0,
                         kwOnlyArgCount: Int = 0,
                         file: StaticString = #file,
                         line: UInt = #line) {
  XCTAssertEqual(code.name,
                 name,
                 "Name",
                 file: file,
                 line: line)
  XCTAssertEqual(code.qualifiedName,
                 qualifiedName,
                 "Qualified name",
                 file: file,
                 line: line)
  XCTAssertEqual(code.kind,
                 kind, "Kind",
                 file: file,
                 line: line)

  assertFlags(code, expected: flags, file: file, line: line)
  assertInstructions(code, expected: instructions, file: file, line: line)

  XCTAssertEqual(code.argCount,
                 argCount,
                 "Arg count",
                 file: file,
                 line: line)
  XCTAssertEqual(code.kwOnlyArgCount,
                 kwOnlyArgCount,
                 "Kw only arg count",
                 file: file,
                 line: line)
}

// MARK: - Flags

private func assertFlags(_ code: CodeObject,
                         expected: CodeObject.Flags,
                         file: StaticString,
                         line: UInt) {
  func assertFlag(_ flag: CodeObject.Flags, name: String) {
    let hasFlag = code.flags.contains(flag)
    let expectsFlag = expected.contains(flag)
    XCTAssertEqual(hasFlag,
                   expectsFlag,
                   "\(name) flag",
                   file: file,
                   line: line)
  }

  assertFlag(.optimized, name: "optimized")
  assertFlag(.newLocals, name: "newLocals")
  assertFlag(.varArgs, name: "varArgs")
  assertFlag(.varKeywords, name: "varKeywords")
  assertFlag(.nested, name: "nested")
  assertFlag(.generator, name: "generator")
  assertFlag(.noFree, name: "noFree")
  assertFlag(.coroutine, name: "coroutine")
  assertFlag(.iterableCoroutine, name: "iterableCoroutine")
  assertFlag(.asyncGenerator, name: "asyncGenerator")
}

// MARK: - Instructions

private func assertInstructions(_ code: CodeObject,
                                expected: [Instruction.Filled],
                                file: StaticString,
                                line: UInt) {
  let instructions = getAllInstructions(from: code, file: file, line: line)
  XCTAssertEqual(instructions.count,
                 expected.count,
                 "Instruction count",
                 file: file,
                 line: line)

  for (index, (i, e)) in zip(instructions, expected).enumerated() {
    XCTAssertEqual(i, e, "Instruction \(index)", file: file, line: line)
  }
}

private func getAllInstructions(from code: CodeObject,
                                file: StaticString,
                                line: UInt) -> [Instruction.Filled] {
  if code.instructions.isEmpty {
    return []
  }

  var result = [Instruction.Filled]()

  var instructionIndex: Int? = 0
  while let index = instructionIndex {
    let filled = code.getFilledInstruction(index: index)
    result.append(filled.instruction)
    instructionIndex = filled.nextInstructionIndex

    let maxInstructionCount = 100
    if result.count > maxInstructionCount {
      XCTFail("More than \(maxInstructionCount) instructions (probably error)",
              file: file,
              line: line)
      return []
    }
  }

  return result
}

// MARK: - Old

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

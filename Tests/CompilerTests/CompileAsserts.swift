import XCTest
import BigInt
import VioletCore
import VioletLexer
import VioletParser
import VioletBytecode
import VioletCompiler

// MARK: - Assert code object

// swiftlint:disable:next function_parameter_count function_body_length
func XCTAssertCodeObject(_ code: CodeObject,
                         name: String,
                         qualifiedName: String,
                         kind: CodeObject.Kind,
                         flags: CodeObject.Flags,
                         instructions: [Instruction.Filled],
                         argCount: Int = 0,
                         posOnlyArgCount: Int = 0,
                         kwOnlyArgCount: Int = 0,
                         childCodeObjectCount: Int = 0,
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
                 kind,
                 "Kind",
                 file: file,
                 line: line)

  assertFlags(code, expected: flags, file: file, line: line)
  assertInstructions(code, expected: instructions, file: file, line: line)
  assertChildCodeObjectCount(code, expected: childCodeObjectCount, file: file, line: line)

  XCTAssertEqual(code.argCount,
                 argCount,
                 "Arg count",
                 file: file,
                 line: line)
  XCTAssertEqual(code.posOnlyArgCount,
                 posOnlyArgCount,
                 "Positional only arg count",
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
  let instructions = code.getAllFilledInstructions(file: file, line: line)
  XCTAssertEqual(instructions.count,
                 expected.count,
                 "Instruction count",
                 file: file,
                 line: line)

  for (index, (instruction, expected)) in zip(instructions, expected).enumerated() {
    switch (instruction, expected) {
    case (.loadConst(.code), .loadConst(.code(let c))):
      XCTAssertTrue(c.isAny,
                    "Code object constant should be created with 'CodeObject.any'.",
                    file: file,
                    line: line)

    default:
      XCTAssertEqual(instruction,
                     expected,
                     "Instruction \(index)",
                     file: file,
                     line: line)
    }
  }
}

// MARK: - ChildCodeObjectCount

private func assertChildCodeObjectCount(_ code: CodeObject,
                                        expected: Int,
                                        file: StaticString,
                                        line: UInt) {
  var count = 0
  for constant in code.constants {
    switch constant {
    case .code:
      count += 1
    default:
      break
    }
  }

  XCTAssertEqual(count,
                 expected,
                 "Child code object count",
                 file: file,
                 line: line)
}

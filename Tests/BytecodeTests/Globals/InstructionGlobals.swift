import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

// MARK: - Assert

func XCTAssertNoInstructions(_ code: CodeObject,
                             file: StaticString = #file,
                             line: UInt = #line) {
  let count = code.instructions.count
  XCTAssertEqual(count, 0, "Instuction count: \(count)", file: file, line: line)
}

func XCTAssertInstructions(_ code: CodeObject,
                           _ expected: Instruction...,
                           file: StaticString = #file,
                           line: UInt = #line) {
  let count = code.instructions.count
  let expectedCount = expected.count

  XCTAssertEqual(count, expectedCount, "Count", file: file, line: line)

  for (index, (i, e)) in zip(code.instructions, expected).enumerated() {
    XCTAssertEqual(i, e, "Instruction: \(index)", file: file, line: line)
  }
}

func XCTAssertInstructionsEndWith(_ code: CodeObject,
                                  _ expected: Instruction...,
                                  file: StaticString = #file,
                                  line: UInt = #line) {
  let count = code.instructions.count
  let startIndex = count - expected.count
  guard startIndex >= 0 else {
    XCTFail("Got only \(count) instructions", file: file, line: line)
    return
  }

  let tail = code.instructions[startIndex...]
  for (index, (i, e)) in zip(tail, expected).enumerated() {
    XCTAssertEqual(i, e, "Instruction: \(index)", file: file, line: line)
  }
}

// MARK: - Assert filled

func XCTAssertFilledInstructions(_ code: CodeObject,
                                 _ expected: Instruction.Filled...,
                                 file: StaticString = #file,
                                 line: UInt = #line) {
  var expectedIndex = 0
  var instructionIndex: Int? = 0

  while let index = instructionIndex {
    let filled = code.getFilledInstruction(index: index)
    let instruction = filled.instruction

    // We may have more 'instructions' than 'expected'
    if expectedIndex < expected.count {
      let expectedInstruction = expected[expectedIndex]
      XCTAssertEqual(instruction, expectedInstruction, file: file, line: line)
    }

    expectedIndex += 1
    instructionIndex = filled.nextInstructionIndex
  }

  let instructionCount = expectedIndex
  XCTAssertEqual(instructionCount, expected.count, "Count", file: file, line: line)
}

// MARK: - Assert lines

func XCTAssertInstructionLines(_ code: CodeObject,
                               _ expected: SourceLocation...,
                               file: StaticString = #file,
                               line: UInt = #line) {
  let count = code.instructionLines.count
  let expectedCount = expected.count

  XCTAssertEqual(count, expectedCount, "Count", file: file, line: line)
  guard count == expectedCount else {
    return
  }

  for (l, e) in zip(code.instructionLines, expected) {
    XCTAssertEqual(l, e.line, file: file, line: line)
  }
}

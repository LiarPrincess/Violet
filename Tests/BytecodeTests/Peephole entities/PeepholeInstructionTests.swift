import XCTest
@testable import VioletBytecode

// MARK: - Asserts

private func XCTAssertInstruction(_ instruction: PeepholeInstruction,
                                  startIndex: Int,
                                  value: Instruction,
                                  file: StaticString = #file,
                                  line: UInt = #line) {
  XCTAssertEqual(instruction.startIndex,
                 startIndex,
                 "Start index",
                 file: file,
                 line: line)

  XCTAssertEqual(instruction.value,
                 value,
                 "Value",
                 file: file,
                 line: line)
}

private func XCTAssertExtendedArg(_ instruction: PeepholeInstruction,
                                  instructionArg: UInt8,
                                  valueWithInstructionArg: Int,
                                  count: Int,
                                  file: StaticString = #file,
                                  line: UInt = #line) {
  let arg = instruction.getArgument(instructionArg: instructionArg)
  XCTAssertEqual(arg,
                 valueWithInstructionArg,
                 "Argument value",
                 file: file,
                 line: line)

  XCTAssertEqual(instruction.extendedArgCount,
                 count,
                 "Argument count",
                 file: file,
                 line: line)
}

private func XCTAssertIndices(_ instruction: PeepholeInstruction,
                              previousIndex: Int?,
                              nextIndex: Int?,
                              file: StaticString = #file,
                              line: UInt = #line) {
  XCTAssertEqual(instruction.previousInstructionUnalignedIndex,
                 previousIndex,
                 "Previous index",
                 file: file,
                 line: line)

  XCTAssertEqual(instruction.nextInstructionIndex,
                 nextIndex,
                 "Next index",
                 file: file,
                 line: line)
}

class PeepholeInstructionTests: XCTestCase {

  // MARK: - Init - start index - out of bound

  func test_initStartIndex_indexBeforeStartIndex_returnsNil() {
    let instructions: [Instruction] = [
      .nop,
      .loadConst(index: 0xf0),
      .return
    ]

    let instruction = PeepholeInstruction(instructions: instructions, startIndex: -1)
    XCTAssertNil(instruction)
  }

  func test_initStartIndex_indexAfterEndIndex_returnsNil() {
    let instructions: [Instruction] = [
      .nop,
      .loadConst(index: 0xf0),
      .return
    ]

    let instruction = PeepholeInstruction(instructions: instructions, startIndex: 10)
    XCTAssertNil(instruction)
  }

  // MARK: - Init - start index

  func test_initStartIndex_first_works() {
    let instructions: [Instruction] = [
      .loadConst(index: 0xf0),
      .return
    ]

    guard let instruction = PeepholeInstruction(instructions: instructions,
                                                startIndex: 0) else {
      XCTFail("Instruction was not created?")
      return
    }

    XCTAssertInstruction(instruction,
                         startIndex: 0,
                         value: .loadConst(index: 0xf0))
    XCTAssertExtendedArg(instruction,
                         instructionArg: 0xf0,
                         valueWithInstructionArg: 0xf0,
                         count: 0)
    XCTAssertIndices(instruction,
                     previousIndex: nil,
                     nextIndex: 1)
  }

  func test_initStartIndex_middle_works() {
    let instructions: [Instruction] = [
      .nop,
      .loadConst(index: 0xf0),
      .return
    ]

    guard let instruction = PeepholeInstruction(instructions: instructions,
                                                startIndex: 1) else {
      XCTFail("Instruction was not created?")
      return
    }

    XCTAssertInstruction(instruction,
                         startIndex: 1,
                         value: .loadConst(index: 0xf0))
    XCTAssertExtendedArg(instruction,
                         instructionArg: 0xf0,
                         valueWithInstructionArg: 0xf0,
                         count: 0)
    XCTAssertIndices(instruction,
                     previousIndex: 0,
                     nextIndex: 2)
  }

  func test_initStartIndex_last_works() {
    let instructions: [Instruction] = [
      .nop,
      .return,
      .loadConst(index: 0xf0)
    ]

    guard let instruction = PeepholeInstruction(instructions: instructions,
                                                startIndex: 2) else {
      XCTFail("Instruction was not created?")
      return
    }

    XCTAssertInstruction(instruction,
                         startIndex: 2,
                         value: .loadConst(index: 0xf0))
    XCTAssertExtendedArg(instruction,
                         instructionArg: 0xf0,
                         valueWithInstructionArg: 0xf0,
                         count: 0)
    XCTAssertIndices(instruction,
                     previousIndex: 1,
                     nextIndex: nil)
  }

  // MARK: - Init - start index - extended

  func test_initStartIndex_1extendedArg_works() {
    let instructions: [Instruction] = [
      .nop, // 0
      .extendedArg(0xfa), // 1
      .loadConst(index: 0xf0), // 2
      .return // 3
    ]

    guard let instruction = PeepholeInstruction(instructions: instructions,
                                                startIndex: 1) else {
      XCTFail("Instruction was not created?")
      return
    }

    XCTAssertInstruction(instruction,
                         startIndex: 1,
                         value: .loadConst(index: 0xf0))
    XCTAssertExtendedArg(instruction,
                         instructionArg: 0xf0,
                         valueWithInstructionArg: 0xfaf0,
                         count: 1)
    XCTAssertIndices(instruction,
                     previousIndex: 0,
                     nextIndex: 3)
  }

  func test_initStartIndex_2extendedArg_works() {
    let instructions: [Instruction] = [
      .nop, // 0
      .extendedArg(0xfa), // 1
      .extendedArg(0xfb), // 2
      .loadConst(index: 0xf0), // 3
      .return // 4
    ]

    guard let instruction = PeepholeInstruction(instructions: instructions,
                                                startIndex: 1) else {
      XCTFail("Instruction was not created?")
      return
    }

    XCTAssertInstruction(instruction,
                         startIndex: 1,
                         value: .loadConst(index: 0xf0))
    XCTAssertExtendedArg(instruction,
                         instructionArg: 0xf0,
                         valueWithInstructionArg: 0xfa_fbf0,
                         count: 2)
    XCTAssertIndices(instruction,
                     previousIndex: 0,
                     nextIndex: 4)
  }

  func test_initStartIndex_3extendedArg_works() {
    let instructions: [Instruction] = [
      .nop, // 0
      .extendedArg(0xfa), // 1
      .extendedArg(0xfb), // 2
      .extendedArg(0xfc), // 3
      .loadConst(index: 0xf0), // 4
      .return // 5
    ]

    guard let instruction = PeepholeInstruction(instructions: instructions,
                                                startIndex: 1) else {
      XCTFail("Instruction was not created?")
      return
    }

    XCTAssertInstruction(instruction,
                         startIndex: 1,
                         value: .loadConst(index: 0xf0))
    XCTAssertExtendedArg(instruction,
                         instructionArg: 0xf0,
                         valueWithInstructionArg: 0xfafb_fcf0,
                         count: 3)
    XCTAssertIndices(instruction,
                     previousIndex: 0,
                     nextIndex: 5)
  }

  func test_initStartIndex_2extendedArg_startIndexAt1_works() {
    let instructions: [Instruction] = [
      .nop, // 0
      .extendedArg(0xfa), // 1
      .extendedArg(0xfb), // 2 <-- startIndex!
      .loadConst(index: 0xf0), // 3
      .return // 4
    ]

    guard let instruction = PeepholeInstruction(instructions: instructions,
                                                startIndex: 2) else {
      XCTFail("Instruction was not created?")
      return
    }

    XCTAssertInstruction(instruction,
                         startIndex: 2,
                         value: .loadConst(index: 0xf0))
    XCTAssertExtendedArg(instruction,
                         instructionArg: 0xf0,
                         valueWithInstructionArg: 0xfbf0,
                         count: 1)
    XCTAssertIndices(instruction,
                     previousIndex: 1,
                     nextIndex: 4)
  }

  // MARK: - Init - unaligned index

  func test_initUnalignedIndex_first_works() {
    let instructions: [Instruction] = [
      .loadConst(index: 0xf0),
      .return
    ]

    guard let instruction = PeepholeInstruction(instructions: instructions,
                                                unalignedIndex: 0) else {
      XCTFail("Instruction was not created?")
      return
    }

    XCTAssertInstruction(instruction,
                         startIndex: 0,
                         value: .loadConst(index: 0xf0))
    XCTAssertExtendedArg(instruction,
                         instructionArg: 0xf0,
                         valueWithInstructionArg: 0xf0,
                         count: 0)
    XCTAssertIndices(instruction,
                     previousIndex: nil,
                     nextIndex: 1)
  }

  func test_initUnalignedIndex_last_works() {
    let instructions: [Instruction] = [
      .return,
      .extendedArg(0xfa),
      .loadConst(index: 0xf0)
    ]

    guard let instruction = PeepholeInstruction(instructions: instructions,
                                                unalignedIndex: 2) else {
      XCTFail("Instruction was not created?")
      return
    }

    XCTAssertInstruction(instruction,
                         startIndex: 1,
                         value: .loadConst(index: 0xf0))
    XCTAssertExtendedArg(instruction,
                         instructionArg: 0xf0,
                         valueWithInstructionArg: 0xfaf0,
                         count: 1)
    XCTAssertIndices(instruction,
                     previousIndex: 0,
                     nextIndex: nil)
  }

  func test_initUnalignedIndex_2extendedArg_indexAtValue_works() {
    let instructions: [Instruction] = [
      .nop, // 0
      .extendedArg(0xfa), // 1 <-- start index
      .extendedArg(0xfb), // 2
      .loadConst(index: 0xf0), // 3 <-- index
      .return // 4
    ]

    guard let instruction = PeepholeInstruction(instructions: instructions,
                                                unalignedIndex: 3) else {
      XCTFail("Instruction was not created?")
      return
    }

    XCTAssertInstruction(instruction,
                         startIndex: 1,
                         value: .loadConst(index: 0xf0))
    XCTAssertExtendedArg(instruction,
                         instructionArg: 0xf0,
                         valueWithInstructionArg: 0xfa_fbf0,
                         count: 2)
    XCTAssertIndices(instruction,
                     previousIndex: 0,
                     nextIndex: 4)
  }

  func test_initUnalignedIndex_2extendedArg_indexAtExtended2_works() {
    let instructions: [Instruction] = [
      .nop, // 0
      .extendedArg(0xfa), // 1 <-- start index
      .extendedArg(0xfb), // 2 <-- index
      .loadConst(index: 0xf0), // 3
      .return // 4
    ]

    guard let instruction = PeepholeInstruction(instructions: instructions,
                                                unalignedIndex: 2) else {
      XCTFail("Instruction was not created?")
      return
    }

    XCTAssertInstruction(instruction,
                         startIndex: 1,
                         value: .loadConst(index: 0xf0))
    XCTAssertExtendedArg(instruction,
                         instructionArg: 0xf0,
                         valueWithInstructionArg: 0xfa_fbf0,
                         count: 2)
    XCTAssertIndices(instruction,
                     previousIndex: 0,
                     nextIndex: 4)
  }

  func test_initUnalignedIndex_2extendedArg_indexAtExtended1_works() {
    let instructions: [Instruction] = [
      .nop, // 0
      .extendedArg(0xfa), // 1 <-- index, start index
      .extendedArg(0xfb), // 2
      .loadConst(index: 0xf0), // 3
      .return // 4
    ]

    guard let instruction = PeepholeInstruction(instructions: instructions,
                                                unalignedIndex: 2) else {
      XCTFail("Instruction was not created?")
      return
    }

    XCTAssertInstruction(instruction,
                         startIndex: 1,
                         value: .loadConst(index: 0xf0))
    XCTAssertExtendedArg(instruction,
                         instructionArg: 0xf0,
                         valueWithInstructionArg: 0xfa_fbf0,
                         count: 2)
    XCTAssertIndices(instruction,
                     previousIndex: 0,
                     nextIndex: 4)
  }
}

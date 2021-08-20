import XCTest
@testable import VioletBytecode

class PeepholeJumpTableTests: XCTestCase {

  func test_hasJumpTargetBetween_noJumps_returnsFalse() {
    let instructions: [Instruction] = [
      .nop, // 0, partition: 0
      .nop, // 1, partition: 0
      .nop // 2, partition: 0
    ]

    let labels: [CodeObject.Label] = []

    let table = PeepholeJumpTable(instructions: instructions, labels: labels)
    XCTAssertFalse(table.hasJumpTargetBetween(0, and: 1))
    XCTAssertFalse(table.hasJumpTargetBetween(1, and: 2))
  }

  func test_hasJumpTargetBetween_equalIndices_returnsFalse() {
    let instructions: [Instruction] = [
      .nop, // 0, partition: 0
      .nop, // 1, partition: 1, <-- jump target
      .nop // 2, partition: 1
    ]

    let labels: [CodeObject.Label] = [
      .init(instructionIndex: 1)
    ]

    let table = PeepholeJumpTable(instructions: instructions, labels: labels)
    XCTAssertFalse(table.hasJumpTargetBetween(0, and: 0))
    XCTAssertFalse(table.hasJumpTargetBetween(1, and: 1))
    XCTAssertFalse(table.hasJumpTargetBetween(2, and: 2))
  }

  func test_hasJumpTargetBetween_withJumps_returnsTrue() {
    let instructions: [Instruction] = [
      .nop, // 0, partition: 0
      .nop, // 1, partition: 1, <-- jump target
      .nop // 2, partition: 2, <-- jump target
    ]

    let labels: [CodeObject.Label] = [
      .init(instructionIndex: 1),
      .init(instructionIndex: 2)
    ]

    let table = PeepholeJumpTable(instructions: instructions, labels: labels)
    XCTAssertTrue(table.hasJumpTargetBetween(0, and: 1))
    XCTAssertTrue(table.hasJumpTargetBetween(1, and: 2))
  }

  func test_hasJumpTargetBetween_insideSinglePartition_returnsFalse() {
    let instructions: [Instruction] = [
      .nop, // 0, partition: 0
      .nop, // 1, partition: 1, <-- jump target
      .nop, // 2, partition: 1
      .nop, // 3, partition: 1
      .nop // 4, partition: 2, <-- jump target
    ]

    let labels: [CodeObject.Label] = [
      .init(instructionIndex: 1),
      .init(instructionIndex: 4)
    ]

    let table = PeepholeJumpTable(instructions: instructions, labels: labels)
    XCTAssertFalse(table.hasJumpTargetBetween(1, and: 2))
    XCTAssertFalse(table.hasJumpTargetBetween(1, and: 3))
    XCTAssertFalse(table.hasJumpTargetBetween(2, and: 3))
  }
}

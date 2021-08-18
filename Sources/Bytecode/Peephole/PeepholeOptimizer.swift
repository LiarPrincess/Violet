import VioletCore

// In CPython:
// Python -> peephole.c

// This is almost 1:1 rewrite of CPython code.
// The thing is, that part of the Python semantic is implemented inside peephole
// optimizer. So, we have to do exactly the same things as them.

internal class PeepholeOptimizer {

  /// `Instructions` before any optimizations were applied.
  internal let oldInstructions: [Instruction]
  /// `InstructionLines` before any optimizations were applied.
  internal let oldInstructionLines: [SourceLine]
  /// `Constants` before any optimizations were applied.
  internal let oldConstants: [CodeObject.Constant]
  /// `Labels` before any optimizations were applied.
  internal let oldLabels: [CodeObject.Label]

  /// Information about jumps in the `self.oldInstructions` according to
  /// `self.oldLabels`.
  ///
  /// `old` means that those information were calculated before any optimizations
  /// were applied. This should be OK, because none of our optimizations add new
  /// jumps.
  internal let oldJumpTable: PeepholeJumpTable

  internal init(instructions: [Instruction],
                instructionLines: [SourceLine],
                constants: [CodeObject.Constant],
                labels: [CodeObject.Label]) {
    assert(instructions.count == instructionLines.count)
    self.oldInstructions = instructions
    self.oldInstructionLines = instructionLines
    self.oldConstants = constants
    self.oldLabels = labels
    self.oldJumpTable = PeepholeJumpTable(instructions: instructions, labels: labels)
  }

  // MARK: - Fill nop

  /// Sets the instructions `startIndex..<endIndex` to `nop`.
  internal func fillNop(result: inout [Instruction],
                        startIndex: Int,
                        endIndex: Int?) {
    let endIndex = endIndex ?? self.instructions.count
    assert(startIndex <= endIndex)

    for index in startIndex..<endIndex {
      result[index] = .nop
    }
  }

  // MARK: - Instruction predicates

  /// \#define UNCONDITIONAL_JUMP(op)  (op==JUMP_ABSOLUTE || op==JUMP_FORWARD)
  internal func isUnconditionalJump(instruction: Instruction) -> Bool {
    // We can omit the '(labelIndex: _)', but this is better.
    switch instruction {
    case .jumpAbsolute(labelIndex: _):
      // We do not have jumpForward
      return true
    default:
      return false
    }
  }

  /// \#define CONDITIONAL_JUMP(op) (op==POP_JUMP_IF_FALSE || op==POP_JUMP_IF_TRUE \
  ///    || op==JUMP_IF_FALSE_OR_POP || op==JUMP_IF_TRUE_OR_POP)
  internal func isConditionalJump(instruction: Instruction) -> Bool {
    // We can omit the '(labelIndex: _)', but this is better.
    switch instruction {
    case .popJumpIfFalse(labelIndex: _),
         .popJumpIfTrue(labelIndex: _),
         .jumpIfFalseOrPop(labelIndex: _),
         .jumpIfTrueOrPop(labelIndex: _):
      return true
    default:
      return false
    }
  }

  /// \#define JUMPS_ON_TRUE(op) (op==POP_JUMP_IF_TRUE || op==JUMP_IF_TRUE_OR_POP)
  internal func isJumpOnTrue(instruction: Instruction) -> Bool {
    // We can omit the '(labelIndex: _)', but this is better.
    switch instruction {
    case .popJumpIfTrue(labelIndex: _),
         .jumpIfTrueOrPop(labelIndex: _):
      return true
    default:
      return false
    }
  }
}

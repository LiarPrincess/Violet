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
}

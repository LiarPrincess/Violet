import VioletCore

// In CPython:
// Python -> peephole.c

// This is almost 1:1 rewrite of CPython code.
// The thing is, that part of the Python semantic is implemented inside peephole
// optimizer. So, we have to do exactly the same things as them.

internal class PeepholeOptimizer {

  internal let instructions: [Instruction]
  internal let instructionLines: [SourceLine]
  internal let constants: [CodeObject.Constant]
  internal let labels: [CodeObject.Label]

  private lazy var jumpTargets = self.findJumpTargets()

  internal init(instructions: [Instruction],
                instructionLines: [SourceLine],
                constants: [CodeObject.Constant],
                labels: [CodeObject.Label]) {
    assert(instructions.count == instructionLines.count)
    self.instructions = instructions
    self.instructionLines = instructionLines
    self.constants = constants
    self.labels = labels
  }

  // MARK: - Jump targets

  /// For every jump target we will increment a running value.
  ///
  /// The end result looks something like:
  /// ```
  /// 0
  /// 0
  /// 1 <- 1st jump target
  /// 1
  /// 1
  /// 2 <- 2nd jump target
  /// (an so on…)
  /// ```
  internal struct JumpTargets {

    private var data: [Int]

    fileprivate init(instructionCount: Int) {
      self.data = [Int](repeating: 0, count: instructionCount)
    }

    fileprivate subscript(instructionIndex: Int) -> Int {
      get { return self.data[instructionIndex] }
      set { self.data[instructionIndex] = newValue }
    }
  }

  /// static unsigned int *
  /// markblocks(_Py_CODEUNIT *code, Py_ssize_t len)
  internal func findJumpTargets() -> JumpTargets {
    // Our code is simpler than the one in CPython, because all of our jumps
    // are absolute (and stored in a single array).

    var result = JumpTargets(instructionCount: self.instructions.count)

    // Mark jump targets with '1'.
    for label in self.labels {
      assert(label != CodeObject.Label.notAssigned)

      let jumpTarget = label.instructionIndex
      result[jumpTarget] = 1
    }

    // Build block numbers.
    var acc = 0
    for index in 0..<self.instructions.count {
      acc += result[index]
      result[index] = acc
    }

    return result
  }

  internal func hasJumpTargetBetween(_ instruction: PeepholeInstruction,
                                     and next: PeepholeInstruction) -> Bool {
    let index0 = instruction.startIndex
    let index1 = next.startIndex
    return self.hasJumpTargetBetween(index0, and: index1)
  }

  internal func hasJumpTargetBetween(_ instruction: PeepholeInstruction,
                                     and index: Int) -> Bool {
    let instructionIndex = instruction.startIndex
    return self.hasJumpTargetBetween(instructionIndex, and: index)
  }

  /// Opposite of:
  /// \#define ISBASICBLOCK(blocks, start, end) \
  ///     (blocks[start]==blocks[end])
  internal func hasJumpTargetBetween(_ index0: Int, and index1: Int) -> Bool {
    assert(index0 < self.instructions.count)

    // Sometimes we may use 'self.instructions.count' as end index
    guard index1 < self.instructions.count else {
      return false
    }

    let block0 = self.jumpTargets[index0]
    let block1 = self.jumpTargets[index1]
    return block0 != block1
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

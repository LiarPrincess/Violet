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
    self.instructions = instructions
    self.instructionLines = instructionLines
    self.constants = constants
    self.labels = labels
  }

  // MARK: - Jump targets

  /// After every jump target we will increment value.
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

    fileprivate var data: [Int]

    fileprivate init(instructionCount: Int) {
      self.data = [Int](repeating: 0, count: instructionCount)
    }
  }

  /// static unsigned int *
  /// markblocks(_Py_CODEUNIT *code, Py_ssize_t len)
  internal func findJumpTargets() -> JumpTargets {
    var result = JumpTargets(instructionCount: self.instructions.count)
    // TODO: Use 'for each labels'

    // 1st pass: mark jump targets with '1'.
    // (We need 2 passes, because jumps may go forward/backward.)
    var extendedArg = 0
    for instruction in self.instructions {
      switch instruction {
      case let .extendedArg(arg):
        extendedArg = Instruction.extend(base: extendedArg, arg: arg)

      case let .jumpAbsolute(labelIndex: arg),
           // .jumpForward
           let .jumpIfFalseOrPop(labelIndex: arg),
           let .jumpIfTrueOrPop(labelIndex: arg),
           let .popJumpIfFalse(labelIndex: arg),
           let .popJumpIfTrue(labelIndex: arg),
           let .forIter(ifEmptyLabelIndex: arg),
           let .continue(loopStartLabelIndex: arg),
           let .setupLoop(loopEndLabelIndex: arg),
           let .setupExcept(firstExceptLabelIndex: arg),
           let .setupFinally(finallyStartLabelIndex: arg),
           let .setupWith(afterBodyLabelIndex: arg):
        // TODO: .setupAsyncWith:
        let labelIndex = Instruction.extend(base: extendedArg, arg: arg)
        let jumpTarget = self.getAbsoluteJumpTarget(labelIndex: labelIndex)
        result.data[jumpTarget] = 1
        extendedArg = 0

      default:
        extendedArg = 0
      }
    }

    // 2nd pass: build block numbers.
    var acc = 0
    for index in 0..<self.instructions.count {
      acc += result.data[index]
      result.data[index] = acc
    }

    return result
  }

  /// Get jump target starting from beginning of the instructions.
  internal func getAbsoluteJumpTarget(labelIndex: Int) -> Int {
    // In Violet all of the jumps are absolute.
    // If that ever changes we would need to:
    // let isAbsoluteJump = self.isAbsoluteJump(instruction: instruction)
    // let relativeToAbsolute = isAbsoluteJump ? 0 : instructionIndex + 1
    // return target + relativeToAbsolute

    let label = self.labels[labelIndex]
    let target = label.instructionIndex
    return target
  }

  internal func hasJumpTargetBetween(_ instruction: InstructionInfo,
                                     _ next: InstructionInfo) -> Bool {
    let index0 = instruction.startIndex
    let index1 = next.startIndex
    return self.hasJumpTargetBetween(index0, and: index1)
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

    let block0 = self.jumpTargets.data[index0]
    let block1 = self.jumpTargets.data[index1]
    return block0 != block1
  }

  // MARK: - Fill nop

  /// Sets the instructions `startIndex..<endIndex` to `nop`.
  internal func fillNop(result: inout [Instruction],
                        startIndex: Int,
                        endIndex: Int?) {
    let endIndex = endIndex ?? self.instructions.count
    assert(startIndex < endIndex)

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

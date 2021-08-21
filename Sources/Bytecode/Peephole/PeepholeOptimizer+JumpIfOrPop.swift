import VioletCore

// In CPython:
// Python -> peephole.c

extension PeepholeOptimizer {

  /// Simplify conditional jump to conditional jump where the
  /// result of the first test implies the success of a similar
  /// test or the failure of the opposite test.
  ///
  /// Arises in code like:
  /// ```
  /// "a and b or c"
  /// "(a and b) and c"
  /// "(a or b) or c"
  /// "(a or b) and c"
  /// ```
  internal func optimizeJumpIfOrPop(result: inout OptimizationResult,
                                    jumpIfOrPop: PeepholeInstruction,
                                    arg: UInt8) -> Int? {
    let labelIndex = jumpIfOrPop.getArgument(instructionArg: arg)
    if let replacedInstructionIndex = self.simplifyJumpToConditionalJump(
      result: &result,
      jumpIfOrPop: jumpIfOrPop,
      labelIndex: labelIndex
    ) {
      return replacedInstructionIndex
    }

    self.optimizeJumps(result: &result,
                       instruction: jumpIfOrPop,
                       arg: arg)

    return nil
  }

  private func simplifyJumpToConditionalJump(result: inout OptimizationResult,
                                             jumpIfOrPop: PeepholeInstruction,
                                             labelIndex: Int) -> Int? {
    let label = result.labels[labelIndex]
    let targetIndex = label.instructionIndex

    guard let targetInstruction = result.instructions.get(startIndex: targetIndex),
          let target = TargetJump(instruction: targetInstruction) else {
      return nil
    }

    // === jumpIfTrueOrPop -> jumpIfTrueOrPop ===
    //
    // Before:                           || After:
    //                                   ||
    // jumpIfTrueOrPop -----.            || jumpIfTrueOrPop --------------.
    //   xxx                | jumps here ||   xxx                         |
    // jumpIfTrueOrPop -. <-'            || jumpIfTrueOrPop -.            | jumps here
    //   xxx            | jumps here     ||   xxx            | jumps here |
    // xxx <------------'                || xxx <------------+------------'

    // === jumpIfTrueOrPop -> popJumpIfTrue ===
    //
    // Before:                         || After:
    //                                 ||
    // jumpIfTrueOrPop ---.            || popJumpIfTrue --------------.
    //   xxx              | jumps here ||   xxx                       |
    // popJumpIfTrue -. <-'            || popJumpIfTrue -.            | jumps here
    //   xxx          | jumps here     ||   xxx          | jumps here |
    // xxx <----------'                || xxx <----------+------------'

    // === jumpIfTrueOrPop -> jumpIfFalseOrPop ===
    //
    // Before:                            || After:
    //                                    ||
    // jumpIfTrueOrPop ------.            || popJumpIfTrue--------.
    //   xxx                 | jumps here ||   xxx                | jumps here
    // jumpIfFalseOrPop -. <-'            || jumpIfFalseOrPop -.  |
    //   xxx             | jumps here     ||   xxx <-----------|--'
    // xxx <-------------'                || xxx <-------------'

    // === jumpIfTrueOrPop -> popJumpIfFalse ===
    //
    // Before:                           || After:
    //                                   ||
    // jumpIfTrueOrPop ----.             || popJumpIfTrue -----.
    //   xxx               | jumps here  ||   xxx              | jumps here
    // popJumpIfFalse -. <-'             || popJumpIfFalse -.  |
    //   xxx           | jumps here      ||   xxx <---------|--'
    // xxx <-----------'                 || xxx <-----------'

    // Jump condition stays the same.
    let jumpCondition = jumpIfOrPop.isJumpOnTrue

    // Is new instruction 'jumpIfOrPop' or 'popJumpIf'?
    // - 'jumpIfTrueOrPop' and 'jumpIfTrueOrPop' -> jumpIfOrPop
    // - 'jumpIfTrueOrPop' and 'popJumpIfTrue' -> 'popJumpIf', 2nd jump pops
    // - 'jumpIfTrueOrPop' and 'popJumpIfFalse' -> 'popJumpIf', 2nd jump pops
    // - 'jumpIfTrueOrPop' and 'jumpIfFalseOrPop' -> 'popJumpIf', we are 'true'
    //    but when we reach 'jumpIfFalseOrPop' it will pop
    let targetCondition = target.isJumpOnTrue
    let sameCondition = jumpCondition == targetCondition
    let jumpKind: JumpKind = sameCondition && target.jumpKind == .jumpIfOrPop ?
      .jumpIfOrPop :
      .popJumpIf

    // New target?
    // - Same condition -> same 'target' as 'target'
    // - Different condition -> instruction after 'target'
    let newLabelIndex: Int
    if sameCondition {
      newLabelIndex = target.labelIndex
    } else {
      newLabelIndex = result.labels.count
      let index = targetInstruction.nextInstructionIndex ?? result.instructions.count
      result.labels.append(CodeObject.Label(instructionIndex: index))
    }

    return self.write(result: &result,
                      oldInstruction: jumpIfOrPop,
                      newCondition: jumpCondition,
                      newKind: jumpKind,
                      newLabelIndex: newLabelIndex)
  }

  private enum JumpKind {
    case jumpIfOrPop
    case popJumpIf
  }

  private struct TargetJump {

    fileprivate let labelIndex: Int
    fileprivate let jumpKind: JumpKind
    fileprivate let isJumpOnTrue: Bool

    fileprivate init?(instruction: PeepholeInstruction) {
      self.isJumpOnTrue = instruction.isJumpOnTrue

      switch instruction.value {
      case let .jumpIfFalseOrPop(labelIndex: arg),
           let .jumpIfTrueOrPop(labelIndex: arg):
        self.jumpKind = .jumpIfOrPop
        self.labelIndex = instruction.getArgument(instructionArg: arg)
      case let .popJumpIfFalse(labelIndex: arg),
           let .popJumpIfTrue(labelIndex: arg):
        self.jumpKind = .popJumpIf
        self.labelIndex = instruction.getArgument(instructionArg: arg)
      default:
        return nil
      }
    }
  }

  private func write(result: inout OptimizationResult,
                     oldInstruction: PeepholeInstruction,
                     newCondition: Bool,
                     newKind: JumpKind,
                     newLabelIndex: Int) -> Int? {
    let newLabelIndexSplit = CodeObjectBuilder.splitExtendedArg(newLabelIndex)

    let oldInstructionCount = oldInstruction.instructionCount
    let newInstructionCount = newLabelIndexSplit.count
    guard newInstructionCount <= oldInstructionCount else {
      return nil
    }

    let newInstructionArg = newLabelIndexSplit.instructionArg
    let newInstruction = self.createInstruction(condition: newCondition,
                                                kind: newKind,
                                                argument: newInstructionArg)

    // Write the instruction at the end of the 'nop' space.
    // This is important because we may want to re-run the optimizations on it.
    let oldStartIndex = oldInstruction.startIndex
    let newStartIndex = oldStartIndex + oldInstructionCount - newInstructionCount

    let line = result.instructionLines[oldStartIndex]

    result.instructions.setToNop(instruction: oldInstruction)
    result.write(index: newStartIndex,
                 extendedArg0: newLabelIndexSplit.extendedArg0,
                 extendedArg1: newLabelIndexSplit.extendedArg1,
                 extendedArg2: newLabelIndexSplit.extendedArg2,
                 instruction: newInstruction,
                 line: line)

    return newStartIndex
  }

  private func createInstruction(condition: Bool,
                                 kind: JumpKind,
                                 argument: UInt8) -> Instruction {
    switch kind {
    case .jumpIfOrPop:
      return condition ?
        .jumpIfTrueOrPop(labelIndex: argument) :
        .jumpIfFalseOrPop(labelIndex: argument)
    case .popJumpIf:
      return condition ?
        .popJumpIfTrue(labelIndex: argument) :
        .popJumpIfFalse(labelIndex: argument)
    }
  }
}

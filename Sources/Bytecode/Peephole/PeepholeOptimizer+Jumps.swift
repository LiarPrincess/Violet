import VioletCore

// In CPython:
// Python -> peephole.c

extension PeepholeOptimizer {

  // Replace jumps to unconditional jumps
  internal func optimizeJumps(result: inout OptimizationResult,
                              instruction: PeepholeInstruction,
                              arg: UInt8) {
    let labelIndex = instruction.getArgument(instructionArg: arg)
    let label = result.labels[labelIndex]
    let targetIndex = label.instructionIndex

    guard let target = result.instructions.get(startIndex: targetIndex) else {
      return
    }

    if self.replaceJumpToReturnByJustReturn(result: &result,
                                            instruction: instruction,
                                            target: target) {
      return
    }

    self.replaceJumpToAbsoluteJumpByJustJump(result: &result,
                                             instruction: instruction,
                                             target: target)
  }

  // MARK: - Jump to return

  /// Replace JUMP_* to a RETURN into just a RETURN
  private func replaceJumpToReturnByJustReturn(result: inout OptimizationResult,
                                               instruction: PeepholeInstruction,
                                               target: PeepholeInstruction) -> Bool {
    guard instruction.isUnconditionalJump else {
      return false
    }

    switch target.value {
    case .return:
      result.instructions.setToNop(instruction: instruction)
      result.instructions[instruction.startIndex] = .return
      return true

    default:
      return false
    }
  }

  // MARK: - Jump to absolute jump

  // swiftlint:disable:next function_body_length
  private func replaceJumpToAbsoluteJumpByJustJump(result: inout OptimizationResult,
                                                   instruction: PeepholeInstruction,
                                                   target: PeepholeInstruction) {
    let labelIndex: Int
    switch target.value {
    case let .jumpAbsolute(labelIndex: arg):
      labelIndex = target.getArgument(instructionArg: arg)
    default:
      return
    }

    let labelIndexSplit = CodeObjectBuilder.splitExtendedArg(labelIndex)

    let oldInstructionCount = instruction.instructionCount
    let newInstructionCount = labelIndexSplit.count
    guard newInstructionCount <= oldInstructionCount else {
      return
    }

    let arg = labelIndexSplit.instructionArg
    let newInstruction: Instruction

    switch instruction.value {
    case .jumpAbsolute: newInstruction = .jumpAbsolute(labelIndex: arg)
    // case .jumpForward:
    case .jumpIfTrueOrPop: newInstruction = .jumpIfTrueOrPop(labelIndex: arg)
    case .jumpIfFalseOrPop: newInstruction = .jumpIfFalseOrPop(labelIndex: arg)
    case .popJumpIfFalse: newInstruction = .popJumpIfFalse(labelIndex: arg)
    case .popJumpIfTrue: newInstruction = .popJumpIfTrue(labelIndex: arg)
    case .setupLoop: newInstruction = .setupLoop(loopEndLabelIndex: arg)
    case .forIter: newInstruction = .forIter(ifEmptyLabelIndex: arg)
    case .continue: newInstruction = .continue(loopStartLabelIndex: arg)
    case .setupExcept: newInstruction = .setupExcept(firstExceptLabelIndex: arg)
    case .setupFinally: newInstruction = .setupFinally(finallyStartLabelIndex: arg)
    case .setupWith: newInstruction = .setupWith(afterBodyLabelIndex: arg)
    // case .setupAsyncWith:
    default:
      let i = instruction.value
      trap("Unknown instruction '\(i)' passed to 'PeepholeOptimizer.optimizeJumps'")
    }

    let startIndex = instruction.startIndex
    let line = result.instructionLines[startIndex]

    result.instructions.setToNop(instruction: instruction)
    result.write(index: startIndex,
                 extendedArg0: labelIndexSplit.extendedArg0,
                 extendedArg1: labelIndexSplit.extendedArg1,
                 extendedArg2: labelIndexSplit.extendedArg2,
                 instruction: newInstruction,
                 line: line)
  }
}

import VioletCore

// cSpell:ignore SEQN

// In CPython:
// Python -> peephole.c

extension PeepholeOptimizer {

  /// Try to fold tuples of constants.
  ///
  /// Skip over `BUILD_SEQN 1 UNPACK_SEQN 1.`
  /// Replace `BUILD_SEQN 2 UNPACK_SEQN 2` with `ROT2`.
  /// Replace `BUILD_SEQN 3 UNPACK_SEQN 3` with `ROT3 ROT2`.
  internal func optimizeBuildTuple(result: inout OptimizationResult,
                                   buildTuple: PeepholeInstruction,
                                   buildTupleArg: UInt8,
                                   next: PeepholeInstruction?) {
    let elementCount = buildTuple.getArgument(instructionArg: buildTupleArg)

    if self.mergeConstantTuple(result: &result,
                               buildTuple: buildTuple,
                               elementCount: elementCount) {
      // We can't continue on this path because 'buildTuple' is now 'loadConst'
      return
    }

    self.buildTuple_thenUnpackSequence(result: &result,
                                       buildTuple: buildTuple,
                                       elementCount: elementCount,
                                       next: next)
  }

  // MARK: - Constant tuple

  /// `loadConst; loadConst; buildTuple 2` -> just use constant tuple.
  private func mergeConstantTuple(result: inout OptimizationResult,
                                  buildTuple: PeepholeInstruction,
                                  elementCount: Int) -> Bool {
    guard elementCount > 0 else {
      return false
    }

    guard let constants = self.getPrecedingConstants(result: result,
                                                     buildTuple: buildTuple,
                                                     count: elementCount) else {
      return false
    }

    let constantIndex = result.constants.count
    let constantIndexSplit = CodeObjectBuilder.splitExtendedArg(constantIndex)

    // Do we have enough space to emit the instruction?
    let indexAfterTuple = buildTuple.nextInstructionIndex ?? result.instructions.count
    let spaceHave = indexAfterTuple - constants.startIndexOfFirstLoadConst
    guard constantIndexSplit.count <= spaceHave else {
      return false
    }

    let tuple = CodeObject.Constant.tuple(constants.values)
    result.constants.append(tuple)

    // Reset everything to 'nop'.
    result.instructions.setToNop(startIndex: constants.startIndexOfFirstLoadConst,
                                 endIndex: indexAfterTuple)

    // We need to emit a single 'loadConst' with 'constantIndex' as argument
    var instructionIndex = constants.startIndexOfFirstLoadConst
    let buildTupleLine = result.instructionLines[buildTuple.startIndex]

    func append(instruction: Instruction) {
      result.instructions[instructionIndex] = instruction
      result.instructionLines[instructionIndex] = buildTupleLine
      instructionIndex += 1
    }

    if let arg = constantIndexSplit.extendedArg0 {
      append(instruction: .extendedArg(arg))
    }

    if let arg = constantIndexSplit.extendedArg1 {
      append(instruction: .extendedArg(arg))
    }

    if let arg = constantIndexSplit.extendedArg2 {
      append(instruction: .extendedArg(arg))
    }

    append(instruction: .loadConst(index: constantIndexSplit.instructionArg))
    return true
  }

  private struct PrecedingConstants {
    fileprivate let values: [CodeObject.Constant]
    fileprivate let startIndexOfFirstLoadConst: Int
  }

  private func getPrecedingConstants(result: OptimizationResult,
                                     buildTuple: PeepholeInstruction,
                                     count: Int) -> PrecedingConstants? {
    var constants = [CodeObject.Constant]()
    var startIndexOfFirstLoadConst = -1

    var index: Int? = buildTuple.startIndex - 1
    while constants.count != count {
      guard let instruction = result.instructions.get(unalignedIndex: index) else {
        return nil
      }

      index = instruction.previousInstructionUnalignedIndex

      switch instruction.value {
      case .nop:
        // We do allow 'nop' between constants.
        break

      case .loadConst(index: let arg):
        let constantIndex = instruction.getArgument(instructionArg: arg)
        let constant = result.constants[constantIndex]
        constants.append(constant)
        startIndexOfFirstLoadConst = instruction.startIndex

      default:
        return nil
      }
    }

    // Constants should be in 'tuple-order'.
    constants.reverse()

    return PrecedingConstants(
      values: constants,
      startIndexOfFirstLoadConst: startIndexOfFirstLoadConst
    )
  }

  // MARK: - Unpack sequence

  /// `buildTuple` and then `unpackSequence` -> why do we even build tuple?
  private func buildTuple_thenUnpackSequence(result: inout OptimizationResult,
                                             buildTuple: PeepholeInstruction,
                                             elementCount: Int,
                                             next: PeepholeInstruction?) {
    guard let unpackSequence = next else {
      return
    }

    guard case let .unpackSequence(elementCount: unpackArg) = unpackSequence.value else {
      return
    }

    let unpackCount = unpackSequence.getArgument(instructionArg: unpackArg)
    guard elementCount == unpackCount else {
      return
    }

    if self.oldJumpTable.hasJumpTargetBetween(buildTuple, and: unpackSequence) {
      return
    }

    let indexAfterUnpack = unpackSequence.nextInstructionIndex

    switch elementCount {
    case 0, 1:
      // push item0
      //   [possible extended]
      // builtTuple 1
      //   [possible extended]
      // unpackSequence 1
      //
      // No effect, set 'instruction' and 'next' to 'nop'.
      result.instructions.setToNop(startIndex: buildTuple.startIndex,
                                   endIndex: indexAfterUnpack)

    case 2:
      // push item0
      // push item1
      //   [possible extended]
      // builtTuple 2
      //   [possible extended]
      // unpackSequence 2
      //
      // Becomes:
      // push item0
      // push item1
      // rotTwo
      //   [possible nops]
      // nop
      //   [possible nops]
      result.instructions[buildTuple.startIndex] = .rotTwo
      result.instructions.setToNop(startIndex: buildTuple.startIndex + 1,
                                   endIndex: indexAfterUnpack)

    case 3:
      // push item0
      // push item1
      // push item2
      //   [possible extended]
      // builtTuple 3
      //   [possible extended]
      // unpackSequence 3
      //
      // Becomes:
      // push item0
      // push item1
      // push item2
      // rotThree
      // rotTwo
      // [possible nops]
      result.instructions[buildTuple.startIndex] = .rotThree
      result.instructions[buildTuple.startIndex + 1] = .rotTwo
      result.instructions.setToNop(startIndex: buildTuple.startIndex + 2,
                                   endIndex: indexAfterUnpack)

    default:
      break
    }
  }
}

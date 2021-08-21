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
                                   arg: UInt8) {
    let elementCount = buildTuple.getArgument(instructionArg: arg)

    if self.mergeTupleOfConstants(result: &result,
                                  buildTuple: buildTuple,
                                  elementCount: elementCount) {
      // We can't continue on this path because 'buildTuple' is now 'loadConst'
      return
    }

    self.nullifyFollowingUnpackSequence(result: &result,
                                        buildTuple: buildTuple,
                                        elementCount: elementCount)
  }

  // MARK: - Constant tuple

  /// `loadConst; loadConst; buildTuple 2` -> just use constant tuple.
  private func mergeTupleOfConstants(result: inout OptimizationResult,
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
    // We always have at least 2 slots (from 'loadConst' and 'buildTuple').
    // But if already have 65 536 constants then we would have to emit
    // 2 x 'extendedArg' before 'loadConst' which does not fit 2 in slots.
    // For example:
    // - builder.appendTrue() - 'True' will get constant slot '0'
    // - add 65536 dummy constants to take slots
    // - builder.appendTrue() -> loadConst(0)
    // - buildTuple(1) -> loadConst(65537) would need 3 slots, but we have only 2

    let startIndex = constants.startIndexOfFirstLoadConst
    let indexAfterTuple = buildTuple.nextInstructionIndex ?? result.instructions.count
    let spaceHave = indexAfterTuple - startIndex
    guard constantIndexSplit.count <= spaceHave else {
      return false
    }

    let tuple = CodeObject.Constant.tuple(constants.values)
    result.constants.append(tuple)

    // We need to emit a single 'loadConst' with 'constantIndex' as argument
    let line = result.instructionLines[buildTuple.startIndex]

    // Reset everything to 'nop'.
    // This is needed because we may be replacing 20 'loadConst' with just 1.
    result.instructions.setToNop(startIndex: startIndex, endIndex: indexAfterTuple)

    result.write(index: startIndex,
                 extendedArg0: constantIndexSplit.extendedArg0,
                 extendedArg1: constantIndexSplit.extendedArg1,
                 extendedArg2: constantIndexSplit.extendedArg2,
                 instruction: .loadConst(index: constantIndexSplit.instructionArg),
                 line: line)

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
  private func nullifyFollowingUnpackSequence(result: inout OptimizationResult,
                                              buildTuple: PeepholeInstruction,
                                              elementCount: Int) {
    let nextIndex = buildTuple.nextInstructionIndex
    guard let unpackSequence = result.instructions.get(startIndex: nextIndex) else {
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
    case 0,
         1:
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

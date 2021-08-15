// cSpell:ignore SEQN

// In CPython:
// Python -> peephole.c

extension PeepholeOptimizer {

  /// Try to fold tuples of constants.
  ///
  /// Skip over `BUILD_SEQN 1 UNPACK_SEQN 1.`
  /// Replace `BUILD_SEQN 2 UNPACK_SEQN 2` with `ROT2`.
  /// Replace `BUILD_SEQN 3 UNPACK_SEQN 3` with `ROT3 ROT2`.
  internal func optimizeBuildTuple(result: inout [Instruction],
                                   buildTuple: InstructionInfo,
                                   arg: UInt8,
                                   next: InstructionInfo?) {
    // TODO: Tuple + ConsecutiveConstIndex
    let elementCount = buildTuple.getArg(instructionArg: arg)
    self.buildTuple_thenUnpackSequence(result: &result,
                                       buildTuple: buildTuple,
                                       elementCount: elementCount,
                                       next: next)
  }

  // MARK: - Build tuple, unpack sequence

  /// `buildTuple` and then `unpackSequence` -> why do we even build tuple?
  private func buildTuple_thenUnpackSequence(result: inout [Instruction],
                                             buildTuple: InstructionInfo,
                                             elementCount: Int,
                                             next: InstructionInfo?) {
    guard let unpackSequence = next else {
      return
    }

    guard case let .unpackSequence(elementCount: unpackArg) = unpackSequence.value else {
      return
    }

    let unpackCount = unpackSequence.getArg(instructionArg: unpackArg)
    guard elementCount == unpackCount else {
      return
    }

    if self.hasJumpTargetBetween(buildTuple, unpackSequence) {
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
      self.fillNop(result: &result,
                   startIndex: buildTuple.startIndex,
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
      result[buildTuple.startIndex] = .rotTwo
      self.fillNop(result: &result,
                   startIndex: buildTuple.startIndex + 1,
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
      result[buildTuple.startIndex] = .rotThree
      result[buildTuple.startIndex + 1] = .rotTwo
      self.fillNop(result: &result,
                   startIndex: buildTuple.startIndex + 2,
                   endIndex: indexAfterUnpack)

    default:
      break
    }
  }
}

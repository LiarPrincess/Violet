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
    #warning("Tuple + ConsecutiveConstIndex")
    let elementCount = buildTuple.getArgument(instructionArg: buildTupleArg)

//    self.buildTupleOfConstants(result: &result,
//                               buildTuple: buildTuple,
//                               elementCount: elementCount)

    self.buildTuple_thenUnpackSequence(result: &result,
                                       buildTuple: buildTuple,
                                       elementCount: elementCount,
                                       next: next)
  }

  // MARK: - Constant tuple
/*
  /// `loadConst; loadConst; buildTuple 2` -> just use constant tuple.
  private func buildTupleOfConstants(result: inout [Instruction],
                                     buildTuple: PeepholeInstruction,
                                     elementCount: Int) {
    guard elementCount > 0 else {
      return
    }

    var firstConstantIndex = -1
    var constants = [CodeObject.Constant]()
    constants.reserveCapacity(elementCount)

    let indexBeforeBuildTuple = buildTuple.startIndex - 1
    var previous = PeepholeInstruction(instructions: self.instructions,
                                       unalignedIndex: indexBeforeBuildTuple)

    while let instruction = previous, constants.count != elementCount {
      let previousIndex = instruction.previousInstructionUnalignedIndex
      previous = PeepholeInstruction(instructions: self.instructions,
                                     unalignedIndex: previousIndex)

      switch instruction.value {
      case .loadConst(index: let arg):
        let constantIndex = instruction.getArg(instructionArg: arg)
        let constant = self.constants[constantIndex]
        constants.append(constant)
        firstConstantIndex = instruction.startIndex
      default:
        return
      }
    }

    guard constants.count == elementCount else {
      return
    }

   #warning("Order of elements in tuple?")
    let tupleConstant = CodeObject.Constant.tuple(constants)

//    Py_ssize_t index = PyList_GET_SIZE(consts);
//    if (PyList_Append(consts, newconst)) {
//    return copy_op_arg(codestr, c_start, LOAD_CONST,
//                           (unsigned int)index, opcode_end);
    fatalError()
  }
*/
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

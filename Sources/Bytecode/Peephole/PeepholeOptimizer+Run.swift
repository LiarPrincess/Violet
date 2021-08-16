import VioletCore

// cSpell:ignore retargeted

// In CPython:
// Python -> peephole.c

extension PeepholeOptimizer {

  internal struct RunResult {
    internal fileprivate(set) var instructions: [Instruction]
    internal fileprivate(set) var instructionLines: [SourceLine]
    internal fileprivate(set) var labels: [CodeObject.Label]
  }

  /// Optimizations are restricted to simple transformations occurring within a
  /// single code object.
  /// All transformations keep the code size the same or smaller.
  /// For those that reduce size, the gaps are initially filled with NOPs.
  /// Later those NOPs are removed and the jump addresses retargeted in a single
  /// pass.
  ///
  /// PyObject *
  /// PyCode_Optimize(PyObject *code, PyObject* consts, PyObject *names,
  ///                 PyObject *lnotab_obj)
  internal func run() -> RunResult {
    // We will start with no changes
    var result = RunResult(instructions: self.instructions,
                           instructionLines: self.instructionLines,
                           labels: self.labels)

    self.applyOptimizations(result: &result.instructions)
    // TODO: Fix lineno
    self.removeNopsAndFixJumpTargets(result: &result)

    return result
  }

  // MARK: - Apply optimizations

  /// Modify `self.result` based on a single instruction.
  private func applyOptimizations(result: inout [Instruction]) {
    var next = self.readInstruction(instructions: self.instructions, index: 0)

    while let instruction = next {
      let nextIndex = instruction.nextInstructionIndex
      next = self.readInstruction(instructions: self.instructions, index: nextIndex)

      switch instruction.value {
      case let .loadConst(index: arg):
        self.optimizeLoadConst(result: &result,
                               loadConst: instruction,
                               arg: arg,
                               next: next)

      case let .buildTuple(elementCount: arg):
        self.optimizeBuildTuple(result: &result,
                                buildTuple: instruction,
                                arg: arg,
                                next: next)

      case .return:
        self.optimizeReturn(result: &result, ret: instruction)

      default:
        break
      }
    }
  }

  // MARK: - Remove NOPs and fix jump targets

  private func removeNopsAndFixJumpTargets(result: inout RunResult) {
    var resultInsertIndex = 0
    var next = self.readInstruction(instructions: result.instructions, index: 0)
    let indicesWithoutNop = self.findIndicesSkippingNop(instructions: result.instructions)

    // TODO: Use 'for each labels'
    while let instruction = next {
      let nextIndex = instruction.nextInstructionIndex
      next = self.readInstruction(instructions: result.instructions, index: nextIndex)

      switch instruction.value {
      case .nop:
        // Remove 'nops'.
        continue

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
        // TODO: .setupAsyncWith

        // Fix jump targets (labels).
        let labelIndex = instruction.getArg(instructionArg: arg)
        let jumpTarget = self.getAbsoluteJumpTarget(labelIndex: labelIndex)
        let newTarget = indicesWithoutNop[jumpTarget]
        result.labels[labelIndex] = CodeObject.Label(instructionIndex: newTarget)

      default:
        break
      }

      resultInsertIndex = self.write(instruction: instruction,
                                     at: resultInsertIndex,
                                     inside: &result.instructions)
    }

    let toRemove = result.instructions.count - resultInsertIndex
    result.instructions.removeLast(toRemove)
  }

  /// Imagine that we removed all `nop` from the bytecode.
  /// This `struct` holds an index of every instruciton in resulting bytecode.
  private func findIndicesSkippingNop(
    instructions: [Instruction]
  ) -> [Int] {
    var result = [Int](repeating: 0, count: instructions.count)

    var nopCount = 0
    for index in instructions.indices {
      let indexWithoutNop = index - nopCount
      result[index] = indexWithoutNop

      let instruction = instructions[index]
      if instruction == .nop {
        nopCount += 1
      }
    }

    return result
  }

  /// static void
  /// write_op_arg(_Py_CODEUNIT *codestr, unsigned char opcode,
  ///     unsigned int oparg, int ilen)
  private func write(instruction: InstructionInfo,
                     at index: Int,
                     inside result: inout [Instruction]) -> Int {
    // 1. extendedArg: 0xfa
    // 2. extendedArg: 0xfb
    // 3. extendedArg: 0xfc
    // 4. instruction: 0xf0
    //
    // Gives us:
    // |No.|Base    |Calculation         |Result    |
    // |1. |       0|       0 << 8 | 0xfa|      0xfa|
    // |2. |    0xfa|    0xfa << 8 | 0xfb|    0xfafb|
    // |3. |  0xfafb|  0xfa fb<< 8 | 0xfc|  0xfafbfc| <- without instruction arg
    // |4. |0xfafbfc|0xfafbfc << 8 | 0xf0|0xfafbfcf0|

    var index = index

    let extendedArg = instruction.extendedArgWithoutInstructionArg
    let extendedArgCount = instruction.extendedArgCount

    let ffMask = Int(UInt8.max)
    let extendedArgBitWidth = UInt8.bitWidth

    if extendedArgCount == 3 {
      let arg = UInt8((extendedArg >> (2 * extendedArgBitWidth)) & ffMask)
      result[index] = .extendedArg(arg)
      index += 1
    }

    if extendedArgCount >= 2 {
      let arg = UInt8((extendedArg >> extendedArgBitWidth) & ffMask)
      result[index] = .extendedArg(arg)
      index += 1
    }

    if extendedArgCount >= 1 {
      let arg = UInt8(extendedArg & ffMask)
      result[index] = .extendedArg(arg)
      index += 1
    }

    result[index] = instruction.value
    index += 1

    return index
  }

  // MARK: - Read instruction

  internal struct InstructionInfo {
    /// Index of the first `extendedArg` (of `self.value` index if this instruction
    /// does not have an `extendedArgs`).
    internal let startIndex: Int
    /// An actual instruction (not `extendedArg`).
    internal let value: Instruction
    // We do not know the current instruction, so we will treat as if its 'arg' was 0.
    // Use 'InstructionInfo.getArg(instructionArg:)' to get proper value.
    fileprivate let extendedArgWithoutInstructionArg: Int
    /// Number of `extendedArg` before `self.value`.
    internal let extendedArgCount: Int

    /// Number of `Instruction` instances.
    internal var size: Int {
      return self.extendedArgCount + 1
    }

    internal var nextInstructionIndex: Int {
      return self.startIndex + self.size
    }

    internal func getArg(instructionArg: UInt8) -> Int {
      return Instruction.extend(
        base: self.extendedArgWithoutInstructionArg,
        arg: instructionArg
      )
    }
  }

  private func readInstruction(instructions: [Instruction],
                               index startIndex: Int) -> InstructionInfo? {
    guard startIndex < instructions.count else {
      return nil
    }

    var index = startIndex

    var extendedArg = 0
    while case let Instruction.extendedArg(arg) = instructions[index] {
      extendedArg = Instruction.extend(base: extendedArg, arg: arg)
      index += 1
    }

    let value = instructions[index]
    return InstructionInfo(startIndex: startIndex,
                           value: value,
                           extendedArgWithoutInstructionArg: extendedArg,
                           extendedArgCount: index - startIndex)
  }
}

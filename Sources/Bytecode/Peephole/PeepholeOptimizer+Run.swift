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
    var instructions = self.instructions

    self.applyOptimizations(result: &instructions)

    let newInstructionIndices = self.rewriteInstructionsSkippingNop(instructions: &instructions)
    let labels = self.retargetLabelsToNewIndices(newIndices: newInstructionIndices)

    // TODO: instructionLines
    var instructionLines = self.instructionLines
    while instructionLines.count < instructions.count {
      instructionLines.append(0)
    }
    while instructions.count < instructionLines.count {
      _ = instructionLines.removeLast()
    }

    self.addNopsToPreventOutOfBoundsJumps(labels: labels,
                                          instructions: &instructions,
                                          instructionLines: &instructionLines)

    return RunResult(instructions: instructions,
                     instructionLines: instructionLines,
                     labels: labels)
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

  // MARK: - Rewrite instructions

  /// Imagine that we removed all `nop` from the bytecode.
  /// This `struct` holds an index of every instruction in resulting bytecode.
  private struct InstructionIndicesSkippingNop {

    private var data = [Int]()

    fileprivate subscript(oldInstructionIndex: Int) -> Int {
      return self.data[oldInstructionIndex]
    }

    fileprivate mutating func append(instructionIndex: Int) {
      assert(instructionIndex >= 0)
      self.data.append(instructionIndex)
    }

    fileprivate mutating func reserveCapacity(_ minimumCapacity: Int) {
      self.data.reserveCapacity(minimumCapacity)
    }
  }

  private func rewriteInstructionsSkippingNop(
    instructions: inout [Instruction]
  ) -> InstructionIndicesSkippingNop {
    var newIndices = InstructionIndicesSkippingNop()
    newIndices.reserveCapacity(instructions.count)

    var nopCount = 0
    for oldIndex in instructions.indices {
      let newIndex = oldIndex - nopCount
      newIndices.append(instructionIndex: newIndex)

      let instruction = instructions[oldIndex]
      switch instruction {
      case .nop:
        nopCount += 1
      default:
        instructions[newIndex] = instruction
      }
    }

    instructions.removeLast(nopCount)
    // instructionLines.removeLast(nopCount)
    // assert(instructions.count == instructionLines.count)

    return newIndices
  }

  // MARK: - Retarget labels

  private func retargetLabelsToNewIndices(
    newIndices: InstructionIndicesSkippingNop
  ) -> [CodeObject.Label] {
    var result = [CodeObject.Label]()
    result.reserveCapacity(self.labels.count)

    for labelIndex in self.labels.indices {
      let label = self.labels[labelIndex]
      let target = label.instructionIndex
      let newTarget = newIndices[target]

      result.append(CodeObject.Label(instructionIndex: newTarget))
    }

    return result
  }

  // MARK: - Out of bound labels

  /// If there is any label that jumps past 'instructions' -> append 'nop'.
  /// Just so that we have such instruction
  private func addNopsToPreventOutOfBoundsJumps(
    labels: [CodeObject.Label],
    instructions: inout [Instruction],
    instructionLines: inout [SourceLine]
  ) {
    assert(instructions.count == instructionLines.count)

    var maxJumpTarget = -1

    for label in labels {
      let target = label.instructionIndex
      maxJumpTarget = Swift.max(maxJumpTarget, target)
    }

    if maxJumpTarget == -1 {
      return
    }

    let line = instructionLines.last ?? SourceLocation.start.line

    while instructions.count < maxJumpTarget {
      instructions.append(.nop)
      instructionLines.append(line)
    }
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

    /// Number of instructions (`extendedArgCount` + 1 for `self.value`).
    internal var instructionCount: Int {
      return self.extendedArgCount + 1
    }

    internal var nextInstructionIndex: Int {
      return self.startIndex + self.instructionCount
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
    while index < instructions.count {
      if case let Instruction.extendedArg(arg) = instructions[index] {
        extendedArg = Instruction.extend(base: extendedArg, arg: arg)
        index += 1
      } else {
        break
      }
    }

    // This is similar check to the one that started the function.
    // It may fire if 'instructions' ended with 'extendedArg'.
    // In such case: there is no last instruction.
    guard index < instructions.count else {
      return nil
    }

    let value = instructions[index]
    return InstructionInfo(startIndex: startIndex,
                           value: value,
                           extendedArgWithoutInstructionArg: extendedArg,
                           extendedArgCount: index - startIndex)
  }
}

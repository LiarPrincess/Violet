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
    var instructions = self.oldInstructions
    var instructionLines = self.oldInstructionLines

    self.applyOptimizations(result: &instructions)

    let newInstructionIndices = self.rewriteInstructionsSkippingNop(
      instructions: &instructions,
      instructionLines: &instructionLines
    )

    assert(instructions.count == instructionLines.count)

    let labels = self.retargetLabels(newIndices: newInstructionIndices)

    self.addNopsToPreventOutOfBoundJumps(labels: labels,
                                         instructions: &instructions,
                                         instructionLines: &instructionLines)

    return RunResult(instructions: instructions,
                     instructionLines: instructionLines,
                     labels: labels)
  }

  // MARK: - Apply optimizations

  /// Modify `self.result` based on a single instruction.
  private func applyOptimizations(result: inout [Instruction]) {
    var index: Int? = 0

    // We can't just 'instruction = next_from_the_previous_iteration'.
    // Some optimization could have changed what the 'next' is.
    while let instruction = PeepholeInstruction(instructions: result, startIndex: index) {
      let nextIndex = instruction.nextInstructionIndex
      let next = PeepholeInstruction(instructions: result, startIndex: nextIndex)
      defer { index = nextIndex }

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
    instructions: inout [Instruction],
    instructionLines: inout [SourceLine]
  ) -> InstructionIndicesSkippingNop {
    assert(instructions.count == instructionLines.count)

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
        let line = self.oldInstructionLines[oldIndex]
        instructions[newIndex] = instruction
        instructionLines[newIndex] = line
      }
    }

    instructions.removeLast(nopCount)
    instructionLines.removeLast(nopCount)
    assert(instructions.count == instructionLines.count)

    return newIndices
  }

  // MARK: - Retarget labels

  private func retargetLabels(
    newIndices: InstructionIndicesSkippingNop
  ) -> [CodeObject.Label] {
    var result = [CodeObject.Label]()
    result.reserveCapacity(self.oldLabels.count)

    for labelIndex in self.oldLabels.indices {
      let label = self.oldLabels[labelIndex]
      let target = label.instructionIndex
      let newTarget = newIndices[target]

      result.append(CodeObject.Label(instructionIndex: newTarget))
    }

    return result
  }

  // MARK: - Out of bound labels

  /// If there is any label that jumps past `instructions` -> append `nop`.
  /// Just so that we have such instruction
  private func addNopsToPreventOutOfBoundJumps(
    labels: [CodeObject.Label],
    instructions: inout [Instruction],
    instructionLines: inout [SourceLine]
  ) {
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
}

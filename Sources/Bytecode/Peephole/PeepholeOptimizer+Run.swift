import VioletCore

// cSpell:ignore retargeted

// In CPython:
// Python -> peephole.c

extension PeepholeOptimizer {

  internal struct RunResult {
    internal let instructions: [Instruction]
    internal let instructionLines: [SourceLine]
    internal let constants: [CodeObject.Constant]
    internal let labels: [CodeObject.Label]
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
    var result = OptimizationResult(
      instructions: self.oldInstructions,
      instructionLines: self.oldInstructionLines,
      constants: self.oldConstants,
      labels: self.oldLabels
    )

    self.applyOptimizations(result: &result)

    let newInstructionIndices = self.rewriteInstructionsSkippingNop(
      instructions: &result.instructions,
      instructionLines: &result.instructionLines
    )

    assert(result.instructions.count == result.instructionLines.count)

    self.retargetLabels(
      labels: &result.labels,
      to: newInstructionIndices
    )

    self.addNopsToPreventOutOfBoundJumps(
      instructions: &result.instructions,
      instructionLines: &result.instructionLines,
      labels: result.labels
    )

    return result.asPeepholeOptimizerResult()
  }

  // MARK: - Apply optimizations

  /// Modify `result` based on a single instruction.
  private func applyOptimizations(result: inout OptimizationResult) {
    var index: Int? = 0

    // We can't just 'instruction = next_from_the_previous_iteration'.
    // Some optimization could have changed what the 'next' is.
    while let instruction = result.instructions.get(startIndex: index) {
      let nextIndex = instruction.nextInstructionIndex
      let next = result.instructions.get(startIndex: nextIndex)
      defer { index = nextIndex }

      switch instruction.value {
      case let .loadConst(index: arg):
        self.optimizeLoadConst(result: &result,
                               loadConst: instruction,
                               loadConstArg: arg,
                               next: next)

      case let .buildTuple(elementCount: arg):
        self.optimizeBuildTuple(result: &result,
                                buildTuple: instruction,
                                buildTupleArg: arg,
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
    instructions: inout OptimizationResult.Instructions,
    instructionLines: inout OptimizationResult.InstructionLines
  ) -> InstructionIndicesSkippingNop {
    assert(instructions.count == instructionLines.count)

    var newIndices = InstructionIndicesSkippingNop()
    newIndices.reserveCapacity(instructions.count)

    var nopCount = 0
    for oldIndex in 0..<instructions.count {
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
    labels: inout OptimizationResult.Labels,
    to newIndices: InstructionIndicesSkippingNop
  ) {
    for labelIndex in 0..<labels.count {
      let label = labels[labelIndex]
      let target = label.instructionIndex
      let newTarget = newIndices[target]

      labels[labelIndex] = CodeObject.Label(instructionIndex: newTarget)
    }
  }

  // MARK: - Out of bound labels

  /// If there is any label that jumps past `instructions` -> append `nop`.
  /// Just so that we have such instruction
  private func addNopsToPreventOutOfBoundJumps(
    instructions: inout OptimizationResult.Instructions,
    instructionLines: inout OptimizationResult.InstructionLines,
    labels: OptimizationResult.Labels
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

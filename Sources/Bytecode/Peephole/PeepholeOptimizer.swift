import VioletCore

// cSpell:ignore retarget retargeted

// In CPython:
// Python -> peephole.c

// This is almost 1:1 rewrite of CPython code.
// The thing is, that part of the Python semantic is implemented inside of the
// peephole optimizer (for example: avoid evaluating '__bool__' more times than needed).
// So, we have to do exactly the same things as them.

internal struct PeepholeOptimizer {

  /// `Instructions` before any optimizations were applied.
  internal let oldInstructions: [Instruction]
  /// `InstructionLines` before any optimizations were applied.
  internal let oldInstructionLines: [SourceLine]
  /// `Constants` before any optimizations were applied.
  internal let oldConstants: [CodeObject.Constant]
  /// `Labels` before any optimizations were applied.
  internal let oldLabels: [CodeObject.Label]

  /// Information about jumps in the `self.oldInstructions` according to
  /// `self.oldLabels`.
  ///
  /// `old` means that those information were calculated before any optimizations
  /// were applied.
  internal let oldJumpTable: PeepholeJumpTable

  internal init(instructions: [Instruction],
                instructionLines: [SourceLine],
                constants: [CodeObject.Constant],
                labels: [CodeObject.Label]) {
    assert(instructions.count == instructionLines.count)
    self.oldInstructions = instructions
    self.oldInstructionLines = instructionLines
    self.oldConstants = constants
    self.oldLabels = labels
    self.oldJumpTable = PeepholeJumpTable(instructions: instructions, labels: labels)
  }

  // MARK: - Run

  internal struct RunResult {
    internal fileprivate(set) var instructions: [Instruction]
    internal fileprivate(set) var instructionLines: [SourceLine]
    internal fileprivate(set) var constants: [CodeObject.Constant]
    internal fileprivate(set) var labels: [CodeObject.Label]
  }

  /// Optimizations are restricted to simple transformations occurring within a
  /// single code object.
  /// All transformations keep the code size the same or smaller.
  /// For those that reduce size, the gaps are initially filled with NOPs.
  /// Later those NOPs are removed and the jump addresses retargeted.
  ///
  /// PyObject *
  /// PyCode_Optimize(PyObject *code, PyObject* consts, PyObject *names,
  ///                 PyObject *lnotab_obj)
  internal func run() -> RunResult {
    var optimizationResult = OptimizationResult(
      instructions: self.oldInstructions,
      instructionLines: self.oldInstructionLines,
      constants: self.oldConstants,
      labels: self.oldLabels
    )

    self.applyOptimizations(result: &optimizationResult)

    var result = optimizationResult.convertToPeepholeOptimizerResult()
    optimizationResult.dropReferencesToAvoidCOW()

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

    return result
  }

  // MARK: - Apply optimizations

  // swiftlint:disable function_body_length

  /// For-each on instructions and apply optimizations.
  private func applyOptimizations(result: inout OptimizationResult) {
    // swiftlint:enable function_body_length
    var instructionIndex: Int? = 0

    while let instruction = result.instructions.get(startIndex: instructionIndex) {
      instructionIndex = instruction.nextInstructionIndex

      switch instruction.value {
      case let .loadConst(index: arg):
        self.optimizeLoadConst(result: &result,
                               loadConst: instruction,
                               arg: arg)

      case let .buildTuple(elementCount: arg):
        self.optimizeBuildTuple(result: &result,
                                buildTuple: instruction,
                                arg: arg)

      case let .jumpIfTrueOrPop(labelIndex: arg),
           let .jumpIfFalseOrPop(labelIndex: arg):
        if let index = self.optimizeJumpIfOrPop(result: &result,
                                                jumpIfOrPop: instruction,
                                                arg: arg) {
          instructionIndex = index
        }

      case let .jumpAbsolute(labelIndex: arg),
           // let .jumpForward,
           let .popJumpIfFalse(labelIndex: arg),
           let .popJumpIfTrue(labelIndex: arg),
           let .setupLoop(loopEndLabelIndex: arg),
           let .forIter(ifEmptyLabelIndex: arg),
           let .continue(loopStartLabelIndex: arg),
           let .setupExcept(firstExceptLabelIndex: arg),
           let .setupFinally(finallyStartLabelIndex: arg),
           let .setupWith(afterBodyLabelIndex: arg):
        // let .setupAsyncWith:
        self.optimizeJumps(result: &result,
                           instruction: instruction,
                           arg: arg)

      case .return:
        self.optimizeReturn(result: &result, ret: instruction)

      default:
        break
      }
    }
  }

  // MARK: - Rewrite instructions

  /// Imagine that we removed all `nop` from the bytecode.
  /// This `struct` holds an index of every instruction in the resulting bytecode.
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

    self.removeTrailingExtendedArgs(instructions: &instructions,
                                    instructionLines: &instructionLines)

    assert(instructions.count == instructionLines.count)

    return newIndices
  }

  private func removeTrailingExtendedArgs(
    instructions: inout [Instruction],
    instructionLines: inout [SourceLine]
  ) {
    while let last = instructions.last {
      switch last {
      case .extendedArg:
        instructions.removeLast()
        instructionLines.removeLast()
      default:
        return
      }
    }
  }

  // MARK: - Retarget labels

  private func retargetLabels(
    labels: inout [CodeObject.Label],
    to newIndices: InstructionIndicesSkippingNop
  ) {
    for labelIndex in labels.indices {
      let label = labels[labelIndex]
      let target = label.instructionIndex
      let newTarget = newIndices[target]

      labels[labelIndex].instructionIndex = newTarget
    }
  }

  // MARK: - Out of bound labels

  /// If there is any label that jumps past `instructions` -> append `nop`.
  /// Just so that we have such instruction
  private func addNopsToPreventOutOfBoundJumps(
    instructions: inout [Instruction],
    instructionLines: inout [SourceLine],
    labels: [CodeObject.Label]
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

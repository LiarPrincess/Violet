import VioletCore

// MARK: - OptimizationResult

internal class OptimizationResult {

  internal var instructions: Instructions
  internal var instructionLines: InstructionLines
  internal var constants: Constants
  internal var labels: Labels

  internal init(instructions: [Instruction],
                instructionLines: [SourceLine],
                constants: [CodeObject.Constant],
                labels: [CodeObject.Label]) {
    self.instructions = Instructions(values: instructions)
    self.instructionLines = InstructionLines(values: instructionLines)
    self.constants = Constants(values: constants)
    self.labels = Labels(values: labels)
  }

  internal func asPeepholeOptimizerResult() -> PeepholeOptimizer.RunResult {
    return PeepholeOptimizer.RunResult(
      instructions: self.instructions.values,
      instructionLines: self.instructionLines.values,
      constants: self.constants.values,
      labels: self.labels.values
    )
  }

  // MARK: - Instructions

  /// Wrapper for `[Instruction]` so that we control the modifications
  /// (for example: we will block removal in some cases).
  internal struct Instructions {

    fileprivate var values: [Instruction]

    internal var count: Int {
      return self.values.count
    }

    internal subscript(index: Int) -> Instruction {
      get { return self.values[index] }
      set { self.values[index] = newValue }
    }

    /// Read an instruction starting from provided `index`.
    ///
    /// This is the method that you want to use if you traverse bytecode in the
    /// 'normal' order (from start to the end).
    internal func get(startIndex: Int?) -> PeepholeInstruction? {
      return PeepholeInstruction(instructions: self.values,
                                 startIndex: startIndex)
    }

    /// Read an instruction going back from provided `index` and collecting all of
    /// the `extendedArgs`. Then read the whole instruction (with extended args).
    ///
    /// `Unaligned` means that you don't have to be at the start of an instruction
    /// to use this method.
    internal func get(unalignedIndex: Int) -> PeepholeInstruction? {
      return PeepholeInstruction(instructions: self.values,
                                 unalignedIndex: unalignedIndex)
    }

    /// Sets the instructions `startIndex..<endIndex` to `nop`.
    internal mutating func setToNop(startIndex: Int, endIndex: Int?) {
      let endIndex = endIndex ?? self.values.count
      assert(startIndex <= endIndex)

      for index in startIndex..<endIndex {
        self.values[index] = .nop
      }
    }

    internal mutating func append(_ element: Instruction) {
      self.values.append(element)
    }

    /// This should be used at the very end (when we have applied all of the
    /// optimizations) to trim the data.
    internal mutating func removeLast(_ count: Int) {
      self.values.removeLast(count)
    }
  }

  // MARK: - Instruction lines

  /// Wrapper for `[SourceLine]` so that we control the modifications
  /// (for example: we will block removal in some cases).
  internal struct InstructionLines {

    fileprivate var values: [SourceLine]

    internal var count: Int {
      return self.values.count
    }

    internal var last: SourceLine? {
      return self.values.last
    }

    internal subscript(index: Int) -> SourceLine {
      get { return self.values[index] }
      set { self.values[index] = newValue }
    }

    internal mutating func append(_ element: SourceLine) {
      self.values.append(element)
    }

    /// This should be used at the very end (when we have applied all of the
    /// optimizations) to trim the data.
    internal mutating func removeLast(_ count: Int) {
      self.values.removeLast(count)
    }
  }

  // MARK: - Constants

  /// Wrapper for `[CodeObject.Constant]` so that we control the modifications
  /// (for example: we will block removal).
  internal struct Constants: RandomAccessCollection {

    fileprivate var values: [CodeObject.Constant]

    internal var startIndex: Int {
      return self.values.startIndex
    }

    internal var endIndex: Int {
      return self.values.endIndex
    }

    // We do not allow changing the value of a constant!
    // It is possible that multiple instructions are using the same constant index
    // (for example 'True/False' are reused).
    internal subscript(index: Int) -> CodeObject.Constant {
      return self.values[index]
    }
  }

  // MARK: - Labels

  /// Wrapper for `[CodeObject.Label]` so that we control the modifications
  /// (for example: we will block removal).
  internal struct Labels: RandomAccessCollection {

    fileprivate var values: [CodeObject.Label]

    internal var startIndex: Int {
      return self.values.startIndex
    }

    internal var endIndex: Int {
      return self.values.endIndex
    }

    internal subscript(index: Int) -> CodeObject.Label {
      get { return self.values[index] }
      set { self.values[index] = newValue }
    }
  }
}

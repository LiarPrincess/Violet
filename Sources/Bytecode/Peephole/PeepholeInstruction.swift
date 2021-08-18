/// Bundle `Instruction` + all of its `extendedArgs` together.
internal struct PeepholeInstruction {

  /// Index of the first `extendedArg` (of `self.value` index if this instruction
  /// does not have an `extendedArgs`).
  internal let startIndex: Int

  /// An actual instruction (not `extendedArg`).
  internal let value: Instruction

  // We do not know the current instruction, so we will treat as if its 'arg' was 0.
  // Use 'PeepholeInstruction.getArg(instructionArg:)' to get proper value.
  fileprivate let extendedArgWithoutInstructionArg: Int

  /// Number of `extendedArg` before `self.value`.
  internal let extendedArgCount: Int

  internal var previousInstructionUnalignedIndex: Int {
    return self.startIndex - 1
  }

  internal var nextInstructionIndex: Int {
    return self.startIndex + self.extendedArgCount + 1
  }

  internal func getArg(instructionArg: UInt8) -> Int {
    return Instruction.extend(
      base: self.extendedArgWithoutInstructionArg,
      arg: instructionArg
    )
  }

  // MARK: - Unaligned init

  /// Read an instruction going back from provided `index` and collecting all of
  /// the `extendedArgs`. Then read the whole instruction (with extended args).
  ///
  /// `Unaligned` means that you don't have to be at the start of an instruction
  /// to use this method.
  internal init?(instructions: [Instruction], unalignedIndex index: Int) {
    assert(index < instructions.count)

    // This may happen if we used 'previousInstructionIndex'.
    if index < 0 {
      return nil
    }

    var startIndex = index
    Self.goBackToFirstExtendedArg(instructions: instructions, index: &startIndex)

    switch PeepholeInstruction(instructions: instructions, startIndex: startIndex) {
    case .some(let i):
      self = i
    case .none:
      return nil
    }
  }

  private static func goBackToFirstExtendedArg(instructions: [Instruction],
                                               index: inout Int) {
    // 'index' is always 1 after 'extendedArgIndex'.
    var extendedArgIndex = index - 1

    while extendedArgIndex >= 0 {
      let instruction = instructions[extendedArgIndex]
      switch instruction {
      case .extendedArg:
        index = extendedArgIndex
        extendedArgIndex -= 1
      default:
        return
      }
    }
  }

  // MARK: - Init

  /// Read an instruction startng from provided `index`.
  ///
  /// This is the method that you want to use if you traverse bytecode in the
  /// 'normal' order (from start to the end).
  internal init?(instructions: [Instruction], startIndex: Int) {
    assert(startIndex >= 0)

    // This may happen if we used 'nextInstructionIndex'.
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

    self.startIndex = startIndex
    self.value = instructions[index]
    self.extendedArgWithoutInstructionArg = extendedArg
    self.extendedArgCount = index - startIndex
  }
}

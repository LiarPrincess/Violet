/// Bundle `Instruction` + all of its `extendedArgs` together.
internal struct PeepholeInstruction {

  /// Index of the first `extendedArg` (of `self.value` index if this instruction
  /// does not have any `extendedArgs`).
  internal let startIndex: Int

  /// An actual instruction (not `extendedArg`).
  internal let value: Instruction

  /// We don't know the current instruction, so we don't have the full `arg` value.
  /// Use `getArg(instructionArg:)` to get proper argument.
  private let argWithoutInstructionArg: Int

  /// Number of `extendedArg` before `self.value`.
  internal let extendedArgCount: Int

  /// Number of instructions including `extendedArg`
  /// (basically: `self.extendedArgCount + 1`).
  internal var instructionCount: Int {
    return self.extendedArgCount + 1
  }

  internal var previousInstructionUnalignedIndex: Int? {
    return self.startIndex == 0 ? nil : self.startIndex - 1
  }

  /// Index of the next instruction.
  internal var nextInstructionIndex: Int?

  /// Get the instruction argument accounting for `extendedArgs`.
  internal func getArgument(instructionArg: UInt8) -> Int {
    return Instruction.extend(
      base: self.argWithoutInstructionArg,
      arg: instructionArg
    )
  }

  // MARK: - Instruction predicates

  /// \#define CONDITIONAL_JUMP(op) (op==POP_JUMP_IF_FALSE || op==POP_JUMP_IF_TRUE \
  ///    || op==JUMP_IF_FALSE_OR_POP || op==JUMP_IF_TRUE_OR_POP)
  internal var isConditionalJump: Bool {
    switch self.value {
    case .popJumpIfFalse,
         .popJumpIfTrue,
         .jumpIfFalseOrPop,
         .jumpIfTrueOrPop:
      return true
    default:
      return false
    }
  }

  /// \#define UNCONDITIONAL_JUMP(op)  (op==JUMP_ABSOLUTE || op==JUMP_FORWARD)
  internal var isUnconditionalJump: Bool {
    switch self.value {
    case .jumpAbsolute:
      // We do not have jumpForward
      return true
    default:
      return false
    }
  }

  /// \#define JUMPS_ON_TRUE(op) (op==POP_JUMP_IF_TRUE || op==JUMP_IF_TRUE_OR_POP)
  internal var isJumpOnTrue: Bool {
    // We can omit the '(labelIndex: _)', but this is better.
    switch self.value {
    case .popJumpIfTrue,
         .jumpIfTrueOrPop:
      return true
    default:
      return false
    }
  }

  // MARK: - Unaligned init

  /// Read an instruction going back from provided `index` and collecting all of
  /// the `extendedArgs`. Then read the whole instruction (with extended args).
  ///
  /// `Unaligned` means that you don't have to be at the start of an instruction
  /// to use this method.
  internal init?(instructions: [Instruction], unalignedIndex index: Int) {
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
    // 'extendedArgIndex' is always 1 before 'index'.
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

  /// Read an instruction starting from provided `index`.
  ///
  /// This is the method that you want to use if you traverse bytecode in the
  /// 'normal' order (from start to the end).
  internal init?(instructions: [Instruction], startIndex: Int) {
    guard instructions.indices.contains(startIndex) else {
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
    guard instructions.indices.contains(index) else {
      return nil
    }

    self.startIndex = startIndex
    self.value = instructions[index]
    self.argWithoutInstructionArg = extendedArg
    self.extendedArgCount = index - startIndex

    let isLast = index + 1 == instructions.count
    self.nextInstructionIndex = isLast ? nil : index + 1
  }
}

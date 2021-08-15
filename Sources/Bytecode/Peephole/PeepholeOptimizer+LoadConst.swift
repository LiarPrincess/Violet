// cSpell:ignore trueconst

// In CPython:
// Python -> peephole.c

extension PeepholeOptimizer {

  internal func optimizeLoadConst(result: inout [Instruction],
                                  loadConst: InstructionInfo,
                                  arg: UInt8,
                                  next: InstructionInfo?) {
    let constantIndex = loadConst.getArg(instructionArg: arg)
    self.loadTrueConst_thenPopJumpIfFalse(result: &result,
                                          loadConst: loadConst,
                                          constantIndex: constantIndex,
                                          next: next)
  }

  /// Skip over `LOAD_CONST trueconst`; `POP_JUMP_IF_FALSE xx`.
  /// This improves "while 1" performance.
  private func loadTrueConst_thenPopJumpIfFalse(result: inout [Instruction],
                                                loadConst: InstructionInfo,
                                                constantIndex: Int,
                                                next: InstructionInfo?) {
    guard let popJumpIfFalse = next else {
      return
    }

    guard case .popJumpIfFalse = popJumpIfFalse.value else {
      return
    }

    // Is the 'popJumpIfFalse' jump target?
    // If so, then we can't set it to 'nop', because later it would get removed.
    if self.hasJumpTargetBetween(loadConst, popJumpIfFalse) {
      return
    }

    let constant = self.constants[constantIndex]

    if self.isTrue(constant: constant) {
      // Set both 'instruction' and 'next' to 'nop'.
      self.fillNop(result: &result,
                   startIndex: loadConst.startIndex,
                   endIndex: popJumpIfFalse.nextInstructionIndex)
    }
  }

  private func isTrue(constant: CodeObject.Constant) -> Bool {
    switch constant {
    case .`true`,
         .ellipsis:
      return true

    case .false,
         .none:
      return false

    case let .integer(int):
      return !int.isZero
    case let .float(double):
      return !double.isZero
    case let .complex(real: real, imag: imag):
      let bothZero = real.isZero && imag.isZero
      return !bothZero

    case let .string(string):
      return !string.isEmpty
    case .bytes(let data):
      return !data.isEmpty

    case .code:
      // >>> def f(): return
      // >>> c = f.__code__
      // >>> bool(c)
      // True
      return true

    case .tuple(let constants):
      return !constants.isEmpty
    }
  }
}

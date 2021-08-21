// cSpell:ignore trueconst

// In CPython:
// Python -> peephole.c

extension PeepholeOptimizer {

  internal func optimizeLoadConst(result: inout OptimizationResult,
                                  loadConst: PeepholeInstruction,
                                  arg: UInt8) {
    let constantIndex = loadConst.getArgument(instructionArg: arg)
    self.solveFollowingPopJumpIf(result: &result,
                                 loadConst: loadConst,
                                 constantIndex: constantIndex)
  }

  /// Skip over `LOAD_CONST trueconst`; `POP_JUMP_IF_FALSE xx`.
  /// This improves "while 1" performance.
  private func solveFollowingPopJumpIf(result: inout OptimizationResult,
                                       loadConst: PeepholeInstruction,
                                       constantIndex: Int) {
    let nextIndex = loadConst.nextInstructionIndex
    guard let popJumpIf = result.instructions.get(startIndex: nextIndex) else {
      return
    }

    // Check if we are popJumpIfTrue/popJumpIfFalse
    var jumpConditionIsTrue: Bool
    switch popJumpIf.value {
    case .popJumpIfTrue: jumpConditionIsTrue = true
    case .popJumpIfFalse: jumpConditionIsTrue = false
    default: return
    }

    // Is the 'popJumpIfFalse' jump target?
    // If so, then we can't set it to 'nop', because later it would get removed.
    if self.oldJumpTable.hasJumpTargetBetween(loadConst, and: popJumpIf) {
      return
    }

    let constant = result.constants[constantIndex]
    let isConstantTrue = self.isTrue(constant: constant)
    let isConstantFalse = !isConstantTrue

    let constantWillNotJump = jumpConditionIsTrue ?
      isConstantFalse :
      isConstantTrue

    if constantWillNotJump {
      // If we never jump -> set both 'loadConst' and 'popJumpIf' to 'nop'.
      result.instructions.setToNop(startIndex: loadConst.startIndex,
                                   endIndex: popJumpIf.nextInstructionIndex)
    }

    // As for the 'else' branch in:
    // if true: # <-- emits 'popJumpIfFalse'
    //   (things)
    // else:
    //   (other things)
    //
    // If the jump target count for 'else' is 1 more than previous instruction
    // (which means that there is only a single way of getting there - when 'if'
    // expression is false) we could remove everything up to next jump target.
    // But this a bit more complicated, because there may be no 'else' branch,
    // in which case we would remove valid code.
  }

  private func isTrue(constant: CodeObject.Constant) -> Bool {
    switch constant {
    case .true,
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

    case .tuple(let elements):
      return !elements.isEmpty
    }
  }
}

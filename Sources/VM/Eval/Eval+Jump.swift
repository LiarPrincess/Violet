import VioletBytecode
import VioletObjects

extension Eval {

  // MARK: - Jump absolute

  /// Set bytecode counter to target.
  internal func jumpAbsolute(labelIndex: Int) -> InstructionResult {
    self.jumpTo(labelIndex: labelIndex)
    return .ok
  }

  // MARK: - Jump if…

  /// If TOS is true, sets the bytecode counter to target. TOS is popped.
  internal func popJumpIfTrue(labelIndex: Int) -> InstructionResult {
    self.popJumpIf(condition: true, labelIndex: labelIndex)
  }

  /// If TOS is false, sets the bytecode counter to target. TOS is popped.
  internal func popJumpIfFalse(labelIndex: Int) -> InstructionResult {
    self.popJumpIf(condition: false, labelIndex: labelIndex)
  }

  private func popJumpIf(condition: Bool, labelIndex: Int) -> InstructionResult {
    let top = self.stack.pop()

    switch self.py.isTrueBool(object: top) {
    case let .value(isTrue):
      if isTrue == condition {
        self.jumpTo(labelIndex: labelIndex)
      }

      return .ok

    case let .error(e):
      return .exception(e)
    }
  }

  // MARK: - Jump or pop

  /// If TOS is true, sets the bytecode counter to target and leaves TOS on the stack.
  /// Otherwise (TOS is false), TOS is popped.
  internal func jumpIfTrueOrPop(labelIndex: Int) -> InstructionResult {
    return self.jumpIfOrPop(condition: true, labelIndex: labelIndex)
  }

  /// If TOS is false, sets the bytecode counter to target and leaves TOS on the stack.
  /// Otherwise (TOS is true), TOS is popped.
  internal func jumpIfFalseOrPop(labelIndex: Int) -> InstructionResult {
    return self.jumpIfOrPop(condition: false, labelIndex: labelIndex)
  }

  private func jumpIfOrPop(condition: Bool, labelIndex: Int) -> InstructionResult {
    let top = self.stack.top

    switch self.py.isTrueBool(object: top) {
    case let .value(isTrue):
      if isTrue == condition {
        self.jumpTo(labelIndex: labelIndex)
      } else {
        _ = self.stack.pop()
      }

      return .ok

    case let .error(e):
      return .exception(e)
    }
  }

  // MARK: - Helpers

  internal func jumpTo(labelIndex: Int) {
    let label = self.code.labels[labelIndex]
    self.jumpTo(instructionIndex: label.instructionIndex)
  }

  internal func jumpTo(instructionIndex: Int) {
    self.frame.nextInstructionIndex = instructionIndex
  }
}

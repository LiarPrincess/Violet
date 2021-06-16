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
    let top = self.stack.pop()

    switch Py.isTrueBool(top) {
    case let .value(isTrue):
      self.popJumpIf(isTrue, to: labelIndex)
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// If TOS is false, sets the bytecode counter to target. TOS is popped.
  internal func popJumpIfFalse(labelIndex: Int) -> InstructionResult {
    let top = self.stack.pop()

    switch Py.isTrueBool(top) {
    case let .value(isTrue):
      self.popJumpIf(!isTrue, to: labelIndex)
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  // MARK: - Jump or pop

  /// If TOS is true, sets the bytecode counter to target and leaves TOS on the stack.
  /// Otherwise (TOS is false), TOS is popped.
  internal func jumpIfTrueOrPop(labelIndex: Int) -> InstructionResult {
    let top = self.stack.top

    switch Py.isTrueBool(top) {
    case let .value(isTrue):
      self.jumpIfOrPop(isTrue, to: labelIndex)
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// If TOS is false, sets the bytecode counter to target and leaves TOS on the stack.
  /// Otherwise (TOS is true), TOS is popped.
  internal func jumpIfFalseOrPop(labelIndex: Int) -> InstructionResult {
    let top = self.stack.top

    switch Py.isTrueBool(top) {
    case let .value(isTrue):
      self.jumpIfOrPop(!isTrue, to: labelIndex)
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  // MARK: - Helpers

  internal func jumpTo(labelIndex: Int) {
    let label = self.getLabel(index: labelIndex)
    self.jumpTo(instructionIndex: label.instructionIndex)
  }

  internal func jumpTo(instructionIndex: Int) {
    self.frame.nextInstructionIndex = instructionIndex
  }

  private func popJumpIf(_ condition: Bool, to labelIndex: Int) {
    if condition {
      self.jumpTo(labelIndex: labelIndex)
    }
  }

  private func jumpIfOrPop(_ condition: Bool, to labelIndex: Int) {
    if condition {
      self.jumpTo(labelIndex: labelIndex)
    } else {
      _ = self.stack.pop()
    }
  }
}

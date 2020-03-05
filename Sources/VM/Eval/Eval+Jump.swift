import Objects
import Bytecode

extension Eval {

  // MARK: - Jump absolute

  /// Set bytecode counter to target.
  internal func jumpAbsolute(labelIndex: Int) -> InstructionResult {
    self.jumpTo(labelIndex: labelIndex)
    return .ok
  }

  // MARK: - Jump if...

  /// If TOS is true, sets the bytecode counter to target. TOS is popped.
  internal func popJumpIfTrue(labelIndex: Int) -> InstructionResult {
    let top = self.stack.pop()

    switch Py.isTrueBool(top) {
    case let .value(isTrue):
      self.popJumpIf(isTrue, to: labelIndex)
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
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
      return .unwind(.exception(e))
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
      return .unwind(.exception(e))
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
      return .unwind(.exception(e))
    }
  }

  // MARK: - Helpers

  internal func jumpTo(labelIndex: Int) {
    let label = self.getLabel(index: labelIndex)
    self.jumpTo(label: label)
  }

  internal func jumpTo(label: Int) {
    self.frame.instructionIndex = label
  }

  private func popJumpIf(_ cond: Bool, to labelIndex: Int) {
    if cond {
      let label = self.getLabel(index: labelIndex)
      self.jumpTo(label: label)
    }
  }

  private func jumpIfOrPop(_ cond: Bool, to labelIndex: Int) {
    if cond {
      let label = self.getLabel(index: labelIndex)
      self.jumpTo(label: label)
    } else {
      _ = self.stack.pop()
    }
  }
}
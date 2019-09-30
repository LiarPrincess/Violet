import Bytecode

extension Frame {

  /// Set bytecode counter to target.
  internal func jumpAbsolute(labelIndex: Int) throws {
    let label = self.code.labels[labelIndex]
    self.jumpTo(label: label)
  }

  /// If TOS is true, sets the bytecode counter to target. TOS is popped.
  internal func popJumpIfTrue(labelIndex: Int) throws {
    let top = self.pop()
    let isTrue = try self.context.isTrue(value: top)
    self.popJumpIf(isTrue, to: labelIndex)
  }

  /// If TOS is false, sets the bytecode counter to target. TOS is popped.
  internal func popJumpIfFalse(labelIndex: Int) throws {
    let top = self.pop()
    let isTrue = try self.context.isTrue(value: top)
    self.popJumpIf(!isTrue, to: labelIndex)
  }

  /// If TOS is true, sets the bytecode counter to target and leaves TOS on the stack.
  /// Otherwise (TOS is false), TOS is popped.
  internal func jumpIfTrueOrPop(labelIndex: Int) throws {
    let top = self.top
    let isTrue = try self.context.isTrue(value: top)
    self.jumpIfOrPop(isTrue, to: labelIndex)
  }

  /// If TOS is false, sets the bytecode counter to target and leaves TOS on the stack.
  /// Otherwise (TOS is true), TOS is popped.
  internal func jumpIfFalseOrPop(labelIndex: Int) throws {
    let top = self.top
    let isTrue = try self.context.isTrue(value: top)
    self.jumpIfOrPop(!isTrue, to: labelIndex)
  }

  // MARK: - Helpers

  private func jumpTo(label: Int) {
    self.nextInstructionIndex = label
  }

  private func popJumpIf(_ cond: Bool, to labelIndex: Int) {
    if cond {
      let label = self.code.labels[labelIndex]
      self.jumpTo(label: label)
    }
  }

  private func jumpIfOrPop(_ cond: Bool, to labelIndex: Int) {
    if cond {
      let label = self.code.labels[labelIndex]
      self.jumpTo(label: label)
    } else {
      _ = self.pop()
    }
  }
}

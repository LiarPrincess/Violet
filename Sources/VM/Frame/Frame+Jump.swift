import Bytecode

extension Frame {

  /// Set bytecode counter to target.
  internal func jumpAbsolute(labelIndex: Int) throws {
    self.unimplemented()
  }

  /// If TOS is true, sets the bytecode counter to target. TOS is popped.
  internal func popJumpIfTrue(labelIndex: Int) throws {
    self.unimplemented()
  }

  /// If TOS is false, sets the bytecode counter to target. TOS is popped.
  internal func popJumpIfFalse(labelIndex: Int) throws {
    self.unimplemented()
  }

  /// If TOS is true, sets the bytecode counter to target and leaves TOS on the stack.
  /// Otherwise (TOS is false), TOS is popped.
  internal func jumpIfTrueOrPop(labelIndex: Int) throws {
    self.unimplemented()
  }

  /// If TOS is false, sets the bytecode counter to target and leaves TOS on the stack.
  /// Otherwise (TOS is true), TOS is popped.
  internal func jumpIfFalseOrPop(labelIndex: Int) throws {
    self.unimplemented()
  }
}

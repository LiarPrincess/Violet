import Bytecode

extension Frame {

  /// Removes one block from the block stack.
  /// The popped block must be an exception handler block,
  /// as implicitly created when entering an except handler.
  /// In addition to popping extraneous values from the frame stack,
  /// the last three popped values are used to restore the exception state.
  internal func popExcept() throws {
    self.unimplemented()
  }

  /// Terminates a finally clause.
  /// The interpreter recalls whether the exception has to be re-raised,
  /// or whether the function returns, and continues with the outer-next block.
  internal func endFinally() throws {
    self.unimplemented()
  }

  /// Pushes a try block from a try-except clause onto the block stack.
  /// `delta` points to the first except block.
  internal func setupExcept(firstExceptLabel: Int) throws {
    self.unimplemented()
  }

  /// Pushes a try block from a try-except clause onto the block stack.
  /// `delta` points to the finally block.
  internal func setupFinally(finallyStartLabel: Int) throws {
    self.unimplemented()
  }

  /// Raises an exception using one of the 3 forms of the raise statement,
  /// depending on the value of argc:
  /// - 0: raise (re-raise previous exception)
  /// - 1: raise TOS (raise exception instance or type at TOS)
  /// - 2: raise TOS1 from TOS (raise exception instance or type at TOS1 with Cause set to TOS)
  internal func raiseVarargs(arg: RaiseArg) throws {
    self.unimplemented()
  }
}

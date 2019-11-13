import Bytecode

extension Frame {

  /// This opcode performs several operations before a `with` block starts.
  ///
  /// It does following operations:
  /// 1.loads `Exit()` from the context manager and pushes it onto the stack
  /// for later use by `WithCleanup`.
  /// 2. calls `Enter()`
  /// 3. block staring at to `afterBodyLabel` is pushed.
  /// 4. the result of calling the enter method is pushed onto the stack.
  ///
  /// The next opcode will either ignore it (`PopTop`),
  /// or store it in variable (StoreFast, StoreName, or UnpackSequence).
  internal func setupWith(afterBodyLabel: Int) -> InstructionResult {
    return .unimplemented
  }

  /// Cleans up the stack when a `with` statement block exits.
  ///
  /// TOS is the context manager’s `__exit__()` bound method.
  /// Below TOS are 1–3 values indicating how/why the finally clause was entered:
  /// - `SECOND = None`
  /// - `(SECOND, THIRD) = (WHY_{RETURN,CONTINUE}), retval`
  /// - `SECOND = WHY_*; no retval below it`
  /// - `(SECOND, THIRD, FOURTH) = exc_info()`
  /// In the last case, `TOS(SECOND, THIRD, FOURTH)` is called,
  /// otherwise `TOS(None, None, None)`.
  /// Pushes `SECOND` and result of the call to the stack.
  internal func withCleanupStart() -> InstructionResult {
    return .unimplemented
  }

  /// Pops exception type and result of ‘exit’ function call from the stack.
  ///
  /// If the stack represents an exception, and the function call returns a ‘true’ value,
  /// this information is “zapped” and replaced with a single WhySilenced
  /// to prevent EndFinally from re-raising the exception.
  /// (But non-local gotos will still be resumed.)
  internal func withCleanupFinish() -> InstructionResult {
    return .unimplemented
  }

  /// Resolves `AEnter` and `AExit` from the object on top of the stack.
  /// Pushes `AExit` and result of `AEnter()` to the stack.
  internal func beforeAsyncWith() -> InstructionResult {
    return .unimplemented
  }

  /// Creates a new frame object.
  internal func setupAsyncWith() -> InstructionResult {
    return .unimplemented
  }
}

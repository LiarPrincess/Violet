import Objects

extension Eval {

  // MARK: - Setup

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
  internal func setupWith(afterBodyLabelIndex: Int) -> InstructionResult {
    let manager  = self.stack.top

    let __enter__: PyObject
    switch Py.lookup(on: manager, name: .__enter__) {
    case .value(let o): __enter__ = o
    case .notFound: return self.notFound(manager: manager, attribute: "__enter__")
    case .error(let e): return .unwind(.exception(e))
    }

    let __exit__: PyObject
    switch Py.lookup(on: manager, name: .__exit__) {
    case .value(let o): __exit__ = o
    case .notFound: return self.notFound(manager: manager, attribute: "__exit__")
    case .error(let e): return .unwind(.exception(e))
    }

    self.stack.top = __exit__

    switch Py.call(callable: __enter__) {
    case let .value(res):
      // Setup the finally block before pushing the result of __enter__ on the stack.
      let label = self.getLabel(index: afterBodyLabelIndex)
      let type = BlockType.setupFinally(finallyStartLabel: label)
      let block = Block(type: type, stackLevel: self.stackLevel)
      self.blocks.push(block: block)

      self.stack.push(res)
      return .ok
    case let .notCallable(e),
         let .error(e):
      return .unwind(.exception(e))
    }
  }

  private func notFound(manager: PyObject,
                        attribute: String) -> InstructionResult {
    let e = Py.newAttributeError(object: manager, hasNoAttribute: attribute)
    return .unwind(.exception(e))
  }

  // MARK: - Cleanup start

  // swiftlint:disable function_body_length

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
    // swiftlint:enable function_body_length

    let __exit__: PyObject
    var exceptionType = self.stack.top
    var exception: PyObject = Py.none
    var traceback: PyObject = Py.none

    let marker = self.stack.top // 'exc' in CPython

    switch PushFinallyReason.pop(from: &self.stack) {
    case .none:
      // nothing unusual happened
      __exit__ = self.stack.top
      self.stack.top = marker

    case let .return(value):
      // we were returning
      __exit__ = self.stack.pop()
      PushFinallyReason.push(.return(value), on: &self.stack)

    case let .continue(loopStartLabel: _, asObject: label):
      // we were continuing
      __exit__ = self.stack.pop()
      PushFinallyReason.push(.continuePy(loopStartLabel: label), on: &self.stack)

    case .break:
      __exit__ = self.stack.pop()
      PushFinallyReason.push(.break, on: &self.stack)

    case let .exception(e):
      exceptionType = e.type
      exception = e
      traceback = e.getTraceback()

      let previousException = self.stack.pop() // may also be 'None'
      __exit__ = self.stack.pop()
      self.stack.push(previousException)

      guard let block = self.blocks.pop() else {
        let e = Py.newSystemError(msg: "XXX block stack underflow")
        return .unwind(.exception(e))
      }

      assert(block.isExceptHandler)
      let newLevel = block.stackLevel - 1
      self.blocks.push(block: Block(type: .exceptHandler, stackLevel: newLevel))

    case .silenced:
      __exit__ = self.stack.pop()
      PushFinallyReason.push(.silenced, on: &self.stack)

    case .invalid:
      let e = Py.newSystemError(msg: "'finally' pops bad exception")
      return .unwind(.exception(e))
    }

    let args = [exceptionType, exception, traceback]
    switch Py.call(callable: __exit__, args: args, kwargs: nil) {
    case let .value(res):
      self.stack.push(exceptionType)
      self.stack.push(res)
      return .ok
    case let .notCallable(e),
         let .error(e):
      return .unwind(.exception(e))
    }
  }

  // MARK: - Cleanup finish

  /// Pops exception type and result of ‘exit’ function call from the stack.
  ///
  /// If the stack represents an exception, and the function call returns a ‘true’ value,
  /// this information is “zapped” and replaced with a single WhySilenced
  /// to prevent EndFinally from re-raising the exception.
  /// (But non-local gotos will still be resumed.)
  internal func withCleanupFinish() -> InstructionResult {
    let res = self.stack.pop()
    let exc = self.stack.pop()

    var err = false
    if !exc.isNone {
      switch Py.isTrueBool(res) {
      case let .value(value):
        err = value
      case let .error(e):
        return .unwind(.exception(e))
      }
    }

    if err {
      // There was an exception and a True return
      PushFinallyReason.push(.silenced, on: &self.stack)
    }

    return .ok
  }
}

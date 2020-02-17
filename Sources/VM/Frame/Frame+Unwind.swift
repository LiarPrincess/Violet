import Core
import Objects

// MARK: - Unwind reason

/// The reason why we might be unwinding a block.
///
/// This could be return of function, exception being raised,
/// a `break` or `continue` being hit, etc..
internal enum UnwindReason {
  /// Instruction requested a `return` from a current frame.
  /// We will unwind and the return `value`.
  case `return`(PyObject)
  /// Instruction requested a `break`.
  /// We will unwind stopping at nearest loop.
  case `break`
  /// Instruction raised an error.
  /// We will unwind trying to handle it (try-except and finally blocks).
  case exception(PyBaseException)
  /// 'yield' operator
  case yield
  /// Exception silenced by 'with'
  case silenced
}

// MARK: - Frame

extension Frame {

  // MARK: - Unwind

  /// Unwind stack if a return/exception/etc. occurred.
  ///
  /// CPython: fast_block_end:
  internal func unwind(reason: UnwindReason) {
    while let block = self.blocks.pop() {
      switch block.type {
      case let .setupLoop(endLabel):
        self.unwindBlock(block: block)

        if case .break = reason {
          self.jumpTo(label: endLabel)
          return
        }

      case let .setupExcept(firstExceptLabel):
        self.unwindBlock(block: block)

        if case let .exception(e) = reason {
          self.prepareForExceptionHandling(exception: e)
          self.jumpTo(label: firstExceptLabel) // execute except
          return
        }

      case let .setupFinally(finallyStartLabel):
        self.unwindBlock(block: block)

        if case let .exception(e) = reason {
          self.prepareForExceptionHandling(exception: e)
          self.jumpTo(label: finallyStartLabel) // execute finally
          return
        }

        // See 'PushFinallyReason' type for comment about what this is.
        PushFinallyReason.push(reason: reason, on: &self.stack)
        self.jumpTo(label: finallyStartLabel) // execute finally
        return

      case .exceptHandler:
        self.unwindExceptHandler(block: block)
      }
    }
  }

  private func prepareForExceptionHandling(exception: PyBaseException) {
    let exceptHandler = Block(type: .exceptHandler, level: self.stackLevel)
    self.blocks.push(block: exceptHandler)

    // Remember 'current' on stack
    let current = self.exceptions.current
    PushExceptionBeforeExcept.push(current, on: &self.stack)

    // Make 'exception' current
    self.exceptions.current = exception
    self.stack.push(exception)
  }

  /// \#define UNWIND_BLOCK(b)
  internal func unwindBlock(block: Block) {
    self.stack.pop(untilCount: block.level)
  }

  /// \#define UNWIND_EXCEPT_HANDLER(b)
  internal func unwindExceptHandler(block: Block) {
    assert(block.isExceptHandler)

    let stackCountIncludingException = block.level + 1
    assert(self.stack.count >= stackCountIncludingException)

    self.stack.pop(untilCount: stackCountIncludingException)

    // Pop new 'current' exception
    switch PushExceptionBeforeExcept.pop(from: &self.stack) {
    case .exception(let e):
      self.exceptions.current = e
    case .noException:
      self.exceptions.current = nil
    case .invalidValue(let o):
      assert(false, "Expected to pop exception (or None), but popped '\(o)'.")
    }

    assert(self.stack.count == block.level)
  }
}

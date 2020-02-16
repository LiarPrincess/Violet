import Core
import Objects

// MARK: - Unwind reason

/// The reason why we might be unwinding a block.
///
/// This could be return of function, exception being raised,
/// a `break` or `continue` being hit, etc..
internal enum UnwindReason {
  /// We are returning a value from a return statement.
  case `return`(PyObject)
  /// We are unwinding blocks, since we hit `break`
  case `break`
  /// We hit an exception, so unwind any try-except and finally blocks.
  case exception(PyBaseException)
  /// 'yield' operator
  case yield
  /// Exception silenced by 'with'
  case silenced
}

// MARK: - Unwind result

internal enum UnwindResult {
  /// Unwind performed succesfully.
  case ok
  /// Unwind encountered an error and cannot continue.
  case error(PyBaseException)
}

// MARK: - Frame

extension Frame {

  // MARK: - Unwind

  /// Unwind stack if a return/exception/etc. occurred.
  ///
  /// CPython: fast_block_end:
  internal func unwind(reason: UnwindReason) -> UnwindResult {
    // swiftlint:disable:previous function_body_length

    while let block = self.blocks.pop() {
      // Order is roughly the same as in CPython.
      switch block.type {
      case .exceptHandler:
        self.unwindExceptHandler(block: block)

      // From now on every case has to start with 'self.unwindBlock'

      case let .setupLoop(endLabel):
        self.unwindBlock(block: block)

        if case .break = reason {
          self.jumpTo(label: endLabel)
          return .ok
        }

      case let .setupExcept(firstExceptLabel):
        self.unwindBlock(block: block)

        if case let .exception(e) = reason {
          self.startExceptHandler(exception: e)
          self.jumpTo(label: firstExceptLabel) // execute except
          return .ok
        }

      case let .setupFinally(finallyStartLabel):
        self.unwindBlock(block: block)

        if case let .exception(e) = reason {
          self.startExceptHandler(exception: e)
          self.jumpTo(label: finallyStartLabel) // execute finally
          return .ok
        }

        // See 'PushFinallyReason' type for comment about what this is.
        PushFinallyReason.push(reason: reason, on: &self.stack)
        self.jumpTo(label: finallyStartLabel) // execute finally
        return .ok
      }
    }

    switch reason {
    case .return:
      return .ok
    case .exception(let e):
      return .error(e)
    case .break:
      trap("Internal error: break or continue must occur within a loop block.")
    case .yield:
      fatalError()
    case .silenced:
      fatalError()
    }
  }

  private func startExceptHandler(exception: PyBaseException) {
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
  ///
  /// Basically restore exception that was `current` when we entered
  /// `self.startExceptHandler`.
  internal func unwindExceptHandler(block: Block) {
    assert(block.type.isExceptHandler)

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

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
  /// We are unwinding blocks since we hit a `continue` statements.
//  case `continue`(labelIndex: Int)
  /// 'yield' operator
//  case yield
  /// Exception silenced by 'with'
//  case silenced
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

  /// Unwind stacks if a exception occurred.
  ///
  /// CPython: fast_block_end:
  internal func unwind(reason: UnwindReason) -> UnwindResult {
    while let block = self.blocks.pop() {
      // Order is roughly the same order as in CPython.
      switch block.type {
      case .exceptHandler:
        self.unwindExceptHandler(block: block)

      // From now on every case has to start with 'self.unwindBlock'

      case let .setupLoop(endLabelIndex):
        self.unwindBlock(block: block)

        if case .break = reason {
          self.jumpTo(labelIndex: endLabelIndex)
          return .ok
        }

      case let .setupExcept(firstExceptLabelIndex):
        self.unwindBlock(block: block)

        if case let .exception(e) = reason {
          self.saveCurrentExceptionOnStack(newException: e)
          self.jumpTo(labelIndex: firstExceptLabelIndex)
          return .ok
        }

      case let .setupFinally(finallyStartLabelIndex):
        self.unwindBlock(block: block)

        // If it is an exception
        if case let .exception(e) = reason {
          self.saveCurrentExceptionOnStack(newException: e)
          self.jumpTo(labelIndex: finallyStartLabelIndex) // execute finally
          return .ok
        }

        // See 'FinallyMarker' type for comment about what this is.
        self.pushFinallyMarker(reason: reason)
        self.jumpTo(labelIndex: finallyStartLabelIndex) // execute finally
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
    }
  }

  private func saveCurrentExceptionOnStack(newException: PyBaseException) {
    let exceptHandler = Block(type: .exceptHandler, level: self.stackLevel)
    self.blocks.push(block: exceptHandler)

    if let current = self.exceptions.current {
      self.stack.push(current)
    }

    self.stack.push(newException)
  }

  private func pushFinallyMarker(reason: UnwindReason) {
    let marker: FinallyMarker.Push = {
      switch reason {
      case .return(let value): return .return(value)
      case .break: return .break
      case .exception(let e): return .exception(e)
      }
    }()

    FinallyMarker.push(marker, on: self.stack)
  }

  /// \#define UNWIND_BLOCK(b)
  internal func unwindBlock(block: Block) {
    self.stack.pop(untilCount: block.level)
  }

  /// \#define UNWIND_EXCEPT_HANDLER(b)
  internal func unwindExceptHandler(block: Block) {
    let stackCountIncludingException = block.level + 1
    assert(self.stack.count >= stackCountIncludingException)

    self.stack.pop(untilCount: stackCountIncludingException)

    let exception = self.stack.pop()
    assert(exception is PyBaseException)
    assert(self.stack.count == block.level)
  }
}

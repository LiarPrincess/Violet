import Foundation
import VioletCore
import VioletObjects

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
  /// Instruction requested a `break`.
  /// We will unwind stopping at nearest loop.
  case `continue`(loopStartLabel: Int)
  /// Instruction raised an error.
  /// We will unwind trying to handle it (try-except and finally blocks).
  case exception(PyBaseException, fillTracebackAndContext: Bool)
  /// 'yield' operator
  case yield
  /// Exception silenced by 'with'
  ///
  /// It happens when '__exit__' returns 'truthy' value.
  case silenced
}

internal enum UnwindResult {
  /// Just continue code execution.
  /// Mostly used after some sort of a jump
  /// (for example `continue` jumps to the start of the loop).
  case continueCodeExecution
  /// We popped all of the blocks, which means
  /// that we can finally return value to caller.
  case `return`(PyObject)
  /// Let parent frame deal with it.
  case reportExceptionToParentFrame(PyBaseException)
}

// MARK: - Eval

extension Eval {

  // MARK: - Unwind

  /// Unwind stack if a return/exception/etc. occurred.
  ///
  /// CPython: fast_block_end:
  internal func unwind(reason: UnwindReason) -> UnwindResult {
    // swiftlint:disable:previous function_body_length

    while let block = self.blocks.current {
      switch block.type {
      case let .setupLoop(endLabel):
        if case let .continue(loopStartLabel) = reason {
          // Do not unwind! We are still in a loop!
          self.jumpTo(instructionIndex: loopStartLabel)
          return .continueCodeExecution
        }

        _ = self.popBlock()
        self.unwindBlock(block: block)

        if case .break = reason {
          self.jumpTo(instructionIndex: endLabel)
          return .continueCodeExecution
        }

      case let .setupExcept(firstExceptLabel):
        _ = self.popBlock()
        self.unwindBlock(block: block)

        if case let .exception(e, _) = reason {
          self.prepareForExceptionHandling(exception: e)
          self.jumpTo(instructionIndex: firstExceptLabel) // execute except
          return .continueCodeExecution
        }

      case let .setupFinally(finallyStartLabel):
        _ = self.popBlock()
        self.unwindBlock(block: block)

        if case let .exception(e, _) = reason {
          self.prepareForExceptionHandling(exception: e)
          self.jumpTo(instructionIndex: finallyStartLabel) // execute finally
          return .continueCodeExecution
        }

        // See 'PushFinallyReason' type for comment about what this is.
        PushFinallyReason.push(reason: reason, on: &self.frame.stack)
        self.jumpTo(instructionIndex: finallyStartLabel) // execute finally
        return .continueCodeExecution

      case .exceptHandler:
        _ = self.popBlock()
        self.unwindExceptHandler(block: block)
      }
    }

    // No blocks! (kinda 'yay', kinda scarry)
    assert(self.blocks.isEmpty)
    switch reason {
    case .return(let value):
      return .return(value)

    case .break:
      // We popped top level loop, we can continue execution
      return .continueCodeExecution

    case .continue:
      let msg = Py.newString("'continue' not properly in loop")
      let e = Py.newSyntaxError(
        msg: msg,
        filename: self.code.filename,
        lineno: Py.newInt(self.frame.currentInstructionLine),
        offset: Py.newInt(0),
        text: msg,
        printFileAndLine: Py.true
      )
      return .reportExceptionToParentFrame(e)

    case .exception(let e, _):
      return .reportExceptionToParentFrame(e)

    case .yield,
         .silenced:
      let instruction = self.frame.currentInstructionIndex ?? 0
      let line = self.frame.currentInstructionLine
      let details = "(instruction: \(instruction), line: \(line))"
      let msg = "Popped all blocks, but this still remains: '\(reason)' \(details)"
      trap(msg)
    }
  }

  private func prepareForExceptionHandling(exception: PyBaseException) {
    let exceptHandler = Block(type: .exceptHandler, stackLevel: self.stackLevel)
    self.pushBlock(block: exceptHandler)

    // Remember current exception on stack
    let currentOrNil = self.currentlyHandledException
    PushExceptionBeforeExcept.push(currentOrNil, on: &self.frame.stack)

    // Make 'exception' current
    self.setCurrentlyHandledException(exception: exception)
    self.stack.push(exception)
  }

  /// \#define UNWIND_BLOCK(b)
  internal func unwindBlock(block: Block) {
    self.stack.pop(untilCount: block.stackLevel)
  }

  /// \#define UNWIND_EXCEPT_HANDLER(b)
  internal func unwindExceptHandler(block: Block) {
    assert(block.isExceptHandler)

    let stackCountIncludingException = block.stackLevel + 1
    assert(self.stack.count >= stackCountIncludingException)

    self.stack.pop(untilCount: stackCountIncludingException)

    // Pop new 'current' exception
    switch PushExceptionBeforeExcept.pop(from: &self.frame.stack) {
    case .exception(let e):
      self.setCurrentlyHandledException(exception: e)
    case .noException:
      self.setCurrentlyHandledException(exception: nil)
    case .invalidValue(let o):
      assert(false, "Expected to pop exception (or None), but popped '\(o)'.")
    }

    assert(self.stack.count == block.stackLevel)
  }
}

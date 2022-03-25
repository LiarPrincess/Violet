import Foundation
import VioletCore
import VioletObjects

// MARK: - Reason

/// The reason why we might be unwinding a block.
///
/// This could be return of function, exception being raised,
/// a `break` or `continue` being hit, etc..
internal enum UnwindReason {
  /// Instruction requested a `return` from a current frame.
  /// We will unwind and the return `value`.
  case `return`(PyObject)
  /// Instruction requested a `break`.
  /// We will unwind and jump after the nearest loop.
  case `break`
  /// Instruction requested a `continue`.
  /// We will unwind and jump to the beginning of the nearest loop.
  case `continue`(loopStartLabelIndex: Int)
  /// Instruction raised an error.
  /// We will unwind trying to handle it (try-except and finally blocks).
  /// If that fails we will report this error to parent frame.
  case exception(PyBaseException, fillTracebackAndContext: Bool)
  /// 'yield' operator
  case yield
  /// Exception silenced by `with`.
  ///
  /// It happens when `__exit__` returns 'truthy' value.
  case silenced
}

// MARK: - Result

internal enum UnwindResult {
  /// Just continue code execution.
  /// Mostly used after some sort of a jump
  /// (for example `continue` jumps to the start of the loop).
  ///
  /// Note that the `nextInstructionIndex` may have changed!
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

    while let block = self.blockStack.current {
      switch block.kind {
      case let .setupLoop(loopEndLabelIndex: loopEndLabelIndex):
        if case let .continue(loopStartLabelIndex: loopStartLabelIndex) = reason {
          // Do not unwind! We are still in a loop! The stack stays the same!
          //
          // for princess in ['elsa', 'ariel']:
          //   <loopStartLabel will put us here>
          //   <load 'next' from iterator and put it as 'princess'>
          //   print(princess)
          //   continue
          self.jumpTo(labelIndex: loopStartLabelIndex)
          return .continueCodeExecution
        }

        // We will be leaving the loop!
        // Go back with our stack to pre-loop level.
        //
        // for princess in ['elsa', 'ariel']:
        //   print(princess)
        //   raise ValueError("Evil character appears!") # No longer in loop after this!
        _ = self.blockStack.pop()
        self.unwindStack(toMatchTheOneBefore: block)

        // 'break' just finishes the loop and starts execution after it.
        // Any other 'reason' (exception, return) should unwind more blocks.
        //
        // for princess in ['elsa', 'ariel']:
        //   print(princess)
        //   break
        // <endLabel will put us here>
        if case .break = reason {
          self.jumpTo(labelIndex: loopEndLabelIndex)
          return .continueCodeExecution
        }

      case let .setupExcept(firstExceptLabelIndex: firstExceptLabelIndex):
        // We will be leaving the 'try' part (even if the reason is not an exception),
        // which means that anything done inside 'try' should be popped.
        //
        // for princess in ['elsa', 'ariel']:
        //   try:
        //     <push 'something' onto the stack>
        //     continue # should remove this 'something' from the stack, before
        //              # we even get to unwind responsible for the 'for loop'
        //   except:
        //     pass
        _ = self.blockStack.pop()
        self.unwindStack(toMatchTheOneBefore: block)

        // If we have an exception then this is the time to start handling it.
        //
        // try:
        //   raise ValueError("I am an evil princess!")
        // except:
        //   <firstExceptLabel will put us here>
        //   pass
        if case let .exception(e, _) = reason {
          self.pushExceptHandlerBlock()
          self.pushCurrentlyHandledExceptionOntoTheStack(newCurrentlyHandledException: e)
          self.jumpTo(labelIndex: firstExceptLabelIndex) // execute except
          return .continueCodeExecution
        }

      case let .setupFinally(finallyStartLabelIndex: finallyStartLabelIndex):
        // Similar to 'setupExcept'.
        _ = self.blockStack.pop()
        self.unwindStack(toMatchTheOneBefore: block)

        // Similar to 'setupExcept'.
        if case let .exception(e, _) = reason {
          self.pushExceptHandlerBlock() // Even though this is 'finally'
          self.pushCurrentlyHandledExceptionOntoTheStack(newCurrentlyHandledException: e)
          self.jumpTo(labelIndex: finallyStartLabelIndex) // execute finally
          return .continueCodeExecution
        }

        // So… we do not have an exception, but we do have 'finally'.
        // We have to execute the it no mater what.
        //
        // try:
        //   return 'elsa'
        // finally:
        //   pass # executing 'finally'
        //   <we still 'returning elsa'>

        // See 'PushFinallyReason' type for comment about what this is.
        PushFinallyReason.push(self.py, stack: self.stack, reason: reason)
        self.jumpTo(labelIndex: finallyStartLabelIndex) // execute finally
        return .continueCodeExecution

      case .exceptHandler:
        // Complicated case, see inside the method for details.
        _ = self.blockStack.pop()
        self.unwindExceptHandler(exceptHandlerBlock: block)
      }
    }

    // No blocks! (kinda 'yay', kinda scarry)
    assert(self.blockStack.isEmpty)
    switch reason {
    case .return(let value):
      // We popped all of the blocks, which means that we can finally return
      // value to caller. For example:
      // def princess()"
      //   return 'Elsa' # Nothing to unwind
      //
      // Or when we returned from a block, which was unwinded in the 'while' loop:
      // for princess in ['elsa', 'ariel']: # already unwinded
      //   return 'elsa'
      return .return(value)

    case .exception(let e, _):
      // We popped all of the blocks, but none of them was an except handler.
      // Ask parent to deal with it. For example:
      // def sing():
      //   raise ValueError("I am an evil princess!")
      return .reportExceptionToParentFrame(e)

    case .break:
      // We popped all of the blocks and we still have 'break'?
      // Should not be possible.
      return self.raiseContinueOrBreakNotInALoop(keyword: "break")

    case .continue:
      // We popped all of the blocks and we still have 'continue'?
      // Should not be possible.
      return self.raiseContinueOrBreakNotInALoop(keyword: "continue")

    case .yield,
         .silenced:
      let instruction = self.frame.currentInstructionIndex ?? 0
      let line = self.frame.currentInstructionLine
      let details = "(instruction: \(instruction), line: \(line))"
      let msg = "Popped all blocks, but this still remains: '\(reason)' \(details)"
      trap(msg)
    }
  }

  // MARK: - Push except handler block

  private func pushExceptHandlerBlock() {
    let block = PyFrame.Block(kind: .exceptHandler, stackCount: self.stack.count)
    self.blockStack.push(block)
  }

  // MARK: - Push currently handled exception onto the stack and set new

  private func pushCurrentlyHandledExceptionOntoTheStack(
    newCurrentlyHandledException: PyBaseException
  ) {
    // Called when we start 'except' or 'finally' block:
    // try:
    //   raise ValueError("I am an evil princess!")
    // except:
    //   <we are here>
    //   <pushing the currently handled exception onto the stack>
    //   <setting 'evil princess' as currently handled exception>
    //   pass

    let currentOrNil = self.currentlyHandledException
    PushExceptionBeforeExcept.push(self.py, stack: self.stack, exception: currentOrNil)

    self.currentlyHandledException = newCurrentlyHandledException
    self.stack.push(newCurrentlyHandledException.asObject)
  }

  // MARK: - Unwind stack to match the one before block

  /// \#define UNWIND_BLOCK(b)
  ///
  /// The more Swift-like name would be 'unwind(toTheLevelBefore: Block)'
  /// But we already have a few 'unwind' methods and we don't want to mix them.
  internal func unwindStack(toMatchTheOneBefore block: PyFrame.Block) {
    self.stack.pop(untilCount: block.stackCount)
  }

  // MARK: - Unwind except handler

  /// \#define UNWIND_EXCEPT_HANDLER(b)
  internal func unwindExceptHandler(exceptHandlerBlock block: PyFrame.Block) {
    // Called when:
    //
    // (1) We are normally finishing the 'except' clause
    // try:
    //   raise ValueError("I am an evil princess!")
    // except:
    //   <pushing the currently handled exception onto the stack>
    //   <setting 'evil princess' as currently handled exception>
    //   pass # executing 'except'
    //   <we are here! we 'handled' the 'evil princess', now restore previous>
    //
    // (2) We were inside 'except' when the 'unwind' struck (https://youtu.be/v2AC41dglnM)
    // for princess in ['elsa', 'ariel']:
    //   try:
    //     raise ValueError("I am an evil princess!")
    //   except:
    //     <pushing the currently handled exception onto the stack>
    //     <setting 'evil princess' as currently handled exception>
    //     continue # <-- We are here!
    //              # Our goal is to discard 'evil princess' and restore previous
    assert(block.isExceptHandler)

    let exceptionOnStack = PushExceptionBeforeExcept.countOnStack // probably 1
    let stackCountIncludingException = block.stackCount + exceptionOnStack
    assert(self.stack.count >= stackCountIncludingException)

    // Remove all stack entries below exception
    // (local variables introduced in 'except')
    self.stack.pop(untilCount: stackCountIncludingException)

    // Pop the exception
    switch PushExceptionBeforeExcept.pop(self.py, stack: self.stack) {
    case .exception(let e):
      self.currentlyHandledException = e
    case .noException:
      self.currentlyHandledException = nil
    case .invalidValue(let o):
      trap("Expected to pop exception (or None), but popped '\(o)'.")
    }

    assert(self.stack.count == block.stackCount)
  }

  // MARK: - Continue/Break not in a loop

  private func raiseContinueOrBreakNotInALoop(keyword: String) -> UnwindResult {
    let message = self.py.newString("'\(keyword)' not properly in loop")
    let error = self.py.newSyntaxError(
      message: message,
      filename: self.code.filename,
      lineno: self.py.newInt(self.frame.currentInstructionLine),
      offset: self.py.newInt(0),
      text: message,
      printFileAndLine: self.py.true
    )

    return .reportExceptionToParentFrame(error.asBaseException)
  }
}

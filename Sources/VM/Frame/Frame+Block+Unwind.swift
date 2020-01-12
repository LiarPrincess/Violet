import Core
import Objects

// MARK: - Unwind reason

/// The reason why we might be unwinding a block.
/// This could be return of function, exception being raised,
/// a break or continue being hit, etc..
internal enum UnwindReason {
  /// We are returning a value from a return statement.
  case `return`(PyObject)
  /// We hit an exception, so unwind any try-except and finally blocks.
  case exception(PyObject)
  /// We are unwinding blocks, since we hit `break`
  case `break`
  /// We are unwinding blocks since we hit a `continue` statements.
  case `continue`
  /// 'yield' operator
//  case yield
  /// Exception silenced by 'with'
//  case silenced
}

// MARK: - Unwind result

internal enum UnwindResult {
  case `return`(PyObject)
  case notImplemented
}

// MARK: - Block

internal struct Block {
  /// The type of block.
  internal let type: BlockType
  /// Where to jump to find handler.
  internal let handler: Int
  /// Stack size when the block was entered.
  internal let level: Int
}

internal enum BlockType {
  case setupLoop
  case setupExcept
  case setupFinally
  case exceptHandler
}

// MARK: - Frame

extension Frame {

  // MARK: - Push

  /// void
  /// PyFrame_BlockSetup(PyFrameObject *f, int type, int handler, int level)
  internal func pushBlock(block: Block) {
    self.blocks.push(block)
  }

  // MARK: - Pop

  internal func popBlockInner() -> Block {
    if let b = self.blocks.popLast() {
      return b
    }

    trap("XXX block stack underflow")
  }

  // MARK: - Unwind

  /// Unwind stacks if a (pseudo) exception occurred.
  ///
  /// CPython: fast_block_end:
  internal func unwind(reason: UnwindReason) -> UnwindResult {
    while let block = self.currentBlock {
      // We don't pop block on 'coutinue'.
      if case .continue = reason, block.type == .setupLoop {
        // JUMPTO(PyLong_AS_LONG(retval));
        break
      }

      if block.type == .exceptHandler {
        self.unwindExceptHandler(block: block)
        continue
      }

      _ = self.blocks.popLast()
      self.unwindBlock(block: block)

      if case .break = reason, block.type == .setupLoop {
        self.jumpTo(label: block.handler)
        break
      }

// TODO: Finish
//      if case .exception = reason,
//        block.type == .setupExcept || block.type == .setupFinally { }

//      if block.type == .setupFinally { }
    }

    switch reason {
    case .return(let value):
      return .return(value)
    case .exception: // (let e):
      fatalError()
    case .break, .continue:
      trap("Internal error: break or continue must occur within a loop block.")
    }
  }

  /// \#define UNWIND_BLOCK(b)
  internal func unwindBlock(block: Block) {
    self.stack.popUntil(count: block.level)
  }

  /// \#define UNWIND_EXCEPT_HANDLER(b)
  internal func unwindExceptHandler(block: Block) {
    let stackWithExceptionInfoCount = block.level + 3
    assert(self.stack.count >= stackWithExceptionInfoCount)

    self.stack.popUntil(count: stackWithExceptionInfoCount)

    // TODO: Finish this
    //  _PyErr_StackItem *exc_info = tstate->exc_info;
    //  exc_info->exc_type = POP();
    //  exc_info->exc_value = POP();
    //  exc_info->exc_traceback = POP();
    _ = self.stack.pop() // type
    _ = self.stack.pop() // value
    _ = self.stack.pop() // traceback

    assert(self.stack.count == block.level)
  }
}

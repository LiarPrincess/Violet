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

import VioletBytecode
import VioletObjects

extension Eval {

  // MARK: - Setup

  /// Pushes a block for a loop onto the block stack.
  /// The block spans from the current instruction up until `loopEndLabel`.
  internal func setupLoop(loopEndLabelIndex: Int) -> InstructionResult {
    let block = PyFrame.Block(
      kind: .setupLoop(loopEndLabelIndex: loopEndLabelIndex),
      stackCount: self.stack.count
    )

    self.blockStack.push(block)
    return .ok
  }

  // MARK: - Iter

  /// Implements `TOS = iter(TOS)`.
  internal func getIter() -> InstructionResult {
    let iterable = self.stack.top

    switch self.py.iter(object: iterable) {
    case let .value(iter):
      self.stack.top = iter
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// TOS is an iterator. Call its `Next()` method.
  /// If this `yields` a new value, push it on the stack (leaving the iterator below it).
  /// If not then TOS is popped, and the byte code counter is incremented by delta.
  internal func forIter(ifEmptyLabelIndex: Int) -> InstructionResult {
    // before: [iter]; after: [iter, iter()] *or* []
    let iter = self.stack.top

    switch self.py.next(iterator: iter) {
    case .value(let o):
      self.stack.push(o)
      return .ok

    case .error(let e):
      if self.py.cast.isStopIteration(e.asObject) {
        _ = self.stack.pop() // iter
        self.jumpTo(labelIndex: ifEmptyLabelIndex)
        return .ok
      }

      return .exception(e)
    }
  }

  // MARK: - Break

  /// Terminates a loop due to a break statement.
  internal func doBreak() -> InstructionResult {
    return .break
  }

  // MARK: - Continue

  /// Continues a loop due to a continue statement.
  /// `loopStartLabel` is the address to jump to
  /// (which should be a `ForIter` instruction).
  internal func doContinue(loopStartLabelIndex: Int) -> InstructionResult {
    return .continue(loopStartLabelIndex: loopStartLabelIndex)
  }
}

import Objects
import Bytecode

extension Frame {

  // MARK: - Setup

  /// Pushes a block for a loop onto the block stack.
  /// The block spans from the current instruction up until `loopEndLabel`.
  internal func setupLoop(loopEndLabelIndex: Int) -> InstructionResult {
    let label = self.getLabel(index: loopEndLabelIndex)
    let block = Block(type: .setupLoop, handler: label, level: self.stackLevel)
    self.pushBlock(block: block)
    return .ok
  }

  // MARK: - Iter

  /// Implements `TOS = iter(TOS)`.
  internal func getIter() -> InstructionResult {
    let iterable = self.stack.top

    switch self.builtins.iter(from: iterable) {
    case let .value(iter):
      self.stack.top = iter
    return .ok
    case let .error(e):
      return .error(e)
    }
  }

  /// TOS is an iterator. Call its `Next()` method.
  /// If this `yields` a new value, push it on the stack (leaving the iterator below it).
  /// If not then TOS is popped, and the byte code counter is incremented by delta.
  internal func forIter(ifEmptyLabelIndex: Int) -> InstructionResult {
    // before: [iter]; after: [iter, iter()] *or* []
    let iter = self.stack.top

    switch self.builtins.next(iterator: iter) {
    case .value(let o):
      self.stack.push(o)
      return .ok

    case .error(let e):
      if e.isStopIteration {
        _ = self.stack.pop() // iter
        self.jumpTo(labelIndex: ifEmptyLabelIndex)
        return .ok
      }

      return .error(e)
    }
  }

  // MARK: - Break

  /// Terminates a loop due to a break statement.
  internal func doBreak() -> InstructionResult {
    return .unwind(.break)
  }
}

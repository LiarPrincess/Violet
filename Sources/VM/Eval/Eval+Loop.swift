import Objects
import Bytecode

extension Eval {

  // MARK: - Setup

  /// Pushes a block for a loop onto the block stack.
  /// The block spans from the current instruction up until `loopEndLabel`.
  internal func setupLoop(loopEndLabelIndex: Int) -> InstructionResult {
    let label = self.getLabel(index: loopEndLabelIndex)
    let type = BlockType.setupLoop(endLabel: label)
    let block = Block(type: type, stackLevel: self.stackLevel)
    self.blocks.push(block: block)
    return .ok
  }

  // MARK: - Iter

  /// Implements `TOS = iter(TOS)`.
  internal func getIter() -> InstructionResult {
    let iterable = self.stack.top

    switch Py.iter(from: iterable) {
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

    switch Py.next(iterator: iter) {
    case .value(let o):
      self.stack.push(o)
      return .ok

    case .error(let e):
      if e.isStopIteration {
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
    let label = self.getLabel(index: loopStartLabelIndex)
    return .continue(loopStartLabel: label)
  }
}

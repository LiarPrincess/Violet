import Objects
import Bytecode

extension Frame {

  // MARK: - Setup

  /// Pushes a try block from a try-except clause onto the block stack.
  /// `delta` points to the first except block.
  internal func setupExcept(firstExceptLabelIndex: Int) -> InstructionResult {
    let label = self.getLabel(index: firstExceptLabelIndex)
    let block = Block(type: .setupExcept, handler: label, level: self.stackLevel)
    self.pushBlock(block: block)
    return .ok
  }

  /// Pushes a try block from a try-except clause onto the block stack.
  /// `delta` points to the finally block.
  internal func setupFinally(finallyStartLabelIndex: Int) -> InstructionResult {
    let label = self.getLabel(index: finallyStartLabelIndex)
    let block = Block(type: .setupFinally, handler: label, level: self.stackLevel)
    self.pushBlock(block: block)
    return .ok
  }

  // MARK: - Pop

  /// Removes one block from the block stack.
  /// The popped block must be an exception handler block,
  /// as implicitly created when entering an except handler.
  /// In addition to popping extraneous values from the frame stack,
  /// the last three popped values are used to restore the exception state.
  internal func popExcept() -> InstructionResult {
    let block = self.popBlockInner()

    if block.type != .exceptHandler {
      return .builtinError(.systemError("popped block is not an except handler"))
    }

    self.unwindExceptHandler(block: block)
    return .ok
  }
}

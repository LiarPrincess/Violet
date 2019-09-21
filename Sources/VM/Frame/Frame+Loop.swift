import Bytecode

extension Frame {

  /// Pushes a block for a loop onto the block stack.
  /// The block spans from the current instruction up until `loopEndLabel`.
  internal func setupLoop(loopEndLabel: Int) throws {
    self.unimplemented()
  }

  /// TOS is an iterator. Call its `Next()` method.
  /// If this `yields` a new value, push it on the stack (leaving the iterator below it).
  /// If not then TOS is popped, and the byte code counter is incremented by delta.
  internal func forIter(ifEmptyLabel: Int) throws {
    self.unimplemented()
  }

  /// Implements `TOS = iter(TOS)`.
  internal func getIter() throws {
    self.unimplemented()
  }

  /// If TOS is a generator iterator or coroutine object then it is left as is.
  /// Otherwise, implements `TOS = iter(TOS)`.
  internal func getYieldFromIter() throws {
    self.unimplemented()
  }

  /// Terminates a loop due to a break statement.
  internal func `break`() throws {
    self.unimplemented()
  }
}

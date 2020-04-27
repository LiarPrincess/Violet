import VioletCore

extension CodeObjectBuilder {

  // MARK: - Generators

  /// Append a `yieldValue` instruction to this code object.
  public func appendYieldValue() {
    self.append(.yieldValue)
  }

  /// Append a `yieldFrom` instruction to this code object.
  public func appendYieldFrom() {
    self.append(.yieldFrom)
  }

  // MARK: - Coroutine

  /// Append a `getAwaitable` instruction to this code object.
  public func appendGetAwaitable() {
    self.append(.getAwaitable)
  }

  /// Append a `getAIter` instruction to this code object.
  public func appendGetAIter() {
    self.append(.getAIter)
  }

  /// Append a `getANext` instruction to this code object.
  public func appendGetANext() {
    self.append(.getANext)
  }
}

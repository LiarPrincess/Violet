import Core

extension CodeObjectBuilder {

  // MARK: - Generators

  /// Append a `yieldValue` instruction to this code object.
  public func appendYieldValue() throws {
    try self.append(.yieldValue)
  }

  /// Append a `yieldFrom` instruction to this code object.
  public func appendYieldFrom() throws {
    try self.append(.yieldFrom)
  }

  // MARK: - Coroutine

  /// Append a `getAwaitable` instruction to this code object.
  public func appendGetAwaitable() throws {
    try self.append(.getAwaitable)
  }

  /// Append a `getAIter` instruction to this code object.
  public func appendGetAIter() throws {
    try self.append(.getAIter)
  }

  /// Append a `getANext` instruction to this code object.
  public func appendGetANext() throws {
    try self.append(.getANext)
  }
}

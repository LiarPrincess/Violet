import Core

extension CodeObject {

  // MARK: - Generators

  /// Append a `yieldValue` instruction to code object.
  public func appendYieldValue(at location: SourceLocation) throws {
    try self.append(.yieldValue, at: location)
  }

  /// Append a `yieldFrom` instruction to code object.
  public func appendYieldFrom(at location: SourceLocation) throws {
    try self.append(.yieldFrom, at: location)
  }

  // MARK: - Coroutine

  /// Append a `getAwaitable` instruction to code object.
  public func appendGetAwaitable(at location: SourceLocation) throws {
    try self.append(.getAwaitable, at: location)
  }

  /// Append a `getAIter` instruction to code object.
  public func appendGetAIter(at location: SourceLocation) throws {
    try self.append(.getAIter, at: location)
  }

  /// Append a `getANext` instruction to code object.
  public func appendGetANext(at location: SourceLocation) throws {
    try self.append(.getANext, at: location)
  }
}

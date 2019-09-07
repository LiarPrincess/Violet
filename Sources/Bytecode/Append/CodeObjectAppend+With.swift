import Core

extension CodeObject {

  /// Append a `setupWith` instruction to code object.
  public func appendSetupWith(afterBody: Label,
                              at location: SourceLocation) throws {
    // try self.append(.setupWith, at: location)
    throw self.unimplemented()
  }

  /// Append a `withCleanupStart` instruction to code object.
  public func appendWithCleanupStart(at location: SourceLocation) throws {
    try self.append(.withCleanupStart, at: location)
  }

  /// Append a `withCleanupFinish` instruction to code object.
  public func appendWithCleanupFinish(at location: SourceLocation) throws {
    try self.append(.withCleanupFinish, at: location)
  }

  /// Append a `beforeAsyncWith` instruction to code object.
  public func appendBeforeAsyncWith(at location: SourceLocation) throws {
    try self.append(.beforeAsyncWith, at: location)
  }

  /// Append a `setupAsyncWith` instruction to code object.
  public func appendSetupAsyncWith(at location: SourceLocation) throws {
    try self.append(.setupAsyncWith, at: location)
  }
}

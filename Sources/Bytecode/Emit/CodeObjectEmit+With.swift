import Core

extension CodeObject {

  /// Append a `setupWith` instruction to code object.
  public func emitSetupWith(afterBody: Label, location: SourceLocation) throws {
    // try self.emit(.setupWith, location: location)
    throw self.unimplemented()
  }

  /// Append a `withCleanupStart` instruction to code object.
  public func emitWithCleanupStart(location: SourceLocation) throws {
    try self.emit(.withCleanupStart, location: location)
  }

  /// Append a `withCleanupFinish` instruction to code object.
  public func emitWithCleanupFinish(location: SourceLocation) throws {
    try self.emit(.withCleanupFinish, location: location)
  }

  /// Append a `beforeAsyncWith` instruction to code object.
  public func emitBeforeAsyncWith(location: SourceLocation) throws {
    try self.emit(.beforeAsyncWith, location: location)
  }

  /// Append a `setupAsyncWith` instruction to code object.
  public func emitSetupAsyncWith(location: SourceLocation) throws {
    try self.emit(.setupAsyncWith, location: location)
  }
}

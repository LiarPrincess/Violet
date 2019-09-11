import Core

extension CodeObject {

  /// Append a `setupWith` instruction to this code object.
  public func appendSetupWith(afterBody: Label,
                              at location: SourceLocation) throws {
    let arg = try self.addLabelWithExtendedArgIfNeeded(afterBody, at: location)
    try self.append(.setupWith(afterBodyLabel: arg), at: location)
  }

  /// Append a `withCleanupStart` instruction to this code object.
  public func appendWithCleanupStart(at location: SourceLocation) throws {
    try self.append(.withCleanupStart, at: location)
  }

  /// Append a `withCleanupFinish` instruction to this code object.
  public func appendWithCleanupFinish(at location: SourceLocation) throws {
    try self.append(.withCleanupFinish, at: location)
  }

  /// Append a `beforeAsyncWith` instruction to this code object.
  public func appendBeforeAsyncWith(at location: SourceLocation) throws {
    try self.append(.beforeAsyncWith, at: location)
  }

  /// Append a `setupAsyncWith` instruction to this code object.
  public func appendSetupAsyncWith(at location: SourceLocation) throws {
    try self.append(.setupAsyncWith, at: location)
  }
}

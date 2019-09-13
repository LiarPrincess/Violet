import Core

extension CodeObjectBuilder {

  /// Append a `setupWith` instruction to this code object.
  public func appendSetupWith(afterBody: Label) throws {
    let arg = try self.addLabelWithExtendedArgIfNeeded(afterBody)
    try self.append(.setupWith(afterBodyLabel: arg))
  }

  /// Append a `withCleanupStart` instruction to this code object.
  public func appendWithCleanupStart() throws {
    try self.append(.withCleanupStart)
  }

  /// Append a `withCleanupFinish` instruction to this code object.
  public func appendWithCleanupFinish() throws {
    try self.append(.withCleanupFinish)
  }

  /// Append a `beforeAsyncWith` instruction to this code object.
  public func appendBeforeAsyncWith() throws {
    try self.append(.beforeAsyncWith)
  }

  /// Append a `setupAsyncWith` instruction to this code object.
  public func appendSetupAsyncWith() throws {
    try self.append(.setupAsyncWith)
  }
}

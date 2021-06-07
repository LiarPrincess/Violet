import VioletCore

extension CodeObjectBuilder {

  /// Append a `setupWith` instruction to this code object.
  public func appendSetupWith(afterBody: NotAssignedLabel) {
    let arg = self.appendExtendedArgsForLabelIndex(afterBody)
    self.append(.setupWith(afterBodyLabelIndex: arg))
  }

  /// Append a `withCleanupStart` instruction to this code object.
  public func appendWithCleanupStart() {
    self.append(.withCleanupStart)
  }

  /// Append a `withCleanupFinish` instruction to this code object.
  public func appendWithCleanupFinish() {
    self.append(.withCleanupFinish)
  }

  /// Append a `beforeAsyncWith` instruction to this code object.
  public func appendBeforeAsyncWith() {
    self.append(.beforeAsyncWith)
  }

  /// Append a `setupAsyncWith` instruction to this code object.
  public func appendSetupAsyncWith() {
    self.append(.setupAsyncWith)
  }
}

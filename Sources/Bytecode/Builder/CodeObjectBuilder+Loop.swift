import Core

extension CodeObjectBuilder {

  // MARK: - Loops

  /// Append a `setupLoop` instruction to this code object.
  public func appendSetupLoop(loopEnd: Label) throws {
    let arg = try self.addLabelWithExtendedArgIfNeeded(loopEnd)
    try self.append(.setupLoop(loopEndLabel: arg))
  }

  /// Append a `getIter` instruction to this code object.
  public func appendGetIter() throws {
    try self.append(.getIter)
  }

  /// Append a `forIter` instruction to this code object.
  public func appendForIter(ifEmpty: Label) throws {
    let arg = try self.addLabelWithExtendedArgIfNeeded(ifEmpty)
    try self.append(.forIter(ifEmptyLabel: arg))
  }

  /// Append a `getYieldFromIter` instruction to this code object.
  public func appendGetYieldFromIter() throws {
    try self.append(.getYieldFromIter)
  }

  // MARK: - Break

  /// Append a `breakLoop` instruction to this code object.
  public func appendBreak() throws {
    try self.append(.break)
  }
}

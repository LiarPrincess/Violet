import Core

extension CodeObject {

  // MARK: - Loops

  /// Append a `setupLoop` instruction to this code object.
  public func appendSetupLoop(loopEnd: Label, at location: SourceLocation) throws {
    let arg = try self.addLabelWithExtendedArgIfNeeded(loopEnd, at: location)
    try self.append(.setupLoop(loopEndLabel: arg), at: location)
  }

  /// Append a `getIter` instruction to this code object.
  public func appendGetIter(at location: SourceLocation) throws {
    try self.append(.getIter, at: location)
  }

  /// Append a `forIter` instruction to this code object.
  public func appendForIter(ifEmpty: Label, at location: SourceLocation) throws {
    let arg = try self.addLabelWithExtendedArgIfNeeded(ifEmpty, at: location)
    try self.append(.forIter(ifEmptyLabel: arg), at: location)
  }

  /// Append a `getYieldFromIter` instruction to this code object.
  public func appendGetYieldFromIter(at location: SourceLocation) throws {
    try self.append(.getYieldFromIter, at: location)
  }

  // MARK: - Break

  /// Append a `breakLoop` instruction to this code object.
  public func appendBreak(at location: SourceLocation) throws {
    try self.append(.break, at: location)
  }
}

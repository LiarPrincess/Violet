import Core

extension CodeObject {

  // MARK: - Loops

  /// Append a `setupLoop` instruction to this code object.
  public func appendSetupLoop(loopEnd: Label, at location: SourceLocation) throws {
    // try self.append(.setupLoop, at: location)
    throw self.unimplemented()
  }

  /// Append a `getIter` instruction to this code object.
  public func appendGetIter(at location: SourceLocation) throws {
    try self.append(.getIter, at: location)
  }

  /// Append a `forIter` instruction to this code object.
  public func appendForIter(ifEmpty: Label, at location: SourceLocation) throws {
    // try self.append(.forIter, at: location)
    throw self.unimplemented()
  }

  /// Append a `getYieldFromIter` instruction to this code object.
  public func appendGetYieldFromIter(at location: SourceLocation) throws {
    try self.append(.getYieldFromIter, at: location)
  }

  // MARK: - Continue, break

  /// Append a `continueLoop` instruction to this code object.
  public func appendContinue(value: Target, at location: SourceLocation) throws {
    // try self.append(.continueLoop, at: location)
    throw self.unimplemented()
  }

  /// Append a `breakLoop` instruction to this code object.
  public func appendBreak(at location: SourceLocation) throws {
    try self.append(.break, at: location)
  }
}

import Core

extension CodeObject {

  /// Append a `popExcept` instruction to code object.
  public func emitPopExcept(location: SourceLocation) throws {
    try self.emit(.popExcept, location: location)
  }

  /// Append an `endFinally` instruction to code object.
  public func emitEndFinally(location: SourceLocation) throws {
    try self.emit(.endFinally, location: location)
  }

  /// Append a `setupExcept` instruction to code object.
  public func emitSetupExcept(firstExcept: Label,
                              location: SourceLocation) throws {
    // try self.emit(.setupExcept, location: location)
    throw self.unimplemented()
  }

  /// Append a `setupFinally` instruction to code object.
  /// - Parameters:
  ///   - start: First instruction of the `finally` block.
  public func emitSetupFinally(jumpTo: Label, location: SourceLocation) throws {
    // try self.emit(.setupFinally, location: location)
    throw self.unimplemented()
  }

  /// Append a `raiseVarargs` instruction to code object.
  public func emitRaiseVarargs(arg: RaiseArg, location: SourceLocation) throws {
    try self.emit(.raiseVarargs(arg), location: location)
  }
}

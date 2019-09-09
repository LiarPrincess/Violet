import Core

extension CodeObject {

  /// Append a `popExcept` instruction to this code object.
  public func appendPopExcept(at location: SourceLocation) throws {
    try self.append(.popExcept, at: location)
  }

  /// Append an `endFinally` instruction to this code object.
  public func appendEndFinally(at location: SourceLocation) throws {
    try self.append(.endFinally, at: location)
  }

  /// Append a `setupExcept` instruction to this code object.
  public func appendSetupExcept(firstExcept: Label,
                                at location: SourceLocation) throws {
    // try self.append(.setupExcept, at: location)
    throw self.unimplemented()
  }

  /// Append a `setupFinally` instruction to this code object.
  /// - Parameters:
  ///   - start: First instruction of the `finally` block.
  public func appendSetupFinally(jumpTo: Label,
                                 at location: SourceLocation) throws {
    // try self.append(.setupFinally, at: location)
    throw self.unimplemented()
  }

  /// Append a `raiseVarargs` instruction to this code object.
  public func appendRaiseVarargs(arg: RaiseArg,
                                 at location: SourceLocation) throws {
    try self.append(.raiseVarargs(arg), at: location)
  }
}

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
    let arg = try self.addLabelWithExtendedArgIfNeeded(firstExcept, at: location)
    try self.append(.setupExcept(firstExceptLabel: arg), at: location)
  }

  /// Append a `setupFinally` instruction to this code object.
  public func appendSetupFinally(finallyStart: Label,
                                 at location: SourceLocation) throws {
    let arg = try self.addLabelWithExtendedArgIfNeeded(finallyStart, at: location)
    try self.append(.setupFinally(finallyStartLabel: arg), at: location)
  }

  /// Append a `raiseVarargs` instruction to this code object.
  public func appendRaiseVarargs(arg: RaiseArg,
                                 at location: SourceLocation) throws {
    try self.append(.raiseVarargs(arg), at: location)
  }
}

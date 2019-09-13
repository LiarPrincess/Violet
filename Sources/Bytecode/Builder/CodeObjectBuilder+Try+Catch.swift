import Core

extension CodeObjectBuilder {

  /// Append a `popExcept` instruction to this code object.
  public func appendPopExcept() throws {
    try self.append(.popExcept)
  }

  /// Append an `endFinally` instruction to this code object.
  public func appendEndFinally() throws {
    try self.append(.endFinally)
  }

  /// Append a `setupExcept` instruction to this code object.
  public func appendSetupExcept(firstExcept: Label) throws {
    let arg = try self.addLabelWithExtendedArgIfNeeded(firstExcept)
    try self.append(.setupExcept(firstExceptLabel: arg))
  }

  /// Append a `setupFinally` instruction to this code object.
  public func appendSetupFinally(finallyStart: Label) throws {
    let arg = try self.addLabelWithExtendedArgIfNeeded(finallyStart)
    try self.append(.setupFinally(finallyStartLabel: arg))
  }

  /// Append a `raiseVarargs` instruction to this code object.
  public func appendRaiseVarargs(arg: RaiseArg) throws {
    try self.append(.raiseVarargs(arg))
  }
}

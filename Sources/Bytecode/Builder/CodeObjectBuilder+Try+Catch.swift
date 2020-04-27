import VioletCore

extension CodeObjectBuilder {

  /// Append a `popExcept` instruction to this code object.
  public func appendPopExcept() {
    self.append(.popExcept)
  }

  /// Append an `endFinally` instruction to this code object.
  public func appendEndFinally() {
    self.append(.endFinally)
  }

  /// Append a `setupExcept` instruction to this code object.
  public func appendSetupExcept(firstExcept: Label) {
    let arg = self.addLabelWithExtendedArgIfNeeded(firstExcept)
    self.append(.setupExcept(firstExceptLabel: arg))
  }

  /// Append a `setupFinally` instruction to this code object.
  public func appendSetupFinally(finallyStart: Label) {
    let arg = self.addLabelWithExtendedArgIfNeeded(finallyStart)
    self.append(.setupFinally(finallyStartLabel: arg))
  }

  /// Append a `raiseVarargs` instruction to this code object.
  public func appendRaiseVarargs(arg: RaiseArg) {
    self.append(.raiseVarargs(arg))
  }
}

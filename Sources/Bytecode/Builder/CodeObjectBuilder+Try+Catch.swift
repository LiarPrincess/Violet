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
  public func appendSetupExcept(firstExcept: NotAssignedLabel) {
    let arg = self.appendExtendedArgsForLabelIndex(firstExcept)
    self.append(.setupExcept(firstExceptLabelIndex: arg))
  }

  /// Append a `setupFinally` instruction to this code object.
  public func appendSetupFinally(finallyStart: NotAssignedLabel) {
    let arg = self.appendExtendedArgsForLabelIndex(finallyStart)
    self.append(.setupFinally(finallyStartLabelIndex: arg))
  }

  /// Append a `raiseVarargs` instruction to this code object.
  public func appendRaiseVarargs(arg: Instruction.RaiseArg) {
    self.append(.raiseVarargs(type: arg))
  }
}

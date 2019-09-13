import Core

extension CodeObjectBuilder {

  /// Append a `makeFunction` instruction to this code object.
  public func appendMakeFunction(flags: FunctionFlags) {
    self.append(.makeFunction(flags))
  }

  /// Append a `callFunction` instruction to this code object.
  public func appendCallFunction(argumentCount: Int) {
    let arg = self.appendExtendedArgIfNeeded(argumentCount)
    self.append(.callFunction(argumentCount: arg))
  }

  /// Append a `callFunctionKw` instruction to this code object.
  public func appendCallFunctionKw(argumentCount: Int) {
    let arg = self.appendExtendedArgIfNeeded(argumentCount)
    self.append(.callFunctionKw(argumentCount: arg))
  }

  /// Append a `callFunctionEx` instruction to this code object.
  public func appendCallFunctionEx(hasKeywordArguments: Bool) {
    self.append(.callFunctionEx(hasKeywordArguments: hasKeywordArguments))
  }

  /// Append a `returnValue` instruction to this code object.
  public func appendReturn() {
    self.append(.return)
  }
}

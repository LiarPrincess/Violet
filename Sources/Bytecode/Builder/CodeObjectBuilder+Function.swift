import Core

extension CodeObjectBuilder {

  /// Append a `makeFunction` instruction to this code object.
  public func appendMakeFunction(flags: FunctionFlags) throws {
    try self.append(.makeFunction(flags))
  }

  /// Append a `callFunction` instruction to this code object.
  public func appendCallFunction(argumentCount: Int) throws {
    let arg = try self.appendExtendedArgIfNeeded(argumentCount)
    try self.append(.callFunction(argumentCount: arg))
  }

  /// Append a `callFunctionKw` instruction to this code object.
  public func appendCallFunctionKw(argumentCount: Int) throws {
    let arg = try self.appendExtendedArgIfNeeded(argumentCount)
    try self.append(.callFunctionKw(argumentCount: arg))
  }

  /// Append a `callFunctionEx` instruction to this code object.
  public func appendCallFunctionEx(hasKeywordArguments: Bool) throws {
    try self.append(.callFunctionEx(hasKeywordArguments: hasKeywordArguments))
  }

  /// Append a `returnValue` instruction to this code object.
  public func appendReturn() throws {
    try self.append(.return)
  }
}

import Core

extension CodeObject {

  /// Append a `makeFunction` instruction to this code object.
  public func appendMakeFunction(flags: FunctionFlags,
                                 at location: SourceLocation) throws {
    try self.append(.makeFunction(flags), at: location)
  }

  /// Append a `callFunction` instruction to this code object.
  public func appendCallFunction(argumentCount: Int,
                                 at location: SourceLocation) throws {
    let arg = try self.appendExtendedArgIfNeeded(argumentCount, at: location)
    try self.append(.callFunction(argumentCount: arg), at: location)
  }

  /// Append a `callFunctionKw` instruction to this code object.
  public func appendCallFunctionKw(argumentCount: Int,
                                   at location: SourceLocation) throws {
    let arg = try self.appendExtendedArgIfNeeded(argumentCount, at: location)
    try self.append(.callFunctionKw(argumentCount: arg), at: location)
  }

  /// Append a `callFunctionEx` instruction to this code object.
  public func appendCallFunctionEx(hasKeywordArguments: Bool,
                                   at location: SourceLocation) throws {
    try self.append(.callFunctionEx(hasKeywordArguments: hasKeywordArguments),
                    at: location)
  }

  /// Append a `returnValue` instruction to this code object.
  public func appendReturn(at location: SourceLocation) throws {
    try self.append(.return, at: location)
  }
}

import Core

extension CodeObject {

  /// Append a `makeFunction` instruction to this code object.
  public func appendMakeFunction(flags: FunctionFlags,
                                 at location: SourceLocation) throws {
    // try self.append(.makeFunction, at: location)
    throw self.unimplemented()
  }

  /// Append a `callFunction` instruction to this code object.
  public func appendCallFunction(argumentCount: Int,
                                 at location: SourceLocation) throws {
    // ADDOP_I(c, CALL_FUNCTION, n + argsCount);
    // try self.append(.callFunction, at: location)
    throw self.unimplemented()
  }

  /// Append a `callFunctionKw` instruction to this code object.
  public func appendCallFunctionKw(argumentCount: Int,
                                   at location: SourceLocation) throws {
    // ADDOP_I(c, CALL_FUNCTION_KW, n + argsCount + keywordCount);
    // try self.append(.callFunctionKw, at: location)
    throw self.unimplemented()
  }

  /// Append a `callFunctionEx` instruction to this code object.
  public func appendCallFunctionEx(hasKeywordArguments: Bool,
                                   at location: SourceLocation) throws {
    // ADDOP_I(c, CALL_FUNCTION_EX, nsubkwargs > 0);
    // try self.append(.callFunctionEx, at: location)
    throw self.unimplemented()
  }

  /// Append a `returnValue` instruction to this code object.
  public func appendReturn(at location: SourceLocation) throws {
    try self.append(.return, at: location)
  }
}

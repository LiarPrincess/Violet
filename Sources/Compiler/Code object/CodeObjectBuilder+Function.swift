import Core
import Parser
import Bytecode

extension CodeObjectBuilder {

  /// Append a `makeFunction` instruction to code object.
  public func emitMakeFunction(argumentCount: Int,
                               location: SourceLocation) throws {
    // try self.emit(.makeFunction, location: location)
    throw self.unimplemented()
  }

  /// Append a `callFunction` instruction to code object.
  public func emitCallFunction(argumentCount: Int,
                               location: SourceLocation) throws {
    // ADDOP_I(c, CALL_FUNCTION, n + argsCount);
    // try self.emit(.callFunction, location: location)
    throw self.unimplemented()
  }

  /// Append a `callFunctionKw` instruction to code object.
  public func emitCallFunctionKw(argumentCount: Int,
                                 location: SourceLocation) throws {
    // ADDOP_I(c, CALL_FUNCTION_KW, n + argsCount + keywordCount);
    // try self.emit(.callFunctionKw, location: location)
    throw self.unimplemented()
  }

  /// Append a `callFunctionEx` instruction to code object.
  public func emitCallFunctionEx(hasKeywordArguments: Bool,
                                 location: SourceLocation) throws {
    // ADDOP_I(c, CALL_FUNCTION_EX, nsubkwargs > 0);
    // try self.emit(.callFunctionEx, location: location)
    throw self.unimplemented()
  }

  /// Append a `returnValue` instruction to code object.
  public func emitReturnValue(location: SourceLocation) throws {
    try self.emit(.returnValue, location: location)
  }
}

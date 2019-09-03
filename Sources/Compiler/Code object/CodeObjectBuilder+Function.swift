import Core
import Parser
import Bytecode

extension CodeObjectBuilder {

  /// Append a `makeFunction` instruction to currently filled code object.
  public func emitMakeFunction(argumentCount: UInt8, location: SourceLocation) throws {
    // try self.emit(.makeFunction, location: location)
    throw self.unimplemented()
  }

  /// Append a `callFunction` instruction to currently filled code object.
  public func emitCallFunction(argumentCount: UInt8, location: SourceLocation) throws {
    // try self.emit(.callFunction, location: location)
    throw self.unimplemented()
  }

  /// Append a `callFunctionKw` instruction to currently filled code object.
  public func emitCallFunctionKw(argumentCount: UInt8, location: SourceLocation) throws {
    // try self.emit(.callFunctionKw, location: location)
    throw self.unimplemented()
  }

  /// Append a `callFunctionEx` instruction to currently filled code object.
  public func emitCallFunctionEx(hasKeywordArguments: Bool, location: SourceLocation) throws {
    // try self.emit(.callFunctionEx, location: location)
    throw self.unimplemented()
  }

  /// Append a `returnValue` instruction to currently filled code object.
  public func emitReturnValue(location: SourceLocation) throws {
    try self.emit(.returnValue, location: location)
  }
}

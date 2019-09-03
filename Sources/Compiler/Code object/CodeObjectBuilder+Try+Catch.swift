import Core
import Parser
import Bytecode

extension CodeObjectBuilder {

  /// Append a `popExcept` instruction to currently filled code object.
  public func emitPopExcept(location: SourceLocation) throws {
    try self.emit(.popExcept, location: location)
  }

  /// Append an `endFinally` instruction to currently filled code object.
  public func emitEndFinally(location: SourceLocation) throws {
    try self.emit(.endFinally, location: location)
  }

  /// Append a `setupExcept` instruction to currently filled code object.
  public func emitSetupExcept(value: Delta, location: SourceLocation) throws {
    // try self.emit(.setupExcept, location: location)
    throw self.unimplemented()
  }

  /// Append a `setupFinally` instruction to currently filled code object.
  public func emitSetupFinally(value: Delta, location: SourceLocation) throws {
    // try self.emit(.setupFinally, location: location)
    throw self.unimplemented()
  }

  /// Append a `raiseVarargs` instruction to currently filled code object.
  public func emitRaiseVarargs(argc: UInt8, location: SourceLocation) throws {
    // try self.emit(.raiseVarargs, location: location)
    throw self.unimplemented()
  }
}
